# Requirements Specification

## 1. Introduction

This document defines the functional and non-functional requirements for the Personal Finance Management System (PFMS).

The system is designed to help users record, organize, and analyze personal financial transactions, providing valuable insights into income, expenses, savings, and overall financial health.

---

# 2. Purpose

The purpose of the system is to:

- Maintain a centralized record of all financial transactions.
- Track income and expenses efficiently.
- Monitor multiple bank accounts and cash balances.
- Analyze spending habits.
- Generate financial reports for better decision-making.

---

# 3. Functional Requirements

## 3.1 User Management

The system shall allow:

- Single user login (Version 1)
- User profile management
- Future support for multiple users

---

## 3.2 Account Management

The system shall allow users to:

- Add bank accounts
- Edit account information
- View account balances
- Manage cash as an account
- Transfer money between accounts

Example Accounts

- Federal Bank
- SBI Bank
- Punjab National Bank
- Cash

---

## 3.3 Income Management

The system shall allow users to:

- Add income
- Edit income
- Delete income
- View income history

Income Categories

- Salary
- Bonus
- Interest
- Freelance
- Refund
- Other

---

## 3.4 Expense Management

The system shall allow users to:

- Add expenses
- Edit expenses
- Delete expenses
- Search expenses
- Filter expenses

Expense Categories

Fixed Expenses

- Rent
- EMI
- Electricity
- Internet
- Mobile Recharge

Daily Expenses

- Tea
- Breakfast
- Lunch
- Dinner
- Snacks
- Bus
- Auto
- Fuel

Lifestyle

- Shopping
- Entertainment
- Travel
- Medical
- Other

---

## 3.5 Category Management

The system shall:

- Maintain income categories
- Maintain expense categories
- Prevent duplicate categories
- Allow categories to be activated/deactivated

---

## 3.6 Transaction Management

Each transaction shall contain:

- Transaction Date
- Transaction Type
- Category
- Account
- Amount
- Payment Method
- Description

---

## 3.7 Account Transfer

The system shall allow:

- Transfer between bank accounts
- Bank to cash transfer
- Cash to bank deposit

Transfers shall not be considered income or expense.

---

## 3.8 Reports

The system shall generate:

Daily Reports

- Daily income
- Daily expenses

Monthly Reports

- Monthly income
- Monthly expenses
- Savings
- Income vs Expense

Analysis Reports

- Category-wise expenses
- Account-wise transactions
- Payment method analysis
- Monthly spending trend

---

# 4. Non-Functional Requirements

## Performance

- Reports should execute efficiently.
- Frequently used queries should be optimized.

## Security

- Data should be accessible only to authorized users.
- If a login/authentication layer is implemented, passwords shall be stored using secure hashing, never in plain text (see Business Rules, BR-003).
- Version 1, which has no application-level login screen, relies on direct single-user access to the database/application; this rule takes effect once authentication is introduced.

## Scalability

The database should support:

- Multiple users
- Additional account types
- New expense categories
- Future financial modules

## Maintainability

- Follow naming conventions.
- Maintain proper documentation.
- Use normalized database design.

## Data Integrity

- Primary keys
- Foreign keys
- Constraints
- Transaction handling

---

# 5. Assumptions

- Single user in Version 1.
- Manual data entry.
- Single currency.
- SQL Server as the database platform.

---

# 6. Constraints

- Amount must be greater than zero.
- Every transaction must belong to an account.
- Every transaction must belong to a category.
- Every transaction must have a valid date.
- Deleted accounts cannot have existing transactions.

---

# 7. Future Scope

- Budget Management
- Savings Goals
- Investment Tracking
- Loan Management
- Mobile Application
- Power BI Dashboard
- Email Notifications
- Export Reports
