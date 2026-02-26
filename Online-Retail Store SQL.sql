CREATE TABLE Category (
    CategoryID NUMBER(9),
    CategoryName VARCHAR2(40) CONSTRAINT Category_Name_NN NOT NULL,
    Apparel_Flag NUMBER(1) DEFAULT 0,
    Electronics_Flag NUMBER(1) DEFAULT 0,
    Makeup_Flag NUMBER(1) DEFAULT 0,
    Fragrance_Flag NUMBER(1) DEFAULT 0,
    Toys_Flag NUMBER(1) DEFAULT 0,
    Antiques_Flag NUMBER(1) DEFAULT 0,
    Furniture_Flag NUMBER(1) DEFAULT 0,
    CONSTRAINT PK_Category PRIMARY KEY (CategoryID),
    CONSTRAINT UQ_Category_Name UNIQUE (CategoryName),
    CONSTRAINT CHK_Apparel_Flag CHECK (Apparel_Flag IN (0, 1)),
    CONSTRAINT CHK_Electronics_Flag CHECK (Electronics_Flag IN (0, 1)),
    CONSTRAINT CHK_Makeup_Flag CHECK (Makeup_Flag IN (0, 1)),
    CONSTRAINT CHK_Fragrance_Flag CHECK (Fragrance_Flag IN (0, 1)),
    CONSTRAINT CHK_Toys_Flag CHECK (Toys_Flag IN (0, 1)),
    CONSTRAINT CHK_Antiques_Flag CHECK (Antiques_Flag IN (0, 1)),
    CONSTRAINT CHK_Furniture_Flag CHECK (Furniture_Flag IN (0, 1))
);

CREATE TABLE Customer2(
  CustomerID2 NUMBER(9),
  FirstName2 VARCHAR2(30) CONSTRAINT Customer_FirstName_NN2 NOT NULL,
  LastName2 VARCHAR2(30) CONSTRAINT Customer_LastName_NN2  NOT NULL,
  Email2 VARCHAR2(80) CONSTRAINT Customer_Email_NN2 NOT NULL,
  PhoneNumber2 VARCHAR2(20),
  Address2 VARCHAR2(150),
  Country2 VARCHAR2(40),
  LoyaltyPointsBalance2 NUMBER DEFAULT 0,
  Customer_Type2 VARCHAR2(10) CONSTRAINT Customer_Type_NN2 NOT NULL,
  CONSTRAINT PK_Customer2 PRIMARY KEY (CustomerID2),
  CONSTRAINT UQ_Customer_Email2 UNIQUE (Email2),
  CONSTRAINT UQ_Customer_Phone2 UNIQUE (PhoneNumber2),
  CONSTRAINT CK_Customer_Points2 CHECK (LoyaltyPointsBalance2 >= 0),
  CONSTRAINT CK_Customer_Type2 CHECK (Customer_Type2 IN ('Loyal', 'New'))
);

CREATE TABLE Product1 (
  ProductID NUMBER(9),
  ProductName VARCHAR2(80) CONSTRAINT Product_Name_NN NOT NULL,
  Description1 VARCHAR2(250),
  Price NUMBER(10,2) CONSTRAINT Product_Price_NN NOT NULL,
  StockQuantity NUMBER DEFAULT 0,
  CategoryID NUMBER(9) CONSTRAINT Product_CategoryID_NN NOT NULL,
  CONSTRAINT PK_Product1 PRIMARY KEY (ProductID),
  CONSTRAINT CK_Product_Price CHECK (Price > 0),
  CONSTRAINT CK_Product_Stock CHECK (StockQuantity >= 0),
  CONSTRAINT FK_Product1_Categoryy FOREIGN KEY (CategoryID)
    REFERENCES Categoryy(CategoryyID)
);

CREATE TABLE Orders (
  OrderID NUMBER(9),
  OrderDate DATE CONSTRAINT Orders_Date_NN NOT NULL,
  CustomerID NUMBER(9) CONSTRAINT Orders_CustomerID_NN NOT NULL,
  PaymentID NUMBER(9),
  OrderStatus VARCHAR2(20) CONSTRAINT Orders_Status_NN NOT NULL,
  CONSTRAINT PK_Orders PRIMARY KEY (OrderID),
  CONSTRAINT CK_Orders_Status CHECK (OrderStatus IN ('PENDING','PAID','SHIPPED','DELIVERED','CANCELLED')),
  CONSTRAINT FK_Orders_Customer2 FOREIGN KEY (CustomerID)
    REFERENCES Customer2(CustomerID2)
);

