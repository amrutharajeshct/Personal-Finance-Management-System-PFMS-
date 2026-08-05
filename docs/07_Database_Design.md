# Database Design

## Introduction

This document defines the physical database design standards for the Personal Finance Management System (PFMS): naming conventions, data type choices, key strategy, constraints, indexing, and default values. It governs how `05_Entity_Analysis.md` and `06_ER_Diagram.md` are translated into the actual SQL Server schema (`01_create_tables.sql`).

---

# 1. Naming Conventions

| Element | Convention | Example |
|---|---|---|
| Table names | Singular, PascalCase | `Account`, `Category`, `Transaction` (not `Accounts`, `Categories`) |
| Lookup tables | Singular, descriptive noun | `AccountType`, `PaymentMethod`, `CategoryType` |
| Column names | PascalCase, no underscores | `AccountName`, `TransactionDate` |
| Primary keys | `<TableName>ID` | `AccountID`, `CategoryID` |
| Foreign keys | Same name as the referenced PK | `AccountID` in `Transaction` references `Account.AccountID` |
| Boolean flags | Prefixed `Is` | `IsActive`, `IsSalaried` |
| Audit columns | `CreatedAt`, `UpdatedAt` | *(not `CreatedDate`/`ModifiedOn`, for consistency)* |
| Constraints | Prefixed by type | `PK_`, `FK_`, `UQ_`, `CK_` (e.g., `FK_Transaction_Account`) |
| Triggers | `trg_<Table>_<Purpose>` | `trg_Category_ParentTypeMatch` |

**Rationale:** Singular table names avoid the "is it `Category` or `Categories`?" ambiguity that caused the mismatch seen in an earlier script attempt (which used `Accounts`, `ExpenseCategories`, `IncomeCategories` — inconsistent with this schema).

---

# 2. Database Standards

- **Platform:** Microsoft SQL Server (per Requirements Specification §Technologies Used).
- **Schema:** all tables live in `dbo` (default schema) for V1; no need for custom schemas at this scale.
- **Collation:** server default (`SQL_Latin1_General_CP1_CI_AS`) is sufficient — no multi-language text requirements yet.

---

# 3. Data Type Standards

| Data Category | Type | Notes |
|---|---|---|
| Surrogate keys | `INT IDENTITY(1,1)` | Sufficient range for a personal/portfolio-scale system |
| Money | `DECIMAL(18,2)` | Never `FLOAT`/`REAL` — avoids rounding errors (BR-045) |
| Short text / names | `VARCHAR(50)`–`VARCHAR(150)` | Sized to the realistic max (e.g., `AccountName VARCHAR(100)`) |
| Long text | `VARCHAR(255)` | Descriptions, addresses |
| Flags | `BIT` | `IsActive`, `IsSalaried` |
| Dates without time | `DATE` | `TransactionDate`, `TransferDate` |
| Timestamps | `DATETIME` | `CreatedAt`, `UpdatedAt` |
| Fixed-length codes | `VARCHAR(3)`–`VARCHAR(15)` | `CurrencyCode`, `IFSCCode` |

---

# 4. Primary Key Strategy

- Every table uses a single-column surrogate primary key (`INT IDENTITY`), **except `UserDetails`**, which uses `UserID` as both PK and FK — a true 1:1 extension table, so no separate surrogate key is introduced.
- Surrogate keys are used throughout (rather than natural keys like `AccountName`) so that renames never cascade into foreign key values.

---

# 5. Foreign Key Summary

| Table | Foreign Keys |
|---|---|
| UserDetails | UserID → User |
| Account | UserID → User, AccountTypeID → AccountType, CurrencyID → Currency |
| Category | CategoryTypeID → CategoryType, ParentCategoryID → Category (self) |
| Transaction | AccountID → Account, CategoryID → Category, PaymentMethodID → PaymentMethod, TransactionTypeID → TransactionType, TransactionSourceID → TransactionSource |
| AccountTransfer | FromAccountID → Account, ToAccountID → Account |

All foreign keys enforce referential integrity by default (no `ON DELETE CASCADE` anywhere — see §7).

---

# 6. Constraints

- **`NOT NULL`** on every column identified as mandatory in `05_Entity_Analysis.md` (e.g., `AccountName`, `Amount`, `TransactionDate`).
- **`UNIQUE`** on natural-key-like columns: `User.UserName`, `UserDetails.MobileNumber`, `UserDetails.Email`, `Account.AccountName`, `Category(CategoryName, CategoryTypeID)`, and the `*Name` column on every lookup table.
- **`CHECK`** constraints for simple, single-row validations: `Amount > 0` (BR-024, BR-030), `FromAccountID <> ToAccountID` (BR-029), and lookup name whitelists (e.g., `CategoryTypeName IN ('Income','Expense')`).
- **Triggers** for cross-row/cross-table validations that `CHECK` can't express: category parent/child type match (BR-020) and transaction/category type match (BR-023).

---

# 7. Referential Integrity & Soft Deletes

- **No cascading deletes.** Per BR-010, BR-017, and BR-046, financial history must never disappear via a cascade. All foreign keys use the default `NO ACTION`, so attempting to delete an `Account` or `Category` with existing `Transaction`/`AccountTransfer` rows will fail with a referential integrity error.
- **Soft delete via `IsActive`** is the supported deactivation path for `User`, `Account`, `Category`, `AccountType`, and `PaymentMethod`. Application/stored-procedure logic should set `IsActive = 0` rather than issuing a `DELETE`.

---

# 8. Indexing Strategy

Beyond the automatic clustered index on each primary key:

| Table | Recommended Index | Purpose |
|---|---|---|
| Transaction | Nonclustered on `TransactionDate` | Daily/monthly/date-range reports (BR-034, BR-035, BR-037) |
| Transaction | Nonclustered on `AccountID` | Account-wise reports (BR-038) |
| Transaction | Nonclustered on `CategoryID` | Category-wise reports (BR-036) |
| Transaction | Nonclustered on `PaymentMethodID` | Payment method analysis (BR-040) |
| AccountTransfer | Nonclustered on `TransferDate` | Transfer history queries |
| Account | Nonclustered on `UserID` | Account list per user (future multi-user) |

These can be added once real query patterns from the reporting layer are known — indexing too early on a single-user, low-volume dataset has little payoff and adds write overhead.

---

# 9. Default Values

| Column | Default | Rationale |
|---|---|---|
| `IsActive` (all tables that have it) | `1` | New records are active by default |
| `CreatedAt` (all tables that have it) | `GETDATE()` | Captured automatically at insert time |
| `Account.CurrencyID` | INR row's ID | Requirements Specification assumes single currency in V1 |
| `Transaction.TransactionSourceID` | "Manual" row's ID | Every V1 transaction is manually entered |

`UpdatedAt` has no default — it stays `NULL` until the first update, at which point it should be set explicitly by the update statement/stored procedure (a trigger could also handle this automatically if preferred).

---

# 10. Deviations Considered and Rejected

- **`StatusID` instead of `IsActive`** — considered per earlier review feedback, but deferred; `IsActive` is sufficient for V1's binary active/inactive need, and introducing a `Status` lookup (Active/Inactive/Closed/Blocked) now would be premature.
- **Cached `Account.CurrentBalance`** — rejected; balance is always derived (§9 of `05_Entity_Analysis.md`) to avoid synchronization bugs.
- **Merged `CategoryType`/`TransactionType` lookup** — still an open decision (see `05_Entity_Analysis.md`, §5); this document assumes they remain separate, as currently implemented.

---

Next document: **08_Table_Specifications.md** — the authoritative, column-by-column specification for every table.
