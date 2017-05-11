/*
 * Unless explicitly acquired and licensed from Licensor under another license, the contents of
 * this file are subject to the Reciprocal Public License ("RPL") Version 1.5, or subsequent
 * versions as allowed by the RPL, and You may not copy or use this file in either source code
 * or executable form, except in compliance with the terms and conditions of the RPL
 *
 * All software distributed under the RPL is provided strictly on an "AS IS" basis, WITHOUT
 * WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, AND LICENSOR HEREBY DISCLAIMS ALL SUCH
 * WARRANTIES, INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 * PARTICULAR PURPOSE, QUIET ENJOYMENT, OR NON-INFRINGEMENT. See the RPL for specific language
 * governing rights and limitations under the RPL.
 *
 * http://opensource.org/licenses/RPL-1.5
 *
 * Copyright 2012-2015 Open Justice Broker Consortium
 */

DROP SCHEMA if EXISTS consent_management;

CREATE SCHEMA consent_management;



CREATE TABLE consent_decision_type (
                ConsentDecisionTypeID IDENTITY NOT NULL,
                ConsentDecisionDescription VARCHAR(25) NOT NULL,
                CONSTRAINT ConsentDecisionTypeID PRIMARY KEY (ConsentDecisionTypeID)
);

CREATE TABLE consent (
                ConsentID IDENTITY NOT NULL,
                BookingNumber VARCHAR(20) NOT NULL,
                NameNumber VARCHAR(20) NOT NULL,
                PersonName VARCHAR(250) NOT NULL,
                PersonGender VARCHAR(20) NOT NULL,
                PersonDOB DATE,
                ConsenterUserID VARCHAR(20),
                ConsentDocumentControlNumber VARCHAR(20),
                RecordCreationTimestamp TIMESTAMP NOT NULL,
                ConsentDecisionTimestamp TIMESTAMP,
                CONSTRAINT ConsentID PRIMARY KEY (ConsentID)
);

CREATE TABLE consent_decision (
                ConsentDecisionID IDENTITY NOT NULL,
                ConsentDecisionTypeID INTEGER NOT NULL,
                ConsentID INTEGER NOT NULL,
                CONSTRAINT ConsentDecisionID PRIMARY KEY (ConsentDecisionID)
);

ALTER TABLE consent_decision ADD CONSTRAINT Consent_Decision_Type_fk
FOREIGN KEY (ConsentDecisionTypeID)
REFERENCES consent_decision_type (ConsentDecisionTypeID)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE consent_decision ADD CONSTRAINT Consent_Decision_fk
FOREIGN KEY (ConsentID)
REFERENCES consent (ConsentID)
ON DELETE CASCADE
ON UPDATE CASCADE;