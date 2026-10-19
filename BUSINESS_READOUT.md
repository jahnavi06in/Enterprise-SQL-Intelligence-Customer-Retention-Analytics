# Business Readout: Enterprise SQL Intelligence & Customer Retention Analytics

## 1. Project Objective

The goal of this project was to use SQL to turn historical retail transactions into business insights. I focused on revenue performance, product and geographic contribution, repeat purchasing behaviour, customer retention, and data quality.

The analysis uses the UCI Online Retail dataset, covering transactions from December 2010 to December 2011. The findings describe one retailer during this historical period and should not be treated as a representation of today's e-commerce market.

## 2. Data Quality and Methodology

The raw dataset contains **541,909 transaction lines**. Before analysing sales, I examined duplicate records, cancellation invoices, non-positive quantities and prices, and missing customer identifiers.

For the positive-sales analysis, I used deduplicated records with valid invoice and date information, positive quantities, positive unit prices, and invoice IDs not beginning with `C`.

Revenue was calculated as:

**Revenue = Quantity × Unit Price**

This measures sales value, not profit. Product costs, operating expenses, and profit margins are not available in the dataset.

Transactions without customer IDs can contribute to overall sales totals but cannot reliably support customer-level retention calculations. Cancellation and return records require separate treatment and reconciliation before these metrics could be used in formal financial reporting.

## 3. Key Business Findings

### Revenue Performance

The cleaned positive-sales dataset contains **£10,642,110.80 in revenue** across **19,960 distinct invoices**.

November 2011 was the highest-revenue month, contributing **£1,503,866.78**, while February 2011 was the lowest, at **£522,545.56**.

**Business implication:** Monthly revenue trends can help identify periods that deserve further investigation. Comparing revenue with invoice counts and average order values would help distinguish higher sales volume from changes in order value.

### Geographic Contribution

The United Kingdom generated **£9,001,744.09 in revenue**, making it the leading country by sales value in this dataset.

**Business implication:** The retailer could investigate whether its geographic concentration reflects its established customer base, market reach, or order patterns. Comparing revenue, invoice counts, and average invoice value by country would provide a more balanced view of performance.

### Product Performance

The highest-revenue product was **DOTCOM POSTAGE**, with **£206,248.77**, representing approximately **1.94% of total cleaned positive-sales revenue**.

**Business implication:** Product rankings can help prioritise further analysis, but high revenue alone does not establish profitability. Units sold, pricing, product costs, and the role of postage-related items should be considered before making product or inventory decisions.

### Customer Retention

The observed repeat-customer rate was **65.58%**: 2,845 out of 4,338 identifiable customers placed at least two distinct invoices during the observation period.

**Business implication:** Repeat purchasing is an important area for further investigation. However, this historical repeat rate does not prove customer loyalty, predict future purchases, or represent buyers whose customer IDs are missing.

### Customer Revenue Concentration

The top 10 identified customers contributed **17.30% of identified-customer revenue**.

**Business implication:** Measuring revenue concentration helps assess how much recorded sales value comes from a small group of customers. A business could monitor this concentration alongside customer activity and purchasing frequency, without assuming that high-value customers will necessarily leave.

### Cohort Retention

Cohort analysis groups customers by the month of their first recorded purchase and tracks subsequent purchasing activity.

**Business implication:** Comparing cohorts at the same number of months after their first purchase provides a fairer view of retention patterns. Later cohorts have less observed history, so their retention should not be compared directly with older cohorts at different cohort ages.

### RFM Customer Segmentation

Recency, Frequency, and Monetary (RFM) analysis groups identifiable customers according to how recently they purchased, how frequently they ordered, and how much recorded revenue they generated.

**Business implication:** RFM segments can help prioritise customer analysis and support the design of targeted follow-up questions. These segments are descriptive, not proof of churn, customer profitability, or campaign effectiveness.

## 4. Recommended Next Steps

Based on this analysis, I would recommend the following investigations before making operational decisions:

1. **Product analysis:** Compare revenue with units sold, average selling price, and product costs to distinguish sales contribution from profitability.
2. **Geographic analysis:** Compare country-level revenue, invoice counts, and average invoice value to understand differences in purchasing patterns.
3. **Retention analysis:** Review cohort retention at matched cohort ages to identify differences in repeat-purchasing behaviour.
4. **Customer concentration:** Monitor the share of identified-customer revenue generated by the highest-value customers and examine changes over time.
5. **Revenue validation:** Reconcile cancellations, returns, and refunds against the retailer's financial reporting definitions.
6. **Data quality automation:** Introduce repeatable validation checks for duplicates, missing identifiers, invalid quantities, and inconsistent prices.
7. **Metric documentation:** Define revenue, repeat customer, active customer, and churn consistently before developing a production dashboard.

## 5. Limitations

- The dataset represents one retailer and a historical period from 2010 to 2011.
- Revenue is calculated from quantity and unit price; it does not measure profit or margin.
- Customer-level metrics exclude transactions that cannot be linked to an identified customer.
- Historical repeat purchasing does not guarantee future retention.
- Later customer cohorts have shorter observation windows.
- RFM segments describe past behaviour and do not predict churn on their own.
- The analysis is descriptive: it does not forecast customer behaviour, establish causation, or measure the impact of marketing campaigns.
- Return and cancellation handling should be reconciled with formal financial records before production use.

## 6. What I Would Improve in a Real Business Environment

For a production implementation, I would automate the data-cleaning workflow, add validation tests, document metric definitions, and establish repeatable reporting checks.

I would also work with business stakeholders to agree on definitions for sales, returns, active customers, retention, and churn. If product-cost and margin data became available, I would extend the analysis to profitability.

Finally, I would validate any proposed retention initiative through a controlled evaluation rather than assuming that an observed historical pattern guarantees a successful outcome.

## 7. Project Scope

This project demonstrates SQL-based descriptive analytics using historical retail transaction data. It focuses on converting raw transaction records into interpretable metrics and business questions.

It does not claim to provide a production forecasting system, predictive churn model, or tested marketing strategy.

## 8. Data Source

Chen, D. (2015). *Online Retail* [Dataset]. UCI Machine Learning Repository.

https://doi.org/10.24432/C5BW33
