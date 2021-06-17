-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema guest_traffic
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema guest_traffic
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `guest_traffic` DEFAULT CHARACTER SET utf8 ;
USE `guest_traffic` ;

-- -----------------------------------------------------
-- Table `guest_traffic`.`mobile_carriers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `guest_traffic`.`mobile_carriers` (
  `mobile_carriers_id` INT NOT NULL,
  `mobile_carrier_name` VARCHAR(50) NOT NULL,
  `mobile_carrier_networkIP` INT NOT NULL,
  PRIMARY KEY (`mobile_carriers_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `guest_traffic`.`device`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `guest_traffic`.`device` (
  `device_id` INT NOT NULL AUTO_INCREMENT,
  `device_IP` INT NOT NULL,
  `signal_created` TIMESTAMP(6) NOT NULL,
  `lost_signal` TIMESTAMP(6) NOT NULL,
  `mobile_carrier_id` INT NOT NULL,
  PRIMARY KEY (`device_id`),
  INDEX `mobile_carrier_idx` (`mobile_carrier_id` ASC) VISIBLE,
  CONSTRAINT `mobile_carrier`
    FOREIGN KEY (`mobile_carrier_id`)
    REFERENCES `guest_traffic`.`mobile_carriers` (`mobile_carriers_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `guest_traffic`.`event_priority`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `guest_traffic`.`event_priority` (
  `event_priority_id` INT NOT NULL AUTO_INCREMENT,
  `event_priority_name` VARCHAR(45) NOT NULL,
  `max_delay_seconds` INT NOT NULL,
  PRIMARY KEY (`event_priority_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `guest_traffic`.`user_role`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `guest_traffic`.`user_role` (
  `user_role_id` INT NOT NULL,
  `user_role_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`user_role_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `guest_traffic`.`core_users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `guest_traffic`.`core_users` (
  `user_id` INT NOT NULL,
  `user_role_id` INT NOT NULL,
  `firstName` VARCHAR(50) NOT NULL,
  `lastName` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`user_id`),
  INDEX `user_role_idx` (`user_role_id` ASC) VISIBLE,
  CONSTRAINT `user_role`
    FOREIGN KEY (`user_role_id`)
    REFERENCES `guest_traffic`.`user_role` (`user_role_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `guest_traffic`.`notification_event`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `guest_traffic`.`notification_event` (
  `event_id` INT NOT NULL AUTO_INCREMENT,
  `event_name` VARCHAR(50) NOT NULL,
  `event_subject` VARCHAR(50) NOT NULL,
  `event_text` TEXT(150) NOT NULL,
  `event_created` TIMESTAMP(6) NOT NULL,
  `event_updated` TIMESTAMP(6) NOT NULL,
  `event_deleted` TIMESTAMP(6) NOT NULL,
  `event_priority_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`event_id`),
  INDEX `event_priority_idx` (`event_priority_id` ASC) VISIBLE,
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `event_priority`
    FOREIGN KEY (`event_priority_id`)
    REFERENCES `guest_traffic`.`event_priority` (`event_priority_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_notification_event_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `guest_traffic`.`core_users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `guest_traffic`.`reports`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `guest_traffic`.`reports` (
  `report_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `report_title` VARCHAR(50) NOT NULL,
  `report_time` TIMESTAMP(6) NOT NULL,
  `device_id` INT NOT NULL,
  PRIMARY KEY (`report_id`),
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  INDEX `device_id_idx` (`device_id` ASC) VISIBLE,
  CONSTRAINT `fk_reports_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `guest_traffic`.`core_users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_reports_device_id`
    FOREIGN KEY (`device_id`)
    REFERENCES `guest_traffic`.`device` (`device_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `guest_traffic`.`tracking_hub`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `guest_traffic`.`tracking_hub` (
  `hub_id` INT NOT NULL,
  `device_id` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`hub_id`),
  INDEX `device_id_idx` (`device_id` ASC) VISIBLE,
  CONSTRAINT `fk_tracking_hub_device_id`
    FOREIGN KEY (`device_id`)
    REFERENCES `guest_traffic`.`device` (`device_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
