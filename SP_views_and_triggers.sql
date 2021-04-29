
go
USE [HospitalDB]
GO
------------------------------------------------------------------------
-- STORED PROCEDURE EXECUTION STATEMENT
------------------------------------------------------------------------
-- 1) Stored Procedure to get Doctor with Most appointments in a year
CREATE PROCEDURE GetMostVisitedDoctor 
(
@year INT,
@doctor VARCHAR(40) OUTPUT,
@appointments INT OUTPUT
)
AS 
BEGIN

DECLARE @doctor_name varchar,
        @no_of_appointments int

Select @doctor=TEMP.Doctor_Name , @appointments=TEMP.No_of_Appointments FROM (
Select Doctor.Doctor_Name as Doctor_Name , COUNT(Appointment.Doctor_ID) as No_of_Appointments from Appointment
inner join Doctor on Doctor.Doctor_ID = Appointment.Doctor_ID
where YEAR(Appointment.Start_Time) = 2019
group by Appointment.Doctor_ID,Doctor.Doctor_Name

) AS TEMP
group by TEMP.Doctor_Name, TEMP.No_of_Appointments
order by COUNT(TEMP.No_of_Appointments) Desc

END


GO
DECLARE 
@appointment_year INT,
@doctor_name VARCHAR (40),
@no_of_appointments INT
EXEC GetMostVisitedDoctor
    @year = 2019,
    @doctor = @doctor_name OUTPUT,
	@appointments= @no_of_appointments OUTPUT;

SELECT @doctor_Name AS 'Most visited doctor';

-- 2) Stored Procedure to get All Appointments of a patient
GO
CREATE PROCEDURE GetPatientAppointments
(
@patient INT,
@appointmentReason VARCHAR(40) OUTPUT,
@appointmentStartTime DATETIME OUTPUT
)
AS 
BEGIN


Select Appointment.Appointment_Reason as Appointment_Reason, Appointment.Start_Time as Appointments from Appointment
inner join Patient on Patient.Patient_ID = Appointment.Patient_ID
where Patient.Patient_ID=@patient;
END


GO
DECLARE 
@patient_id INT,
@appointment_reason VARCHAR (40),
@appointment_start DATETIME
EXEC GetPatientAppointments
    @patient = 102,
    @appointmentReason = @appointment_reason OUTPUT,
	@appointmentStartTime= @appointment_start OUTPUT;


-- 3) Stored Procedure to get All Drugs prescribed for a patient
go
USE [HospitalDB]

GO
CREATE PROCEDURE GetPatientDrugs
(
@patient INT,
@patientName VARCHAR(40) OUTPUT,
@drug VARCHAR(40) OUTPUT,
@appointment DATETIME OUTPUT
)
AS 
BEGIN

Select Patient.Patient_ID as Patient_ID, Patient.FirstName as Patient_Name, Item.Item_Name as Prescribed_Drug, Appointment.Start_Time as Appointment from Patient
inner join Appointment on Patient.Patient_ID = Appointment.Patient_ID
inner join Prescription on Appointment.Appointment_ID = Prescription.Appointment_ID
inner join Item on Prescription.Prescription_Drug_ID = Item.Item_ID
where Patient.Patient_ID=@patient
END


GO
DECLARE 
@patient_id INT,
@patient_name VARCHAR (40),
@item_name VARCHAR (40),
@appointment_start DATETIME
EXEC GetPatientDrugs
    @patient = 102,
    @patientName = @patient_name OUTPUT,
	@drug= @item_name OUTPUT,
	@appointment = @appointment_start OUTPUT;

-----------------------------------------------------------------------
-- VIEW AND EXECUTION STATEMENT
-----------------------------------------------------------------------
-- 1) View to get the Medical Order Deatils

GO
USE HospitalDB ; 

GO
CREATE VIEW MedicalOrderDetails AS
SELECT MedicalOrderItem.Order_ID, MedicalOrderItem.Item_ID, Item.Item_Name, Item.Item_Price, MedicalOrderItem.Quantity,
ROUND(Item.Item_Price * MedicalOrderItem.Quantity,0) AS "ExtendedPrice"
FROM Item
JOIN MedicalOrderItem
ON Item.Item_ID = MedicalOrderItem.Item_ID;

GO
EXEC('SELECT * FROM MedicalOrderDetails;')

-- 2) View to get Appointments by Doctors

USE HospitalDB ;   
GO  
CREATE VIEW AppointmentsByDoctors AS 
SELECT Doctor.Doctor_ID AS 'DoctorID',
Doctor.Doctor_Name AS 'DoctorName',
Appointment.Start_Time AS 'Appointments'
FROM Doctor
JOIN Appointment ON Appointment.Doctor_ID=Doctor.Doctor_ID
GROUP BY Doctor.Doctor_ID, Doctor.Doctor_Name, Appointment.Start_Time
GO

EXEC('SELECT * FROM AppointmentsByDoctors;')




-------------------------------------------------------------------------
-- TRIGGERS AND EXECUTION STATEMENT
-------------------------------------------------------------------------
-- 1) Trigger to get an Update on Stock  Quantity

GO
CREATE TRIGGER UpdateItemStockQuantity
ON MedicalOrder 
AFTER UPDATE
AS 
BEGIN
UPDATE Item
SET Item.Stock_Quantity = Item.Stock_Quantity + MedicalOrderItem.Quantity
FROM MedicalOrder
INNER JOIN MedicalOrderItem
ON MedicalOrderItem.Order_ID = MedicalOrder.Order_ID
INNER JOIN Item
ON Item.Item_ID = MedicalOrderItem.Item_ID
where MedicalOrder.Status='Completed' AND EXISTS (SELECT 1 FROM inserted i WHERE i.Order_ID=MedicalOrder.Order_ID)
END



-----------------------------------------------------------------------------
-- NON - CLUSTERED INDEXES AND EXECUTION STATEMENT
-----------------------------------------------------------------------------
GO
USE [HospitalDB];
GO
CREATE NONCLUSTERED INDEX idx_doctor_name ON Doctor(Doctor_Name)
GO
CREATE NONCLUSTERED INDEX idx_appointment_reason ON Appointment(Appointment_Reason)
GO
CREATE NONCLUSTERED INDEX idx_zip_city ON Zip(City)
GO
CREATE NONCLUSTERED INDEX idx_zip_state ON Zip([State])
GO
CREATE NONCLUSTERED INDEX idx_item_name ON Item(Item_Name)
GO
CREATE NONCLUSTERED INDEX idx_order_status ON MedicalOrder([Status])
GO



