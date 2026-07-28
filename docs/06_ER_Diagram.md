# Entity Relationship (ER) Diagram

## Introduction

This document describes the Entity Relationship (ER) model of the **Personal Finance Management System (PFMS)**.

The ER Diagram illustrates the logical structure of the database by identifying entities, their attributes, primary keys, foreign keys, and the relationships between them.

This document serves as the foundation for the physical database design and implementation.

---

# Objectives

- Identify all entities in the system.
- Define relationships between entities.
- Establish primary and foreign keys.
- Maintain referential integrity.
- Support future scalability.

---

# Entity List

| Entity | Description |
|---------|-------------|
| User | Stores login information |
| UserDetails | Stores personal profile information |
| AccountType | Lookup table for account types |
| Account | Stores user accounts |
| CategoryType | Lookup table for category types |
| Category | Stores income and expense categories |
| TransactionType | Lookup table for transaction types |
| Transaction | Stores income and expense transactions |
| PaymentMethod | Lookup table for payment methods |
| AccountTransfer | Stores transfers between user accounts |

---

# Relationship Summary

| Parent Entity | Child Entity | Relationship |
|---------------|-------------|--------------|
| User | UserDetails | One-to-One |
| User | Account | One-to-Many |
| AccountType | Account | One-to-Many |
| CategoryType | Category | One-to-Many |
| Category | Category | One-to-Many (Self Reference) |
| Account | Transaction | One-to-Many |
| Category | Transaction | One-to-Many |
| TransactionType | Transaction | One-to-Many |
| PaymentMethod | Transaction | One-to-Many |
| Account | AccountTransfer (FromAccountID) | One-to-Many |
| Account | AccountTransfer (ToAccountID) | One-to-Many |

---

# Entity Relationships

## User → UserDetails

Relationship

```
One User
      │
      ▼
One UserDetails
```

Cardinality

```
1 : 1
```

---

## User → Account

```
One User
      │
      ├─────────────► Account
      ├─────────────► Account
      ├─────────────► Account
```

Cardinality

```
1 : Many
```

---

## AccountType → Account

```
Bank
Cash
Wallet
Savings
        │
        ▼
      Account
```

Cardinality

```
1 : Many
```

---

## CategoryType → Category

```
Expense
Income
      │
      ▼
 Category
```

Cardinality

```
1 : Many
```

---

## Category → Category

(Self Reference)

```
Food
 │
 ├── Tea
 ├── Lunch
 └── Dinner
```

Cardinality

```
1 : Many
```

Maximum depth

```
One Level
```

---

## Category → Transaction

```
Food
 │
 ├──── Transaction
 ├──── Transaction
 └──── Transaction
```

Cardinality

```
1 : Many
```

---

## TransactionType → Transaction

```
Income

Expense
      │
      ▼
Transaction
```

Cardinality

```
1 : Many
```

---

## PaymentMethod → Transaction

```
Cash
UPI
Debit Card
Bank Transfer
        │
        ▼
    Transaction
```

Cardinality

```
1 : Many
```

---

## Account → Transaction

```
Federal Bank
      │
      ├──── Salary
      ├──── Rent
      ├──── Tea
      └──── Shopping
```

Cardinality

```
1 : Many
```

---

## Account → AccountTransfer

```
Federal Bank
        │
        ├────────────► Cash
        │
        └────────────► SBI
```

Cardinality

```
1 : Many
```

Both **FromAccountID** and **ToAccountID** reference the **Account** table.

---

# Business Constraints

- Every user may own multiple accounts.
- Every account belongs to one account type.
- Every category belongs to one category type.
- Categories support one level of hierarchy.
- Every transaction belongs to one account.
- Every transaction belongs to one category.
- Every transaction belongs to one payment method.
- Every transaction belongs to one transaction type.
- Every transfer must contain a source account.
- Every transfer must contain a destination account.
- Source and destination accounts must be different.
- Transfers shall not be included in income or expense reports.

---

# ER Diagram

The ER diagram below represents the logical database model.

```text
                              +----------------+
                              |      User      |
                              +----------------+
                                      |
                                   1  |  1
                                      |
                              +----------------+
                              |  UserDetails   |
                              +----------------+

                                      |
                                   1  |  N
                                      |
                              +----------------+
                              |    Account     |
                              +----------------+
                                      |
                     +----------------+----------------+
                     |                                 |
                  N  |                                 | N
                     |                                 |
      +------------------------+         +----------------------+
      |    Transaction         |         |  AccountTransfer     |
      +------------------------+         +----------------------+
                     ^                          ^          ^
                     |                          |          |
                     |                          |          |
          +----------+----------+               |          |
          |                     |               |          |
+----------------+   +----------------+         |          |
|   Category     |   | PaymentMethod  |         |          |
+----------------+   +----------------+         |          |
        ^                                         From      To
        |
+----------------+
| CategoryType   |
+----------------+

+----------------+
| TransactionType|
+----------------+
        |
        ▼
 Transaction

+----------------+
| AccountType    |
+----------------+
        |
        ▼
 Account
```

> A graphical ER diagram will be created using **dbdiagram.io**, **draw.io**, or **SQL Server Management Studio Database Diagram** and stored in:

```
docs/Images/ER_Diagram.png
```

---

# Design Notes

- Lookup tables are used for AccountType, CategoryType, TransactionType, and PaymentMethod.
- Transactions store only Income and Expense records.
- Account transfers are stored separately.
- Categories support one level of hierarchy using `ParentCategoryID`.
- Soft delete is implemented using `IsActive`.
- Savings are calculated dynamically through reports.

---

# Next Step

The next document is:

**07_Database_Design.md**

This document will define:

- Naming conventions
- Database standards
- Data types
- Primary keys
- Foreign keys
- Constraints
- Indexing strategy
- Audit columns
- Default values
