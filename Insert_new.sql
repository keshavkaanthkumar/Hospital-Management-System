USE [HospitalDB];

INSERT INTO [dbo].Department VALUES ('Blood rank'),
('Recovery'),
('Surgical ward'),
('Urology'),
('Nursery'),
('Emergency'),
('Dental'),
('Admissions'),
('Critical care'),
('Elderly services');

INSERT INTO [dbo].Doctor VALUES ('John', 'Male', 'Attending Physician', 1),
('Achsa', 'Female', 'Hospitalist',1),
('Rahiq', 'Female', 'Intern',2),
('Jack', 'Male', 'Attending Physician',5),
('Jackson', 'Male', 'Hospitalist',5),
('Nadir', 'Male', 'Fellow',6),
('Bambina', 'Female', 'Medical Director',3),
('Haul', 'Male', 'Attending Physician',4),
('Banu', 'Female', 'Fellow',7),
('Chen', 'Female', 'Attending Physician',1);

INSERT INTO [dbo].Patient VALUES ('Harsh','Kunal','Shahdev','shahdev.h@northeastern.edu','1984-08-19','6177579164'),
('Kamini','Prem','Prakash','prakash.k@northeastern.edu','1987-02-20','6178759161'),
('Sakshi','Dharmesh','Gupta','gupta.s@northeastern.edu','1982-10-09','8771579194'),
('Nandika','Sanjay','Vasanthmurali','vasanthmurali.n@northeastern.edu','1979-12-21','9177577787'),
('Steve','George','Smith','smith.h@northeastern.edu','1964-01-27','7176578762'),
('Vyoma','Tejas','Patel','patel.vy@northeastern.edu','1964-10-20','8577577814'),
('Karan','Brijesh','Soni','soni.ka@northeastern.edu','1975-09-21','7171572161'),
('Kelly','Stuart','Moore','moore.k@northeastern.edu','1991-01-10','9144471243'),
('Andrew','Craig','Mark','mark.a@northeastern.edu','1982-10-29','6177578784'),
('Akash','Prasanta','Sinha','sinha.ak@northeastern.edu','1987-10-20','6474719174');


INSERT INTO [dbo].Item VALUES ('Dacogen', 10,'2022-02-23',10),
('Halcinonide', 15,'2022-04-04',10),
('Abelcet', 21,'2023-04-02',2),
('Paclitaxel', 12,'2023-05-04',30),
('Wellbutrin', 20,'2023-07-01',40),
('Wellbutrin', 20,'2023-02-26',60),
('Paclitaxel', 12,'2024-02-04',10),
('Halcinonide', 15,'2020-01-02',1),
('Dacogen', 10,'2021-01-26',40),
('Paclitaxel', 12,'2019-01-09',10);

INSERT INTO [dbo].Supplier VALUES ('Pfizer', 'New York'),
('Roche', 'Boston'),
('Johnson', ' New Brunswick'),
('Merck', ' Kenilworth'),
('Sanofi', 'Cambridge'),
('Novartis', ' Basel'),
('AbbVie', 'Ashland'),
('GSK', 'Waltham'),
(' Sanofi', 'CambridgeS'),
('AbbVie', 'North Chicago');

INSERT INTO [dbo].Appointment VALUES 
(101, 102, '2019-12-16 14:00:00','2019-12-16 15:00:00','toothache'),
(102, 103,  '2019-12-16 15:00:00','2019-12-16 16:00:00','cold'),
(103, 104, '2019-12-16 15:00:00','2019-12-16 16:00:00','physical examination'),
(104, 105,  '2019-12-16 15:00:00','2019-12-16 16:00:00','stomach pain'),
(105, 106, '2019-12-21 09:00:00','2019-12-21 10:00:00','Vaccine'),
(106, 107,  '2019-12-21 09:00:00','2019-12-21 10:00:00',''),
(107, 108,  '2019-12-21 09:00:00','2019-12-21 10:00:00','Vaccine'),
(108, 109,  '2019-12-21 09:00:00','2019-12-21 10:00:00',''),
(109, 101, '2019-12-21 09:00:00','2019-12-21 10:00:00','cold'),
(102, 104, '2019-12-21 09:00:00','2019-12-21 10:00:00','physical examination'),
(106, 101, '2019-12-22 09:00:00','2019-12-21 10:00:00','cold'),
(109, 101, '2019-12-23 09:00:00','2019-12-21 10:00:00','cold'),
(102, 101, '2019-12-26 09:00:00','2019-12-26 10:00:00','cold');

INSERT INTO [dbo].Prescription VALUES (10001, 1001,2),
(10001, 1003, 5),
(10002, 1004, 10),
(10002, 1006, 2),
(10002, 1008, 1),
(10004, 1002, 3),
(10008, 1004, 2),
(10009, 1005, 4),
(10009, 1008, 1),
(10007, 1009, 5);

INSERT INTO [dbo].Bill VALUES (1000, 10001, 'Paid'),
(960, 10002, 'Paid'),
(1050, 10004, 'Paid'),
(140, 10005, 'Paid'),
(190, 10006, 'Paid'),
(2000, 10007, 'Pending'),
(900, 10008, 'Pending'),
(340, 10009, 'Paid'),
(1670, 10001, 'Paid'),
(9085, 10003, 'Pending');


