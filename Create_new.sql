DROP DATABASE IF EXISTS [HospitalDB];
CREATE DATABASE [HospitalDB]
go
USE [HospitalDB]
GO

create master key encryption by password = 'keshavkaanth';

SELECT name KeyName, 
    symmetric_key_id KeyID, 
    key_length KeyLength, 
    algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;

CREATE CERTIFICATE encryption_cert WITH SUBJECT = 'Encrypted card details';



SELECT name CertName, 
    certificate_id CertID, 
    pvt_key_encryption_type_desc EncryptType, 
    issuer_name Issuer
FROM sys.certificates;

CREATE SYMMETRIC KEY card_encrption_key WITH ALGORITHM = AES_256 ENCRYPTION BY CERTIFICATE encryption_cert;



SELECT name KeyName, 
    symmetric_key_id KeyID, 
    key_length KeyLength, 
    algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;

--DROP TABLE IF EXISTS Hospital
--CREATE TABLE Hospital(
-- Hospital_ID INT NOT NULL,
-- Hospital_Name varchar(25) NOT NULL,
-- Hospital_Address varchar(25) NULL,
--CONSTRAINT Hospital_PK PRIMARY KEY (Hospital_ID));

DROP TABLE IF EXISTS Department
CREATE TABLE Department(
 Department_ID INT NOT NULL IDENTITY(1,1),
 Department_Name varchar (25) NOT NULL,
CONSTRAINT Department_PK PRIMARY KEY (Department_ID),
--CONSTRAINT Hospital_FK FOREIGN KEY (Hospital_ID) REFERENCES Hospital(Hospital_ID)
);

DROP TABLE IF EXISTS Doctor
CREATE TABLE Doctor(
 Doctor_ID INT NOT NULL IDENTITY(100,1),
 Doctor_Name varchar(25) NOT NULL,
 Doctor_Gender varchar(10) NOT NULL,
 Doctor_Rank varchar(20) NOT NULL,
 Department_ID INT NOT NULL,
CONSTRAINT Doctor_PK PRIMARY KEY (Doctor_ID),
CONSTRAINT Department_FK FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID),
CHECK(Doctor_Gender IN ('Male','Female')),
CHECK(Doctor_Rank IN ('Fellow','Intern','Hospitalist','Attending Physician','Medical Director','Surgeon')));

DROP TABLE IF EXISTS Patient;
CREATE TABLE Patient(
	Patient_ID INT NOT NULL IDENTITY(100,1),
	FirstName varchar (25) NOT NULL,
	MiddleName varchar (25) DEFAULT NULL,
	LastName varchar (25) NOT NULL,
	EmailID varchar (100) NOT NULL,
	DateOfBirth Date DEFAULT NULL,
	Phone numeric (10) NOT NULL,
	Age as (year(CURRENT_TIMESTAMP) - year(DateOfBirth)),
CONSTRAINT Patient_PK PRIMARY KEY (Patient_ID)
);

DROP TABLE IF EXISTS Item
CREATE TABLE Item(
Item_ID INT NOT NULL IDENTITY(1000,1),
Item_Name varchar(20) NOT NULL,
Item_Price varchar(10) NOT NULL,
Item_ExpiryDate DATE NULL,
Stock_Quantity INT DEFAULT 0,
CONSTRAINT Item_PK PRIMARY KEY (Item_ID));

DROP TABLE IF EXISTS Supplier;
CREATE TABLE Supplier(
Supplier_ID INT NOT NULL IDENTITY(100,1),
Supplier_Name varchar(20) NOT NULL,
Supplier_City varchar(20) NOT NULL,
CONSTRAINT Supplier_PK PRIMARY KEY (Supplier_ID));

DROP TABLE IF EXISTS Appointment
CREATE TABLE Appointment(
 Appointment_ID INT NOT NULL IDENTITY(10000,1),
 Patient_ID INT NOT NULL,
 Doctor_ID INT NOT NULL,
 Start_Time datetime NOT NULL,
 End_Time datetime ,
 Appointment_Reason varchar(60) NULL,
CONSTRAINT Appointment_PK PRIMARY KEY (Appointment_ID),
CONSTRAINT Patient_FK FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID),
CONSTRAINT Doctor_FK FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID)
);

DROP TABLE IF EXISTS Prescription
CREATE TABLE Prescription(
Prescription_ID INT NOT NULL IDENTITY(10000,1),
Appointment_ID INT NOT NULL,
Prescription_Drug_ID INT NOT NULL,
Prescription_DrugQuantity numeric(10) NULL,
CONSTRAINT Prescription_PK PRIMARY KEY (Prescription_ID),
CONSTRAINT Appointment_FK FOREIGN KEY (Appointment_ID) REFERENCES Appointment(Appointment_ID),
CONSTRAINT Prescription_Drug_FK FOREIGN KEY (Prescription_Drug_ID) REFERENCES Item(Item_ID),
);

