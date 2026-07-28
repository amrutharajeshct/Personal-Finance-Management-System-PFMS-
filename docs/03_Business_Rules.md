# Business Rules

## Introduction

This document defines the business rules that govern the Personal Finance Management System. These rules ensure data consistency, integrity, and accurate financial reporting.

---

# User Rules

BR-001

The system shall support one active user in Version 1.

BR-002

Each user shall have a unique login account.

---

# Account Rules

BR-003

Each account shall have a unique name.

Examples

- Federal Bank
- SBI Bank
- Punjab National Bank
- Cash

BR-004

An account cannot be deleted if transactions exist.

BR-005

An inactive account cannot be used for new transactions.

---

# Income Rules

BR-006

Every income transaction must belong to one income category.

BR-007

Income amount must be greater than zero.

BR-008

Income date is mandatory.

---

# Expense Rules

BR-009

Every expense shall belong to one expense category.

BR-010

Expense amount must be greater than zero.

BR-011

Expense date is mandatory.

BR-012

Every expense must be associated with one account.

---

# Category Rules

BR-013

Every category shall belong to either:

- Income
- Expense

BR-014

Category names must be unique within their type.

Example

Food (Expense)

Salary (Income)

BR-015

Categories with existing transactions cannot be deleted.

---

# Transaction Rules

BR-016

Each transaction shall belong to exactly one account.

BR-017

Each transaction shall belong to exactly one category.

BR-018

Transaction amount must be positive.

BR-019

Transaction date cannot be empty.

BR-020

Transaction description is optional.

---

# Account Transfer Rules

BR-021

Transfers shall occur between two valid accounts.

BR-022

Transfers shall not be included in income reports.

BR-023

Transfers shall not be included in expense reports.

BR-024

Transfers shall update the balances of both accounts.

---

# Payment Method Rules

BR-025

Supported payment methods:

- Cash
- UPI
- Debit Card
- Bank Transfer

Future

- Credit Card

---

# Reporting Rules

BR-026

Monthly income shall include only income transactions.

BR-027

Monthly expense shall include only expense transactions.

BR-028

Savings shall be calculated as:

Savings = Total Income − Total Expenses

BR-029

Category-wise reports shall group transactions by category.

BR-030

Daily reports shall display transactions for the selected date.

---

# Data Integrity Rules

BR-031

Primary keys shall uniquely identify each record.

BR-032

Foreign key relationships shall maintain referential integrity.

BR-033

Duplicate transactions should be avoided where possible.

BR-034

All monetary values shall be stored using DECIMAL data type.

---

BR-035

The source and destination accounts must be different.

BR-036

The transfer amount must be greater than zero.

BR-037

A transfer does not affect total income or total expenses.

BR-038

A transfer decreases the balance of the source account and increases the balance of the destination account.


# Future Business Rules

- Budget validation
- EMI reminders
- Savings goals
- Investment tracking
- Loan repayment schedules
- Recurring transactions
