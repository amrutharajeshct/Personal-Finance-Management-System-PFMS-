
# Normalization

## Introduction

This document explains how the PFMS schema satisfies the first three normal forms (1NF, 2NF, 3NF), using this project's actual tables as examples rather than generic textbook illustrations. Normalization isn't just a checkbox here — several concrete design decisions earlier in this project (lookup tables, splitting `User`/`UserDetails`, not caching balances) exist *because* of these principles.

---

# 1. First Normal Form (1NF)

**Rule:** Every column holds a single, atomic value — no repeating groups, no comma-separated lists, no multi-valued fields.

**How PFMS satisfies this:**
- `Transaction.Description` holds one note, not a list of notes.
- `Account` does not have `BankName1`, `BankName2`, etc. — a user with multiple bank accounts gets multiple rows in `Account`, not repeated columns in one row.
- `Category` does not store a comma-separated list of sub-categories in a single field; each sub-category is its own row, linked via `ParentCategoryID`.

**A violation this design avoids:** storing something like `PaymentMethods = "Cash, UPI"` as a single text field on a transaction. Instead, `Transaction.PaymentMethodID` is a single FK to one row in `PaymentMethod` — one transaction, one payment method (BR-027).

---

# 2. Second Normal Form (2NF)

**Rule:** Must already be in 1NF, and every non-key column must depend on the *whole* primary key — no partial dependency on part of a composite key.

**How PFMS satisfies this:**
Every table in this schema uses a **single-column surrogate primary key** (`TableNameID`), except `UserDetails`, which uses `UserID` as its sole key (shared with `User`). Since there are no composite primary keys anywhere in the schema, there's no possibility of a partial dependency — 2NF is satisfied by construction.

**Where this mattered during design:** `UQ_Category_NameType UNIQUE (CategoryName, CategoryTypeID)` is a *unique constraint*, not the primary key — `CategoryID` alone remains the key. This distinction matters: if `(CategoryName, CategoryTypeID)` had been made the primary key instead, every other column (`ParentCategoryID`, `IsActive`) would depend on both parts together, which is still technically fine here, but using a surrogate key keeps the design uniform and avoids ever having to reason about partial dependency at all.

---

# 3. Third Normal Form (3NF)

**Rule:** Must already be in 2NF, and no non-key column may depend on another non-key column (no transitive dependency).

**How PFMS satisfies this — and why the lookup tables exist:**

Consider a *denormalized* alternative where `Account.AccountTypeName` was stored directly as text on every account row:

```
Account
-------
AccountID | AccountName    | AccountTypeName | ...
1         | Federal Bank   | Bank
2         | Cash           | Cash
```

Here, `AccountTypeName` doesn't depend on `AccountID` directly — it depends on *which type* the account is, which is really its own concept. If you later wanted to add a `Description` for "Bank" accounts in general, you'd have to update it on every single Bank-type row, and any typo (`"Bank"` vs `"bank"`) would silently break grouping in reports. This is exactly the transitive dependency 3NF forbids.

**The fix — already implemented:** `AccountType` is its own table (`AccountTypeID`, `AccountTypeName`, `Description`, `IsActive`), and `Account` stores only `AccountTypeID` as a foreign key. The same reasoning is why this schema has five lookup tables instead of storing their values as text:

| Text value that *could* have been inline | Extracted to lookup table |
|---|---|
| Account's type (Bank/Cash/Wallet/Savings) | `AccountType` |
| Account's currency | `Currency` |
| Category's type (Income/Expense) | `CategoryType` |
| Transaction's payment method | `PaymentMethod` |
| Transaction's type (Income/Expense) | `TransactionType` |
| Transaction's source (Manual/Import/Recurring) | `TransactionSource` |

**Another 3NF decision: splitting `User` and `UserDetails`.** `PasswordHash` (an authentication concern) and `FullName`/`Address`/`IsSalaried` (profile concerns) don't depend on each other — they only both happen to depend on `UserID`. Keeping them in one table wouldn't strictly violate 3NF (both sets of columns do depend on the whole key), but splitting them is a deliberate design boundary: authentication data and personal data have different sensitivity, different update patterns, and different owners in a real application, even though textbook 3NF alone wouldn't force the split.

**A closely related decision — not stored 3NF violation, but worth naming:** `Account.CurrentBalance` was deliberately **not** added as a column. If it had been, it would be a transitively-*derived* value (dependent on the sum of every `Transaction` and `AccountTransfer` row for that account) sitting redundantly on the `Account` row — normalized schemas avoid storing values that can be computed from other tables, precisely because it can drift out of sync. The same reasoning is why **savings** (BR-041) is never stored: it's `Total Income − Total Expenses`, always computed at query time.

---

# 4. Summary Table

| Normal Form | Satisfied? | Key Mechanism |
|---|---|---|
| 1NF | ✅ | Every column atomic; multi-valued data lives in child tables (e.g., `Category` rows, not list fields) |
| 2NF | ✅ | Single-column surrogate keys everywhere — no composite keys, so no partial dependency is possible |
| 3NF | ✅ | Six lookup tables remove transitive dependencies; `User`/`UserDetails` split separates concerns; no derived/cached values (`CurrentBalance`, `Savings`) are stored |

---

# 5. A Conscious Trade-off Worth Noting

`CategoryType` and `TransactionType` are two separate lookup tables that currently hold the same two values ("Income", "Expense"). Strictly, this is a small duplication — both tables' *rows* are identical in content, even though they serve conceptually different columns (`Category.CategoryTypeID` vs. `Transaction.TransactionTypeID`). This doesn't violate any normal form (each table is independently well-formed), but it's a design choice you may want to revisit: merging them into one shared `TransactionCategoryType` lookup would remove the duplication at the cost of a slightly less explicit schema. This is still listed as an open question in `05_Entity_Analysis.md`, §5.

---

This completes the System Design phase (`04` through `10`). The project is now ready to move into SQL development proper: applying `01_create_tables.sql` and `02_seed_data.sql`, then building stored procedures, views, functions, and triggers on top of this foundation.