CREATE TABLE Order_Detail (
  OrderDetailID NUMBER(9),
  OrderID NUMBER(9) CONSTRAINT OD_OrderID_NN NOT NULL,
  ProductID NUMBER(9) CONSTRAINT OD_ProductID_NN NOT NULL,
  Quantity NUMBER CONSTRAINT OD_Quantity_NN NOT NULL,
  Price NUMBER(10,2) CONSTRAINT OD_Price_NN NOT NULL,
  Subtotal NUMBER(12,2) CONSTRAINT OD_Subtotal_NN NOT NULL,
  CONSTRAINT PK_OrderDetail PRIMARY KEY (OrderDetailID),
  CONSTRAINT UQ_OD_Order_Product UNIQUE (OrderID, ProductID),
  CONSTRAINT CK_OD_Qty CHECK (Quantity > 0),
  CONSTRAINT CK_OD_Price CHECK (Price > 0),
  CONSTRAINT CK_OD_Subtotal CHECK (Subtotal = Quantity * Price),
  CONSTRAINT FK_OD_Order FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
  CONSTRAINT FK_OD_Product1 FOREIGN KEY (ProductID) REFERENCES Product1(ProductID)
);

CREATE TABLE Inventory (
  InventoryID NUMBER(9),
  ProductID NUMBER(9) CONSTRAINT Inventory_ProductID_NN NOT NULL,
  QuantityAvailable NUMBER DEFAULT 0,
  ReorderLevel NUMBER DEFAULT 5,
  CONSTRAINT PK_InventoryID PRIMARY KEY (InventoryID),
  CONSTRAINT UQ_Inventory_ProductID UNIQUE (ProductID),
  CONSTRAINT CK_Inv_Qty CHECK (QuantityAvailable >= 0),
  CONSTRAINT CK_Inv_Reorder CHECK (ReorderLevel >= 0),
  CONSTRAINT FK_Inventory_Product1 FOREIGN KEY (ProductID)
    REFERENCES Product1(ProductID)
);

CREATE TABLE Payment (
    PaymentID NUMBER(9),
    PaymentDate DATE CONSTRAINT Payment_Date_NN NOT NULL,
    PaymentMethod VARCHAR2(50),
    Amount NUMBER(10,2) CONSTRAINT Payment_Amount_NN NOT NULL,
    OrderID NUMBER(9) CONSTRAINT Payment_OrderID_NN NOT NULL,
    PaymentStatus VARCHAR2(20) CONSTRAINT Payment_Status_NN NOT NULL,
    Payment_Type VARCHAR2(10) CONSTRAINT Payment_Type_NN NOT NULL,
    Card_Number VARCHAR2(16),  
    Tabby_Tamara VARCHAR2(50), 
    COD NUMBER(10,2),          
    CONSTRAINT PK_Payment PRIMARY KEY (PaymentID),
    CONSTRAINT UQ_Payment_Order UNIQUE (OrderID), 
    CONSTRAINT CK_Payment_Amount CHECK (Amount > 0),
    CONSTRAINT CK_Payment_Status CHECK (PaymentStatus IN ('PENDING','PAID','FAILED','REFUNDED')),
    CONSTRAINT CK_Payment_Type CHECK (Payment_Type IN ('CARD','CASH','DEFERRED')),
    CONSTRAINT CK_Payment_Data CHECK (
        (Payment_Type = 'CARD' AND Card_Number IS NOT NULL AND Tabby_Tamara IS NULL AND COD IS NULL) OR
        (Payment_Type = 'DEFERRED' AND Card_Number IS NULL AND Tabby_Tamara IS NOT NULL AND COD IS NULL) OR
        (Payment_Type = 'CASH' AND Card_Number IS NULL AND Tabby_Tamara IS NULL AND COD IS NOT NULL)
    ),
    
    CONSTRAINT FK_Payment_Order FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_PaymentID FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID);

REATE TABLE Loyalty_Point (
  LoyaltyTransactionID NUMBER(9),
  Customer_ID NUMBER(9) CONSTRAINT LP_CustomerID_NN NOT NULL,
  PointsEarned NUMBER DEFAULT 0,
  PointsRedeemed NUMBER DEFAULT 0,
  PointsDate DATE CONSTRAINT LP_Date_NN NOT NULL,
  CONSTRAINT PK_LoyaltyPoint PRIMARY KEY (LoyaltyTransactionID),
  CONSTRAINT CK_LP_Earned CHECK (PointsEarned >= 0),
  CONSTRAINT CK_LP_Redeemed CHECK (PointsRedeemed >= 0),
  CONSTRAINT FK_LP_Customer2 FOREIGN KEY (Customer_ID)
    REFERENCES Customer2(CustomerID2)
);

