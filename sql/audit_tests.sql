-- EY Audit Analytics & Financial Data Quality Assessment
-- MySQL 8+
-- Assumes the cleaned CSV is loaded into: audit_transactions

-- 1. Basic population
SELECT COUNT(*) AS transaction_count,
       ROUND(SUM(Amount), 2) AS total_transaction_value
FROM audit_transactions;

-- 2. Duplicate invoice testing
SELECT Invoice_Number, COUNT(*) AS duplicate_count,
       ROUND(SUM(Amount),2) AS total_value
FROM audit_transactions
WHERE Invoice_Number IS NOT NULL
GROUP BY Invoice_Number
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- 3. Missing approval / approval threshold testing
SELECT Transaction_ID, Transaction_Date, Vendor_ID, Amount,
       Required_Approval, Approver_ID
FROM audit_transactions
WHERE Approver_ID IS NULL
  AND ABS(Amount) >= 1000
ORDER BY ABS(Amount) DESC;

-- 4. Period-end high-value testing
SELECT Transaction_ID, Transaction_Date, Posting_Date,
       Department, Amount
FROM audit_transactions
WHERE Period_End_Flag = 1
  AND ABS(Amount) >= 10000
ORDER BY Transaction_Date DESC, ABS(Amount) DESC;

-- 5. Invalid posting dates
SELECT Transaction_ID, Transaction_Date, Posting_Date
FROM audit_transactions
WHERE Posting_Date < Transaction_Date
ORDER BY Transaction_Date;

-- 6. Missing master-data fields
SELECT
    SUM(Vendor_ID IS NULL) AS missing_vendor,
    SUM(Account_ID IS NULL) AS missing_account,
    SUM(Approver_ID IS NULL) AS missing_approver
FROM audit_transactions;

-- 7. High-value transactions
SELECT Transaction_ID, Transaction_Date, Vendor_ID,
       Department, Amount, Risk_Level
FROM audit_transactions
WHERE ABS(Amount) >= 50000
ORDER BY ABS(Amount) DESC
LIMIT 100;

-- 8. Exception summary by category
SELECT Exception_Category,
       COUNT(*) AS exception_records,
       ROUND(SUM(ABS(Amount)),2) AS transaction_value
FROM audit_transactions
WHERE Exception_Flag = 1
GROUP BY Exception_Category
ORDER BY exception_records DESC;

-- 9. Exception trend by month
SELECT Transaction_Month,
       COUNT(*) AS transactions,
       SUM(Exception_Flag) AS exception_records,
       ROUND(100 * AVG(Exception_Flag), 2) AS exception_rate_pct
FROM audit_transactions
GROUP BY Transaction_Month
ORDER BY Transaction_Month;

-- 10. Department-level exception analysis
SELECT Department,
       COUNT(*) AS transactions,
       SUM(Exception_Flag) AS exception_records,
       ROUND(100 * AVG(Exception_Flag), 2) AS exception_rate_pct,
       ROUND(SUM(ABS(Amount)),2) AS transaction_value
FROM audit_transactions
GROUP BY Department
ORDER BY exception_rate_pct DESC;
