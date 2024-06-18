SET search_path TO healthcare;

--Creating entities
--Patient -PK Serial
Create table Patient(
patient_id serial primary key,
first_name varchar(15) not null,
last_name varchar(15) not null,
phone_no numeric(10) not null,
address varchar(50) not null)

--Doctor
--Sequence and trigger
Create table Doctor(
doctor_id int,
doctor_name varchar(30) not null,
specialization varchar(30) not null,
availability_status varchar(15) default 'Available',
phone_no numeric(10) not null,
primary key (doctor_id,doctor_name))

--Appointment
--Sequence and trigger
CREATE TABLE Appointment (
    appointment_id INT PRIMARY KEY,
    service VARCHAR(15) NOT NULL,
    scheduled_time TIMESTAMP NOT NULL,
    patient_id INT REFERENCES Patient(patient_id),
    doctor_id INT,
	doctor_name varchar(30),
    CONSTRAINT fk_doctor
        FOREIGN KEY (doctor_id, doctor_name)
        REFERENCES Doctor(doctor_id, doctor_name) 
		ON UPDATE CASCADE
);


--Billing entity
--Trigger and Function to generate the billing id,time
Create table Billing(
billing_id int primary key,
amount numeric(15) not null,
billingdatetime timestamp not null,
paymentstatus varchar(15) not null,
patient_id int references Patient(patient_id))


--Serial for unique id
create table Prescription(
prescription_id serial primary key,
prescribed_drug varchar(30) not null,
disease_name varchar(30) not null,
dosage varchar(30),
expiry_date date not null)

--function to generate the record id,datetime
--trigger for function
create table Medicalrecord(
record_id int primary key,
disease_name varchar(15) not null,
recordcreated timestamp not null,
notes varchar(30),
patient_id int references Patient(patient_id),
prescription_id int references Prescription(prescription_id))

--------------------------------------------------------------------------------------------------
Create sequence new_patient_id
Start with 1
increment by 1

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'patient';


create or replace function patient_func() returns trigger as $$
Begin
	If new.patient_id is null then
	new.patient_id:=nextval('new_patient_id');
	end if;
	return new;
end;
$$ language plpgsql;

Create trigger patient_trigger
before insert or update on Patient
for each row
execute function patient_func();

ALTER SEQUENCE patient_patient_id_seq RESTART WITH 1;

---------------------------------------------------------

---------------------------------------------------------

Insert into patient(patient_id,first_name,last_name,phone_no,address)
values (1,'Sherlock','Holmes',7542910863,'Richardson');
Insert into patient(first_name,last_name,phone_no,address)
values ('Jon','Snow',9028846833,'Irving');
Insert into patient(first_name,last_name,phone_no,address)
values ('Tony','Stark',9098346175,'Plano');
Insert into patient(first_name,last_name,phone_no,address)
values ('John','Wick',8687132049,'Irving');
Insert into patient(first_name,last_name,phone_no,address)
values ('Walter','White',9213465780,'Allen');
Insert into patient(first_name,last_name,phone_no,address)
values ('Sheldon','Cooper',8309876512,'Coppell');
Insert into patient(first_name,last_name,phone_no,address)
values ('Saul','Goodman',8675021943,'Fort-Worth');
Insert into patient(first_name,last_name,phone_no,address)
values ('Jane','Doe',9152897046,'Arlington');
Insert into patient(first_name,last_name,phone_no,address)
values ('Shaun','Benjamin',9241753089,'Richardson');
Insert into patient(first_name,last_name,phone_no,address)
values ('Logan','Nance',8980764523,'Plano');
select * from appointment

-------------------------------------------------------
create sequence doctor_id_seq
start with 1
minvalue 1

create or replace function doctor_id_func() returns trigger as $$
Begin
	if new.doctor_id is null then
	new.doctor_id:=nextval('doctor_id_seq');
	end if;
	return new;
end;
$$ language plpgsql

create trigger doctor_id
before insert or update on doctor
for each row
execute function doctor_id_func();

create or replace function doctor_unavailable() returns trigger as $$
Begin
	If (select availability_status from doctor where doctor_id=new.doctor_id)='Unavailable' then
	raise exception 'Doctor is unavailable';
	end if;
	return new;
end;
$$ language plpgsql

create trigger unavailability_status
before insert or update on appointment
for each row
execute function doctor_unavailable();


Insert into doctor(doctor_name,specialization,phone_no)
values ('Gasan Elkhadori','Orthopedic',9087890987);
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
-----------------------------------------------------------------------------


create or replace function billing_func() returns trigger as $$
Begin
	new.billingdatetime=current_timestamp;
	If new.billing_id is null then
	new.billing_id= floor(random() * 10000)::int; 
	end if;
	return new;	
end
$$ language plpgsql;

Create trigger billing_trigger
before insert or update on billing
for each row
execute function billing_func();

Insert into billing(amount,paymentstatus,patient_id)
values (2300,'Paid',1);
Insert into billing(amount,paymentstatus,patient_id)
values (5000,'Unpaid',3);
Insert into billing(amount,paymentstatus,patient_id)
values (1000,'Paid',2);
Insert into billing(amount,paymentstatus,patient_id)
values (1500,'Unpaid',6);
Insert into billing(amount,paymentstatus,patient_id)
values (51000,'Unpaid',8);
Insert into billing(amount,paymentstatus,patient_id)
values (10000,'Paid',9);
Insert into billing(amount,paymentstatus,patient_id)
values (15000,'Paid',10);
Insert into billing(amount,paymentstatus,patient_id)
values (40000,'Unpaid',7);
Insert into billing(amount,paymentstatus,patient_id)
values (8900,'Paid',4);
Insert into billing(amount,paymentstatus,patient_id)
values (11000,'Unpaid',5);
Insert into billing(amount,paymentstatus,patient_id)
values (100,'Unpaid',10);

-------------------------------------------
Create sequence appointment_id_seq
Start with 1
minvalue 1;

create or replace function appointment_func() returns trigger as $$
Begin
	new.scheduled_time=current_timestamp;
	If new.appointment_id is null then
	new.appointment_id:=nextval('appointment_id_seq');
	end if;
	return new;	
	 
end;
$$ language plpgsql;

Create trigger appointment_trigger
before insert or update on appointment
for each row
execute function appointment_func();

Insert into appointment(doctor_name,service,patient_id,doctor_id)
values ('Gasan Elkhadori','Check up',1,1)
--Add  more appointments based on doctor's availability.


---------------------------------------------------------------------------
select * from prescription
Insert into prescription(prescribed_drug,disease_name,dosage,expiry_date)
values ('Xanax','Anxiety',2,'2023-01-01')
---Add more 9 drugs


------------------------------------------
Create sequence record_id_seq
start with 1
increment 1

create or replace function medicalrecord_func() returns trigger as $$
Begin
	new.recordcreated=current_timestamp;
	If new.record_id is null then
	new.record_id:=nextval('record_id_seq');
	end if;
	return new;	
end;
$$ language plpgsql;



Create trigger medicalrecord_trigger
before insert or update on medicalrecord
for each row
execute function medicalrecord_func();

Insert into medicalrecord(disease_name,notes,patient_id,prescription_id)
values ('Anxiety','Heart disease',1,1)
--Add more 9 records in medicalrecord.
select * from medicalrecord