DROP TABLE IF EXISTS Bill
CREATE TABLE Bill(
 Bill_No INT NOT NULL IDENTITY(10000,1),
 Amount numeric(10) NOT NULL,
 Appointment_ID INT NOT NULL,
 Bill_Status varchar (20) NOT NULL,
CONSTRAINT [Bill_PK] PRIMARY KEY (Bill_No),
CONSTRAINT Appointment_Bill_FK FOREIGN KEY (Appointment_ID) REFERENCES Appointment(Appointment_ID),
CHECK(Bill_Status IN ('Paid','Pending'))
);

DROP TABLE IF EXISTS Payment
CREATE TABLE Payment(
Payment_ID INT NOT NULL IDENTITY(10000,1),
Bill_No INT NOT NULL,
Payment_Date DATE NOT NULL,
Payment_Method varchar(20) NOT NULL,
Payment_Amount numeric NOT NULL,
Card_No varbinary(MAX) DEFAULT NULL,
CONSTRAINT Payment_PK PRIMARY KEY (Payment_ID),
CONSTRAINT Payment_Bill_FK FOREIGN KEY (Bill_No) REFERENCES Bill(Bill_No),
CHECK(Payment_Method IN ('Cash','Credit','Debit'))
);




-- Creating Zip
DROP TABLE IF EXISTS Zip;
CREATE TABLE Zip(
    ZipCode VARCHAR(6) NOT NULL, -- added 6 on VARCHAR
 	City CHAR(25) NOT NULL,
	[State] CHAR(25) NOT NULL,
	Country CHAR(25) NOT NULL
CONSTRAINT Zip_PK PRIMARY KEY (ZipCode)
);


-- Creating Address (Incomplete / we can break into two trabvles as zipcode and address) and changed the name to [Address] and [state]
DROP TABLE IF EXISTS [Address];
CREATE TABLE [Address](
	Address_ID INT NOT NULL IDENTITY(1,1),
	StreetName varchar(45) DEFAULT NULL,
	AptNo varchar(10) DEFAULT NULL,
	ZipCode varchar(6) NOT NULL, -- added 6 on VARCHAR
CONSTRAINT Address_PK PRIMARY KEY (Address_ID),
CONSTRAINT AddZip_FK FOREIGN KEY (ZipCode) REFERENCES Zip(ZipCode)
);


-- Creating Customer Has Address // Added the whole table
DROP TABLE IF EXISTS PatientHasAddress
CREATE TABLE PatientHasAddress(
    Patient_ID INT NOT NULL,
	Address_ID INT NOT NULL,
CONSTRAINT PatientHasAdd_PK PRIMARY KEY (Patient_ID,Address_ID),
CONSTRAINT PatientHasAddAdd_FK FOREIGN KEY (Address_ID) REFERENCES [Address](Address_ID),
CONSTRAINT PatientHasAddCus_FK FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID)
);


DROP TABLE IF EXISTS MedicalOrder;
CREATE TABLE MedicalOrder(
	Order_ID INT NOT NULL IDENTITY(1,1),
	OrderDate DATETIME NOT NULL,
	[Status] CHAR(20) NOT NULL DEFAULT 'Initiated',
	OrderAmount FLOAT DEFAULT NULL,
	ShippingCharges FLOAT NOT NULL,
CONSTRAINT Orders_PK PRIMARY KEY (Order_ID),
CHECK(Status IN ('Initiated','Shipped','Completed','Cancelled')),
);

DROP TABLE IF EXISTS MedicalOrderItem;
CREATE TABLE MedicalOrderItem(
	Order_ID INT NOT NULL,
	Item_ID INT NOT NULL,
	Supplier_ID INT NOT NULL,
	Quantity INT DEFAULT 1, 
CONSTRAINT OrdItem_PK PRIMARY KEY (Order_ID, Item_ID),
CONSTRAINT OrdItemOrd_FK FOREIGN KEY (Order_ID) REFERENCES MedicalOrder(Order_ID),
CONSTRAINT OrdItemProd_FK FOREIGN KEY (Item_ID) REFERENCES Item(Item_ID)
);


DROP TABLE IF EXISTS SupplierSuppliesItem;
CREATE TABLE SupplierSuppliesItem(
    Supplier_ID INT NOT NULL,
	Item_ID INT NOT NULL,
CONSTRAINT SupplierSuppliesItem_PK PRIMARY KEY (Supplier_ID,Item_ID),
CONSTRAINT SupplierSuppliesItem_SupplierFK FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID),
CONSTRAINT SupplierSuppliesItem_ItemFK FOREIGN KEY (Item_ID) REFERENCES Item(Item_ID)
);

