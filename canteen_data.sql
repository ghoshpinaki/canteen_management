-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema canteen_data
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema canteen_data
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `canteen_data` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `canteen_data` ;

-- -----------------------------------------------------
-- Table `canteen_data`.`accounting_period`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `canteen_data`.`accounting_period` (
  `FINANCIAL_YEAR` VARCHAR(5) NOT NULL DEFAULT '',
  `START_DATE` DATE NULL DEFAULT NULL,
  `END_DATE` DATE NULL DEFAULT NULL,
  `STATUS` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`FINANCIAL_YEAR`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `canteen_data`.`company_master`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `canteen_data`.`company_master` (
  `COMPANY_CODE` VARCHAR(12) NOT NULL,
  `COMPANY_NAME` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`COMPANY_CODE`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `canteen_data`.`department_master`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `canteen_data`.`department_master` (
  `DEPARTMENT_CODE` VARCHAR(12) NOT NULL,
  `EMPLOYER_CODE` VARCHAR(12) NULL DEFAULT NULL,
  `DEPARTMENT_NAME` VARCHAR(100) NOT NULL,
  `AUTHORIZED_PERSON` VARCHAR(50) NOT NULL,
  `ADMINISTRATOR_NAME` VARCHAR(50) NOT NULL,
  `CONTACT_NO` VARCHAR(25) NULL DEFAULT NULL,
  `E_MAIL` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`DEPARTMENT_CODE`),
  UNIQUE INDEX `DMUK` USING BTREE (`EMPLOYER_CODE`, `DEPARTMENT_NAME`) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `canteen_data`.`employer_master`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `canteen_data`.`employer_master` (
  `EMPLOYER_CODE` VARCHAR(12) NOT NULL,
  `COMPANY_CODE` VARCHAR(12) NOT NULL,
  `VENDOR` CHAR(1) NOT NULL,
  `VENDOR_CODE` VARCHAR(15) NULL DEFAULT NULL,
  `EMPLOYER_NAME` VARCHAR(100) NOT NULL,
  `EMPLOYER_PREFIX` CHAR(2) NULL DEFAULT NULL,
  `CONTACT_PERSON` VARCHAR(100) NULL DEFAULT NULL,
  `CONTACT_NO` VARCHAR(20) NULL DEFAULT NULL,
  `E_MAIL` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY USING BTREE (`EMPLOYER_CODE`),
  INDEX `E1MFK` USING BTREE (`COMPANY_CODE`) VISIBLE,
  CONSTRAINT `E1MFK`
    FOREIGN KEY (`COMPANY_CODE`)
    REFERENCES `canteen_data`.`company_master` (`COMPANY_CODE`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `canteen_data`.`employee_master`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `canteen_data`.`employee_master` (
  `EMPLOYEE_CODE` VARCHAR(25) NOT NULL,
  `EMPLOYER_CODE` VARCHAR(12) NOT NULL,
  `EMPLOYEE_NAME` VARCHAR(100) NOT NULL,
  `DEPARTMENT_NAME` VARCHAR(100) NULL DEFAULT NULL,
  `UNIQUE_IDENTIFIER` VARCHAR(100) NULL DEFAULT NULL,
  `CONTACT_NO` VARCHAR(11) NULL DEFAULT NULL,
  `E_MAIL` VARCHAR(50) NULL DEFAULT NULL,
  `CURRENT_BALANCE` DECIMAL(10,2) NOT NULL,
  `ACTIVE` CHAR(1) NOT NULL,
  PRIMARY KEY (`EMPLOYEE_CODE`),
  INDEX `EMFK` USING BTREE (`EMPLOYER_CODE`) VISIBLE,
  CONSTRAINT `E2MFK`
    FOREIGN KEY (`EMPLOYER_CODE`)
    REFERENCES `canteen_data`.`employer_master` (`EMPLOYER_CODE`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `canteen_data`.`menu_master`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `canteen_data`.`menu_master` (
  `MENU_CODE` VARCHAR(12) NOT NULL,
  `MENU_NAME` VARCHAR(100) NOT NULL,
  `ACTIVE` CHAR(1) NOT NULL,
  PRIMARY KEY (`MENU_CODE`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `canteen_data`.`organization_master`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `canteen_data`.`organization_master` (
  `ORGANIZATION_CODE` VARCHAR(12) NOT NULL,
  `ORGANIZATION_NAME` VARCHAR(100) NOT NULL,
  `ORGANIZATION_PREFIX` CHAR(1) NOT NULL,
  `CONTACT_PERSON` VARCHAR(100) NULL DEFAULT NULL,
  `CONTACT_NO` VARCHAR(11) NULL DEFAULT NULL,
  `E_MAIL` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`ORGANIZATION_CODE`),
  UNIQUE INDEX `OMUK` (`ORGANIZATION_PREFIX` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `canteen_data`.`employee_booking`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `canteen_data`.`employee_booking` (
  `BOOKING_NO` BIGINT UNSIGNED NOT NULL,
  `EMPLOYEE_CODE` VARCHAR(25) NOT NULL,
  `ORGANIZATION_CODE` VARCHAR(12) NOT NULL,
  `MENU_CODE` VARCHAR(12) NOT NULL,
  `SHIFT_CODE` VARCHAR(12) NOT NULL,
  `WEEKDAY` CHAR(3) NOT NULL,
  `BOOKING_TYPE` VARCHAR(10) NULL DEFAULT NULL,
  `DEDUCT` CHAR(1) NULL DEFAULT NULL,
  `BOOKING_DATE` DATE NOT NULL,
  `BOOKING_TIME` DECIMAL(4,2) NOT NULL,
  `RATE` DECIMAL(5,2) NOT NULL,
  `QUANTITY` DECIMAL(5,2) NULL DEFAULT NULL,
  `AMOUNT` DECIMAL(8,2) NOT NULL,
  `CANCELLED` CHAR(1) NOT NULL,
  `CANCELLATION_DATE` DATE NULL DEFAULT NULL,
  `CANCELLATION_TIME` DECIMAL(4,2) NULL DEFAULT NULL,
  `EXECUTED` CHAR(1) NOT NULL,
  `REMARKS` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`BOOKING_NO`),
  UNIQUE INDEX `EBUK` (`EMPLOYEE_CODE` ASC, `MENU_CODE` ASC, `BOOKING_DATE` ASC, `BOOKING_TYPE` ASC) VISIBLE,
  INDEX `EBFK1` (`EMPLOYEE_CODE` ASC) VISIBLE,
  INDEX `EBFK2` (`MENU_CODE` ASC) VISIBLE,
  INDEX `EBFK3` (`ORGANIZATION_CODE` ASC) VISIBLE,
  CONSTRAINT `EBFK1`
    FOREIGN KEY (`EMPLOYEE_CODE`)
    REFERENCES `canteen_data`.`employee_master` (`EMPLOYEE_CODE`),
  CONSTRAINT `EBFK2`
    FOREIGN KEY (`MENU_CODE`)
    REFERENCES `canteen_data`.`menu_master` (`MENU_CODE`),
  CONSTRAINT `EBFK3`
    FOREIGN KEY (`ORGANIZATION_CODE`)
    REFERENCES `canteen_data`.`organization_master` (`ORGANIZATION_CODE`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `canteen_data`.`menu_detail`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `canteen_data`.`menu_detail` (
  `MENU_CODE` VARCHAR(12) NOT NULL,
  `SHIFT_CODE` VARCHAR(12) NOT NULL,
  `WEEKDAY` CHAR(3) NOT NULL,
  `START_DATE` DATE NOT NULL,
  `END_DATE` DATE NULL DEFAULT NULL,
  `BOOKING_START` DECIMAL(4,2) NULL DEFAULT NULL,
  `BOOKING_END` DECIMAL(4,2) NULL DEFAULT NULL,
  `CANCELLATION_START` DECIMAL(4,2) NULL DEFAULT NULL,
  `CANCELLATION_END` DECIMAL(4,2) NULL DEFAULT NULL,
  `SUBSIDIZED_RATE` DECIMAL(5,2) NOT NULL,
  `NORMAL_RATE` DECIMAL(5,2) NOT NULL,
  `NARRATION` VARCHAR(250) NULL DEFAULT NULL,
  `BOOKING_REQUIRED` CHAR(1) NULL DEFAULT NULL,
  `VALID` CHAR(1) NOT NULL,
  PRIMARY KEY USING BTREE (`MENU_CODE`, `SHIFT_CODE`, `WEEKDAY`, `START_DATE`),
  INDEX `MDFK2` (`SHIFT_CODE` ASC) VISIBLE,
  CONSTRAINT `MDFK`
    FOREIGN KEY (`MENU_CODE`)
    REFERENCES `canteen_data`.`menu_master` (`MENU_CODE`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `canteen_data`.`menu_transaction`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `canteen_data`.`menu_transaction` (
  `TRANSACTION_NO` BIGINT UNSIGNED NOT NULL,
  `EMPLOYEE_CODE` VARCHAR(25) NOT NULL,
  `ORGANIZATION_CODE` VARCHAR(12) NOT NULL,
  `TRANSACTION_DATE` DATE NOT NULL,
  `BOOKED` CHAR(1) NOT NULL,
  `BOOKING_NO` BIGINT UNSIGNED NULL DEFAULT NULL,
  `MENU_CODE` VARCHAR(12) NOT NULL,
  `SHIFT_CODE` VARCHAR(12) NOT NULL,
  `WEEKDAY` CHAR(3) NOT NULL,
  `USER_ID` VARCHAR(25) NOT NULL,
  `RATE` DECIMAL(5,2) NOT NULL,
  `QUANTITY` DECIMAL(5,2) NOT NULL,
  `AMOUNT` DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (`TRANSACTION_NO`),
  UNIQUE INDEX `MTUK2` (`EMPLOYEE_CODE` ASC, `TRANSACTION_DATE` ASC, `MENU_CODE` ASC, `SHIFT_CODE` ASC) VISIBLE,
  UNIQUE INDEX `MTUK1` USING BTREE (`BOOKING_NO`) VISIBLE,
  INDEX `MTFK2` USING BTREE (`BOOKING_NO`) VISIBLE,
  INDEX `MTFK3` USING BTREE (`MENU_CODE`) VISIBLE,
  INDEX `MTFK1` (`EMPLOYEE_CODE` ASC) VISIBLE,
  INDEX `MTFK4` (`USER_ID` ASC) VISIBLE,
  INDEX `MTFK5` (`ORGANIZATION_CODE` ASC) VISIBLE,
  CONSTRAINT `MTFK1`
    FOREIGN KEY (`EMPLOYEE_CODE`)
    REFERENCES `canteen_data`.`employee_master` (`EMPLOYEE_CODE`),
  CONSTRAINT `MTFK2`
    FOREIGN KEY (`BOOKING_NO`)
    REFERENCES `canteen_data`.`employee_booking` (`BOOKING_NO`),
  CONSTRAINT `MTFK3`
    FOREIGN KEY (`MENU_CODE`)
    REFERENCES `canteen_data`.`menu_master` (`MENU_CODE`),
  CONSTRAINT `MTFK5`
    FOREIGN KEY (`ORGANIZATION_CODE`)
    REFERENCES `canteen_data`.`organization_master` (`ORGANIZATION_CODE`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `canteen_data`.`non_employee_menu_transaction`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `canteen_data`.`non_employee_menu_transaction` (
  `TRANSACTION_NO` BIGINT UNSIGNED NOT NULL,
  `ORGANIZATION_CODE` VARCHAR(12) NOT NULL,
  `TRANSACTION_DATE` DATE NOT NULL,
  `NAME_OF_PAYEE` VARCHAR(100) NOT NULL,
  `EMPLOYER_NAME` VARCHAR(100) NOT NULL,
  `OTHER_EMPLOYER` VARCHAR(100) NOT NULL,
  `MENU_CODE` VARCHAR(12) NOT NULL,
  `SHIFT_CODE` VARCHAR(12) NOT NULL,
  `WEEKDAY` VARCHAR(12) NOT NULL,
  `MENU_NAME` VARCHAR(100) NOT NULL,
  `SALE_RATE` DECIMAL(5,2) NOT NULL,
  `SOLD_QUANTITY` DECIMAL(5,2) NOT NULL,
  `SALE_PRICE` DECIMAL(8,2) NOT NULL,
  `RECEIPT_MODE` VARCHAR(15) NOT NULL,
  `INSTRUMENT_NO` VARCHAR(20) NULL DEFAULT NULL,
  `INSTRUMENT_DATE` DATE NULL DEFAULT NULL,
  `BANK_NAME` VARCHAR(15) NULL DEFAULT NULL,
  `BRANCH` VARCHAR(20) NULL DEFAULT NULL,
  `BOOKING_TIME` VARCHAR(12) NOT NULL,
  PRIMARY KEY (`TRANSACTION_NO`),
  INDEX `NEMTFK2` (`MENU_CODE` ASC) VISIBLE,
  INDEX `NEMTFK1` (`ORGANIZATION_CODE` ASC) VISIBLE,
  CONSTRAINT `NEMTFK1`
    FOREIGN KEY (`ORGANIZATION_CODE`)
    REFERENCES `canteen_data`.`organization_master` (`ORGANIZATION_CODE`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `canteen_data`.`organization_wise_employee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `canteen_data`.`organization_wise_employee` (
  `EMPLOYEE_CODE` VARCHAR(25) NOT NULL,
  `ORGANIZATION_CODE` VARCHAR(12) NOT NULL,
  PRIMARY KEY (`EMPLOYEE_CODE`),
  INDEX `OWEFK2` (`ORGANIZATION_CODE` ASC) VISIBLE,
  CONSTRAINT `OWEFK1`
    FOREIGN KEY (`EMPLOYEE_CODE`)
    REFERENCES `canteen_data`.`employee_master` (`EMPLOYEE_CODE`),
  CONSTRAINT `OWEFK2`
    FOREIGN KEY (`ORGANIZATION_CODE`)
    REFERENCES `canteen_data`.`organization_master` (`ORGANIZATION_CODE`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `canteen_data`.`statutory_master`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `canteen_data`.`statutory_master` (
  `REGISTERED_USER` VARCHAR(100) NOT NULL,
  `GST_IN` VARCHAR(25) NOT NULL,
  `CGST_PORTION` DECIMAL(4,2) NOT NULL,
  `SGST_PORTION` DECIMAL(4,2) NOT NULL,
  `CONTACT_NO` VARCHAR(100) NULL DEFAULT NULL,
  `FOOD_LICENSE_NO` VARCHAR(100) NULL DEFAULT NULL,
  `FOOD_LICENSE_EXPIRY` DATE NULL DEFAULT NULL,
  `LABOUR_LICENSE_NO` VARCHAR(100) NULL DEFAULT NULL,
  `LABOUR_LICENSE_EXPIRY` DATE NULL DEFAULT NULL,
  `E_MAIL` VARCHAR(50) NULL DEFAULT NULL,
  `URL` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`REGISTERED_USER`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `canteen_data`.`user_master`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `canteen_data`.`user_master` (
  `USER_ID` VARCHAR(25) NOT NULL,
  `CREATED_BY` VARCHAR(25) NULL DEFAULT NULL,
  `USER_NAME` VARCHAR(50) NULL DEFAULT NULL,
  `USER_TYPE` VARCHAR(25) NOT NULL,
  `PASSWORD` VARCHAR(50) NOT NULL,
  `E_MAIL` VARCHAR(50) NULL DEFAULT NULL,
  `REGISTERING_IP` VARCHAR(20) NOT NULL,
  `REGISTRATION_DATE` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`USER_ID`),
  INDEX `UMFK` (`CREATED_BY` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `canteen_data`.`wallet_transaction`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `canteen_data`.`wallet_transaction` (
  `TRANSACTION_NO` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `EMPLOYEE_CODE` VARCHAR(25) NOT NULL,
  `ORGANIZATION_CODE` VARCHAR(12) NULL DEFAULT NULL,
  `TRANSACTION_DATE` DATETIME NOT NULL,
  `RECEIVED_AMOUNT` DECIMAL(10,2) NOT NULL,
  `RECEIPT_MODE` VARCHAR(15) NOT NULL,
  `INSTRUMENT_NO` VARCHAR(20) NULL DEFAULT NULL,
  `INSTRUMENT_DATE` DATE NULL DEFAULT NULL,
  `BANK_NAME` VARCHAR(15) NULL DEFAULT NULL,
  `BRANCH` VARCHAR(20) NULL DEFAULT NULL,
  `CREATED_BY` VARCHAR(25) NULL DEFAULT NULL,
  PRIMARY KEY (`TRANSACTION_NO`),
  INDEX `WTFK` (`EMPLOYEE_CODE` ASC) VISIBLE,
  INDEX `WTFK2` (`ORGANIZATION_CODE` ASC) VISIBLE,
  CONSTRAINT `WTFK1`
    FOREIGN KEY (`EMPLOYEE_CODE`)
    REFERENCES `canteen_data`.`employee_master` (`EMPLOYEE_CODE`),
  CONSTRAINT `WTFK2`
    FOREIGN KEY (`ORGANIZATION_CODE`)
    REFERENCES `canteen_data`.`organization_master` (`ORGANIZATION_CODE`))
ENGINE = InnoDB
AUTO_INCREMENT = 29551
DEFAULT CHARACTER SET = latin1;

USE `canteen_data` ;

-- -----------------------------------------------------
-- Placeholder table for view `canteen_data`.`employee_booking_view`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `canteen_data`.`employee_booking_view` (`BOOKING_NO` INT, `MENU_CODE` INT, `REMARKS` INT, `MENU_NAME` INT, `BOOKING_START` INT, `BOOKING_END` INT, `CANCELLATION_END` INT, `CANCELLATION_START` INT, `EMPLOYEE_CODE` INT, `EMPLOYEE_NAME` INT, `EMPLOYER_CODE` INT, `EMPLOYER_NAME` INT, `CURRENT_BALANCE` INT, `SHIFT_CODE` INT, `ORGANIZATION_CODE` INT, `WEEKDAY` INT, `BOOKING_TYPE` INT, `DEDUCT` INT, `BOOKING_DATE` INT, `BOOKING_TIME` INT, `RATE` INT, `QUANTITY` INT, `AMOUNT` INT, `CANCELLED` INT, `CANCELLATION_DATE` INT, `CANCELLATION_TIME` INT, `EXECUTED` INT);

-- -----------------------------------------------------
-- Placeholder table for view `canteen_data`.`employee_master_view`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `canteen_data`.`employee_master_view` (`EMPLOYEE_CODE` INT, `DEPARTMENT_NAME` INT, `EMPLOYEE_NAME` INT, `COMPANY_CODE` INT, `COMPANY_NAME` INT, `EMPLOYER_CODE` INT, `EMPLOYER_NAME` INT, `UNIQUE_IDENTIFIER` INT, `CONTACT_NO` INT, `E_MAIL` INT, `CURRENT_BALANCE` INT, `ACTIVE` INT);

-- -----------------------------------------------------
-- procedure MENU_DETAIL_INSERT_DELETE
-- -----------------------------------------------------

DELIMITER $$
USE `canteen_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `MENU_DETAIL_INSERT_DELETE`(
              IN MC VARCHAR(12),
			        IN SC VARCHAR(12),
              IN WD CHAR(3),
              IN SD DATE,
              IN BS DECIMAL(4,2),
              IN BE DECIMAL(4,2),
              IN CS DECIMAL(4,2),
              IN CE DECIMAL(4,2),
              IN SR DECIMAL(5,2),
              IN NR DECIMAL(5,2),
              IN NT VARCHAR(250),
              IN BR CHAR(1),
			        IN FLAG INTEGER(1)
              )
BEGIN
    DECLARE STARTDATE DATE;
    DECLARE ENDDATE DATE;

	  DECLARE WEEKDAY_ERROR CONDITION FOR SQLSTATE '99001';
    DECLARE BOOKING_START_END_ERROR CONDITION FOR SQLSTATE '99002';
    DECLARE CANCELLATION_START_END_ERROR CONDITION FOR SQLSTATE '99003';
    DECLARE BOOKING_CANCELLATION_ERROR CONDITION FOR SQLSTATE '99004';
    DECLARE BOOKING_REQUIRED_ERROR CONDITION FOR SQLSTATE '99005';
    DECLARE BOOKING_CANCELLATION_TIME_REQUIRED_ERROR CONDITION FOR SQLSTATE '99006';
    DECLARE BOOKING_CANCELLATION_TIME_NOT_REQUIRED_ERROR CONDITION FOR SQLSTATE '99007';

    DECLARE CONTINUE HANDLER FOR WEEKDAY_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Valid Values For Week Day Are:SUN,MON,TUE,WED,THU,FRI And SAT.';

    DECLARE CONTINUE HANDLER FOR BOOKING_START_END_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Booking End Time Should Be After Booking Start Time.';

    DECLARE CONTINUE HANDLER FOR CANCELLATION_START_END_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Cancellation End Time Should Be After Cancellation Start Time.';

    DECLARE CONTINUE HANDLER FOR BOOKING_CANCELLATION_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Cancellation Start Time Should Be After Booking Start Time.';

    DECLARE CONTINUE HANDLER FOR BOOKING_REQUIRED_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Valid Values For Booking Required Are Y And N.';

    DECLARE CONTINUE HANDLER FOR BOOKING_CANCELLATION_TIME_REQUIRED_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'If Booking Is Required Then Booking Start & End Time And Cancellation Start & End Time Is Must.';

    DECLARE CONTINUE HANDLER FOR BOOKING_CANCELLATION_TIME_NOT_REQUIRED_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'If Booking Is Not Required Then Booking Start & End Time And Cancellation Start & End Time Should Be Empty.';

    IF UPPER(WD) NOT IN ('SUN','MON','TUE','WED','THU','FRI','SAT') THEN
      SIGNAL WEEKDAY_ERROR;
    ELSEIF BE <= BS THEN
      SIGNAL BOOKING_START_END_ERROR;
    ELSEIF CE <= CS THEN
      SIGNAL CANCELLATION_START_END_ERROR;
    ELSEIF CS < BS THEN
      SIGNAL BOOKING_CANCELLATION_ERROR;
    ELSEIF UPPER(BR) NOT IN ('Y','N') THEN
      SIGNAL BOOKING_REQUIRED_ERROR;
    ELSEIF UPPER(BR) IN ('Y')  AND BS IS NULL THEN
      SIGNAL BOOKING_CANCELLATION_TIME_REQUIRED_ERROR;
    ELSEIF UPPER(BR) IN ('Y')  AND BE IS NULL THEN
      SIGNAL BOOKING_CANCELLATION_TIME_REQUIRED_ERROR;
    ELSEIF UPPER(BR) IN ('Y')  AND CS IS NULL THEN
      SIGNAL BOOKING_CANCELLATION_TIME_REQUIRED_ERROR;
    ELSEIF UPPER(BR) IN ('Y')  AND CE IS NULL THEN
      SIGNAL BOOKING_CANCELLATION_TIME_REQUIRED_ERROR;
     ELSEIF UPPER(BR) IN ('N')  AND BS IS NOT NULL THEN
      SIGNAL BOOKING_CANCELLATION_TIME_NOT_REQUIRED_ERROR;
    ELSEIF UPPER(BR) IN ('N')  AND BE IS NOT NULL THEN
      SIGNAL BOOKING_CANCELLATION_TIME_NOT_REQUIRED_ERROR;
    ELSEIF UPPER(BR) IN ('N')  AND CS IS NOT NULL THEN
      SIGNAL BOOKING_CANCELLATION_TIME_NOT_REQUIRED_ERROR;
    ELSEIF UPPER(BR) IN ('N')  AND CE IS NOT NULL THEN
      SIGNAL BOOKING_CANCELLATION_TIME_NOT_REQUIRED_ERROR;
    END IF;

  	IF FLAG = -1 THEN
      SELECT MAX(START_DATE) INTO STARTDATE
      FROM menu_detail
      WHERE MENU_CODE=MC AND SHIFT_CODE=SC AND WEEKDAY=UPPER(WD);

      INSERT INTO menu_detail
      VALUES(MC,SC,UPPER(WD),SD,NULL,BS,BE,CS,CE,SR,NR,NULL,UPPER(BR),'Y');

      IF STARTDATE IS NOT NULL THEN
        SELECT DATE_ADD(CURDATE(),INTERVAL -1 DAY) INTO ENDDATE;

        UPDATE menu_detail
        SET END_DATE=ENDDATE,NARRATION=NT,VALID='N'
        WHERE MENU_CODE=MC AND SHIFT_CODE=SC AND WEEKDAY=UPPER(WD) AND START_DATE=STARTDATE;
      END IF;
 	 END IF;

  	IF FLAG = 1 THEN
       DELETE FROM menu_detail WHERE MENU_CODE=MC AND SHIFT_CODE=SC AND WEEKDAY=UPPER(WD) AND START_DATE=SD;

       SELECT MAX(START_DATE) INTO STARTDATE
       FROM menu_detail
       WHERE MENU_CODE=MC AND SHIFT_CODE=SC AND WEEKDAY=UPPER(WD);

       IF STARTDATE IS NOT NULL THEN
        UPDATE menu_detail
        SET END_DATE=NULL,NARRATION=NULL,VALID='Y'
        WHERE MENU_CODE=MC AND SHIFT_CODE=SC AND WEEKDAY=UPPER(WD) AND START_DATE=STARTDATE;
      END IF;
  	END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure MENU_MASTER_INSUPDEL
-- -----------------------------------------------------

DELIMITER $$
USE `canteen_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `MENU_MASTER_INSUPDEL`(
              IN MC VARCHAR(12),
			        IN MN VARCHAR(100),
			        IN FLAG INTEGER(1)
              )
BEGIN
    DECLARE AV CHAR(1);
	  DECLARE EMPTY_ERROR CONDITION FOR SQLSTATE '99001';
    DECLARE INACTIVE_ERROR CONDITION FOR SQLSTATE '99002';

    DECLARE ACTIVE_ERROR CONDITION FOR SQLSTATE '99003';

    DECLARE CONTINUE HANDLER FOR EMPTY_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Menu Name Should Not Be Empty.';

    DECLARE CONTINUE HANDLER FOR INACTIVE_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'This Menu Is Inactive.';

    DECLARE CONTINUE HANDLER FOR ACTIVE_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'This Menu Is Active.';

    IF MN IN (' ','') THEN
      SIGNAL EMPTY_ERROR;
    END IF;

  	IF FLAG = -1 THEN
       INSERT INTO menu_master
       VALUES(MC,UPPER(MN),'Y');
 	 END IF;

  	IF FLAG = 0 THEN
      SELECT AV=ACTIVE
      FROM menu_master
      WHERE MENU_CODE=MC;

      IF UPPER(AV) IN ('N') THEN
         SIGNAL INACTIVE_ERROR;
      ELSE
		    UPDATE menu_master
		    SET MENU_NAME=UPPER(MN)
        WHERE MENU_CODE=MC;
      END IF;
  	END IF;

  	IF FLAG = 1 THEN
      SELECT AV=ACTIVE
      FROM menu_master
      WHERE MENU_CODE=MC;

      IF UPPER(AV) IN ('Y') THEN
         SIGNAL ACTIVE_ERROR;
      ELSE
        DELETE FROM menu_master WHERE MENU_CODE=MC;
      END IF;
  	END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure MENU_TRANSACTION_ADJUSTMENT
-- -----------------------------------------------------

DELIMITER $$
USE `canteen_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `MENU_TRANSACTION_ADJUSTMENT`(
      IN BD DATE,
      IN SC VARCHAR(12)
      )
BEGIN
  DECLARE BN BIGINT(20);
  DECLARE EC VARCHAR(25);
  DECLARE OC VARCHAR(12);
  DECLARE MC VARCHAR(12);
  DECLARE WD CHAR(3);
  DECLARE RT DECIMAL(8,2);
  DECLARE QT DECIMAL(8,2);
  DECLARE AT DECIMAL(8,2);

  DECLARE TN BIGINT(20);

  DECLARE DONE INT DEFAULT FALSE;

  DECLARE EMPLOYEE_BOOKING_CURSOR CURSOR FOR
	SELECT BOOKING_NO,EMPLOYEE_CODE,ORGANIZATION_CODE,MENU_CODE,WEEKDAY,RATE,QUANTITY,AMOUNT
  FROM employee_booking
  WHERE BOOKING_DATE=DATE(BD) AND SHIFT_CODE=UPPER(SC) AND CANCELLED IN ('N');

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET DONE = TRUE;

  OPEN EMPLOYEE_BOOKING_CURSOR;

  READ_LOOP:LOOP
    		FETCH EMPLOYEE_BOOKING_CURSOR
		    INTO BN,EC,OC,MC,WD,RT,QT,AT;

    		IF DONE THEN
      			LEAVE READ_LOOP;
		    END IF;

        SELECT GENERATE_PRIMARY_KEY('menu_transaction') INTO TN;

        INSERT INTO menu_transaction
        VALUES(TN,EC,OC,BD,'Y',BN,MC,SC,WD,'administrator',RT,QT,AT);
  END LOOP;

  CLOSE EMPLOYEE_BOOKING_CURSOR;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure MENU_TRANSACTION_INSERT_DELETE
-- -----------------------------------------------------

DELIMITER $$
USE `canteen_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `MENU_TRANSACTION_INSERT_DELETE`(
              IN TN BIGINT(20),
              IN EC VARCHAR(25),
              IN OC VARCHAR(12),
              IN TD DATE,
			        IN BD CHAR(1),
              IN BN BIGINT,
              IN MC VARCHAR(12),
				      IN SC VARCHAR(12),
              IN WD CHAR(3),
              IN UI VARCHAR(25),
              IN RT DECIMAL(5,2),
              IN QT DECIMAL(5,2),
              IN AM DECIMAL(8,2),
              IN RM VARCHAR(100),
			        IN FLAG INTEGER(1)
              )
BEGIN
    DECLARE TRANSACTIONNO BIGINT(20);
    DECLARE O VARCHAR(12);
    DECLARE C CHAR(1);
    DECLARE CB DECIMAL(8,2);

	  DECLARE TRANSACTION_DATE_ERROR CONDITION FOR SQLSTATE '99001';
    DECLARE BOOKED_VALUE_ERROR CONDITION FOR SQLSTATE '99002';
    DECLARE BOOKED_ERROR CONDITION FOR SQLSTATE '99003';
    DECLARE UNBOOKED_ERROR CONDITION FOR SQLSTATE '99004';
    DECLARE ORGANIZATION_CODE_ERROR CONDITION FOR SQLSTATE '99005';
    DECLARE CANCELLED_ERROR CONDITION FOR SQLSTATE '99006';
    DECLARE CURRENT_BALANCE_ERROR CONDITION FOR SQLSTATE '99007';

    DECLARE CONTINUE HANDLER FOR TRANSACTION_DATE_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Transaction Date Should Not Be After Current Date.';

    DECLARE CONTINUE HANDLER FOR BOOKED_VALUE_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Valid Values For Booked Are:Y And N.';

    DECLARE CONTINUE HANDLER FOR BOOKED_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'If Booked Is Y Then Booking No Should Not Be Empty.';

    DECLARE CONTINUE HANDLER FOR UNBOOKED_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'If Booked Is N Then Booking No Should Be Empty.';

    DECLARE CONTINUE HANDLER FOR ORGANIZATION_CODE_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'The Booking Has Been Made For Different Organization.';

    DECLARE CONTINUE HANDLER FOR CANCELLED_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'This Booking Has Been Cancelled.';

    DECLARE CONTINUE HANDLER FOR CURRENT_BALANCE_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Current Balance In Wallet Of This Employee Is Low.';

    IF DATE(TD) > DATE(NOW()) THEN
      SIGNAL TRANSACTION_DATE_ERROR;
    ELSEIF UPPER(BD) NOT IN ('Y','N') THEN
      SIGNAL BOOKED_VALUE_ERROR;
    ELSEIF UPPER(BD) IN ('Y') AND BN IS NULL THEN
      SIGNAL BOOKED_ERROR;
    ELSEIF UPPER(BD) IN ('N') AND BN IS NOT NULL THEN
      SIGNAL UNBOOKED_ERROR;
    END IF;

  	IF FLAG = -1 THEN
       IF UPPER(BD) IN ('Y') THEN
         SELECT ORGANIZATION_CODE,CANCELLED
         INTO O,C
         FROM employee_booking
         WHERE BOOKING_NO=BN;

         IF OC <> O THEN
           SIGNAL ORGANIZATION_CODE_ERROR;
         ELSEIF C IN ('Y') THEN
           SIGNAL CANCELLED_ERROR;
         ELSE
           SELECT GENERATE_PRIMARY_KEY('menu_transaction') INTO TRANSACTIONNO;

           INSERT INTO menu_transaction
           VALUES(TRANSACTIONNO,EC,OC,DATE(TD),UPPER(BD),BN,MC,UPPER(SC),UPPER(WD),UI,RT,QT,AM);

           UPDATE employee_booking
           SET EXECUTED='Y'
           WHERE BOOKING_NO=BN;
         END IF;
       ELSE
         SELECT CURRENT_BALANCE INTO CB
         FROM employee_master
         WHERE EMPLOYEE_CODE=EC;

         IF CB < AM THEN
            SIGNAL CURRENT_BALANCE_ERROR;
         ELSE
            SELECT GENERATE_PRIMARY_KEY('menu_transaction') INTO TRANSACTIONNO;

            INSERT INTO menu_transaction
            VALUES(TRANSACTIONNO,EC,OC,DATE(TD),UPPER(BD),BN,MC,UPPER(SC),UPPER(WD),UI,RT,QT,AM);

            UPDATE employee_master
            SET CURRENT_BALANCE = CURRENT_BALANCE - AM
            WHERE EMPLOYEE_CODE=EC;
         END IF;
      END IF;
 	 END IF;

  	IF FLAG = 1 THEN
       DELETE FROM menu_transaction WHERE TRANSACTION_NO=TN;

       IF UPPER(BD) IN ('Y') THEN
          UPDATE employee_booking
          SET EXECUTED='N',REMARKS=RM
          WHERE BOOKING_NO=BN;
       ELSE
          UPDATE employee_master
          SET CURRENT_BALANCE = CURRENT_BALANCE + AM
          WHERE EMPLOYEE_CODE=EC;
      END IF;
  	END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure NON_EMPLOYEE_MENU_TRANSACTION_INSUPDEL
-- -----------------------------------------------------

DELIMITER $$
USE `canteen_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `NON_EMPLOYEE_MENU_TRANSACTION_INSUPDEL`(
              IN TN BIGINT(20),
              IN OC VARCHAR(12),
			        IN TD DATE,
				      IN NP VARCHAR(100),
              IN EN VARCHAR(100),
              IN OE VARCHAR(100),
              IN MC VARCHAR(12),
              IN SC VARCHAR(12),
              IN WD VARCHAR(12),
              IN MN VARCHAR(100),
              IN SR DECIMAL(5,2),
              IN SQ DECIMAL(5,2),
              IN SP DECIMAL(8,2),
              IN RM VARCHAR(15),
              IN IO VARCHAR(20),
              IN ID VARCHAR(15),
              IN BN VARCHAR(15),
              IN BC VARCHAR(20),
              IN BT VARCHAR(12),
			        IN FLAG INTEGER(1)
              )
BEGIN
    DECLARE TRANSACTIONNO BIGINT(20);

	  DECLARE TRANSACTION_DATE_ERROR CONDITION FOR SQLSTATE '99001';
    DECLARE RECEIPT_MODE_ERROR CONDITION FOR SQLSTATE '99002';

    DECLARE CONTINUE HANDLER FOR TRANSACTION_DATE_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Transaction Date Should Not Be After Current Date.';

    DECLARE CONTINUE HANDLER FOR RECEIPT_MODE_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Valid Values For Receipt Mode Are:CASH,CHEQUE,DEMAND DRAFT,RTGS,NEFT,MONEY TRANSFER And ONLINE.';

    IF DATE(TD) > DATE(NOW()) THEN
      SIGNAL TRANSACTION_DATE_ERROR;
    ELSEIF UPPER(RM) NOT IN ('CASH','CHEQUE','DEMAND DRAFT','RTGS','NEFT','MONEY TRANSFER','ONLINE') THEN
      SIGNAL RECEIPT_MODE_ERROR;
    ELSE
  	    IF FLAG = -1 THEN
           SELECT GENERATE_PRIMARY_KEY('non_employee_menu_transaction') INTO TRANSACTIONNO;

           INSERT INTO non_employee_menu_transaction
           VALUES(TRANSACTIONNO,OC,TD,NP,EN,OE,MC,SC,WD,UPPER(MN),SR,SQ,SP,UPPER(RM),IO,ID,BN,BC,BT);
 	     END IF;

  	    IF FLAG = 0 THEN
          UPDATE non_employee_menu_transaction
		      SET ORGANIZATION_CODE=OC,TRANSACTION_DATE=TD,NAME_OF_PAYEE=NP,EMPLOYER_NAME=EN,OTHER_EMPLOYER=OE,SALE_RATE=SR,SOLD_QUANTITY=SQ,SALE_PRICE=SP,
          RECEIPT_MODE=UPPER(RM),INSTRUMENT_NO=IO,INSTRUMENT_DATE=ID,BANK_NAME=BN,BRANCH=BC
          WHERE TRANSACTION_NO=TN;
  	    END IF;

  	    IF FLAG = 1 THEN
          DELETE FROM non_employee_menu_transaction WHERE TRANSACTION_NO=TN;
  	    END IF;
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ORGANIZATION_MASTER_INSUPDEL
-- -----------------------------------------------------

DELIMITER $$
USE `canteen_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ORGANIZATION_MASTER_INSUPDEL`(
              IN OC VARCHAR(12),
			        IN OM VARCHAR(100),
				      IN OP CHAR(1),
              IN CP VARCHAR(100),
              IN CN VARCHAR(11),
              IN EM VARCHAR(50),
			        IN FLAG INTEGER(1)
              )
BEGIN
	  DECLARE EMPTY_ERROR CONDITION FOR SQLSTATE '99001';

    DECLARE CONTINUE HANDLER FOR EMPTY_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Organization Name And Organization Prefix Should Not Be Empty.';

    IF OM IN (' ','') OR OP IN (' ','') THEN
      SIGNAL EMPTY_ERROR;
    END IF;

  	IF FLAG = -1 THEN
       INSERT INTO organization_master
       VALUES(OC,UPPER(OM),UPPER(OP),UPPER(CP),CN,LOWER(EM));
 	 END IF;

  	IF FLAG = 0 THEN
		  UPDATE organization_master
		  SET ORGANIZATION_NAME=UPPER(OM),ORGANIZATION_PREFIX=UPPER(OP),CONTACT_PERSON=UPPER(CP),
      CONTACT_NO=CN,E_MAIL=LOWER(EM)
      WHERE ORGANIZATION_CODE=OC;
  	END IF;

  	IF FLAG = 1 THEN
       DELETE FROM organization_master WHERE ORGANIZATION_CODE=OC;
  	END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ORGANIZATION_WISE_EMPLOYEE_INUPDEL
-- -----------------------------------------------------

DELIMITER $$
USE `canteen_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ORGANIZATION_WISE_EMPLOYEE_INUPDEL`(
              IN EC VARCHAR(25),
              IN OC VARCHAR(12),
			        IN FLAG INTEGER(1)
              )
BEGIN
  	IF FLAG = -1 THEN
      INSERT INTO organization_wise_employee
      VALUES(EC,OC);
    END IF;

    IF FLAG = 0 THEN
      UPDATE organization_wise_employee
      SET ORGANIZATION_CODE=OC
      WHERE EMPLOYEE_CODE=EC;
    END IF;

  	IF FLAG = 1 THEN
      DELETE FROM organization_wise_employee WHERE EMPLOYEE_CODE=EC;
  	END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure STATUTORY_MASTER_INSUPDEL
-- -----------------------------------------------------

DELIMITER $$
USE `canteen_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `STATUTORY_MASTER_INSUPDEL`(
              IN RU VARCHAR(100),
			        IN GI VARCHAR(25),
				      IN CP DECIMAL(4,2),
              IN SP DECIMAL(4,2),
              IN CN VARCHAR(100),
              IN FLN VARCHAR(100),
              IN FLE DATE,
              IN LLN VARCHAR(100),
              IN LLE DATE,
              IN EM VARCHAR(50),
              IN UL VARCHAR(50),
			        IN FLAG INTEGER(1)
              )
BEGIN

    DECLARE COUNTER INTEGER(1);
	  DECLARE NO_OF_ROW_ERROR CONDITION FOR SQLSTATE '99001';

    DECLARE CONTINUE HANDLER FOR NO_OF_ROW_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'There Can Be only One Row In Statutory Detail.';

  	IF FLAG = -1 THEN
      SELECT COUNT(*) INTO COUNTER
      FROM statutory_master;

      IF COUNTER > 0 THEN
        SIGNAL NO_OF_ROW_ERROR;
      ELSE
        INSERT INTO statutory_master
        VALUES(UPPER(RU),GI,CP,SP,CN,FLN,FLE,LLN,LLE,LOWER(EM),LOWER(UL));
      END IF;
 	 END IF;

  	IF FLAG = 0 THEN
		  UPDATE statutory_master
		  SET REGISTERED_USER=RU,GST_IN=GI,CGST_PORTION=CP,SGST_PORTION=SP,CONTACT_NO=CN,
      FOOD_LICENSE_NO=FLN,FOOD_LICENSE_EXPIRY=FLE,LABOUR_LICENSE_NO=LLN,LABOUR_LICENSE_EXPIRY=LLE,
      E_MAIL=LOWER(EM),URL=LOWER(UL);
  	END IF;

  	IF FLAG = 1 THEN
     		DELETE FROM statutory_master;
  	END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure USER_MASTER_INSUPDEL
-- -----------------------------------------------------

DELIMITER $$
USE `canteen_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `USER_MASTER_INSUPDEL`(
      IN UI VARCHAR(25),
      IN CB VARCHAR(25),
			IN UN VARCHAR(50),
      IN UT VARCHAR(25),
			IN PW VARCHAR(50),
      IN EM VARCHAR(50),
			IN RI VARCHAR(20),
			IN RD VARCHAR(25),
			IN FLAG INTEGER(1)

			)
BEGIN
	  DECLARE DATE_ERROR CONDITION FOR SQLSTATE '99001';
    DECLARE EMPTY_ERROR CONDITION FOR SQLSTATE '99002';
    DECLARE USER_TYPE_ERROR CONDITION FOR SQLSTATE '99003';

	  DECLARE CONTINUE HANDLER FOR DATE_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Registration Date Should Not Be After Current Date.';

  	DECLARE CONTINUE HANDLER FOR EMPTY_ERROR
  	RESIGNAL SET MESSAGE_TEXT = 'User Name,User Type,Password And Registering IP.';

  	DECLARE CONTINUE HANDLER FOR USER_TYPE_ERROR
  	RESIGNAL SET MESSAGE_TEXT = 'Valid Values For User Type Are:ADMINISTRATOR,HOD,EMPLOYEE,GENERAL USER,CANTEEN,HAWKER,OTHER.';

  	IF UN IN (' ','') OR UT IN (' ','') OR PW IN (' ','') OR RI IN (' ','') THEN
		  SIGNAL EMPTY_ERROR;
	  ELSEIF UPPER(UT) NOT IN  ('ADMINISTRATOR','HOD','EMPLOYEE','GENERAL USER','CANTEEN ISWP','CANTEEN JEMCO','HAWKER','OTHERS') THEN
      SIGNAL USER_TYPE_ERROR;
  	ELSEIF DATE(RD) > DATE(CURDATE()) THEN

		  SIGNAL DATE_ERROR;
	  END IF;

	  IF FLAG = -1 THEN
		  INSERT INTO user_master
		  VALUES(UI,CB,UN,UPPER(UT),PW,LOWER(EM),RI,DATE(RD));
	  END IF;

	  IF FLAG = 0 THEN
		  UPDATE user_master
		  SET CREATED_BY=CB,USER_NAME=UN,USER_TYPE=UPPER(UT),PASSWORD=PW,E_MAIL=LOWER(EM),REGISTERING_IP=RI,
      REGISTRATION_DATE=DATE(RD)
		  WHERE USER_ID=UI;
	  END IF;

	  IF FLAG = 1 THEN
		  DELETE FROM user_master WHERE USER_ID=UI;
	  END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure WALLET_TRANSACTION_INSUPDEL
-- -----------------------------------------------------

DELIMITER $$
USE `canteen_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `WALLET_TRANSACTION_INSUPDEL`(
              IN TN BIGINT(20),
              IN EC VARCHAR(25),
              IN OC VARCHAR(12),
			        IN TD DATETIME,
				      IN RA DECIMAL(10,2),
              IN RM VARCHAR(15),
              IN IO VARCHAR(20),
              IN ID VARCHAR(15),
              IN BN VARCHAR(15),
              IN BC VARCHAR(20),
		IN CB VARCHAR(25),
			        IN FLAG INTEGER(1)
              )
BEGIN
    DECLARE TRANSACTIONNO BIGINT(20);
    DECLARE EMPLOYEECODE VARCHAR(25);
    DECLARE RECEIVEDAMOUNT DECIMAL(10,2);

	  DECLARE TRANSACTION_DATE_ERROR CONDITION FOR SQLSTATE '99001';
    DECLARE RECEIPT_MODE_ERROR CONDITION FOR SQLSTATE '99002';
    DECLARE UPDATE_ERROR CONDITION FOR SQLSTATE '99003';

    DECLARE CONTINUE HANDLER FOR TRANSACTION_DATE_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Transaction Date Should Not Be After Current Date.';

    DECLARE CONTINUE HANDLER FOR RECEIPT_MODE_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Valid Values For Receipt Mode Are:CASH,CHEQUE,DEMAND DRAFT,RTGS,NEFT,MONEY TRANSFER And ONLINE.';

    DECLARE CONTINUE HANDLER FOR UPDATE_ERROR
    RESIGNAL SET MESSAGE_TEXT = 'Employee Code Should Not Be Edited.';

    IF DATE(TD) > DATE(NOW()) THEN
      SIGNAL TRANSACTION_DATE_ERROR;
    ELSEIF UPPER(RM) NOT IN ('CASH','CHEQUE','DEMAND DRAFT','RTGS','NEFT','MONEY TRANSFER','ONLINE') THEN
      SIGNAL RECEIPT_MODE_ERROR;
    END IF;

  	IF FLAG = -1 THEN
       SELECT GENERATE_PRIMARY_KEY('walet_transaction') INTO TRANSACTIONNO;

       INSERT INTO wallet_transaction
       VALUES(TRANSACTIONNO,EC,OC,TD,RA,UPPER(RM),IO,ID,BN,BC,CB);

       UPDATE employee_master
       SET CURRENT_BALANCE = CURRENT_BALANCE + RA
       WHERE EMPLOYEE_CODE=EC;
 	 END IF;

  	IF FLAG = 0 THEN
      SELECT EMPLOYEE_CODE,RECEIVED_AMOUNT
      INTO EMPLOYEECODE,RECEIVEDAMOUNT
      FROM wallet_transaction
      WHERE TRANSACTION_NO=TN;

      IF EC <> EMPLOYEECODE THEN
        SIGNAL UPDATE_ERROR;
      ELSE
        UPDATE wallet_transaction
		    SET EMPLOYEE_CODE=EC,ORGANIZATION_CODE=OC,TRANSACTION_DATE=TD,RECEIVED_AMOUNT=RA,RECEIPT_MODE=UPPER(RM),INSTRUMENT_NO=IO,
        INSTRUMENT_DATE=ID,BANK_NAME=BN,BRANCH=BC,CREATED_BY=CB
        WHERE TRANSACTION_NO=TN;

        UPDATE employee_master
         SET CURRENT_BALANCE = CURRENT_BALANCE - RECEIVEDAMOUNT + RA
       WHERE EMPLOYEE_CODE=EC;
      END IF;
  	END IF;

  	IF FLAG = 1 THEN
       UPDATE employee_master
       SET CURRENT_BALANCE = CURRENT_BALANCE - RA
       WHERE EMPLOYEE_CODE=EC;

       DELETE FROM wallet_transaction WHERE TRANSACTION_NO=TN;
  	END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `canteen_data`.`employee_booking_view`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `canteen_data`.`employee_booking_view`;
USE `canteen_data`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`chiragsol`@`localhost` SQL SECURITY DEFINER VIEW `canteen_data`.`employee_booking_view` AS select `canteen_data`.`employee_booking`.`BOOKING_NO` AS `BOOKING_NO`,`canteen_data`.`employee_booking`.`MENU_CODE` AS `MENU_CODE`,`canteen_data`.`employee_booking`.`REMARKS` AS `REMARKS`,`canteen_data`.`menu_master`.`MENU_NAME` AS `MENU_NAME`,`canteen_data`.`menu_detail`.`BOOKING_START` AS `BOOKING_START`,`canteen_data`.`menu_detail`.`BOOKING_END` AS `BOOKING_END`,`canteen_data`.`menu_detail`.`CANCELLATION_END` AS `CANCELLATION_END`,`canteen_data`.`menu_detail`.`CANCELLATION_START` AS `CANCELLATION_START`,`canteen_data`.`employee_booking`.`EMPLOYEE_CODE` AS `EMPLOYEE_CODE`,`canteen_data`.`employee_master`.`EMPLOYEE_NAME` AS `EMPLOYEE_NAME`,`canteen_data`.`employee_master`.`EMPLOYER_CODE` AS `EMPLOYER_CODE`,`canteen_data`.`employer_master`.`EMPLOYER_NAME` AS `EMPLOYER_NAME`,`canteen_data`.`employee_master`.`CURRENT_BALANCE` AS `CURRENT_BALANCE`,`canteen_data`.`employee_booking`.`SHIFT_CODE` AS `SHIFT_CODE`,`canteen_data`.`employee_booking`.`ORGANIZATION_CODE` AS `ORGANIZATION_CODE`,`canteen_data`.`employee_booking`.`WEEKDAY` AS `WEEKDAY`,`canteen_data`.`employee_booking`.`BOOKING_TYPE` AS `BOOKING_TYPE`,`canteen_data`.`employee_booking`.`DEDUCT` AS `DEDUCT`,`canteen_data`.`employee_booking`.`BOOKING_DATE` AS `BOOKING_DATE`,`canteen_data`.`employee_booking`.`BOOKING_TIME` AS `BOOKING_TIME`,`canteen_data`.`employee_booking`.`RATE` AS `RATE`,`canteen_data`.`employee_booking`.`QUANTITY` AS `QUANTITY`,`canteen_data`.`employee_booking`.`AMOUNT` AS `AMOUNT`,`canteen_data`.`employee_booking`.`CANCELLED` AS `CANCELLED`,`canteen_data`.`employee_booking`.`CANCELLATION_DATE` AS `CANCELLATION_DATE`,`canteen_data`.`employee_booking`.`CANCELLATION_TIME` AS `CANCELLATION_TIME`,`canteen_data`.`employee_booking`.`EXECUTED` AS `EXECUTED` from ((((`canteen_data`.`employee_booking` join `canteen_data`.`employee_master`) join `canteen_data`.`employer_master`) join `canteen_data`.`menu_detail`) join `canteen_data`.`menu_master`) where ((`canteen_data`.`employee_master`.`EMPLOYEE_CODE` = `canteen_data`.`employee_booking`.`EMPLOYEE_CODE`) and (`canteen_data`.`employer_master`.`EMPLOYER_CODE` = `canteen_data`.`employee_master`.`EMPLOYER_CODE`) and (`canteen_data`.`menu_detail`.`MENU_CODE` = `canteen_data`.`employee_booking`.`MENU_CODE`) and (`canteen_data`.`menu_detail`.`SHIFT_CODE` = `canteen_data`.`employee_booking`.`SHIFT_CODE`) and (`canteen_data`.`menu_detail`.`WEEKDAY` = `canteen_data`.`employee_booking`.`WEEKDAY`) and ((`canteen_data`.`menu_detail`.`VALID` = 'Y') or (`canteen_data`.`menu_detail`.`VALID` = 'N')) and (`canteen_data`.`menu_master`.`MENU_CODE` = `canteen_data`.`menu_detail`.`MENU_CODE`));

-- -----------------------------------------------------
-- View `canteen_data`.`employee_master_view`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `canteen_data`.`employee_master_view`;
USE `canteen_data`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`chiragsol`@`localhost` SQL SECURITY DEFINER VIEW `canteen_data`.`employee_master_view` AS select `canteen_data`.`employee_master`.`EMPLOYEE_CODE` AS `EMPLOYEE_CODE`,`canteen_data`.`employee_master`.`DEPARTMENT_NAME` AS `DEPARTMENT_NAME`,`canteen_data`.`employee_master`.`EMPLOYEE_NAME` AS `EMPLOYEE_NAME`,`canteen_data`.`employer_master`.`COMPANY_CODE` AS `COMPANY_CODE`,`canteen_data`.`company_master`.`COMPANY_NAME` AS `COMPANY_NAME`,`canteen_data`.`employee_master`.`EMPLOYER_CODE` AS `EMPLOYER_CODE`,`canteen_data`.`employer_master`.`EMPLOYER_NAME` AS `EMPLOYER_NAME`,`canteen_data`.`employee_master`.`UNIQUE_IDENTIFIER` AS `UNIQUE_IDENTIFIER`,`canteen_data`.`employee_master`.`CONTACT_NO` AS `CONTACT_NO`,`canteen_data`.`employee_master`.`E_MAIL` AS `E_MAIL`,`canteen_data`.`employee_master`.`CURRENT_BALANCE` AS `CURRENT_BALANCE`,`canteen_data`.`employee_master`.`ACTIVE` AS `ACTIVE` from ((`canteen_data`.`employee_master` join `canteen_data`.`employer_master`) join `canteen_data`.`company_master`) where ((`canteen_data`.`employer_master`.`EMPLOYER_CODE` = `canteen_data`.`employee_master`.`EMPLOYER_CODE`) and (`canteen_data`.`company_master`.`COMPANY_CODE` = `canteen_data`.`employer_master`.`COMPANY_CODE`));

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
