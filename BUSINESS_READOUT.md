# Business Readout: What the Retail Data Suggests

## Why I looked at these questions

I wanted this project to go beyond writing SQL queries that return tables. The aim was to understand what a retailer could learn from its transaction history: where sales are coming from, whether customers return, and which data-quality issues could change the story.

The analysis uses the UCI Online Retail dataset, which covers transactions from December 2010 to December 2011. It is a useful case study, but it is old data from one retailer, so I would not treat the results as a picture of today's e-commerce market.

## First, I checked what the data could support

The raw file contains 541,909 transaction lines. Before interpreting sales, I separated normal positive-sales records from cancellation invoices and rows with non-positive quantities or prices. I also checked exact duplicates and kept transactions with missing customer IDs in overall sales totals, while leaving them out of customer-level calculations.

These choices matter. For example, a negative quantity may represent a return rather than a normal sale. Excluding it from positive-sales revenue makes the sales measure easier to interpret, but it does not replace a full finance reconciliation of sales, returns and refunds.

## What stands out

- **There is enough transaction history to explore repeat behaviour.** The cleaned analysis covers 19,960 distinct invoices. That gives a useful base for studying order patterns across the observation period.
- **Customer IDs are essential for retention analysis.** The observed repeat-customer rate is 65.58% among customers with an ID. This should be read as a result for the identifiable-customer subset, not necessarily every buyer.
- **Revenue needs context.** The cleaned positive-sales total is £10,642,110.80. This is calculated as quantity multiplied by unit price; it is sales revenue, not profit, because the dataset does not provide product costs or margins.
- **A single repeat-rate number is not the whole retention story.** Cohort analysis helps distinguish customers who return soon after their first purchase from those who do not appear again during the available period. Later cohorts also have less time to return, so they should be compared at the same cohort age.
- **A customer segment is a starting point, not a verdict.** RFM groups can help a business organise follow-up analysis, but the labels do not prove that a customer has churned or that a campaign will bring them back.

## How I would use the findings

If this were a business review, I would use the results to decide where to investigate next rather than immediately recommending a campaign:

1. Review the highest-revenue products and check whether their contribution is driven by units sold, price, or both.
2. Compare country performance using both revenue and invoice counts so that large totals are not mistaken for stronger order economics.
3. Inspect cohort retention at matched month numbers before comparing acquisition periods.
4. Review high-value customers and the distribution of revenue across customers, while checking how missing customer IDs affect the picture.
5. Reconcile cancellations and returns with the retailer's finance definitions before using the numbers for reporting.

## What I would improve in a real deployment

I would automate the cleaning checks, add tests for missing or inconsistent values, and document each metric so that another analyst could reproduce it. I would also ask stakeholders how they define a sale, a return, an active customer and churn before publishing a production dashboard. If cost data became available, I would add gross margin because revenue alone cannot show which products or customers are most profitable.

## A note on scope

This is a descriptive analysis of historical transactions. It does not forecast churn, estimate campaign impact, or prove causation. Those questions would need additional data and a separate evaluation design.

## Data source

Chen, D. (2015). *Online Retail* [Dataset]. UCI Machine Learning Repository. https://doi.org/10.24432/C5BW33
