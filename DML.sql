--DML
--Data Insertion for entities
--Entity:patient
SET search_path TO healthcare;

Insert into patient(patient_id,first_name,last_name,phone_no,address)
values (1,'Sherlock','Holmes',7542910863,'Richardson');
Insert into patient(patient_id,first_name,last_name,phone_no,address)
values (2,'Jon','Snow',9028846833,'Irving');
Insert into patient(patient_id,first_name,last_name,phone_no,address)
values (3,'Tony','Stark',9098346175,'Plano');
Insert into patient(patient_id,first_name,last_name,phone_no,address)
values (4,'John','Wick',8687132049,'Irving');
Insert into patient(patient_id,first_name,last_name,phone_no,address)
values (5,'Walter','White',9213465780,'Allen');
Insert into patient(patient_id,first_name,last_name,phone_no,address)
values (6,'Sheldon','Cooper',8309876512,'Coppell');
Insert into patient(patient_id,first_name,last_name,phone_no,address)
values (7,'Saul','Goodman',8675021943,'Fort-Worth');
Insert into patient(patient_id,first_name,last_name,phone_no,address)
values (8,'Jane','Doe',9152897046,'Arlington');
Insert into patient(patient_id,first_name,last_name,phone_no,address)
values (9,'Shaun','Benjamin',9241753089,'Richardson');
Insert into patient(patient_id,first_name,last_name,phone_no,address)
values (10,'Logan','Nance',8980764523,'Plano');


SELECT setval('doctor_id_seq', (SELECT COALESCE(MAX(doctor_id), 1) FROM doctor));
--Entity:doctor
Insert into doctor(doctor_id,doctor_name,specialization,phone_no)
values (1,'Gasan Elkhadori','Orthopedic',9087890987);
Insert into doctor(doctor_name,specialization,phone_no,availability_status)
values ('Willy Wonka','Cardiologist',9087890998,'Unavailable');
Insert into doctor(doctor_name,specialization,phone_no)
values ('Darth Vader','Dermatology',9087890998);
Insert into doctor(doctor_name,specialization,phone_no,availability_status)
values ('Arya Stark','Neurology',7887809678,'Unavailable');
Insert into doctor(doctor_name,specialization,phone_no)
values ('Indiana Jones','Dermatology',8907890567);
Insert into doctor(doctor_name,specialization,phone_no)
values ('James Bond','Cardiologist',4677646789);
Insert into doctor(doctor_name,specialization,phone_no,availability_status)
values ('Hermoine Granger','Dermatology',9876543210,'Unavailable');
Insert into doctor(doctor_name,specialization,phone_no,availability_status)
values ('Harry Potter','Pediatrics',9089098909,'Unavailable');
Insert into doctor(doctor_name,specialization,phone_no)
values ('Norman Bates','Cardiologist',9876098760);
Insert into doctor(doctor_name,specialization,phone_no)
values ('Bruce Wayne','Neurology',4238900987);

--Entity:billing
Insert into billing(amount,paymentstatus,patient_id)
values (2300,'Paid',1);
Insert into billing(amount,paymentstatus,patient_id)
values (5000,'Unpaid',3);
Insert into billing(amount,paymentstatus,patient_id)
values (1000,'Paid',2);
Insert into billing(amount,paymentstatus,patient_id)
values (1500,'Unpaid',4);
Insert into billing(amount,paymentstatus,patient_id)
values (51000,'Unpaid',5);
Insert into billing(amount,paymentstatus,patient_id)
values (10000,'Paid',2);
Insert into billing(amount,paymentstatus,patient_id)
values (15000,'Paid',4);
Insert into billing(amount,paymentstatus,patient_id)
values (40000,'Unpaid',3);
Insert into billing(amount,paymentstatus,patient_id)
values (8900,'Paid',1);
Insert into billing(amount,paymentstatus,patient_id)
values (11000,'Unpaid',5);
Insert into billing(amount,paymentstatus,patient_id)
values (100,'Unpaid',4);


