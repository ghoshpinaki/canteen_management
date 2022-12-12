ALTER TABLE `cms_data`.`user_master` DROP FOREIGN KEY `UMFK`;
ALTER TABLE `cms_data`.`user_master` DROP INDEX `UMFK`;

ALTER TABLE `cms_data`.`user_master` MODIFY COLUMN `USER_ID` VARCHAR(25) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL;