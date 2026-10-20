"""
EntEnterpriseerprise SQL Intelligence & Customer Retention Analytics
Data Preparation Pipeline

Input:
    Online Retail.xlsx

Output:
    customer_retention_analytics.db

Tables:
    raw_transactions
    clean_sales

Requirements:
    pandas
    openpyxl
"""

import sqlite3
from pathlib import Path

import pandas as pd


# ==========================================================
# 1. CONFIGURATION
# ==========================================================

INPUT_FILE = Path("/content/Online Retail.xlsx")
DATABASE_FILE = Path("/content/customer_retention_analytics.db")

RAW_TABLE = "raw_transactions"
CLEAN_TABLE = "clean_sales"


# ==========================================================
# 2. LOAD DATA
# ==========================================================

def load_data(file_path):
    """Load the original Excel dataset."""

    if not file_path.exists():
        raise FileNotFoundError(
            f"Dataset not found: {file_path}\n"
            "Please upload Online Retail.xlsx to Google Colab."
        )

    print("Loading Online Retail dataset...")

    df = pd.read_excel(
        file_path,
        engine="openpyxl"
    )

    # Standardize column names.
    df.columns = df.columns.str.strip()

    required_columns = [
        "InvoiceNo",
        "StockCode",
        "Description",
        "Quantity",
        "InvoiceDate",
        "UnitPrice",
        "CustomerID",
        "Country",
    ]

    missing = [
        column
        for column in required_columns
        if column not in df.columns
    ]

    if missing:
        raise ValueError(
            f"Required columns are missing: {missing}"
        )

    print(f"Original rows loaded: {len(df):,}")

    return df


# ==========================================================
# 3. PREPARE RAW TRANSACTIONS
# ==========================================================

def prepare_raw_transactions(df):
    """
    Standardize column names and data types.

    Preserve every source row, including duplicate records,
    cancellations, negative quantities and invalid sales.
    """

    raw = df.copy()

    raw = raw.rename(
        columns={
            "InvoiceNo": "invoice_no",
            "StockCode": "stock_code",
            "Description": "description",
            "Quantity": "quantity",
            "InvoiceDate": "invoice_date",
            "UnitPrice": "unit_price",
            "CustomerID": "customer_id",
            "Country": "country",
        }
    )

    # Normalize text columns without deleting source rows.
    for column in [
        "invoice_no",
        "stock_code",
        "description",
        "country",
    ]:
        raw[column] = (
            raw[column]
            .astype("string")
            .str.strip()
        )

    # Convert numeric fields.
    raw["quantity"] = pd.to_numeric(
        raw["quantity"],
        errors="coerce"
    )

    raw["unit_price"] = pd.to_numeric(
        raw["unit_price"],
        errors="coerce"
    )

    raw["customer_id"] = pd.to_numeric(
        raw["customer_id"],
        errors="coerce"
    ).astype("Int64")

    # Convert invoice dates.
    raw["invoice_date"] = pd.to_datetime(
        raw["invoice_date"],
        errors="coerce"
    )

    print(
        f"Raw transactions prepared: {len(raw):,}"
    )

    return raw


# ==========================================================
# 4. CLEAN SALES DATA
# ==========================================================

def clean_sales_data(raw):
    """
    Create a sales table containing valid positive sales.

    Exclude:
    - Missing essential transaction fields
    - Blank invoice or stock identifiers
    - Cancellation invoices
    - Non-positive quantities
    - Non-positive unit prices
    - Exact duplicate rows
    """

    clean = raw.copy()

    # Remove rows missing essential transaction fields.
    clean = clean.dropna(
        subset=[
            "invoice_no",
            "stock_code",
            "quantity",
            "unit_price",
            "invoice_date",
        ]
    )

    # Remove blank identifiers.
    clean = clean[
        clean["invoice_no"].str.strip().ne("")
        & clean["stock_code"].str.strip().ne("")
    ]

    # Exclude cancellation invoices beginning with C.
    clean = clean[
        ~clean["invoice_no"]
        .str.upper()
        .str.startswith("C")
    ]

    # Retain positive sales quantities and prices.
    clean = clean[
        (clean["quantity"] > 0)
        & (clean["unit_price"] > 0)
    ]

    # Remove exact duplicate records after filtering.
    clean = clean.drop_duplicates().copy()

    # Calculate revenue, not profit.
    clean["revenue"] = (
        clean["quantity"] * clean["unit_price"]
    )

    # Add date-derived analytical fields.
    clean["invoice_month"] = (
        clean["invoice_date"].dt.strftime("%Y-%m")
    )

    clean["invoice_hour"] = (
        clean["invoice_date"].dt.hour
    )

    clean["weekday"] = (
        clean["invoice_date"].dt.day_name()
    )

    # Preserve missing customer IDs as missing values.
    clean["customer_id"] = (
        clean["customer_id"].astype("Int64")
    )

    print("\nClean sales summary")
    print("-" * 40)
    print(f"Clean sales rows: {len(clean):,}")
    print(
        "Identified customers: "
        f"{clean['customer_id'].nunique():,}"
    )
    print(
        "Unique invoices: "
        f"{clean['invoice_no'].nunique():,}"
    )
    print(
        "Unique products: "
        f"{clean['stock_code'].nunique():,}"
    )
    print(
        "Total sales revenue: "
        f"£{clean['revenue'].sum():,.2f}"
    )

    return clean


