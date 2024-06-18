--DDL
SET search_path TO healthcare;

------Creating tables.
--Entity:patient
Create table Patient(
patient_id serial primary key,
first_name varchar(15) not null,
last_name varchar(15) not null,
phone_no numeric(10) not null,
address varchar(50) not null);


--Entity:doctor
Create table Doctor(
doctor_id int,
doctor_name varchar(30) not null,
specialization varchar(30) not null,
availability_status varchar(15) default 'Available',
phone_no numeric(10) not null,
primary key (doctor_id,doctor_name));



--Entity:doctor
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



--Entity:billing
Create table Billing(
billing_id int primary key,
amount numeric(15) not null,
billingdatetime timestamp not null,
paymentstatus varchar(15) not null,
patient_id int references Patient(patient_id));

--Entity:prescription
create table Prescription(
prescription_id serial primary key,
prescribed_drug varchar(30) not null,
disease_name varchar(30) not null,
dosage varchar(30),
expiry_date date not null);



--Entity:medicalrecord
create table Medicalrecord(
record_id int primary key,
disease_name varchar(30) not null,
recordcreated timestamp not null,
notes varchar(30),
patient_id int references Patient(patient_id),
prescription_id int references Prescription(prescription_id));

----------------Constraints--------------------------
--Constraint for Patient entity.
Create sequence new_patient_id
Start with 1
increment by 1;


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

---------------------------------------------
-- Constraint for Patient entity.
-- Create the sequence (only once)
CREATE SEQUENCE doctor_id_seq
START WITH 1
INCREMENT BY 1;

-- Create the function to assign doctor_id
CREATE OR REPLACE FUNCTION doctor_id_func() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.doctor_id IS NULL THEN
        NEW.doctor_id := NEXTVAL('doctor_id_seq');
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--Constraint for doctor_unavilability
-- Create the trigger to assign doctor_id before insert or update on doctor
CREATE TRIGGER doctor_id
BEFORE INSERT OR UPDATE ON doctor
FOR EACH ROW
EXECUTE FUNCTION doctor_id_func();

CREATE OR REPLACE FUNCTION doctor_unavailable() RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT availability_status FROM doctor WHERE doctor_id = NEW.doctor_id) = 'Unavailable' THEN
        RAISE EXCEPTION 'Doctor is unavailable';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


--Trigger for unavilability
-- Create the trigger to check availability before insert or update on appointment
CREATE TRIGGER unavailability_status
BEFORE INSERT OR UPDATE ON appointment
FOR EACH ROW
EXECUTE FUNCTION doctor_unavailable();

--Trigger for billing
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

--Constraint for entity appoinment
Create sequence appointment_id_seq
Start with 1
increment by 1;

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

--Constraint for medicalrecord
Create sequence record_id_seq
start with 1
increment 1;

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

