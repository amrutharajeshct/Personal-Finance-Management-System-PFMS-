# Entity Analysis

## Introduction

This document identifies every entity required by the Personal Finance Management System (PFMS), along with their attributes, primary/foreign keys, and relationships. It is derived directly from `02_Requirements_Specification.md` and `business-rules.md`, and forms the foundation for the ER Diagram (`06_ER_Diagram.md`) and Table Specifications (`08_Table_Specifications.md`).

---

## 1. Entity List

| Entity | Purpose | Related Business Rules |
|---|---|---|
| User | Login/authentication record (single user in V1, multi-user ready) | BR-001, BR-002, BR-003 |
| UserDetails | Personal profile information for a user | BR-004–BR-008 |
| AccountType | Lookup: Bank, Cash, Wallet, Savings | BR-013 |
| Currency | Lookup: currency code/name/symbol (future-ready for multi-currency) | Requirements §5, Assumptions |
| Account | Bank accounts and cash | BR-009–BR-014 |
| CategoryType | Lookup: Income, Expense | BR-015 |
| Category | Income and expense categories, one-level hierarchy | BR-016–BR-020 |
| PaymentMethod | Lookup: Cash, UPI, Debit Card, Bank Transfer | BR-021 |
| TransactionType | Lookup: Income, Expense | (mirrors CategoryType — see note in §2.9) |
| TransactionSource | Lookup: Manual, Import, Recurring (future-ready) | — |
| Transaction | Income and expense records | BR-022–BR-027 |
| AccountTransfer | Money movement between the user's own accounts | BR-028–BR-033 |

**Documented but not built yet (future scope):**
- `Budget` (BudgetID, CategoryID, Month, Amount) — planned once Budget Management is prioritized.
- Transaction attachments (`ReceiptImage` / `AttachmentPath` on `Transaction`) — planned for receipt uploads.

---

## 2. Entity Details

### 2.1 User

| Attribute | Type | Nullable | Key | Notes |
|---|---|---|---|---|
| UserID | INT | No | PK | Unique identifier |
| UserName | VARCHAR(100) | No | Unique | Login name (BR-002) |
| PasswordHash | VARCHAR(256) | Yes | | Populated once authentication is introduced (BR-003) |
| IsActive | BIT | No | | Supports future multi-user deactivation |
| CreatedAt | DATETIME | No | | Audit column |
| UpdatedAt | DATETIME | Yes | | Audit column |

**Note:** V1 will contain exactly one row here (BR-001), but the table is designed to scale. Kept lean — authentication/identity fields only — with all personal/profile data split into `UserDetails` below.

---

### 2.2 UserDetails

| Attribute | Type | Nullable | Key | Notes |
|---|---|---|---|---|
| UserID | INT | No | PK, FK → User | Shared PK; one-to-one with `User` |
| FullName | VARCHAR(150) | No | | Mandatory (BR-004) |
| MobileNumber | VARCHAR(15) | No | Unique | Mandatory (BR-005) |
| Address | VARCHAR(255) | Yes | | Optional (BR-006) |
| IsSalaried | BIT | No | | Employment status flag (BR-007) |
| Email | VARCHAR(150) | Yes | Unique | Optional (BR-008) |
| CreatedAt | DATETIME | No | | Audit column |
| UpdatedAt | DATETIME | Yes | | Audit column |

**Note:** `UserID` is both the primary key and the foreign key — a true 1:1 extension table.

---

### 2.3 AccountType *(lookup)*

| Attribute | Type | Nullable | Key | Notes |
|---|---|---|---|---|
| AccountTypeID | INT | No | PK | Unique identifier |
| AccountTypeName | VARCHAR(50) | No | Unique | Bank / Cash / Wallet / Savings (BR-013) |
| Description | VARCHAR(255) | Yes | | Optional explanation |
| IsActive | BIT | No | | Allows retiring a type without deleting historical references |

---

### 2.4 Currency *(lookup — future-ready)*

| Attribute | Type | Nullable | Key | Notes |
|---|---|---|---|---|
| CurrencyID | INT | No | PK | Unique identifier |
| CurrencyCode | VARCHAR(3) | No | Unique | e.g., "INR" |
| CurrencyName | VARCHAR(50) | No | | e.g., "Indian Rupee" |
| Symbol | VARCHAR(5) | No | | e.g., "₹" |

**Note:** Version 1 will seed a single row (INR) and every `Account` will default to it, per the Requirements Specification's single-currency assumption. Adding this now avoids a schema change if multi-currency support is ever needed.

---

### 2.5 Account

