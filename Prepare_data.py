here"""
Enterprise SQL Intelligence & Customer Retention Analytics
Data preparation pipeline

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


# --------------------------------------------------
# 1. CONFIGURATION
# --------------------------------------------------

INPUT_FILE = Path("Online Retail.xlsx")
DATABASE_FILE = Path("customer_retention_analytics.db")

RAW_TABLE = "raw_transactions"
CLEAN_TABLE = "clean_sales"


# --------------------------------------------------
# 2. LOAD DATA
# --------------------------------------------------

def load_data(file_path):
    """Load the original Excel dataset."""

    if not file_path.exists():
        raise FileNotFoundError(
            f"Dataset not found: {file_path}\n"
            "Place Online Retail.xlsx in the project directory."
        )

    print("Loading Online Retail dataset...")

    df = pd.read_excel(file_path, engine="openpyxl")

    # Standardize column names for consistent processing.
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
        column for column in required_columns
        if column not in df.columns
    ]

    if missing:
        raise ValueError(
            f"Required columns are missing: {missing}"
        )

    print(f"Raw rows loaded: {len(df):,}")

    return df


# --------------------------------------------------
# 3. PREPARE RAW TRANSACTIONS
# --------------------------------------------------

def prepare_raw_transactions(df):
    """
    Standardize column names and data types.

    The raw table retains all source rows, including
    cancellations, negative quantities and duplicates.
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

    raw["invoice_no"] = raw["invoice_no"].astype("string").str.strip()
    raw["stock_code"] = raw["stock_code"].astype("string").str.strip()
    raw["description"] = raw["description"].astype("string").str.strip()
    raw["country"] = raw["country"].astype("string").str.strip()

    raw["quantity"] = pd.to_numeric(
        raw["quantity"], errors="coerce"
    )

    raw["unit_price"] = pd.to_numeric(
        raw["unit_price"], errors="coerce"
    )

    raw["customer_id"] = pd.to_numeric(
        raw["customer_id"], errors="coerce"
    ).astype("Int64")

    raw["invoice_date"] = pd.to_datetime(
        raw["invoice_date"], errors="coerce"
    )

    return raw


# --------------------------------------------------
# 4. CLEAN SALES DATA
# --------------------------------------------------

def clean_sales_data(raw):
    """
    Keep positive-quantity, positive-price sales lines
    with valid invoice numbers and invoice dates.

    Note:
    These rules must be compared with the rules used
    to produce the project's previously reported results.
    """

    clean = raw.copy()

    # Exclude missing essential transaction information.
    clean = clean.dropna(
        subset=[
            "invoice_no",
            "stock_code",
            "quantity",
            "unit_price",
            "invoice_date",
        ]
    )

    # Exclude blank invoice and stock identifiers.
    clean = clean[
        clean["invoice_no"].str.strip().ne("")
        & clean["stock_code"].str.strip().ne("")
    ]

    # Exclude cancellation invoices.
    clean = clean[
        ~clean["invoice_no"].str.upper().str.startswith("C")
    ]

    # Keep positive sales quantities and unit prices.
    clean = clean[
        (clean["quantity"] > 0)
        & (clean["unit_price"] > 0)
    ]

    # Remove exact duplicate transaction rows.
    clean = clean.drop_duplicates().copy()

    # Calculate sales revenue, not profit.
    clean["revenue"] = (
        clean["quantity"] * clean["unit_price"]
    ).round(2)

    # Create the time-based fields required by analysis.sql.
    clean["invoice_month"] = (
        clean["invoice_date"].dt.strftime("%Y-%m")
    )

    clean["invoice_hour"] = clean["invoice_date"].dt.hour

    clean["weekday"] = clean["invoice_date"].dt.day_name()

    # Normalize customer IDs.
    # Missing customer IDs remain missing; they are not invented.
    clean["customer_id"] = clean["customer_id"].astype("Int64")

    print(f"Cleaned sales rows: {len(clean):,}")
    print(f"Identified customers: {clean['customer_id'].nunique():,}")
    print(f"Unique invoices: {clean['invoice_no'].nunique():,}")
    print(f"Total sales revenue: £{clean['revenue'].sum():,.2f}")

    return clean


# --------------------------------------------------
# 5. SAVE DATABASE
# --------------------------------------------------

def save_database(raw, clean, database_path):
    """Save raw and cleaned tables into a SQLite database."""

    print("\nCreating SQLite database...")

    with sqlite3.connect(database_path) as connection:
        raw.to_sql(
            RAW_TABLE,
            connection,
            if_exists="replace",
            index=False,
        )

        clean.to_sql(
            CLEAN_TABLE,
            connection,
            if_exists="replace",
            index=False,
        )

        # Add indexes to improve common analytical queries.
        connection.execute(
            "CREATE INDEX IF NOT EXISTS idx_clean_invoice "
            "ON clean_sales(invoice_no)"
        )

        connection.execute(
            "CREATE INDEX IF NOT EXISTS idx_clean_customer "
            "ON clean_sales(customer_id)"
        )

        connection.execute(
            "CREATE INDEX IF NOT EXISTS idx_clean_date "
            "ON clean_sales(invoice_date)"
        )

    print(f"Database saved: {database_path.resolve()}")


# --------------------------------------------------
# 6. VERIFY OUTPUT
# --------------------------------------------------

def verify_database(database_path):
    """Check that the database contains both required tables."""

    print("\nVerifying database...")

    with sqlite3.connect(database_path) as connection:
        tables = pd.read_sql_query(
            """
            SELECT name
            FROM sqlite_master
            WHERE type = 'table'
            ORDER BY name
            """,
            connection,
        )

        print("\nTables created:")
        print(tables.to_string(index=False))

        for table in [RAW_TABLE, CLEAN_TABLE]:
            result = pd.read_sql_query(
                f"SELECT COUNT(*) AS row_count FROM {table}",
                connection,
            )

            print(
                f"{table}: "
                f"{result.loc[0, 'row_count']:,} rows"
            )

        # Check columns needed by analysis.sql.
        columns = pd.read_sql_query(
            "PRAGMA table_info(clean_sales)",
            connection,
        )["name"].tolist()

        required = [
            "invoice_no",
            "stock_code",
            "description",
            "quantity",
            "invoice_date",
            "customer_id",
            "country",
            "revenue",
            "invoice_month",
            "invoice_hour",
            "weekday",
        ]

        missing = [
            column for column in required
            if column not in columns
        ]

        if missing:
            raise RuntimeError(
                f"Required SQL columns are missing: {missing}"
            )

    print("\nDatabase verification successful.")


# --------------------------------------------------
# 7. MAIN PIPELINE
# --------------------------------------------------

def main():
    """Run the complete preparation pipeline."""

    raw_df = load_data(INPUT_FILE)

    raw_transactions = prepare_raw_transactions(raw_df)

    clean_sales = clean_sales_data(raw_transactions)

    save_database(
        raw_transactions,
        clean_sales,
        DATABASE_FILE,
    )

    verify_database(DATABASE_FILE)

    print("\nData preparation completed successfully!")


if __name__ == "__main__":
    main()
