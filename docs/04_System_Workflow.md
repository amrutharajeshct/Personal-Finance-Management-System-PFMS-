# System Workflow

## Introduction

This document describes how a user interacts with the Personal Finance Management System (PFMS) — the step-by-step flow behind each major feature. It reflects the entities and business rules finalized in `05_Entity_Analysis.md` and `business-rules.md`, and will guide the stored procedure and application-layer design later.

---

## 1. Login Workflow

```text
User Login
    ↓
Validate against [User] table (UserName + PasswordHash)  -- BR-002, BR-003
    ↓
Dashboard
```

**Notes:**
- Version 1 supports a single active user (BR-001). If no login screen is built yet, this step is skipped and the app connects directly to the single seeded user.
- Dashboard should surface: total balance across active accounts, this month's income vs. expense, and savings so far.

---

## 2. Add Income Workflow

```text
Dashboard
    ↓
Income
    ↓
Select Account            -- must be an active Account (BR-011)
    ↓
Select Income Category    -- Category.CategoryTypeID = 'Income' (BR-015, BR-018)
    ↓
Select Payment Method      -- BR-027
    ↓
Enter Amount               -- must be > 0 (BR-024)
    ↓
Enter Date                 -- mandatory (BR-025)
    ↓
Enter Description (optional)  -- BR-026
    ↓
Save
    ↓
System sets TransactionTypeID = 'Income', TransactionSourceID = 'Manual'
    ↓
Trigger validates Category type matches Transaction type (BR-023)
    ↓
Update Reports (dashboard, monthly income, category-wise)
```

---

## 3. Add Expense Workflow

```text
Dashboard
    ↓
Expense
    ↓
Select Account             -- must be active (BR-011)
    ↓
Select Expense Category    -- Category.CategoryTypeID = 'Expense'
    ↓
    ├── Optionally drill into a sub-category (BR-019)
    ↓
Select Payment Method       -- BR-027
    ↓
Enter Amount                -- must be > 0 (BR-024)
    ↓
Enter Date                  -- mandatory (BR-025)
    ↓
Enter Description (optional)
    ↓
Save
    ↓
System sets TransactionTypeID = 'Expense', TransactionSourceID = 'Manual'
    ↓
Trigger validates Category type matches Transaction type (BR-023)
    ↓
Update Reports (dashboard, monthly expense, category-wise, payment method analysis)
```

---

## 4. Self Transfer Workflow

```text
Dashboard
    ↓
Transfer Money
    ↓
Select From Account
    ↓
Select To Account           -- must differ from From Account (BR-029)
    ↓
Enter Amount                -- must be > 0 (BR-030)
    ↓
Enter Date
    ↓
Enter Description (optional)
    ↓
Save
    ↓
Record inserted into AccountTransfer (NOT Transaction) — BR-031
    ↓
Update balances: decrease From Account, increase To Account (BR-032)
    ↓
Transfer excluded from income/expense/savings reports (BR-033)
```

---

## 5. Category Management Workflow

```text
Dashboard
    ↓
Categories
    ↓
Add / Edit Category
    ↓
Choose Type: Income or Expense   -- BR-015
    ↓
Optionally choose a Parent Category  -- one level only (BR-019)
    ↓
Trigger validates child type matches parent type (BR-020)
    ↓
Save
    ↓
    ├── Deactivate: sets IsActive = 0 (BR-018)
    └── Delete blocked if transactions exist (BR-017)
```

---

## 6. Account Management Workflow

```text
Dashboard
    ↓
Accounts
    ↓
Add / Edit Account
    ↓
Enter Account Name          -- must be unique (BR-009)
    ↓
Select Account Type          -- Bank / Cash / Wallet / Savings (BR-013)
    ↓
    ├── If Bank: enter AccountNumber, IFSCCode, BankName (optional fields)
    └── If Cash/Wallet: banking fields left NULL
    ↓
Select Currency               -- defaults to INR
    ↓
Enter Opening Balance
    ↓
Save
    ↓
    ├── Deactivate: sets IsActive = 0 (BR-010, BR-011)
    └── Hard delete blocked if transactions/transfers exist (BR-010)
```

**Note:** Current balance is never stored directly — it's always computed as:
`OpeningBalance + Income − Expense + Incoming Transfers − Outgoing Transfers`

---

## 7. Reports Workflow

```text
Dashboard
    ↓
Reports
    ↓
Choose Report Type:
    ├── Daily Report              (BR-037)
    ├── Monthly Income Report     (BR-034)
    ├── Monthly Expense Report    (BR-035)
    ├── Income vs Expense / Savings (BR-041)
    ├── Category-wise Report      (BR-036)
    ├── Account-wise Report       (BR-038)
    ├── Payment Method Analysis   (BR-040)
    └── Monthly Spending Trend    (BR-039)
    ↓
Select Date Range
    ↓
Generate Report (query excludes AccountTransfer records — BR-033)
    ↓
Display / Export (Excel, PDF — future scope)
```

---

## 8. Workflow-to-Entity Cross-Reference

| Workflow | Primary Tables Touched |
|---|---|
| Login | User |
| Add Income / Expense | Transaction, Account, Category, PaymentMethod, TransactionType, TransactionSource |
| Self Transfer | AccountTransfer, Account |
| Category Management | Category, CategoryType |
| Account Management | Account, AccountType, Currency |
| Reports | Transaction, Category, Account, PaymentMethod (read-only, aggregated) |

---

Next document: **06_ER_Diagram.md** — visualizing these entities, relationships, and the workflows above.
