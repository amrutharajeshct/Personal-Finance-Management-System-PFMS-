# Business Rules

## Introduction

This document defines the business rules that govern the Personal Finance Management System (PFMS). These rules ensure data consistency, integrity, and accurate financial reporting.

---

## User Rules

**BR-001** — The system shall support one active user in Version 1.

**BR-002** — Each user shall have a unique login account.

---

## Account Rules

**BR-003** — Each account shall have a unique name.
*Examples: Federal Bank, SBI Bank, Punjab National Bank, Cash*

**BR-004** — Accounts shall use soft deletion via an `IsActive` flag. Hard deletion of an account with existing transactions is not allowed.

**BR-005** — An inactive account cannot be used for new transactions.

**BR-006** — Every transaction must be associated with a valid account (`AccountID` is `NOT NULL`). If the account is unknown, a predefined account such as **Cash** or **Unassigned** shall be used.

**BR-007** — Accounts may optionally have an `AccountType` (e.g., Bank, Cash, Savings, Wallet) to support dedicated savings accounts in the future.

---

## Category Rules

**BR-008** — Every category shall belong to exactly one type: **Income** or **Expense**.

**BR-009** — Category names must be unique within their type.
*Example: "Food" (Expense) and "Salary" (Income) can coexist, but two Expense categories cannot both be named "Food."*

**BR-010** — Categories with existing transactions cannot be deleted.

**BR-011** — Categories shall support one level of hierarchy via `ParentCategoryID`.
*Example: Food → Tea, Lunch, Dinner*

**BR-012** — A child category shall belong to the same category type (Income/Expense) as its parent.

---

## Transaction Rules

**BR-013** — Each transaction shall belong to exactly one account.

**BR-014** — Each transaction shall belong to exactly one category, matching the transaction's type (income transactions → income categories; expense transactions → expense categories).

**BR-015** — Transaction amount must be positive (greater than zero). Negative amounts are not allowed.

**BR-016** — Transaction date is mandatory.

**BR-017** — Transaction description is optional.

---

## Account Transfer Rules

**BR-018** — Transfers shall occur between two valid accounts belonging to the same user.

**BR-019** — The source and destination accounts must be different.

**BR-020** — The transfer amount must be greater than zero.

**BR-021** — Transfers shall be stored in a separate `AccountTransfers` table (not in `Transactions`), containing:
- `FromAccountID`
- `ToAccountID`
- `TransferDate`
- `Amount`
- `Description` (optional)

**BR-022** — Transfers shall update the balances of both accounts: decreasing the source account and increasing the destination account.

**BR-023** — Transfers shall not be included in income reports, expense reports, or savings calculations.

---

## Payment Method Rules

**BR-024** — Supported payment methods: Cash, UPI, Debit Card, Bank Transfer.
*Future: Credit Card.*

---

## Reporting Rules

**BR-025** — Monthly income reports shall include only income transactions.

**BR-026** — Monthly expense reports shall include only expense transactions.

**BR-027** — Category-wise reports shall group transactions by category.

**BR-028** — Daily reports shall display transactions for the selected date.

**BR-029** — Savings shall be calculated as:
**Savings = Total Income − Total Expenses**
Savings shall not be stored as a separate ledger; it shall always be derived/computed.

---

## Data Integrity Rules

**BR-030** — Primary keys shall uniquely identify each record.

**BR-031** — Foreign key relationships shall maintain referential integrity.

**BR-032** — Duplicate transactions should be avoided where possible.

**BR-033** — All monetary values shall use the `DECIMAL` data type.

**BR-034** — Financial records shall not be permanently deleted; soft deletion (`IsActive` / status flags) shall be used throughout.

---

## Future Business Rules

- Budget validation
- EMI reminders
- Savings goals
- Investment tracking
- Loan repayment schedules
- Recurring transactions
