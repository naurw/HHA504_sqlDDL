/* 
DML triggers --> run before and after like inserting, updating, or deleting a table or a view  
DDL triggers --> when user attempts to create, alter, and drop statements of a table or view 
*/

/* Creating table for inserting test data */ 
CREATE TABLE medicalNotes (
    id INT AUTO_INCREMENT PRIMARY KEY, 
    encounterId INT NOT NULL, 
    med VARCHAR(100) NOT NULL, 
    dose INT NOT NULL, 
    age INT NOT NULL, 
    sex VARCHAR(50) NOT NULL,
    cost DECIMAL(10,2) NOT NULL
);

INSERT INTO medicalNotes (encounterId, med, dose, age, sex, cost) 
VALUES (869542, 'Ambien', 84, 34, 'M', 300), (345639, 'Paromycin Sulfate', 60, 49, 'M', 68.65), (626366, 'Accutane', 100, 18, 'F', 9.89), (277486, 'Skyla', 15, 25, 'F', 100.2);

/* Creating trigger */ 
/* Delimiter $$ is only needed for terminal SSH */
delimiter $$
CREATE TRIGGER qualityAge BEFORE INSERT ON medicalNotes
FOR EACH ROW
BEGIN
    IF NEW.age >= 150 THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: HUMANS HAVE NOT DEVELOPED IMMORTALITY'; 
    END IF; 
END; $$
delimiter ; 


delimiter $$
CREATE TRIGGER backupNotes BEFORE DELETE ON medicalNotes
FOR EACH ROW
BEGIN
    INSERT INTO medicalNotes.hisotrical
    VALUES (OLD.encounterId, OLD.med, OLD.dose); 
END; $$
delimiter ; 

/* 
Functions in Python for SQL reference

def genderModifier(medicalNotes): 
    medicalNotes['gender'] = 'the gender of this person is: ', medicalNotes['gender']
    return medicalNotes
*/ 

/* Creating deterministic/nondeterministic functions */ 
CREATE FUNCTION[medicalNotes].function_name(sexModifier)
RETURNS data_type as
BEGIN 
    'The sex of this person is: ', medicalNotes[sex]
    RETURN value 
END 

delimiter $$
CREATE FUNCTION medicationPrice(price DECIMAL(10,2)
RETURNS VARCHAR(20) 
BEGIN 
    DECLARE drugPrice VARCHAR(20);
    IF price > 200 THEN 
        SET drugPrice = 'expensive';
    ELSE IF (price >= 10 and price <= 200) THEN 
        SET drugPrice = 'standard';
    ELSE IF price < 10 THEN 
        SET drugPrice = 'cheap';
    END IF; 
    -- return the drug cost category
    RETURN (drugPrice);
END; $$ 
delimiter ; 

/* Testing the function for validity */
SELECT 
    cost, 
    medicationPrice(cost)
FROM 
    synthea.medicalNotes; 


CREATE FUNCTION medicationType(medName VARCHAR(100))
RETURNS VARCHAR(100)
BEGIN 
	DECLARE medType VARCHAR(100);
    IF medName = "Ambien" THEN 
		SET medType = "Zolpidem"; 
	ELSEIF medName = "Accutane" THEN 
		SET medType = "Zolpidem"; 
    ELSEIF medName = "Paromycin Sulfate" THEN 
        SET medType = "Paromomycin";
    ELSEIF medName = "Skyla" THEN
        SET medType = "Levonorgestrel-releasing intrauterine system";
	END IF; 
    RETURN (medType);
END;

/* Testing the function for validity */ 
SELECT cost, encounterId, med, medicationType(med)
FROM synthea.medicalNotes;