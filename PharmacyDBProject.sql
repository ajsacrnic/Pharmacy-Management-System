CREATE DATABASE pharmacy_db;
USE pharmacy_db;

CREATE TABLE SUPPLIER(
	SupplierID INTEGER PRIMARY KEY AUTO_INCREMENT,
    SName VARCHAR(100),
    ContactPerson VARCHAR(100),
    Phone VARCHAR(20),
    Email VARCHAR(50),
    Address VARCHAR(100));
    
INSERT INTO SUPPLIER (SupplierID, SName, ContactPerson, Phone, Email, Address)
VALUES 
(101, 'Bosnalijek d.d.', 'Adisa Softić','+387 33 254 400', 'info@bosnalijek.ba', 'Jukićeva 53, Sarajevo'),
(102, 'Hercegovinalijek d.o.o.', 'Josip Jurić','+387 36 501 500', 'info@hercegovinalijek.ba', 'Muje Pašića 4, Mostar'),
(103, 'Farmavita d.o.o.', 'Adnan Begić','+387 33 476 323', 'prodaja@farmavita.ba', 'Igmanska 5a, Vogošća');

SELECT * FROM SUPPLIER;

CREATE TABLE MEDICINE( 
MedicineID INTEGER PRIMARY KEY auto_increment, 
    MName VARCHAR(50) NOT NULL, 
    Category VARCHAR(50) NOT NULL, 
    Price DECIMAL(8,2) NOT NULL CHECK (Price>0), 
    StockQuantity INT NOT NULL CHECK (StockQuantity >= 0), 
    ExpiryDate DATE NOT NULL, 
    SupplierID INT NOT NULL, 
    foreign key (SupplierID) REFERENCES SUPPLIER(SupplierID)); 

INSERT INTO MEDICINE(MedicineID, MName, Category, Price, StockQuantity, ExpiryDate, SupplierID) 
VALUES 
(201, 'Paracetamol', 'Painkiller', 3.50, 120, '2027-05-15', 101), 
(202, 'Brufen', 'Anti-inflammatory', 6.20, 80, '2026-11-20', 102), 
(203, 'Aspirin', 'Painkiller', 4.00, 100, '2027-01-10', 101), 
(204, 'Vitamin C', 'Supplement', 5.50, 150, '2028-03-25', 103), 
(205, 'Amoxicillin', 'Antibiotic', 12.80, 60, '2026-09-30', 102); 

SELECT * FROM MEDICINE; 

CREATE TABLE EMPLOYEE( 
   EmployeeID INTEGER PRIMARY KEY AUTO_INCREMENT, 
   FName VARCHAR(50), 
   LName VARCHAR(50), 
   Role VARCHAR(50), 
   Phone VARCHAR(20) 
); 

INSERT INTO EMPLOYEE (EmployeeID, FName, LName, Role, Phone) 
VALUES 
(401, 'Lejla', 'Softić', 'Pharmacist', '+387 61 222 333'), 
(402, 'Emir', 'Alić', 'Cashier', '+387 62 444 555'), 
(403, 'Sara', 'Delić', 'Manager', '+387 63 666 777'); 

SELECT * FROM EMPLOYEE; 

CREATE TABLE CUSTOMER( 
CustomerID INT PRIMARY KEY auto_increment, 
FName VARCHAR(50) NOT NULL, 
LName VARCHAR(50) NOT NULL, 
Phone VARCHAR(20) NOT NULL, 
Email VARCHAR(50) UNIQUE, 
Adress VARCHAR(100) 
); 

INSERT INTO CUSTOMER (CustomerID, FName, LName, Phone, Email, Adress) 
VALUES 
(301, 'Amna', 'Hodžić', '+387 61 111 222', 'amna@gmail.com', 'Sarajevo'), 
(302, 'Emina', 'Karić', '+387 62 333 444', 'emina@gmail.com', 'Zenica'), 
(303, 'Adnan', 'Begić', '+387 63 555 666', 'adnan@gmail.com', 'Mostar'); 

SELECT * FROM CUSTOMER; 

CREATE TABLE SALE( 
SaleID INT PRIMARY KEY auto_increment, 
SaleDate DATE NOT NULL, 
TotalAmount DECIMAL(10, 2) NOT  NULL CHECK (TotalAmount >= 0), 
CustomerID INT, 
EmployeeID INT, 
foreign key (CustomerID) REFERENCES CUSTOMER(CustomerID), 
foreign key (EmployeeID) REFERENCES EMPLOYEE(EmployeeID)); 

INSERT INTO SALE (SaleID, SaleDate, TotalAmount, CustomerID, EmployeeID) 
VALUES 
(501, '2026-05-01', 10.00, 301, 401), 
(502, '2026-05-02', 18.30, 302, 402), 
(503, '2026-05-03', 25.60, 303, 401); 

SELECT * FROM SALE;

CREATE TABLE SALE_ITEM( 
SaleID INT NOT NULL, 
MedicineID INT NOT NULL, 
Quantity INT CHECK (Quantity>0), 
UnitPrice DECIMAL(8,2) CHECK (UnitPrice > 0), 
primary key (SaleID, MedicineID), 
foreign key (SaleID) references  SALE(SaleID), 
foreign key (MedicineID) REFERENCES MEDICINE(MedicineID) 
); 

INSERT INTO SALE_ITEM (SaleID, MedicineID, Quantity, UnitPrice) 
VALUES 
(501, 201, 2, 3.50), 
(501, 203, 1, 4.00), 
(502, 202, 1, 6.20), 
(502, 204, 2, 5.50), 
(503, 205, 2, 12.80); 

SELECT * FROM SALE_ITEM; 

-- Every medicine with supplier that provides it 
SELECT M.MedicineID, M.MName, M.Category, M.Price, S.SName 
FROM MEDICINE AS M 
JOIN SUPPLIER AS S ON M.SupplierID = S.SupplierID; 

-- Each sale with costumer who bought it and employee who made sale 
SELECT SA.SaleID, SA.SaleDate, C.FName AS CustomerName, C.LName AS CustomerSurname, 
      E.FName AS EmployeeName, E.LName AS EmployeeSurname, SA.TotalAmount 
FROM SALE AS SA 
JOIN CUSTOMER AS C ON SA.CustomerID = C.CustomerID 
JOIN EMPLOYEE E ON SA.EmployeeID = E.EmployeeID; 

-- Shows details of each sold medicine, how much each of them cost 
SELECT SA.SaleID, SA.SaleDate, M.MName, SI.Quantity, SI.UnitPrice, 
SI.Quantity * SI.UnitPrice AS ItemTotal 
FROM SALE_ITEM AS SI 
JOIN SALE AS SA ON SI.SaleID = SA.SaleID 
JOIN MEDICINE M ON SI.MedicineID = M.MedicineID; 

-- Shows total number of medicines in stock 
SELECT SUM(StockQuantity) AS TotalStock 
FROM MEDICINE; 

-- Shows the most expensive medicine 
SELECT MName, Price 
FROM MEDICINE 
ORDER BY Price DESC 
LIMIT 1; 

-- Medicines that expire before 1 January 2027 
SELECT * 
FROM MEDICINE 
WHERE ExpiryDate < '2027-01-01'; 

-- Shows how many medicines belong to each category 
SELECT Category, COUNT(*) AS NumberOfMedicines 
FROM MEDICINE 
GROUP BY Category; 

-- Decreases the stock of medicine 201 by 2 
UPDATE MEDICINE 
SET StockQuantity = StockQuantity - 2 
WHERE MedicineID = 201; 

-- Deletes specific medicines from stock 
DELETE FROM SALE_ITEM 
WHERE SaleID = 501 AND MedicineID = 203; 

-- Changes the price of medicine 203 to 4.50 
UPDATE MEDICINE 
SET Price = 4.50 
WHERE MedicineID = 203; 

-- Shows medicines ordered by price from highest to lowest 
SELECT MName, Category, Price 
FROM MEDICINE 
ORDER BY Price DESC; 

-- Shows medicine that are more expensive than average price 
SELECT MName, Price 
FROM MEDICINE 
WHERE Price > ( 
   SELECT avg(Price) FROM MEDICINE 
   ); 

-- Shows customers who made at least 1 sale: 
SELECT FName, LName 
FROM CUSTOMER 
WHERE CustomerID IN ( 
   SELECT CustomerID FROM SALE); 
   
-- Shows sold medicine and total price for each item 
SELECT SI.SaleID, M.MNAme, SI.Quantity, SI.UnitPrice,  
(SI.Quantity * SI.UnitPrice) AS ItemTotal 
FROM SALE_ITEM AS SI INNER JOIN MEDICINE AS M 
ON SI.MedicineID = M.MedicineID;  

-- Shows each sale with customer and employee 
SELECT SA.SaleID, SA.SaleDate, C.FName AS CustomerName, 
E.FName AS EmployeeName, SA.TotalAmount 
FROM (SALE AS SA JOIN CUSTOMER AS C  
ON SA.CustomerID = C.CustomerID) 
JOIN EMPLOYEE AS E ON SA.EmployeeID = E.EmployeeID; 



     