| Attribute | Type | Nullable | Key | Notes |
|---|---|---|---|---|
| AccountID | INT | No | PK | Unique identifier |
| UserID | INT | No | FK → User | Multi-user readiness (BR-014) |
| AccountName | VARCHAR(100) | No | Unique | e.g., "Federal Bank" (BR-009) |
| AccountTypeID | INT | No | FK → AccountType | (BR-013) |
| CurrencyID | INT | No | FK → Currency | Defaults to INR in V1 |
| OpeningBalance | DECIMAL(18,2) | No | | Initial balance |
| AccountNumber | VARCHAR(30) | Yes | | NULL for Cash-type accounts |
| IFSCCode | VARCHAR(15) | Yes | | NULL for Cash-type accounts |
| BankName | VARCHAR(100) | Yes | | NULL for Cash-type accounts |
| IsActive | BIT | No | | Soft delete flag (BR-010, BR-011) |
| CreatedAt | DATETIME | No | | Audit column |
| UpdatedAt | DATETIME | Yes | | Audit column |

**Note:** No hard delete permitted once transactions exist (BR-010). A default "Cash" or "Unassigned" row must exist to satisfy BR-012. `CurrentBalance` is intentionally **not** stored — it's calculated as `OpeningBalance + Income − Expense + Incoming Transfers − Outgoing Transfers` via a view/query, avoiding a column that could drift out of sync with the underlying transactions.

---

### 2.6 CategoryType *(lookup)*

| Attribute | Type | Nullable | Key | Notes |
|---|---|---|---|---|
| CategoryTypeID | INT | No | PK | Unique identifier |
| CategoryTypeName | VARCHAR(10) | No | Unique | 'Income' or 'Expense' |

---

### 2.7 Category

| Attribute | Type | Nullable | Key | Notes |
|---|---|---|---|---|
| CategoryID | INT | No | PK | Unique identifier |
| CategoryName | VARCHAR(100) | No | Unique within CategoryTypeID | (BR-016) |
| CategoryTypeID | INT | No | FK → CategoryType | (BR-015) |
| ParentCategoryID | INT | Yes | FK → Category (self) | One level only (BR-019) |
| IsActive | BIT | No | | (BR-018) |
| CreatedAt | DATETIME | No | | Audit column |
| UpdatedAt | DATETIME | Yes | | Audit column |

**Note:** A trigger enforces that a child's `CategoryTypeID` matches its parent's (BR-020), since this can't be expressed as a simple column constraint.

---

### 2.8 PaymentMethod *(lookup)*

| Attribute | Type | Nullable | Key | Notes |
|---|---|---|---|---|
| PaymentMethodID | INT | No | PK | Unique identifier |
| PaymentMethodName | VARCHAR(50) | No | Unique | Cash / UPI / Debit Card / Bank Transfer (BR-021) |
| Description | VARCHAR(255) | Yes | | Optional explanation |
| IsActive | BIT | No | | Allows retiring a method without deleting historical references |

---

### 2.9 TransactionType *(lookup)*

| Attribute | Type | Nullable | Key | Notes |
|---|---|---|---|---|
| TransactionTypeID | INT | No | PK | Unique identifier |
| TransactionTypeName | VARCHAR(10) | No | Unique | 'Income' or 'Expense' |
| Description | VARCHAR(255) | Yes | | Optional explanation |
| IsActive | BIT | No | | Allows retiring a type without deleting historical references |

**Note:** This lookup exists purely so `Transaction` follows the same normalized pattern as `AccountType`/`PaymentMethod`, rather than storing `TransactionType` as free text. It will contain the same two values as `CategoryType` (§2.6) — the two tables aren't merged because a transaction's type and a category's type are conceptually independent fields, even though they must always agree in practice (BR-023). If this duplication bothers you, the two lookups could be merged into one shared table later; flagging it here as an option rather than doing it silently.

---

### 2.10 TransactionSource *(lookup — future-ready)*

| Attribute | Type | Nullable | Key | Notes |
|---|---|---|---|---|
| TransactionSourceID | INT | No | PK | Unique identifier |
| TransactionSourceName | VARCHAR(50) | No | Unique | Manual / Import / Recurring |

**Note:** Every V1 record will use "Manual." Having this lookup now means future import or recurring-transaction features won't require a schema change — just new rows and application logic.

---

### 2.11 Transaction

| Attribute | Type | Nullable | Key | Notes |
|---|---|---|---|---|
| TransactionID | INT | No | PK | Unique identifier |
| AccountID | INT | No | FK → Account | (BR-012, BR-022) |
| CategoryID | INT | No | FK → Category | Must match TransactionTypeID (BR-023) |
| PaymentMethodID | INT | No | FK → PaymentMethod | (BR-027) |
| TransactionTypeID | INT | No | FK → TransactionType | Replaces free-text TransactionType |
| TransactionSourceID | INT | No | FK → TransactionSource | Defaults to "Manual" in V1 |
| Amount | DECIMAL(18,2) | No | | Must be > 0 (BR-024) |
| TransactionDate | DATE | No | | (BR-025) |
| Description | VARCHAR(255) | Yes | | Optional (BR-026) |
| CreatedAt | DATETIME | No | | Audit column |
| UpdatedAt | DATETIME | Yes | | Audit column |

