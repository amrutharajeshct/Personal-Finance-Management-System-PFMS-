-- =====================================================
-- Sample Data for Personal Finance Database
-- Insert order respects FK dependencies
-- =====================================================

-- ---------------------------------------------------
-- 1. Users
-- ---------------------------------------------------
INSERT INTO Users (UserName, PasswordHash, IsActive, LastLogin, CreatedAt, UpdatedAt)
VALUES
('arun.kumar', 'HASH_arun_9f8a3c', 1, '2026-08-07 09:15:00', '2025-01-10 10:00:00', '2026-08-07 09:15:00'),
('priya.singh', 'HASH_priya_1b2c4d', 1, '2026-08-06 21:40:00', '2025-02-15 11:30:00', '2026-08-06 21:40:00'),
('rahul.mehta', 'HASH_rahul_7e6f5a', 1, '2026-08-05 08:05:00', '2025-03-20 09:45:00', '2026-08-05 08:05:00'),
('sneha.rao',   'HASH_sneha_3d2e1f', 0, '2026-05-01 12:00:00', '2025-04-05 14:20:00', '2026-05-01 12:00:00');

-- ---------------------------------------------------
-- 2. UsersDetails
-- ---------------------------------------------------
INSERT INTO UsersDetails (UserID, FullName, MobileNumber, Address, IsSalaried, Email, CreatedAt, UpdatedAt, IsActive)
VALUES
(1, 'Arun Kumar',  '9876543210', 'No. 12, Anna Nagar, Chennai, TN',      1, 'arun.kumar@example.com',  '2025-01-10 10:00:00', '2025-01-10 10:00:00', 1),
(2, 'Priya Singh', '9876543211', 'B-45, Sector 21, Noida, UP',           1, 'priya.singh@example.com', '2025-02-15 11:30:00', '2025-02-15 11:30:00', 1),
(3, 'Rahul Mehta', '9876543212', '221, MG Road, Pune, MH',               0, 'rahul.mehta@example.com', '2025-03-20 09:45:00', '2025-03-20 09:45:00', 1),
(4, 'Sneha Rao',   '9876543213', '78, Jayanagar, Bengaluru, KA',         1, 'sneha.rao@example.com',   '2025-04-05 14:20:00', '2025-04-05 14:20:00', 0);

-- ---------------------------------------------------
-- 3. AccountType
-- ---------------------------------------------------
INSERT INTO AccountType (AccountTypeName, Description, IsActive)
VALUES
('Savings',      'Regular bank savings account',              1),
('Current',      'Business/current account',                  1),
('Credit Card',  'Credit card account',                        1),
('Wallet',       'Digital wallet / prepaid account',           1),
('Cash',         'Physical cash in hand',                      1);

-- ---------------------------------------------------
-- 4. Currency
-- ---------------------------------------------------
INSERT INTO Currency (CurrencyCode, CurrencyName, Symbol, IsActive)
VALUES
('INR', 'Indian Rupee',   '₹', 1),
('USD', 'US Dollar',      '$', 1),
('EUR', 'Euro',           '€', 1);

-- ---------------------------------------------------
-- 5. Account
-- ---------------------------------------------------
INSERT INTO Account (UserID, AccountName, AccountTypeID, CurrencyID, OpeningBalance, AccountNumber, IFSCCode, BankName, IsActive, CreatedAt, UpdatedAt)
VALUES
(1, 'Arun HDFC Savings',      1, 1, 25000.00, '50100123456789', 'HDFC0001234', 'HDFC Bank',       1, '2025-01-10 10:05:00', '2025-01-10 10:05:00'),
(1, 'Arun ICICI Credit Card', 3, 1, 0.00,      '4000XXXXXXXX1234', NULL,        'ICICI Bank',      1, '2025-01-12 12:00:00', '2025-01-12 12:00:00'),
(1, 'Arun Cash Wallet',       5, 1, 2000.00,   NULL,               NULL,        NULL,              1, '2025-01-10 10:10:00', '2025-01-10 10:10:00'),
(2, 'Priya SBI Savings',      1, 1, 15000.00, '20050098765432', 'SBIN0005678', 'State Bank of India', 1, '2025-02-15 11:35:00', '2025-02-15 11:35:00'),
(2, 'Priya Paytm Wallet',     4, 1, 500.00,    NULL,               NULL,        'Paytm Payments Bank', 1, '2025-02-16 09:00:00', '2025-02-16 09:00:00'),
(3, 'Rahul Axis Current',     2, 1, 100000.00,'91020034567890', 'UTIB0001122', 'Axis Bank',        1, '2025-03-20 09:50:00', '2025-03-20 09:50:00');

-- ---------------------------------------------------
-- 6. CategoryType
-- ---------------------------------------------------
INSERT INTO CategoryType (CategoryTypeName, UpdatedAt, IsActive)
VALUES
('Income',  '2025-01-01 00:00:00', 1),
('Expense', '2025-01-01 00:00:00', 1),
('Transfer','2025-01-01 00:00:00', 1);

