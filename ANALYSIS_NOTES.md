# Analysis Notes: Enterprise SQL Intelligence & Customer Retention Analytics

## What I wanted to understand

For this project, I used historical online retail transactions to explore a few practical business questions:

- How does revenue change over time?
- Which products and markets contribute most to recorded sales?
- How much of the customer base appears to return?
- Can customer purchase behaviour be grouped into useful segments?
- What should a business investigate before making decisions from these numbers?

I focused on questions that a sales, operations, or customer analytics team could reasonably ask—not just on writing queries for their own sake.

## A few findings from the cleaned analysis

The dataset contains historical transactions from December 2010 to December 2011. After cleaning and filtering the transaction records for the sales analysis, the project reports:

- **524,878** sales records retained from **541,909** raw transaction rows.
- **19,960** distinct invoices.
- **4,338** identified customers.
- **3,922** products.
- **38** countries represented.
- Approximately **£10.64 million** in recorded revenue.
- An average invoice value of approximately **£533.17**.
- A repeat-customer rate of approximately **65.58%** among identified customers, based on the project's calculation.

These figures describe this dataset and its cleaning rules. They should not be interpreted as current market performance or as proof that any particular business strategy caused the observed behaviour.

## How I interpret the results

Revenue totals are useful for understanding sales activity, but they do not tell the whole story. A product with high revenue may also have high costs, and revenue alone cannot establish profitability.

Likewise, a repeat-customer rate is a useful starting point, but it depends on how customers are identified and which transactions are included. It does not automatically tell us why customers return, how satisfied they are, or whether they will keep purchasing.

Customer segments such as RFM groups can help prioritise further investigation. They are descriptive labels based on observed purchase behaviour, not permanent descriptions of a person.

## Checks I would make before acting on the analysis

1. Confirm how cancellations, returns, and negative-quantity rows are handled.
2. Check whether customer IDs are missing and how that affects retention calculations.
3. Compare revenue by month and market, while checking for unusually large orders.
4. Validate the RFM scoring rules and the date used as the analysis reference point.
5. Compare the findings with more recent data before making present-day business decisions.
6. Bring in cost, margin, marketing, and customer-service data before making profitability or customer-experience claims.

## What I would investigate next

If I had access to more business data, I would look at customer retention by acquisition period, product combinations in the same basket, changes in average order value, and the relationship between customer segments and gross margin. I would also ask stakeholders which decisions they need the analysis to support.

## Project reflection

This project helped me practise turning transaction data into business questions, documenting cleaning assumptions, writing SQL analysis, and explaining results with appropriate caveats. The main lesson is that a query result is only useful when its definition is clear and its limitations are understood.
