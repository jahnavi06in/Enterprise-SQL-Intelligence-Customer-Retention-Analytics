# Data Source and Methodology

## Project
**Enterprise SQL Intelligence & Customer Retention Analytics**

## Why I chose this dataset
I used the UCI Online Retail dataset because it contains transaction-level records that make it possible to explore practical e-commerce questions: how revenue changes over time, which products contribute most to sales, how customers return, and how purchasing behaviour differs across customer groups.

**Source:** UCI Machine Learning Repository — Online Retail dataset  
https://archive.ics.uci.edu/dataset/352/online+retail

The dataset describes transactions from a UK-based online retailer between **1 December 2010 and 9 December 2011**. It is historical data, so the results should be treated as a case study rather than a description of today's retail market.

## Questions I wanted to answer
1. How does recorded sales revenue change over time?
2. Which products and countries contribute the most recorded revenue?
3. How much of the customer base made purchases on more than one occasion?
4. What patterns appear when customers are grouped by recency, frequency, and monetary value (RFM)?
5. What should a business investigate next before taking action?

## Preparation and quality checks
Before interpreting the results, I considered the following checks:

- Inspect missing customer identifiers and avoid pretending those records can be assigned to known customers.
- Check quantities and unit prices for zero or negative values, since cancellations, returns, and unusual records can affect revenue calculations.
- Use invoice and customer identifiers consistently when counting transactions and customers.
- Keep the distinction between transaction-level records and customer-level summaries clear.
- Verify that revenue calculations use quantity multiplied by unit price, and label the measure as **recorded sales revenue**, not profit.

The treatment of cancelled invoices, returns, missing identifiers, and unusual values should be stated explicitly in the SQL and reflected consistently in all output tables. Where these decisions change the population being analysed, the resulting counts may differ from the raw dataset totals.

## Analytical approach

### Revenue trends
Aggregate transaction line revenue over time to identify broad patterns. Monthly totals are easier to communicate to business stakeholders than a long list of individual invoices.

### Product and geography analysis
Rank products and countries by recorded revenue. These rankings describe contribution in this dataset; they do not by themselves explain why a product performs well or whether it is profitable.

### Customer retention
Use customer identifiers and invoice dates to distinguish one-time purchasers from customers with multiple recorded purchases. Define the repeat-customer calculation clearly, including which records are included in the customer population.

### RFM segmentation
RFM stands for:
- **Recency:** how recently a customer purchased relative to the analysis reference date.
- **Frequency:** how often the customer purchased during the observed period.
- **Monetary value:** the total recorded spend attributed to that customer during the observed period.

RFM groups are descriptive, not permanent labels. Results depend on the reference date, the cleaning rules, and the scoring thresholds used.

## Important limitations
- The dataset covers a limited historical period and one retailer; it is not representative of every e-commerce business.
- Missing customer IDs limit customer-level analysis for some transactions.
- Recorded revenue does not include all costs, so it cannot be used as a substitute for profit or margin.
- Returns, cancellations, discounts, shipping, and other business rules can affect interpretation.
- A customer who does not appear again within the observed period is not necessarily permanently lost; the dataset window may simply end before their next purchase.
- Descriptive patterns show associations, not the causes of customer behaviour.

## What I would investigate next
1. Compare retention across acquisition periods using a clearly defined cohort method.
2. Separate returned or cancelled transactions from completed sales and reconcile the impact on revenue.
3. Add gross margin and marketing-cost data before recommending which products or customers to prioritise.
4. Test whether retention patterns differ by customer location or product category, while checking sample sizes.
5. Validate any proposed retention campaign through an experiment rather than assuming that correlation implies impact.

## Reproducibility note
The SQL scripts, data preparation rules, and output summaries should agree with one another. If the cleaning logic or analysis period changes, rerun the relevant queries and update reported numbers rather than manually editing results. Document any assumptions that are specific to this implementation.