--Entity:Appointment
--NOTE: Some entries will throw doctor_unavailable constraint. Please check doctor table and availability status.
Insert into appointment(appointment_id,doctor_name,service,patient_id,doctor_id)
values (1,'Gasan Elkhadori','Check up',1,1);
Insert into appointment(doctor_name,service,patient_id,doctor_id)
values ('Willy Wonka', 'Check_up', 2, 2);
Insert into appointment(doctor_name,service,patient_id,doctor_id)
values ('Darth Vader', 'Follow-up', 2, 3);
Insert into appointment(doctor_name,service,patient_id,doctor_id)
values ('Arya Stark', 'Physical Exam', 3, 4);
Insert into appointment(doctor_name,service,patient_id,doctor_id)
values ('James Bond', 'Consultation', 4, 6);
Insert into appointment(doctor_name,service,patient_id,doctor_id)
values ('Harry Potter', 'X-ray', 5, 8);
Insert into appointment(doctor_name,service,patient_id,doctor_id)
values ('Norman Bates', 'Blood Test', 3, 9);
Insert into appointment(doctor_name,service,patient_id,doctor_id)
values ('Bruce Wayne', 'Ultrasound', 2, 10);
Insert into appointment(doctor_name,service,patient_id,doctor_id)
values ('Indiana Jones', 'Vaccination', 3, 5);
Insert into appointment(doctor_name,service,patient_id,doctor_id)
values ('Hermoine Granger', 'Eye Exam', 2, 7);
select * from appointment

--Entity:prescription
INSERT INTO prescription (prescription_id, prescribed_drug, disease_name, dosage, expiry_date)
VALUES (1,'Xanax', 'Alprazolam', 2, '2023-01-01'),
       (2, 'Ibuprofen', 'Headache', 3, '2023-02-01'),
       (3, 'Amoxicillin', 'Infection', 4, '2023-03-01'),
       (4, 'Simvastatin', 'High Cholesterol', 5, '2023-04-01'),
       (5, 'Levothyroxine', 'Hypothyroidism', 6, '2023-05-01'),
       (6, 'Metformin', 'Type 2 Diabetes', 7, '2023-06-01'),
       (7, 'Lisinopril', 'Hypertension', 8, '2023-07-01'),
       (8, 'Omeprazole', 'Acid Reflux', 9, '2023-08-01'),
       (9, 'Fluticasone', 'Allergies', 10, '2023-09-01'),
       (10, 'Escitalopram', 'Depression', 11, '2023-10-01');
	   
--Entity:Medical record
Insert into medicalrecord(record_id, disease_name,notes,patient_id,prescription_id)
values (1,'Anxiety','Heart disease',1,1);
Insert into medicalrecord( disease_name,notes,patient_id,prescription_id)
values ('Headache', 'Prescription working well', 2, 2);
Insert into medicalrecord( disease_name,notes,patient_id,prescription_id)
values ('Infection', 'Completed antibiotic course', 3, 3);
Insert into medicalrecord( disease_name,notes,patient_id,prescription_id)
values ('High Cholesterol', 'Follow-up needed', 4, 4);
Insert into medicalrecord( disease_name,notes,patient_id,prescription_id)
values ('Hypothyroidism', 'Stable condition', 5, 5);
Insert into medicalrecord( disease_name,notes,patient_id,prescription_id)
values ('Type 2 Diabetes', 'Monitor blood sugar levels', 6, 6);
Insert into medicalrecord( disease_name,notes,patient_id,prescription_id)
values ('Hypertension', 'Taking medication reg', 7, 7);
Insert into medicalrecord( disease_name,notes,patient_id,prescription_id)
values ('Acid Reflux', 'Dietary changes recommended', 8, 8);
Insert into medicalrecord( disease_name,notes,patient_id,prescription_id)
values ('Allergies', 'Presc for allergy symptoms', 9, 9);
Insert into medicalrecord( disease_name,notes,patient_id,prescription_id)
values ('Depression', 'In therapy, medication presc', 10, 10);

