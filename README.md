# Audit Analytics & Financial Data Quality Assessment

## Overview

This portfolio project simulates how data analytics can support an assurance/audit team in identifying financial data-quality issues, unusual transactions, control exceptions, and areas requiring further investigation.

**Important:** The dataset is fully synthetic and does not represent a real client or real audit engagement.

## Business Objective

Analyse 100,000 financial transactions to:

- Validate data quality and completeness
- Identify duplicate invoices
- Test approval-threshold controls
- Identify period-end high-value transactions
- Detect invalid transaction/posting dates
- Identify unusual transaction amounts
- Prioritise exceptions for further review
- Present findings through a Power BI dashboard

## Technology

- Python / Pandas / NumPy
- MySQL
- Power BI
- Excel (optional)
- GitHub

## Workflow

Raw synthetic data → Python cleaning & validation → SQL audit tests → anomaly detection → exception prioritisation → Power BI dashboard → findings & recommendations

## Audit Analytics Tests

1. Duplicate invoice testing
2. Missing approval / approval-threshold testing
3. Period-end high-value transaction testing
4. Invalid posting-date testing
5. Missing master-data testing
6. High-value transaction review
7. Exception trend analysis
8. Department-level exception analysis

## Anomaly Detection

A transparent IQR-based statistical method is used to flag unusually high positive transaction amounts. An anomaly is **not** treated as evidence of fraud; it is a transaction requiring further investigation.

## Key Synthetic Results

- **100,000** transactions analysed
- **£300.69M** total transaction value
- **4.66%** of records contained one or more defined exceptions
- **501** records were classified as high risk
- **1,780** records were associated with duplicate invoice references
- **700** records had missing approvals
- **400** records had missing vendor IDs
- **250** records had invalid/non-positive amounts
- **1,474** records had posting dates earlier than transaction dates
- **8,938** transactions were flagged as unusually high by the IQR anomaly test

## Important Interpretation

These are synthetic data-quality and analytical exceptions. They should be described as **items requiring investigation**, not confirmed control failures, fraud, or audit findings.

## Power BI Dashboard

### Page 1 — Executive Overview
- Total transactions
- Total transaction value
- Exception count
- Exception rate
- High-risk transaction count
- Monthly transaction trend
- Exceptions by category
- Transaction value by department

### Page 2 — Exception Analysis
- Exception category
- Risk level
- Department
- High-value transactions
- Detailed transaction table
- Filters for date, department, vendor, risk and exception category

### Page 3 — Data Quality
- Missing vendor records
- Missing account records
- Missing approval records
- Invalid amount records
- Invalid posting-date records
- Duplicate invoice records
- Data-quality trend

## Recommendations

1. Review high-risk and high-value exceptions before relying on the affected records for reporting.
2. Strengthen duplicate-invoice validation before payment processing.
3. Introduce mandatory approval controls for transactions above defined thresholds.
4. Add automated validation for posting dates and master-data completeness.
5. Use exception dashboards to prioritise review rather than manually inspecting the entire transaction population.
6. Investigate recurring department-level exception patterns for potential process improvement.

## Limitations

- Synthetic data only
- No conclusion about fraud or financial-statement misstatement
- Approval rules are illustrative
- IQR anomaly detection is a screening technique, not an audit conclusion
- A real engagement would require documented client policies, evidence, materiality thresholds, audit methodology and professional judgement

## Portfolio Positioning

This project demonstrates practical application of SQL, Python, Power BI, data validation, analytics, exception testing, anomaly detection, reporting and process improvement in an assurance-oriented scenario.