open symmetric key card_encrption_key decryption by certificate encryption_cert;


INSERT INTO [dbo].Payment (
            [Bill_No]
           ,[Payment_Date]
           ,[Payment_Method]
		   ,[Payment_Amount]
		   ,[Card_No]
		   )
 VALUES 
(10001,'2020-02-12', 'Cash', 1200,null),
(10002,'2020-08-04', 'Credit', 1600, EncryptByKey (Key_GUID('card_encrption_key'), '12432423876876')),
(10003,'2020-12-05', 'Debit',1210, EncryptByKey (Key_GUID('card_encrption_key'), '98798790707078')),
(10004,'2020-12-06', 'Cash', 5120, null),
(10006,'2020-02-08', 'Cash',1000, null),
(10005,'2020-01-10', 'Debit',1500, EncryptByKey (Key_GUID('card_encrption_key'),'4716918792006306')),
(10006,'2020-12-21', 'Cash',350,null),
(10007,'2020-03-12', 'Debit', 5000, EncryptByKey (Key_GUID('card_encrption_key'),'4539534839097086')),
(10008,'2021-01-21', 'Credit',1500, EncryptByKey (Key_GUID('card_encrption_key'),'372036798121335')),
(10009,'2021-03-02', 'Cash', 1100,null);

INSERT INTO [dbo].MedicalOrder VALUES 
           ('2020-12-05','Initiated', 4900, 1001),
		   ('2020-11-24', 'Initiated', 6100, 1002),
		   ('2020-10-13', 'Shipped', 2000, 1003),
		   ('2020-09-12', 'Completed', 3000, 1004),
		   ('2020-08-01', 'Completed', 1800, 1006),
		   ('2020-07-01',  'Shipped', 5950, 1007),
		   ('2020-10-10', 'Initiated', 1560, 1008),
		   ('2020-11-11',  'Shipped',  5009, 1003),
		   ('2020-07-15',  'Completed', 5014, 800),
		   ('2019-09-15', 'Cancelled', 4690, 1005),
		   ('2018-07-16', 'Shipped', 4020, 1001 );
		   

INSERT INTO [dbo].MedicalOrderItem VALUES
           (1, 1001, 101, 7),
		   (1, 1002, 101, 4),
		   (1, 1003, 102, 6),
		   (2, 1004, 103, 8),
		   (2, 1005, 104, 12),
		   (2, 1002, 105, 3),
		   (5, 1004, 101, 7),
		   (7, 1005, 102, 2),
		   (8, 1006, 106, 3),
		   (9, 1009, 107, 10),
		   (10, 1009, 108, 7),
		   (10, 1002, 109, 6);

INSERT INTO [dbo].[Zip]
           ([ZipCode]
           ,[City]
           ,[State]
           ,[Country])
     VALUES
           ('02120', 'Boston', 'MA', 'USA'),
		   ('02122', 'Quincy', 'MA', 'USA'),
		   ('02130', 'Jamaica Plain', 'MA', 'USA'),
		   ('02135', 'New York City', 'NY', 'USA'),
		   ('02256', 'Los Angeles', 'CA', 'USA'),
		   ('02476', 'Arlington', 'TX', 'USA'),
		   ('10001', 'Ney York', 'NY', 'USA'),
		   ('28105', 'Charlotte', 'NC', 'USA'),
		   ('32003', 'Orange Park', 'FL', 'USA'),
		   ('32006', 'Fleming Island', 'FL', 'USA'),
		   ('75001', 'Dallas', 'TX', 'USA');
GO

INSERT INTO [dbo].[Address]
           ([StreetName]
           ,[AptNo]
           ,[ZipCode])
     VALUES
           ('Tetlow Street', '31', '02120'),
		   ('Columbus Ave', '40', '02122'),
		   ('Mass Avenue', '9', '02130'),
		   ('30 South Huntington Ave', '1', '02130'),
		   ('Islington Street', '41', '02135'),
		   ('Harvard Avenue', '37', '02256'),
		   ('Ward Street', '110 B', '02476'),
		   ('Wall Street', '778', '10001'),
		   ('Beacon Street', '25 A', '32006'),
		   ('Verndale Street', '34', '32003'),
		   ('Huntington Avenue', '807', '28105'),
		   ('South End Corner', '1204', '75001'),
		   ('Allston Street', '704', '75001'),
		   ('Commonwealth Avenue', '331', '02120');
GO

INSERT INTO [dbo].[PatientHasAddress]
           ([Patient_ID]
           ,[Address_ID])
     VALUES
		   (101, 2),
		   (102, 3),
		   (103, 4),
		   (104, 5),
		   (105, 3),
		   (106, 6),
		   (107, 7),
		   (108, 8),
		   (109, 9),
		   (100, 1);

GO

INSERT INTO [dbo].[SupplierSuppliesItem]
           ([Supplier_ID]
           ,[Item_ID])
     VALUES
           (101, 1001),
		   (100, 1006),
		   (100, 1007),
		   (100, 1008),
		   (101, 1009),
		   (102, 1000),
		   (103, 1001),
		   (104, 1001),
		   (105, 1002),
		   (106, 1004),
		   (107, 1003),
		   (108, 1005),
		   (109, 1005);
		