**Note:** A trigger enforces that `TransactionTypeID`'s name matches the linked `Category`'s `CategoryTypeID` name (BR-023) — the comparison is done by name since `TransactionType` and `CategoryType` are independent lookup tables with their own surrogate keys.

---

### 2.12 AccountTransfer

| Attribute | Type | Nullable | Key | Notes |
|---|---|---|---|---|
| TransferID | INT | No | PK | Unique identifier |
| FromAccountID | INT | No | FK → Account | Must differ from ToAccountID (BR-029) |
| ToAccountID | INT | No | FK → Account | |
| TransferDate | DATE | No | | |
| Amount | DECIMAL(18,2) | No | | Must be > 0 (BR-030) |
| Description | VARCHAR(255) | Yes | | Optional |
| CreatedAt | DATETIME | No | | Audit column |
| UpdatedAt | DATETIME | Yes | | Audit column |

**Note:** Kept fully separate from `Transaction` so transfers never leak into income/expense reports (BR-033).

---

## 3. Relationships

| From | To | Cardinality | Notes |
|---|---|---|---|
| User | UserDetails | 1 : 1 | `UserID` is shared PK/FK |
| User | Account | 1 : Many | One user owns many accounts |
| AccountType | Account | 1 : Many | Each account has one type |
| Currency | Account | 1 : Many | Each account has one currency (defaults to INR) |
| User | Category | 1 : Many *(optional in V1)* | Categories may become per-user later |
| CategoryType | Category | 1 : Many | Each category has one type |
| Category | Category | 1 : Many *(self)* | Parent → child, one level (BR-019) |
| Account | Transaction | 1 : Many | Every transaction belongs to one account |
| Category | Transaction | 1 : Many | Every transaction belongs to one category |
| PaymentMethod | Transaction | 1 : Many | Every transaction has one payment method |
| TransactionType | Transaction | 1 : Many | Every transaction has one type |
| TransactionSource | Transaction | 1 : Many | Every transaction has one source |
| Account | AccountTransfer (as From) | 1 : Many | |
| Account | AccountTransfer (as To) | 1 : Many | Two separate FKs to the same `Account` table |

---

## 4. Design Decisions Carried Forward

- **Soft deletes everywhere** — `IsActive` flags on User, Account, Category, and the `AccountType`/`PaymentMethod` lookups; no hard deletes once related records exist (BR-010, BR-011, BR-017, BR-046).
- **Lookup tables over hardcoded strings** — `AccountType`, `PaymentMethod`, `CategoryType`, `TransactionType`, and `TransactionSource` are all proper tables now, keeping the design consistent end-to-end.
- **No cached balance** — `Account` has no `CurrentBalance` column; balance is always calculated as `OpeningBalance + Income − Expense + Incoming Transfers − Outgoing Transfers`, avoiding sync issues (resolves the open question from the previous version of this doc).
- **Transfers are structurally separate from Transactions** — prevents double-counting in reports (BR-033) without needing report-level filtering logic.
- **Derived savings, not stored** — no `Savings` entity exists; it's calculated as Total Income − Total Expenses (BR-041) via a view/query in the reporting layer.
- **Authentication and profile data are split** — `User` holds login/identity fields only; `UserDetails` holds personal details (BR-004–BR-008) in a 1:1 extension table keyed on `UserID`.
- **Audit columns standardized** — `CreatedAt`/`UpdatedAt` (not `CreatedDate`) across `User`, `UserDetails`, `Account`, `Category`, `Transaction`, and `AccountTransfer`.
- **Future scope documented, not built** — `Budget` and transaction receipt attachments are recorded as planned entities/fields but intentionally left out of the current schema to avoid premature complexity.

---

## 5. Open Questions Before Moving to the ER Diagram

1. Should `Category` carry a `UserID` (per-user categories) in V1, or stay global and only add `UserID` when multi-user support is actually built? *(Recommendation: keep global in V1 — simpler, and BR-014 already covers the multi-user path via Account.)*
2. For `IsSalaried` (BR-007) — is a simple Yes/No flag enough, or would you also want an optional `Occupation`/`EmploymentType` free-text field?
3. `CategoryType` and `TransactionType` currently exist as two separate lookup tables holding the same two values ("Income"/"Expense"). Keep them separate (as built), or merge into one shared lookup referenced by both `Category` and `Transaction`?

---

Next document: **06_ER_Diagram.md** — visualizing these entities and relationships.
