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
/*This is the default test data loaded into h2 when this is deployed */
use warrant_repository;

INSERT INTO WARRANT(WARRANTID, StateWarrantRepositoryID, DATEOFWARRANT, DATEOFEXPIRATION, BROADCASTAREA, WARRANTENTRYTYPE, COURTAGENCYORI, LAWENFORCEMENTORI, COURTDOCKETNUMBER, OCACOMPLAINTNUMBER, OPERATOR, PACCCODE, ORIGINALOFFENSECODE, OFFENSECODE, GENERALOFFENSECHARACTER, CRIMINALTRACKINGNUMBER, EXTRADITE, EXTRADITIONLIMITS, PICKUPLIMITS, BONDAMOUNT, WARRANTSTATUS, WARRANTSTATUSTIMESTAMP, WARRANTMODREQUESTSENT, WARRANTMODRESPONSERECEIVED) VALUES
(1, 'PE45678', DATE '2015-08-13', DATE '2016-08-13', 'B26', '6', '659056746', '12345678', 'Docket8987', 'A123456', 'ID45656768', 'PCC45678', '3577', '5678', 'D', 'PW56', TRUE, 'M', '5', '5000', 'Accepted', NULL, FALSE, FALSE);

INSERT INTO WARRANTREMARKS(WARRANTREMARKSID, WARRANTID, WARRANTREMARKTEXT) VALUES
(1, 1, 'CASH ONLY BOND');

INSERT INTO PERSON(PERSONID, FIRSTNAME, MIDDLENAME, LASTNAME, NAMESUFFIX, FULLPERSONNAME, ADDRESSFULLTEXT, AddressStreetName, AddressStreetNumber, ADDRESSCITY, ADDRESSSTATE, ADDRESSZIP, SOCIALSECURITYNUMBERBASE, DATEOFBIRTH, PLACEOFBIRTH, PERSONAGE, OPERATORLICENSENUMBERBASE, OPERATORLICENSESTATEBASE, PERSONETHNICITYDESCRIPTION, PERSONEYECOLORDESCRIPTION, PERSONHAIRCOLORDESCRIPTION, PERSONSEXDESCRIPTION, PERSONRACEDESCRIPTION, PERSONSKINTONEDESCRIPTION, PERSONHEIGHT, PERSONWEIGHT, PERSONSCARSMARKSTATTOSBASE, PERSONCITIZENSHIPCOUNTRY, USCITIZENSHIPINDICATOR, PERSONIMMIGRATIONALIENQUERYIND, PERSONSTATEIDENTIFICATION, FBIIDENTIFICATIONNUMBER, MISCELLANEOUSIDBASE, PRISONRECORDNUMBER, PERSONCAUTIONDESCRIPTION) VALUES
(1, 'Peter', 'J', 'Jones', 'Jr', 'Peter J Jones Jr', '123 TEST DRIVE', 'TEST DRIVE', '123', 'Detroit', 'MI', '96733', '098213455', DATE '1967-08-13', 'CA', '49', 'DL0983456', 'MI', 'N', 'BLK', 'ONG', 'M', 'W', 'ALB', '71', '165', '259', 'AO', TRUE, FALSE, 'SID56567', '354786908', 'PS-123456', 'PN3929593', 'G4');

INSERT INTO VEHICLE(VEHICLEID, PERSONID, LICENSEPLATETYPE, VEHICLELICENSEPLATEEXPIRATIOND, VEHICLENONEXPIRINGINDICATOR, VEHICLELICENSEPLATENUMBER, VEHICLELICENSESTATECODE, VEHICLEIDENTIFICATIONNUMBER, VEHICLEYEAR, VEHICLEMODEL, VEHICLEMAKE, VEHICLEPRIMARYCOLOR, VEHICLESECONDARYCOLOR, VEHICLESTYLE) VALUES
(1, 1, 'LP', '2016-11', NULL, 'LP4365-023', NULL, 'VIN3458745679777', '2012', 'DIA', 'AAA', 'BGE', 'BRO', '2D'),
(2, 1, 'WI', NULL, TRUE, '555ABC', 'MI', 'VIN124', '2010', 'FSN', 'FRD', 'RED', 'PINK', 'SN');

INSERT INTO PERSONIDADDITIONAL(PERSONIDADDITIONALID, PERSONID, PERSONADDITIONALID) VALUES
(1, 1, 'MISC1234');

INSERT INTO PERSONSMTADDITIONAL(PERSONSMTSUPPLEMENTALID, PERSONID, PERSONSCARSMARKSTATTOOS) VALUES
(1, 1, 'SMT');

INSERT INTO PERSONOLNADDITIONAL(PERSONOLNID, PERSONID, OPERATORLICENSENUMBER, OPERATORLICENSESTATE) VALUES
(1, 1, 'LI12335', 'MI');

INSERT INTO PERSONSSNADDITIONAL(PERSONSSNID, PERSONID, SOCIALSECURITYNUMBER) VALUES
(1, 1, '999999999');

INSERT INTO PERSONALTERNATENAME(PERSONALTERNATENAMEID, PERSONID, FIRSTNAME, FULLPERSONNAME, LASTNAME, MIDDLENAME, NAMESUFFIX) VALUES
(1, 1, 'Pete', 'Pete K Johnson Jr', 'Johnson', 'K', 'Jr');

INSERT INTO CHARGEREF(CHARGEREFID, PERSONID, REPORTINGAGENCYORI, CASEAGENCYCOMPLAINTNUMBER, TRANSACTIONCONTROLNUMBER, REPORTINGAGENCYNAME) VALUES
(1, 1, '12345678', 'A123457', '12345', 'Incident Agency');

INSERT INTO CHARGE(CHARGEID, CHARGEREFID, CHARGESEVERITYLEVEL) VALUES
(1, 1, 'Felony'),
(2, 1, 'SEV2');

INSERT INTO WARRANTCHARGEREF(WARRANTCHARGEREFID, WARRANTID, CHARGEREFID) VALUES
(1, 1, 1);

INSERT INTO OFFICER(OFFICERID, CHARGEREFID, OFFICERNAME, OFFICERBADGENUMBER) VALUES
(1, 1, 'Joe Law Enforcement', '123');