-- ---------------------------------------------------
-- 7. Category (parent categories first, then children)
-- ---------------------------------------------------
INSERT INTO Category (CategoryName, CategoryTypeID, ParentCategoryID, IsActive, CreatedAt, UpdatedAt)
VALUES
('Salary',        1, NULL, 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00'),
('Freelance',      1, NULL, 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00'),
('Food & Dining',  2, NULL, 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00'),
('Groceries',      2, NULL, 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00'),
('Transport',      2, NULL, 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00'),
('Utilities',      2, NULL, 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00'),
('Entertainment',  2, NULL, 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00'),
('Rent',           2, NULL, 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00');

-- Sub-category example (child of 'Food & Dining', CategoryID = 3)
INSERT INTO Category (CategoryName, CategoryTypeID, ParentCategoryID, IsActive, CreatedAt, UpdatedAt)
VALUES
('Restaurants', 2, 3, 1, '2025-01-02 00:00:00', '2025-01-02 00:00:00'),
('Coffee Shops', 2, 3, 1, '2025-01-02 00:00:00', '2025-01-02 00:00:00');

-- ---------------------------------------------------
-- 8. PaymentMethod
-- ---------------------------------------------------
INSERT INTO PaymentMethod (PaymentMethodName, Description, IsActive)
VALUES
('Cash',        'Physical cash payment',              1),
('Debit Card',  'Bank debit card payment',             1),
('Credit Card', 'Credit card payment',                 1),
('UPI',         'Unified Payments Interface',          1),
('Net Banking', 'Online bank transfer',                1),
('Wallet',      'Digital wallet payment',              1);

-- ---------------------------------------------------
-- 9. TransactionType
-- ---------------------------------------------------
INSERT INTO TransactionType (TransactionTypeName, Description, IsActive)
VALUES
('Credit', 'Money coming into the account', 1),
('Debit',  'Money going out of the account', 1);

-- ---------------------------------------------------
-- 10. TransactionSource
-- ---------------------------------------------------
INSERT INTO TransactionSource (TransactionSourceName, IsActive)
VALUES
('Manual Entry',   1),
('Bank Sync',      1),
('SMS Parser',     1),
('Import (CSV)',   1);

-- ---------------------------------------------------
-- 11. Transactions
-- ---------------------------------------------------
INSERT INTO Transactions (AccountID, CategoryID, PaymentMethodID, TransactionTypeID, TransactionSourceID, Amount, TransactionDate, Description, CreatedAt, IsActive, UpdatedAt)
VALUES
(1, 1, 5, 1, 2, 75000.00, '2026-08-01', 'August Salary Credit',           '2026-08-01 09:00:00', 1, '2026-08-01 09:00:00'),
(1, 4, 4, 2, 3, 2350.50,  '2026-08-02', 'Grocery shopping - Big Bazaar',  '2026-08-02 18:30:00', 1, '2026-08-02 18:30:00'),
(1, 9, 4, 2, 3, 640.00,   '2026-08-03', 'Dinner at Saravana Bhavan',      '2026-08-03 20:15:00', 1, '2026-08-03 20:15:00'),
(2, 9, 3, 2, 1, 1200.00,  '2026-08-04', 'Credit card - restaurant bill',  '2026-08-04 21:00:00', 1, '2026-08-04 21:00:00'),
(1, 8, 5, 2, 2, 18000.00, '2026-08-01', 'Monthly house rent',             '2026-08-01 10:00:00', 1, '2026-08-01 10:00:00'),
(1, 6, 5, 2, 2, 1450.00,  '2026-08-05', 'Electricity bill payment',       '2026-08-05 11:20:00', 1, '2026-08-05 11:20:00'),
(4, 1, 5, 1, 2, 60000.00, '2026-08-01', 'August Salary Credit - Priya',   '2026-08-01 09:30:00', 1, '2026-08-01 09:30:00'),
(4, 5, 4, 2, 3, 320.00,   '2026-08-02', 'Auto/cab fare',                  '2026-08-02 08:45:00', 1, '2026-08-02 08:45:00'),
(6, 2, 5, 1, 1, 45000.00, '2026-08-03', 'Freelance project payment',      '2026-08-03 15:00:00', 1, '2026-08-03 15:00:00'),
(6, 7, 3, 2, 1, 899.00,   '2026-08-06', 'Movie tickets - PVR',            '2026-08-06 19:00:00', 1, '2026-08-06 19:00:00');

-- ---------------------------------------------------
-- 12. AccountTransfer
-- ---------------------------------------------------
INSERT INTO AccountTransfer (FromAccountID, ToAccountID, TransferDate, Amount, Description, CreatedAt, UpdatedAt, IsActive)
VALUES
(1, 3, '2026-08-01', 2000.00, 'Cash withdrawal to wallet',        '2026-08-01 12:00:00', '2026-08-01 12:00:00', 1),
(1, 2, '2026-08-02', 5000.00, 'Credit card bill payment',         '2026-08-02 09:00:00', '2026-08-02 09:00:00', 1),
(4, 5, '2026-08-03', 1000.00, 'Top-up Paytm wallet from savings', '2026-08-03 10:30:00', '2026-08-03 10:30:00', 1);
