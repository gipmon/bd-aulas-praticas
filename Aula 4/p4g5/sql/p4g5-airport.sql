use p4g5 --ligar a base de dados
CREATE SCHEMA aula4_airport;
CREATE TABLE aula4_airport.Airport (
	city VARCHAR(50) NOT NULL,
	state_name VARCHAR(50) NOT NULL,
	name VARCHAR(50) NOT NULL,
	airport_code int PRIMARY KEY
);

CREATE TABLE aula4_airport.Airplane_Type (
	typename VARCHAR(40) PRIMARY KEY,
	company VARCHAR(40) NOT NULL,
	max_seats int NOT NULL
);

CREATE TABLE aula4_airport.Airplane (
	airplane_id int PRIMARY KEY,
	total_no_of_seats int NOT NULL,
	typename VARCHAR(40)
);
-- AIRPLANE
ALTER TABLE aula4_airport.Airplane ADD CONSTRAINT TPAIRFK FOREIGN KEY (typename) REFERENCES aula4_airport.Airplane_Type(typename) ON UPDATE CASCADE;

CREATE TABLE aula4_airport.Flight (
	number int PRIMARY KEY,
	airline VARCHAR(30) NOT NULL,
	weekdays VARCHAR(10) CHECK(weekdays IN('sunday','monday','tuesday', 'wednesday', 'thursday', 'friday', 'saturday'))
);

CREATE TABLE aula4_airport.Flight_Leg (
	leg_no int,
	flight_number int,
	airport_code_arrives int,
	airport_code_departs int,
	scheduled_dep_time datetime,
	scheduled_arr_time datetime,
	PRIMARY KEY (leg_no, flight_number)
);
-- FLIGHT LEG
ALTER TABLE aula4_airport.Flight_Leg ADD CONSTRAINT FLFNFNFK FOREIGN KEY (flight_number) REFERENCES aula4_airport.Flight(number) ON UPDATE CASCADE;
ALTER TABLE aula4_airport.Flight_Leg ADD CONSTRAINT AIRCARR FOREIGN KEY (airport_code_arrives) REFERENCES aula4_airport.Airport(airport_code) ON UPDATE CASCADE;
ALTER TABLE aula4_airport.Flight_Leg ADD CONSTRAINT AIRCDEPFK FOREIGN KEY (airport_code_departs) REFERENCES aula4_airport.Airport(airport_code) ON UPDATE NO ACTION;

CREATE TABLE aula4_airport.Leg_Instance (
	leg_date date,
	leg_no int,
	flight_number int,
	no_of_avail_seats int,
	airpline_id int,
	airport_code_arrives int,
	airport_code_departs int,
	arr_time datetime,
	dep_time datetime,
	PRIMARY KEY (leg_date, flight_number, leg_no)
);
-- LEG INSTANCE
ALTER TABLE aula4_airport.Leg_Instance ADD CONSTRAINT LEGNOINSFLILEG FOREIGN KEY (leg_no, flight_number) REFERENCES aula4_airport.Flight_Leg(leg_no, flight_number) ON UPDATE CASCADE;
ALTER TABLE aula4_airport.Leg_Instance ADD CONSTRAINT AILIAIAFK FOREIGN KEY (airpline_id) REFERENCES aula4_airport.Airplane(airplane_id) ON UPDATE NO ACTION;
ALTER TABLE aula4_airport.Leg_Instance ADD CONSTRAINT ACAACFK FOREIGN KEY (airport_code_arrives) REFERENCES aula4_airport.Airport(airport_code) ON UPDATE NO ACTION;
ALTER TABLE aula4_airport.Leg_Instance ADD CONSTRAINT ACDACFK FOREIGN KEY (airport_code_departs) REFERENCES aula4_airport.Airport(airport_code) ON UPDATE NO ACTION;

CREATE TABLE aula4_airport.Seat (
	seat_no int,
	leg_date date,
	leg_no int,
	flight_number int,
	customer_name VARCHAR(40),
	cphone int,
	PRIMARY KEY (seat_no, leg_date, leg_no, flight_number)
);
-- Seat
ALTER TABLE aula4_airport.Seat ADD CONSTRAINT SEATLIFK FOREIGN KEY (leg_date, flight_number, leg_no) REFERENCES aula4_airport.Leg_Instance(leg_date, flight_number, leg_no) ON UPDATE CASCADE;

CREATE TABLE aula4_airport.Fare (
	code int,
	flight_number int,
	restrictions VARCHAR(40),
	amount money,
	PRIMARY KEY (code, flight_number)
);
-- Fare
ALTER TABLE aula4_airport.Fare ADD CONSTRAINT FNFFN FOREIGN KEY (flight_number) REFERENCES aula4_airport.Flight(number) ON UPDATE CASCADE;

CREATE TABLE aula4_airport.Can_Land (
	airport_type_name VARCHAR(40),
	airport_code int,
	PRIMARY KEY (airport_type_name, airport_code)
);
-- Can Land
ALTER TABLE aula4_airport.Can_Land ADD CONSTRAINT CLATNAT FOREIGN KEY (airport_type_name) REFERENCES aula4_airport.Airplane_Type(typename) ON UPDATE CASCADE;
ALTER TABLE aula4_airport.Can_Land ADD CONSTRAINT CLACACA FOREIGN KEY (airport_code) REFERENCES aula4_airport.Airport(airport_code) ON UPDATE CASCADE;