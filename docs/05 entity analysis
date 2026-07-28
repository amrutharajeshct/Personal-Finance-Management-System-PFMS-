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
| Account | Bank accounts and cash | BR-009–BR-014 |
| Category | Income and expense categories, one-level hierarchy | BR-015–BR-020 |
| PaymentMethod | Lookup: Cash, UPI, Debit Card, Bank Transfer | BR-021 |
| Transaction | Income and expense records | BR-022–BR-027 |
| AccountTransfer | Money movement between the user's own accounts | BR-028–BR-033 |

---

## 2. Entity Details

### 2.1 User

| Attribute | Type | Nullable | Key | Notes |
|---|---|---|---|---|
| UserID | INT | No | PK | Unique identifier |
| UserName | VARCHAR(100) | No | Unique | Login name (BR-002) |
| PasswordHash | VARCHAR(256) | Yes | | Populated once authentication is introduced (BR-003) |
| IsActive | BIT | No | | Supports future multi-user deactivation |
| CreatedDate | DATETIME | No | | Audit column |

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

**Note:** `UserID` is both the primary key and the foreign key here — a true 1:1 extension table, so there's no separate surrogate key and no risk of one user having multiple detail rows. Split out from `User` to keep authentication concerns (login, password) separate from personal/profile data.

---

### 2.3 AccountType *(lookup)*

| Attribute | Type | Nullable | Key | Notes |
|---|---|---|---|---|
| AccountTypeID | INT | No | PK | Unique identifier |
| AccountTypeName | VARCHAR(50) | No | Unique | Bank / Cash / Wallet / Savings (BR-013) |
| Description | VARCHAR(255) | Yes | | Optional explanation of the account type |
| IsActive | BIT | No | | Allows retiring a type without deleting historical references |

---

### 2.4 Account

| Attribute | Type | Nullable | Key | Notes |
|---|---|---|---|---|
| AccountID | INT | No | PK | Unique identifier |
| UserID | INT | No | FK → User | Multi-user readiness (BR-014) |
| AccountName | VARCHAR(100) | No | Unique | e.g., "Federal Bank" (BR-009) |
| AccountTypeID | INT | No | FK → AccountType | (BR-013) |
| OpeningBalance | DECIMAL(18,2) | No | | Initial balance |
| IsActive | BIT | No | | Soft delete flag (BR-010, BR-011) |
| CreatedDate | DATETIME | No | | Audit column |

**Note:** No hard delete permitted once transactions exist (BR-010). A default "Cash" or "Unassigned" row must exist to satisfy BR-012.

---

### 2.5 Category

| Attribute | Type | Nullable | Key | Notes |
|---|---|---|---|---|
| CategoryID | INT | No | PK | Unique identifier |
| CategoryName | VARCHAR(100) | No | Unique within CategoryType | (BR-016) |
| CategoryType | VARCHAR(10) | No | | 'Income' or 'Expense' (BR-015) |
| ParentCategoryID | INT | Yes | FK → Category (self) | One level only (BR-019) |
| IsActive | BIT | No | | (BR-018) |

**Note:** A trigger or check constraint should enforce that a child's `CategoryType` matches its parent's (BR-020), since this can't be expressed as a simple column constraint.

---

### 2.6 PaymentMethod *(lookup)*

| Attribute | Type | Nullable | Key | Notes |
|---|---|---|---|---|
| PaymentMethodID | INT | No | PK | Unique identifier |
| PaymentMethodName | VARCHAR(50) | No | Unique | Cash / UPI / Debit Card / Bank Transfer (BR-021) |
| Description | VARCHAR(255) | Yes | | Optional explanation of the payment method |
| IsActive | BIT | No | | Allows retiring a method without deleting historical references |

---

### 2.7 Transaction

