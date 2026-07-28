# Business Rules

## Introduction

This document defines the business rules that govern the Personal Finance Management System (PFMS). These rules ensure data consistency, integrity, and accurate financial reporting, and are aligned with the Project Overview and Requirements Specification documents.

---

## User Rules

**BR-001** — The system shall support one active user in Version 1.

**BR-002** — Each user shall have a unique login account.

**BR-003** — If a login/authentication mechanism is implemented in Version 1, passwords shall be stored using secure hashing (never plain text). If no login screen exists in V1 and access is limited to direct database/application use, this rule shall apply once authentication is introduced.

---

## Account Rules

**BR-004** — Each account shall have a unique name.
*Examples: Federal Bank, SBI Bank, Punjab National Bank, Cash*

**BR-005** — Accounts shall use soft deletion via an `IsActive` flag. Hard deletion of an account with existing transactions is not allowed.

**BR-006** — An inactive account cannot be used for new transactions.

**BR-007** — Every transaction must be associated with a valid account (`AccountID` is `NOT NULL`). If the account is unknown, a predefined account such as **Cash** or **Unassigned** shall be used.

**BR-008** — Accounts may optionally have an `AccountType` (e.g., Bank, Cash, Savings, Wallet) to support dedicated savings accounts in the future.

**BR-009** — The `Accounts` table shall include a `UserID` foreign key to support multi-user expansion in future versions, even though Version 1 enforces a single active user (BR-001).

---

## Category Rules

**BR-010** — Every category shall belong to exactly one type: **Income** or **Expense**.

**BR-011** — Category names must be unique within their type.
*Example: "Food" (Expense) and "Salary" (Income) can coexist, but two Expense categories cannot both be named "Food."*

**BR-012** — Categories with existing transactions cannot be deleted.

**BR-013** — Categories shall support an `IsActive` flag. Inactive categories cannot be used for new transactions but shall remain visible in historical reports.

**BR-014** — Categories shall support one level of hierarchy via `ParentCategoryID`.
*Example: Daily Expenses → Tea, Breakfast, Lunch, Dinner, Snacks, Bus, Auto, Fuel*

**BR-015** — A child category shall belong to the same category type (Income/Expense) as its parent.

---

## Payment Method Rules

**BR-016** — Supported payment methods: Cash, UPI, Debit Card, Bank Transfer.
*Future: Credit Card.*

---

## Transaction Rules

**BR-017** — Each transaction shall belong to exactly one account.

**BR-018** — Each transaction shall belong to exactly one category, matching the transaction's type (income transactions → income categories; expense transactions → expense categories).

**BR-019** — Transaction amount must be positive (greater than zero). Negative amounts are not allowed.

**BR-020** — Transaction date is mandatory.

**BR-021** — Transaction description is optional.

**BR-022** — Every transaction shall record a payment method, selected from the supported list defined in BR-016.

---

## Account Transfer Rules

**BR-023** — Transfers shall occur between two valid accounts belonging to the same user.

**BR-024** — The source and destination accounts must be different.

**BR-025** — The transfer amount must be greater than zero.

**BR-026** — Transfers shall be stored in a separate `AccountTransfers` table (not in `Transactions`), containing:
- `FromAccountID`
- `ToAccountID`
- `TransferDate`
- `Amount`
- `Description` (optional)

**BR-027** — Transfers shall update the balances of both accounts: decreasing the source account and increasing the destination account.

**BR-028** — Transfers shall not be included in income reports, expense reports, or savings calculations.

---

## Reporting Rules

**BR-029** — Monthly income reports shall include only income transactions.

**BR-030** — Monthly expense reports shall include only expense transactions.

**BR-031** — Category-wise reports shall group transactions by category.

**BR-032** — Daily reports shall display transactions for the selected date.

**BR-033** — Account-wise reports shall display all transactions grouped by account.

**BR-034** — Monthly spending trend reports shall show expense patterns across months to support trend analysis.

**BR-035** — Payment method analysis reports shall group transactions by payment method (BR-016) to show spending distribution across Cash, UPI, Debit Card, and Bank Transfer.

**BR-036** — Savings shall be calculated as:
**Savings = Total Income − Total Expenses**
Savings shall not be stored as a separate ledger; it shall always be derived/computed.

---

## Data Integrity Rules

**BR-037** — Primary keys shall uniquely identify each record.

**BR-038** — Foreign key relationships shall maintain referential integrity.

**BR-039** — Duplicate transactions should be avoided where possible.

**BR-040** — All monetary values shall use the `DECIMAL` data type.

**BR-041** — Financial records shall not be permanently deleted; soft deletion (`IsActive` / status flags) shall be used throughout.

---

## Future Business Rules

- Budget validation
- EMI reminders
- Savings goals
- Investment tracking
- Loan repayment schedules
- Recurring transactions