# ==========================================================
# 5. SAVE SQLITE DATABASE
# ==========================================================

def save_database(raw, clean, database_path):
    """Save raw and cleaned transactions to SQLite."""

    print("\nCreating SQLite database...")

    # Ensure the destination directory exists.
    database_path.parent.mkdir(
        parents=True,
        exist_ok=True
    )

    # Close any existing connection before replacing tables.
    with sqlite3.connect(database_path) as connection:

        # Save every source row to the raw table.
        raw.to_sql(
            RAW_TABLE,
            connection,
            if_exists="replace",
            index=False
        )

        # Save cleaned positive sales separately.
        clean.to_sql(
            CLEAN_TABLE,
            connection,
            if_exists="replace",
            index=False
        )

        # Create indexes for common analytical queries.
        connection.execute(
            """
            CREATE INDEX IF NOT EXISTS idx_clean_invoice
            ON clean_sales(invoice_no)
            """
        )

        connection.execute(
            """
            CREATE INDEX IF NOT EXISTS idx_clean_customer
            ON clean_sales(customer_id)
            """
        )

        connection.execute(
            """
            CREATE INDEX IF NOT EXISTS idx_clean_date
            ON clean_sales(invoice_date)
            """
        )

    print(f"Database saved to: {database_path}")


# ==========================================================
# 6. VERIFY DATABASE
# ==========================================================

def verify_database(database_path):
    """Verify tables, row counts, columns and key metrics."""

    print("\nVerifying database...")

    with sqlite3.connect(database_path) as connection:

        # List available tables.
        tables = pd.read_sql_query(
            """
            SELECT name
            FROM sqlite_master
            WHERE type = 'table'
            ORDER BY name
            """,
            connection
        )

        print("\nTables created:")
        print(tables.to_string(index=False))

        table_names = set(tables["name"])

        for required_table in [
            RAW_TABLE,
            CLEAN_TABLE,
        ]:
            if required_table not in table_names:
                raise RuntimeError(
                    f"Missing required table: {required_table}"
                )

        # Count rows in both tables.
        raw_count = pd.read_sql_query(
            "SELECT COUNT(*) AS row_count FROM raw_transactions",
            connection
        ).iloc[0, 0]

        clean_count = pd.read_sql_query(
            "SELECT COUNT(*) AS row_count FROM clean_sales",
            connection
        ).iloc[0, 0]

        # Calculate cleaned sales revenue.
        revenue = pd.read_sql_query(
            """
            SELECT ROUND(SUM(revenue), 2) AS revenue_gbp
            FROM clean_sales
            """,
            connection
        ).iloc[0, 0]

        # Check the columns required by analysis.sql.
        columns = pd.read_sql_query(
            "PRAGMA table_info(clean_sales)",
            connection
        )["name"].tolist()

        required_columns = [
            "invoice_no",
            "stock_code",
            "description",
            "quantity",
            "unit_price",
            "invoice_date",
            "customer_id",
            "country",
            "revenue",
            "invoice_month",
            "invoice_hour",
            "weekday",
        ]

        missing_columns = [
            column
            for column in required_columns
            if column not in columns
        ]

        if missing_columns:
            raise RuntimeError(
                "Required SQL columns are missing: "
                f"{missing_columns}"
            )

    print("\n" + "=" * 48)
    print("PIPELINE VERIFICATION COMPLETE")
    print("=" * 48)
    print(f"Raw transactions: {raw_count:,}")
    print(f"Clean sales rows: {clean_count:,}")
    print(f"Clean sales revenue: £{revenue:,.2f}")
    print(f"Database location: {database_path}")
    print("=" * 48)

    return raw_count, clean_count, revenue


# ==========================================================
# 7. MAIN PIPELINE
# ==========================================================

def main():
    """Execute the complete data preparation pipeline."""

    # Load the original dataset.
    original_df = load_data(INPUT_FILE)

    # Prepare raw data without removing source rows.
    raw_transactions = prepare_raw_transactions(
        original_df
    )

    # Generate the cleaned sales dataset.
    clean_sales = clean_sales_data(
        raw_transactions
    )

    # Save both datasets into SQLite.
    save_database(
        raw_transactions,
        clean_sales,
        DATABASE_FILE
    )

    # Verify the saved database.
    raw_count, clean_count, revenue = verify_database(
        DATABASE_FILE
    )

    # Final completion message.
    print("\nData preparation completed successfully!")

    # Download the generated database in Google Colab.
    try:
        from google.colab import files

        files.download(str(DATABASE_FILE))

    except ImportError:
        print(
            "Google Colab download unavailable. "
            "The database remains at the specified path."
        )


# ==========================================================
# 8. RUN PIPELINE
# ==========================================================

if __name__ == "__main__":
    main()