| Attribute | Type | Nullable | Key | Notes |
|---|---|---|---|---|
| TransactionID | INT | No | PK | Unique identifier |
| AccountID | INT | No | FK → Account | (BR-012, BR-022) |
| CategoryID | INT | No | FK → Category | Must match TransactionType (BR-023) |
| PaymentMethodID | INT | No | FK → PaymentMethod | (BR-027) |
| TransactionType | VARCHAR(10) | No | | 'Income' or 'Expense' |
| Amount | DECIMAL(18,2) | No | | Must be > 0 (BR-024) |
| TransactionDate | DATE | No | | (BR-025) |
| Description | VARCHAR(255) | Yes | | Optional (BR-026) |

**Note:** `TransactionType` here must agree with the `CategoryType` of the linked `Category` row — enforce via trigger or check, similar to the parent/child category rule.

---

### 2.8 AccountTransfer

| Attribute | Type | Nullable | Key | Notes |
|---|---|---|---|---|
| TransferID | INT | No | PK | Unique identifier |
| FromAccountID | INT | No | FK → Account | Must differ from ToAccountID (BR-029) |
| ToAccountID | INT | No | FK → Account | |
| TransferDate | DATE | No | | |
| Amount | DECIMAL(18,2) | No | | Must be > 0 (BR-030) |
| Description | VARCHAR(255) | Yes | | Optional |

**Note:** Kept fully separate from `Transaction` so transfers never leak into income/expense reports (BR-033).

---

## 3. Relationships

| From | To | Cardinality | Notes |
|---|---|---|---|
| User | UserDetails | 1 : 1 | `UserID` is shared PK/FK |
| User | Account | 1 : Many | One user owns many accounts |
| AccountType | Account | 1 : Many | Each account has one type |
| User | Category | 1 : Many *(optional in V1)* | Categories may become per-user later |
| Category | Category | 1 : Many *(self)* | Parent → child, one level (BR-019) |
| Account | Transaction | 1 : Many | Every transaction belongs to one account |
| Category | Transaction | 1 : Many | Every transaction belongs to one category |
| PaymentMethod | Transaction | 1 : Many | Every transaction has one payment method |
| Account | AccountTransfer (as From) | 1 : Many | |
| Account | AccountTransfer (as To) | 1 : Many | Two separate FKs to the same `Account` table |

---

## 4. Design Decisions Carried Forward

- **Soft deletes everywhere** — `IsActive` flags on User, Account, Category, and now the `AccountType`/`PaymentMethod` lookups too; no hard deletes once related records exist (BR-010, BR-011, BR-017, BR-046).
- **Lookup tables over hardcoded strings** — `AccountType` and `PaymentMethod` are proper tables, not free text, so new types/methods can be added without schema changes.
- **Transfers are structurally separate from Transactions** — prevents double-counting in reports (BR-033) without needing report-level filtering logic.
- **Derived savings, not stored** — no `Savings` entity exists; it's calculated as Total Income − Total Expenses (BR-041) via a view/query in the reporting layer.
- **Authentication and profile data are split** — `User` holds login/identity fields only; `UserDetails` holds `FullName`, `MobileNumber`, `Address`, `IsSalaried`, `Email` (BR-004–BR-008) in a 1:1 extension table keyed on `UserID`. This keeps the auth table lean and makes it easy to secure/audit login data separately from personal details.

---

## 5. Open Questions Before Moving to the ER Diagram

1. Should `Category` carry a `UserID` (per-user categories) in V1, or stay global and only add `UserID` when multi-user support is actually built? *(Recommendation: keep global in V1 — simpler, and BR-014 already covers the multi-user path via Account.)*
2. Do you want a `CurrentBalance` column cached on `Account`, or should balance always be calculated on the fly from Transactions + Transfers? *(Caching is faster to query but needs careful updates on every transaction/transfer; calculating on the fly is simpler and always accurate.)*
3. For `IsSalaried` (BR-007) — is a simple Yes/No flag enough, or would you also want an optional `Occupation`/`EmploymentType` free-text field (e.g., "Salaried – IT", "Self-employed", "Business")? A flag alone tells you *whether*, but not *what kind*.

---

Next document: **06_ER_Diagram.md** — visualizing these entities and relationships.
