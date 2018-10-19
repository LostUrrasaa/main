<?xml version="1.0" encoding="UTF-8"?>
<!--

    Unless explicitly acquired and licensed from Licensor under another license, the contents of
    this file are subject to the Reciprocal Public License ("RPL") Version 1.5, or subsequent
    versions as allowed by the RPL, and You may not copy or use this file in either source code
    or executable form, except in compliance with the terms and conditions of the RPL

    All software distributed under the RPL is provided strictly on an "AS IS" basis, WITHOUT
    WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, AND LICENSOR HEREBY DISCLAIMS ALL SUCH
    WARRANTIES, INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
    PARTICULAR PURPOSE, QUIET ENJOYMENT, OR NON-INFRINGEMENT. See the RPL for specific language
    governing rights and limitations under the RPL.

    http://opensource.org/licenses/RPL-1.5

    Copyright 2012-2017 Open Justice Broker Consortium

-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:iad="http://ojbc.org/IEPD/Extensions/InformationAccessDenial/1.0"
	xmlns:rls-res-doc="http://ojbc.org/IEPD/Exchange/RegulatoryLicenseSearchResults/1.0"
	xmlns:rls-res-ext="http://ojbc.org/IEPD/Extensions/RegulatoryLicenseSearchResults/1.0"
	xmlns:qrer="http://ojbc.org/IEPD/Extensions/SearchRequestErrorReporting/1.0"
	xmlns:qrm="http://ojbc.org/IEPD/Extensions/SearchResultsMetadata/1.0" xmlns:mbsc="http://www.sauper.com/MSBIOnlineServices"
	xmlns:j="http://release.niem.gov/niem/domains/jxdm/6.0/" xmlns:intel="http://release.niem.gov/niem/domains/intelligence/4.0/"
	xmlns:nc="http://release.niem.gov/niem/niem-core/4.0/" xmlns:niem-xs="http://release.niem.gov/niem/proxy/xsd/4.0/"
	xmlns:structures="http://release.niem.gov/niem/structures/4.0/" exclude-result-prefixes="#all">
	<xsl:import href="_formatters.xsl" />
	<xsl:output method="html" encoding="UTF-8" />
	<xsl:template match="/">
		<table class="detailsTable">
			<tr>
				<td colspan="8" class="detailsTitle"></td>
			</tr>
			<tr>
				<td class="padding0">
					<div id="warrants" style="overflow:auto; width:100%; height:auto">
						<xsl:apply-templates select="rls-res-doc:RegulatoryLicenseSearchResults" />
					</div>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="rls-res-doc:RegulatoryLicenseSearchResults">
		<xsl:choose>
			<xsl:when
				test="qrm:SearchResultsMetadata/qrer:SearchRequestError | qrm:SearchResultsMetadata/iad:InformationAccessDenial">
				<xsl:apply-templates select="qrm:SearchResultsMetadata/qrer:SearchRequestError" />
				<xsl:apply-templates select="qrm:SearchResultsMetadata/iad:InformationAccessDenial" />
			</xsl:when>
			<xsl:otherwise>
				<script type="text/javascript"> $(function () { $("#regulatoryLicensing").accordion({ heightStyle: "content", collapsible: true, activate:
					function( event, ui ) { var modalIframe = $("#modalIframe", parent.document);
					modalIframe.height(modalIframe.contents().find("body").height() + 16); } } ); }); 
				</script>
				<div id="regulatoryLicensing">
					<xsl:apply-templates select="rls-res-ext:RegulatoryLicenseSearchResult" />
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="rls-res-ext:RegulatoryLicenseSearchResult">
		<xsl:apply-templates select="rls-res-ext:RegulatoryLicense"></xsl:apply-templates>
		<xsl:apply-templates select="rls-res-ext:RegulatoryLicense" mode="licensee"></xsl:apply-templates>
		<xsl:apply-templates select="nc:Case"></xsl:apply-templates>
	</xsl:template>
	<xsl:template match="rls-res-ext:RegulatoryLicense">
		<h3>License Information</h3>
		<div>
			<table style="width:100%">
				<tr>
					<td class="detailsLabel">License Number</td>
					<td>
						<xsl:value-of select="rls-res-ext:RegulatoryLicenseIdentification/nc:IdentificationID" />
					</td>
					<td class="detailsLabel">First Issue Date</td>
					<td>
						<xsl:value-of
							select="rls-res-ext:RegulatoryLicenseFirstIssueDate/nc:Date" />
					</td>
				</tr>
				<tr>
					<td class="detailsLabel">License Type</td>
					<td>
						<xsl:value-of select="rls-res-ext:RegulatoryLicenseCategoryText" />
					</td>
					<td class="detailsLabel">Issue Date</td>
					<td>
						<xsl:value-of select="rls-res-ext:RegulatoryLicenseIssueDate/nc:Date"></xsl:value-of>
					</td>
				</tr>
				<tr>
					<td class="detailsLabel">Regulator</td>
					<td>
						<xsl:value-of select="rls-res-ext:RegulatoryLicenseRegulatorName" />
					</td>
					<td class="detailsLabel">Expiration Date</td>
					<td>
						<xsl:value-of select="rls-res-ext:RegulatoryLicenseExpirationDate/nc:Date" />
					</td>
				</tr>
				<tr>
				</tr>
				<tr>
					<td class="detailsLabel">Agency</td>
					<td>
						<xsl:value-of select="rls-res-ext:RegulatoryLicenseAgency/nc:OrganizationName" />
					</td>
					<td class="detailsLabel">License Status</td>
					<td>
						<xsl:value-of select="rls-res-ext:RegulatoryLicenseStatus/nc:StatusDescriptionText" />
					</td>
				</tr>
				<tr>
					<td class="detailsLabel">Department</td>
					<td>
						<xsl:value-of select="rls-res-ext:RegulatoryLicenseDepartmentName" />
					</td>
					<td class="detailsLabel">License Secondary Status</td>
					<td>
						<xsl:value-of select="rls-res-ext:RegulatoryLicenseStatus/rls-res-ext:SecondaryStatusDescriptionText" />
					</td>
				</tr>
			</table>
		</div>
	</xsl:template>
	<xsl:template match="rls-res-ext:RegulatoryLicense" mode="licensee">
		<xsl:param name="personID" select="rls-res-ext:RegulatoryLicensePerson/@structures:ref" />
		<h3>Licensee</h3>
		<div>
			<table style="width:100%">
				<tr>
					<td class="detailsLabel">Licensee ID</td>
					<td>
						<xsl:value-of select="rls-res-ext:PersonLicenseeID/nc:IdentificationID" />
					</td>
				</tr>
				<xsl:apply-templates select="../nc:Person[@structures:id = $personID]" mode="person"></xsl:apply-templates>
				<xsl:apply-templates select="../nc:Person[@structures:id = $personID]" mode="mailing_address"></xsl:apply-templates>
				<xsl:apply-templates
					select="../nc:Location[@structures:id = /rls-res-doc:RegulatoryLicenseSearchResults/rls-res-ext:RegulatoryLicenseSearchResult/nc:PersonResidenceAssociation[nc:Person/@structures:ref=$personID]/nc:Location/@structures:ref]"
					mode="residence_address"></xsl:apply-templates>
			</table>
		</div>
	</xsl:template>
	<xsl:template match="nc:Person" mode="person">
		<tr>
			<td class="detailsLabel">First Name</td>
			<td>
				<xsl:value-of select="nc:PersonName/nc:PersonGivenName" />
			</td>
		</tr>
		<tr>
			<td class="detailsLabel">Middle Name</td>
			<td>
				<xsl:value-of select="nc:PersonName/nc:PersonMiddleName" />
			</td>
		</tr>
		<tr>
			<td class="detailsLabel">Last Name</td>
			<td>
				<xsl:value-of select="nc:PersonName/nc:PersonSurName" />
			</td>
		</tr>
		<tr>
			<td class="detailsLabel">Name Suffix</td>
			<td>
				<xsl:value-of select="nc:PersonName/nc:PersonNameSuffixText" />
			</td>
		</tr>
		<tr>
			<td class="detailsLabel">Date Of Birth</td>
			<td>
				<xsl:value-of select="nc:PersonBirthDate/nc:Date" />
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="nc:Person" mode="mailing_address">
		<tr>
			<td class="detailsLabel">Mailing Address</td>
			<td>
				<xsl:apply-templates select="nc:PersonHomeContactInformation/nc:ContactMailingAddress" />
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="nc:Location" mode="residence_address">
		<tr>
			<td class="detailsLabel">Residence Address</td>
			<td>
				<xsl:apply-templates select="nc:Address" />
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="nc:Case">
		<h2>Case Information</h2>
		<div>
			<table style="width:100%">
				<tr>
					<td class="detailsLabel">Case ID</td>
					<td>
						<xsl:value-of select="nc:ActivityIdentification/nc:IdentificationID" />
					</td>
				</tr>
				<tr>
					<td class="detailsLabel">Date Opened</td>
					<td>
						<xsl:value-of select="nc:ActivityDate/nc:DateRange/nc:StartDate/nc:Date" />
					</td>
				</tr>
				<tr>
					<td class="detailsLabel">Date Closed</td>
					<td>
						<xsl:value-of select="nc:ActivityDate/nc:DateRange/nc:EndDate/nc:Date" />
					</td>
				</tr>
			</table>
		</div>
		<xsl:apply-templates select="rls-res-ext:CaseComplaint" />
	</xsl:template>
	<xsl:template match="rls-res-ext:CaseComplaint">
		<h3>Complaint</h3>
		<div>
			<table style="width:100%">
				<tr>
					<td class="detailsLabel">Resolution Date</td>
					<td>
						<xsl:value-of select="rls-res-ext:ComplaintResolution/rls-res-ext:ResolutionDate/nc:Date" />
					</td>
				</tr>
				<tr>
					<td class="detailsLabel">Resolution Description</td>
					<td>
						<xsl:value-of select="rls-res-ext:ComplaintResolution/rls-res-ext:ResolutionDescriptionText" />
					</td>
				</tr>
				<xsl:apply-templates select="rls-res-ext:ComplaintAllegation" />
				<xsl:apply-templates select="rls-res-ext:ComplaintAction" />
			</table>
		</div>
	</xsl:template>
	<xsl:template match="rls-res-ext:ComplaintAllegation">
		<tr>
			<td class="detailsLabel">Allegation Description</td>
			<td>
				<xsl:value-of select="rls-res-ext:AllegationDescriptionText" />
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="rls-res-ext:ComplaintAction">
		<tr>
			<td class="detailsLabel">Action Value</td>
			<td>
				<xsl:value-of select="rls-res-ext:ActionValueText" />
			</td>
			<td class="detailsLabel">Action Description</td>
			<td>
				<xsl:value-of select="rls-res-ext:ActionDescriptionText" />
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="nc:ContactMailingAddress | nc:Address">
		<xsl:value-of select="nc:LocationStreet/nc:StreetFullText"></xsl:value-of>
		<xsl:text> </xsl:text>
		<xsl:value-of select="nc:LocationCityName" />
		<xsl:text>, </xsl:text>
		<xsl:value-of select="nc:LocationState/nc:LocationStateUSPostalServiceCode" />
		<xsl:text> </xsl:text>
		<xsl:value-of select="nc:LocationPostalCode"></xsl:value-of>
		<xsl:text> </xsl:text>
		<xsl:value-of select="nc:LocationCountry/nc:LocationCountryName"></xsl:value-of>
	</xsl:template>
	<xsl:template match="qrer:SearchRequestError">
		<span class="error">
			Profession Regulatory License Search Result Error:
			<xsl:value-of select="qrer:ErrorText" />
		</span>
		<br />
	</xsl:template>
	<xsl:template match="iad:InformationAccessDenial">
		<span class="error">
			Access to System
			<xsl:value-of select="iad:InformationAccessDenyingSystemNameText" />
			Denied. Denied Reason:
			<xsl:value-of select="iad:InformationAccessDenialReasonText" />
		</span>
		<br />
	</xsl:template>
</xsl:stylesheet>