CREATE TABLE Customer
(
  Cemail_id VARCHAR(255) NOT NULL,
  Cfirst_name VARCHAR(50) NOT NULL,
  Cmiddle_name VARCHAR(50),
  Clast_name VARCHAR(50) NOT NULL,
  Cbirthdate DATE NOT NULL,
  Cphone_number VARCHAR(15) NOT NULL,
  Cpassword VARCHAR(100) NOT NULL,
  PRIMARY KEY (Cemail_id)
)

CREATE TABLE Products
(
  Pproduct_number INTEGER PRIMARY KEY AUTOINCREMENT,
  Pshort_name VARCHAR(100) NOT NULL,
  Ptextual_description VARCHAR(300),
  Pbrand VARCHAR(50),
  Pcolour VARCHAR(50),
  Plength FLOAT CHECK (Plength >= 0),
  Pwidth FLOAT CHECK (Pwidth >= 0),
  Pheight FLOAT CHECK (Pheight >= 0),
  Pweight FLOAT CHECK (Pweight >= 0),
  Pprice FLOAT NOT NULL CHECK (Pprice >= 0),
  Pdays_of_warranty INT,
  Pcategory VARCHAR(100),
  Pstock_count INT NOT NULL CHECK (Pstock_count >= 0)
)


CREATE TABLE Address
(
  Aaddress_id INTEGER PRIMARY KEY AUTOINCREMENT,
  Abuilding_name_number VARCHAR(100),
  Astreet VARCHAR(100) NOT NULL,
  Acity VARCHAR(100) NOT NULL,
  Acountry VARCHAR(100) NOT NULL,
  Apostcode VARCHAR(20) NOT NULL,
  Cemail_id VARCHAR(255),
  FOREIGN KEY (Cemail_id) REFERENCES Customer(Cemail_id) ON DELETE CASCADE
)

CREATE TABLE Payment_methods
(
  Pis_default CHAR(1) NOT NULL DEFAULT 'N' CHECK (Pis_default IN ('Y', 'N')),
  Ppayment_method_id INTEGER PRIMARY KEY AUTOINCREMENT,
  Cemail_id VARCHAR(255) NOT NULL,
  FOREIGN KEY (Cemail_id) REFERENCES Customer(Cemail_id) ON DELETE CASCADE
)

CREATE TABLE Pcredit_debit_cards
(
  Pcard_number VARCHAR(16) NOT NULL,
  Pcard_expiry_date DATE NOT NULL,
  Pverification_code VARCHAR(4) NOT NULL,
  Pname_on_card VARCHAR(100) NOT NULL,
  Ppayment_method_id INTEGER NOT NULL,
  PRIMARY KEY (Pcard_number),
  FOREIGN KEY (Ppayment_method_id) REFERENCES Payment_methods(Ppayment_method_id) ON DELETE CASCADE
)

CREATE TABLE Pvouchers_gift_cards
(
  Pserial_numbers VARCHAR(20) NOT NULL,
  Pvoucher_expiry_date DATE NOT NULL,
  Ptotal_amount FLOAT NOT NULL CHECK (Ptotal_amount >= 0),
  Pcurrent_balance FLOAT NOT NULL CHECK (Pcurrent_balance >= 0),
  Ppayment_method_id INTEGER NOT NULL,
  PRIMARY KEY (Pserial_numbers),
  FOREIGN KEY (Ppayment_method_id) REFERENCES Payment_methods(Ppayment_method_id) ON DELETE CASCADE
)

CREATE TABLE Basket
(
  Bbasket_id INTEGER PRIMARY KEY AUTOINCREMENT,
  Cemail_id VARCHAR(255) NOT NULL,
  FOREIGN KEY (Cemail_id) REFERENCES Customer(Cemail_id) ON DELETE CASCADE
)

