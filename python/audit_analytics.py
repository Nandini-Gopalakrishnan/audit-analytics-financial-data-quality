import pandas as pd
import numpy as np

raw = pd.read_csv("audit_analytics_raw_transactions.csv",
                  parse_dates=["Transaction_Date", "Posting_Date"])

# Data validation
raw["Amount"] = pd.to_numeric(raw["Amount"], errors="coerce")
raw["Missing_Vendor_Flag"] = raw["Vendor_ID"].isna().astype(int)
raw["Missing_Approver_Flag"] = raw["Approver_ID"].isna().astype(int)
raw["Missing_Account_Flag"] = raw["Account_ID"].isna().astype(int)
raw["Invalid_Amount_Flag"] = (raw["Amount"] <= 0).astype(int)
raw["Invalid_Posting_Date_Flag"] = (
    raw["Posting_Date"] < raw["Transaction_Date"]
).astype(int)

# Duplicate invoice testing
raw["Duplicate_Invoice_Flag"] = (
    raw["Invoice_Number"].notna()
    & raw.duplicated("Invoice_Number", keep=False)
).astype(int)

# Period-end testing
raw["Period_End_Flag"] = (
    raw["Transaction_Date"].dt.is_month_end
    | (raw["Transaction_Date"].dt.day >= 27)
).astype(int)

# Approval thresholds
raw["Required_Approval"] = np.select(
    [raw["Amount"].abs() > 10000, raw["Amount"].abs() >= 1000],
    ["Finance Director", "Senior Manager"],
    default="Department Manager"
)

raw["Approval_Exception_Flag"] = (
    raw["Approver_ID"].isna() & (raw["Amount"].abs() >= 1000)
).astype(int)

# Exception aggregation
flags = [
    "Missing_Vendor_Flag", "Missing_Approver_Flag",
    "Missing_Account_Flag", "Invalid_Amount_Flag",
    "Invalid_Posting_Date_Flag", "Duplicate_Invoice_Flag",
    "Approval_Exception_Flag"
]
raw["Exception_Count"] = raw[flags].sum(axis=1)
raw["Exception_Flag"] = (raw["Exception_Count"] > 0).astype(int)

# Risk prioritisation
raw["Risk_Level"] = np.select(
    [
        (raw["Amount"].abs() >= 50000) | (raw["Exception_Count"] >= 3),
        (raw["Amount"].abs() >= 10000) | (raw["Exception_Count"] == 2)
    ],
    ["High", "Medium"],
    default="Low"
)

# Transparent anomaly detection using IQR
positive = raw.loc[raw["Amount"] > 0, "Amount"]
q1, q3 = positive.quantile([0.25, 0.75])
upper_bound = q3 + 1.5 * (q3 - q1)
raw["Anomaly_Flag"] = (raw["Amount"] > upper_bound).astype(int)

raw.to_csv("audit_analytics_clean_transactions.csv", index=False)
raw[raw["Exception_Flag"] == 1].to_csv(
    "audit_analytics_exception_review.csv", index=False
)