-- Categoryy
INSERT INTO Categoryy VALUES (10, 'Apparel', 1, 0, 0, 0, 0, 0, 0);
INSERT INTO Categoryy VALUES (20, 'Electronics', 0, 1, 0, 0, 0, 0, 0);
INSERT INTO Categoryy VALUES (30, 'Makeup', 0, 0, 1, 0, 0, 0, 0);
INSERT INTO Categoryy VALUES (40, 'Fragrance', 0, 0, 0, 1, 0, 0, 0);
INSERT INTO Categoryy VALUES (50, 'Furniture', 0, 0, 0, 0, 0, 0, 1);
INSERT INTO Categoryy VALUES (60, 'Toys', 0, 0, 0, 0, 1, 0, 0);
-- Customer
INSERT INTO Customer2 VALUES (1,'Mayar','Ali','mayar@mail.com','0500000001','Madinah','Saudi Arabia',120, 'Loyal');
INSERT INTO Customer2 VALUES (2,'Sara','Hassan','sara@mail.com','0500000002','Jeddah','Saudi Arabia',0, 'New');
-- Product
INSERT INTO Product1 VALUES (1001, 'T-Shirt','Cotton t-shirt', 59.00, 50, 10);
INSERT INTO Product1 VALUES (1002, 'Earbuds','Noise cancelling',199.00, 30, 20);
INSERT INTO Product1 VALUES (1003, 'Lip Gloss','Glossy finish', 45.00, 80, 30); 
INSERT INTO Product1 VALUES (1004, 'Jeans','Denim jeans', 150.00, 25, 10);
INSERT INTO Product1 VALUES (1005, 'Smart Watch','Waterproof watch', 499.00, 15, 20);
INSERT INTO Product1 VALUES (1006, 'Vanilla Perfume','Strong scent', 220.00, 40, 40);
INSERT INTO Product1 VALUES (1007, 'Rose Scent','Light floral', 180.00, 35, 40);
INSERT INTO Product1 VALUES (1008, 'Woody Oud','Rich oud scent', 350.00, 10, 40);
-- Inventory 
INSERT INTO Inventory VALUES (501, 1001, 50, 10);
INSERT INTO Inventory VALUES (502, 1002, 30, 5); 
INSERT INTO Inventory VALUES (503, 1003, 80, 15); 

-- Payment
INSERT INTO Payment VALUES (8001, TO_DATE('25-oct-2025','DD-MON-YYYY'), 163.00, 5001, 'PAID', 'CARD', '4111**1234', NULL, NULL); 
INSERT INTO Payment VALUES (8002, TO_DATE('25-oct-2025','DD-MON-YYYY'), 199.00, 5002, 'PAID', 'CASH', NULL, NULL, 199.00);
INSERT INTO Payment VALUES (8003, TO_DATE('26-oct-2025','DD-MON-YYYY'), 59.00, 5003, 'PENDING', 'DEFERRED', NULL, 'Ref: Tabby-A987', NULL);
-- Loyalty points 
INSERT INTO Loyalty_Point VALUES (60001, 1, 20, 0, TO_DATE('25-oct-2025','DD-MON-YYYY')); 
INSERT INTO Loyalty_Point VALUES (60002, 1, 10, 0, TO_DATE('25-oct-2025','DD-MON-YYYY')); 
INSERT INTO Loyalty_Point VALUES (60003, 2, 0, 5, TO_DATE('26-oct-2025','DD-MON-YYYY'));

SELECT *
FROM Customer2
ORDER BY CustomerID2 DESC;

SELECT Customer_ID,
SUM(PointsEarned) AS TotalPoints
FROM Loyalty_Point
GROUP BY Customer_ID
HAVING SUM(PointsEarned) > 20; 

SELECT Payment_Type,
SUM(Amount) AS TotalPaid
FROM Payment
GROUP BY Payment_Type
ORDER BY TotalPaid ASC;

SELECT ProductID,ProductName, Price
FROM product1
WHERE Price <= 50;

SELECT
  P.ProductName,
  C.CategoryyName
FROM
  Product1 P
INNER JOIN
  Categoryy C ON P.CategoryID = C.CategoryyID
ORDER BY
  C.CategoryyName ASC;

SELECT
  C.FirstName2,
  O.OrderDate,
  P.PaymentStatus
FROM
  Orders O
INNER JOIN
  Customer2 C ON O.CustomerID = C.CustomerID2
INNER JOIN
  Payment P ON O.PaymentID = P.PaymentID
ORDER BY
  O.OrderDate DESC;

SELECT
  C.CategoryyName,
  COUNT(P.ProductID) AS NumberOfProducts
FROM
  Categoryy C
LEFT JOIN
  Product1 P ON C.CategoryyID = P.CategoryID
GROUP BY
  C.CategoryyName
ORDER BY
  NumberOfProducts DESC, C.CategoryyName ASC;
