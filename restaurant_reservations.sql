CREATE DATABASE  IF NOT EXISTS `restaurant_reservations`;
USE `restaurant_reservations`;

CREATE TABLE `customers` (
  `customerId` int NOT NULL AUTO_INCREMENT,
  `customerName` varchar(45) NOT NULL,
  `contactInfo` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`customerId`)
);

INSERT INTO `customers` VALUES (1,'El Alfa','apple@gmail.com'),(2,'Bad Bunny','orange@gmail.com'),(3,'Pit Bull','grape@gmail.com'),(4,'Aaron Judge','peach@gmail.com'),(5,'Leo Messi','tomato@gmail.com'),(6,'Bryan Coca','bcoca@gmail.com');


CREATE TABLE `diningpreferences` (
  `preferenceId` int NOT NULL AUTO_INCREMENT,
  `customerId` int DEFAULT NULL,
  `favoriteTable` varchar(45) DEFAULT NULL,
  `dietaryRestrictions` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`preferenceId`),
  KEY `customerId` (`customerId`),
  CONSTRAINT `diningpreferences_ibfk_1` FOREIGN KEY (`customerId`) REFERENCES `customers` (`customerId`)
);


INSERT INTO `diningpreferences` VALUES (1,1,'Table 5','None'),(2,2,'Table 9','Allergic to shrimp'),(3,3,'Table 20','Vegan'),(4,4,'Table 15','Accesible'),(5,5,'Table 1','Keto');


CREATE TABLE `reservations` (
  `reservationId` int NOT NULL AUTO_INCREMENT,
  `customerId` int DEFAULT NULL,
  `reservationTime` datetime NOT NULL,
  `numberOfGuests` int NOT NULL,
  `specialRequests` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`reservationId`),
  KEY `customerId` (`customerId`),
  CONSTRAINT `reservations_ibfk_1` FOREIGN KEY (`customerId`) REFERENCES `customers` (`customerId`)
);

INSERT INTO `reservations` VALUES (1,1,'2024-07-05 14:20:00',2,'It\'s my birthday'),(2,2,'2024-08-02 10:30:00',4,'Last minute'),(3,3,'2024-08-25 16:55:00',3,'Birthday'),(4,4,'2024-07-25 23:15:00',5,'Window Seat'),(5,5,'2024-09-08 19:05:00',2,'Extra Sauce'),(6,6,'2024-06-28 14:30:00',5,'Fruits');




DELIMITER //

CREATE DEFINER=`root`@`localhost` PROCEDURE `findReservations`(IN customerIdx INT)
BEGIN
    SELECT * FROM reservations WHERE customerId = customerIdx;
END//

CREATE DEFINER=`root`@`localhost` PROCEDURE `addSpecialRequest`(IN reservationIdx INT, IN requestsx VARCHAR(200))
BEGIN
    UPDATE reservations SET specialRequests = requestsx WHERE reservationId = reservationIdx;
END//

CREATE DEFINER=`root`@`localhost` PROCEDURE `addReservation`(
    IN customerNamex VARCHAR(45),
    IN contactInfox VARCHAR(200),
    IN reservationTimex DATETIME,
    IN numberOfGuestsx INT,
    IN specialRequestsx VARCHAR(200)
)
BEGIN
    DECLARE customerId INT;
   
    -- Check if customer already exists
    SELECT customerId INTO customerId FROM customers
    WHERE customerName = customerNamex AND contactInfo = contactInfox;
   
    -- If customer does not exist, create a new one
    IF customerId IS NULL THEN
        INSERT INTO customers (customerName, contactInfo) VALUES (customerNamex, contactInfox);
        SET customerId = LAST_INSERT_ID();
    END IF;
   
    -- Add reservation
    INSERT INTO reservations (customerId, reservationTime, numberOfGuests, specialRequests) VALUES
    (customerId, reservationTimex, numberOfGuestsx, specialRequestsx);
END//

DELIMITER ;