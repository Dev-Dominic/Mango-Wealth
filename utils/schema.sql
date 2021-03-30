/**
  * MangoWealth Database Schema
  */

/* ################### CREATING DATABASE  ########################## */

DROP DATABASE IF EXISTS mangowealth;
CREATE DATABASE mangowealth;
USE mangowealth;

/* ################### CREATING TABLES  ########################### */

CREATE TABLE Users(
    id INT AUTO_INCREMENT NOT NULL,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    age TINYINT(100) NOT NULL,
    email VARCHAR(256) NOT NULL,
    password_hash VARCHAR(256) NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE UserFinancialsRecords(
    id INT NOT NULL AUTO_INCREMENT,
    income INT NOT NULL,
    expenses INT NOT NULL,
    risk_profile TINYINT(100) NOT NULL,
    recordDate DATE NOT NULL DEFAULT NOW(),
    userId INT NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(userId) REFERENCES Users(id) ON DELETE CASCADE
);

CREATE TABLE FinancialInstitutions(
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(256) NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE UserFinancialInstitutions(
    userId INT NOT NULL,
    institutionId INT NOT NULL,
    PRIMARY KEY(userId, institutionId),
    FOREIGN KEY(userId) REFERENCES Users(id) ON DELETE CASCADE,
    FOREIGN KEY(institutionId) REFERENCES FinancialInstitutions(id) ON DELETE CASCADE
);

CREATE TABLE ProductType(
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(256) NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE FinancialProducts(
    id INT NOT NULL AUTO_INCREMENT,
    product_name VARCHAR(256) NOT NULL,
    description TEXT NOT NULL,
    minimum_deposit INT NOT NULL DEFAULT 0,
    risk_profile TINYINT(100) NOT NULL,
    interest_rate DOUBLE NOT NULL,
    productTypeId INT NOT NULL,
    institutionId INT NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(productTypeId) REFERENCES ProductType(id) ON UPDATE CASCADE,
    FOREIGN KEY(institutionId) REFERENCES FinancialInstitutions(id) ON UPDATE CASCADE
);

CREATE TABLE Fees(
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(256) NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE FinancialProductsFees(
    financialProductId INT NOT NULL,
    feesId INT NOT NULL,
    PRIMARY KEY(financialProductId, feesId),
    FOREIGN KEY(financialProductId) REFERENCES FinancialProducts(id) ON DELETE CASCADE,
    FOREIGN KEY(feesId) REFERENCES Fees(id) ON DELETE CASCADE
);

CREATE TABLE Recommendations(
    userId INT NOT NULL,
    financialProductId INT NOT NULL,
    recommendationDate DATE NOT NULL DEFAULT NOW(),
    PRIMARY KEY(userId, financialProductId),
    FOREIGN KEY(userId) REFERENCES Users(id) ON DELETE CASCADE,
    FOREIGN KEY(financialProductId) REFERENCES FinancialProducts(id) ON DELETE CASCADE
);

/* ################ INSERTING DEFAULT VALUE INTO TABLES  ################### */

-- Inserting basic Financial Product Types
INSERT INTO ProductType(name) VALUES("SAVINGS");
INSERT INTO ProductType(name) VALUES("INVESTMENTS");
INSERT INTO ProductType(name) VALUES("LOANS");

/* ######### STORED PROCEDURE FOR CREATING VECTOR OBJECTS  ################# */