CREATE TABLE basket_contains
(
  Bbasket_id INT NOT NULL,
  Pproduct_number INT NOT NULL,
  Bquantity INT NOT NULL CHECK (Bquantity >= 0),
  PRIMARY KEY (Bbasket_id, Pproduct_number),
  FOREIGN KEY (Bbasket_id) REFERENCES Basket(Bbasket_id) ON DELETE CASCADE,
  FOREIGN KEY (Pproduct_number) REFERENCES Products(Pproduct_number) ON DELETE CASCADE
)

CREATE TABLE Delivery
(
  Dtrack_number INTEGER PRIMARY KEY AUTOINCREMENT,
  Ddate_of_delivery DATE NOT NULL,
  Dstatus VARCHAR(50) NOT NULL DEFAULT 'Pending' CHECK (Dstatus IN ('Pending', 'Delivered', 'Cancelled')),
  Aaddress_id INT,
  FOREIGN KEY (Aaddress_id) REFERENCES Address(Aaddress_id) ON DELETE SET NULL
)

CREATE TABLE "Orders" (
	"Oorder_number"	INTEGER,
	"Odate"	DATE NOT NULL,
	"Odeduction"	FLOAT CHECK("Odeduction" >= 0),
	"Cemail_id"	VARCHAR(255) NOT NULL,
	"Ppayment_method_id"	INTEGER NOT NULL,
	"Dtrack_number"	INTEGER,
	PRIMARY KEY("Oorder_number" AUTOINCREMENT),
	FOREIGN KEY("Cemail_id") REFERENCES "Customer"("Cemail_id") ON DELETE CASCADE,
	FOREIGN KEY("Dtrack_number") REFERENCES "Delivery"("Dtrack_number"),
	FOREIGN KEY("Ppayment_method_id") REFERENCES "Payment_methods"("Ppayment_method_id") ON DELETE CASCADE
)

CREATE TABLE "order_contains" (
    "Oorder_number" INT NOT NULL,
    "Pproduct_number" INT NOT NULL,
    "Oquantity" INT NOT NULL CHECK("Oquantity" >= 0),
    PRIMARY KEY("Oorder_number", "Pproduct_number"),
    FOREIGN KEY("Oorder_number") REFERENCES "Orders"("Oorder_number") ON DELETE CASCADE,
    FOREIGN KEY("Pproduct_number") REFERENCES "Products"("Pproduct_number") ON DELETE CASCADE
)

CREATE TABLE "Returns" (
	"Rticket_number"	INTEGER,
	"Rstart_date"	DATE NOT NULL,
	"Rdue_date"	DATE NOT NULL,
	"Rstatus"	VARCHAR(50) NOT NULL DEFAULT 'Pending' CHECK("Rstatus" IN ('Pending', 'Completed', 'Cancelled', 'Confirmed')),
	"Oorder_number"	INT NOT NULL,
	PRIMARY KEY("Rticket_number" AUTOINCREMENT),
	FOREIGN KEY("Oorder_number") REFERENCES "Orders"("Oorder_number") ON DELETE CASCADE
)

CREATE TABLE Reviews
(
  Rreview_number INTEGER PRIMARY KEY AUTOINCREMENT,
  Rdate DATE NOT NULL,
  Rtext VARCHAR(500) NOT NULL,
  Rranking INT NOT NULL DEFAULT 1 CHECK (Rranking BETWEEN 1 AND 5),
  Cemail_id VARCHAR(255) NOT NULL,
  Pproduct_number INT NOT NULL,
  FOREIGN KEY (Cemail_id) REFERENCES Customer(Cemail_id) ON DELETE CASCADE,
  FOREIGN KEY (Pproduct_number) REFERENCES Products(Pproduct_number) ON DELETE CASCADE
)

CREATE VIEW OrderDetails AS
SELECT 
    O.Odate AS Order_Date,
    O.Cemail_id AS Customer_Email,
    P.Pshort_name AS Product_Name,
    OC.Oquantity AS Quantity,
    O.Oorder_number AS Order_Number,
    P.Pproduct_number AS Product_Number
FROM Orders O
JOIN order_contains OC ON O.Oorder_number = OC.Oorder_number
JOIN Products P ON OC.Pproduct_number = P.Pproduct_number