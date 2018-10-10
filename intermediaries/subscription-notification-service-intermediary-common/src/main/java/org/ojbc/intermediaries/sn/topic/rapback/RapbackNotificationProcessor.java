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
 * Copyright 2012-2017 Open Justice Broker Consortium
 */
package org.ojbc.intermediaries.sn.topic.rapback;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.apache.camel.Exchange;
import org.apache.camel.Message;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.ojbc.intermediaries.sn.SubscriptionNotificationConstants;
import org.ojbc.intermediaries.sn.dao.SubscriptionSearchQueryDAO;
import org.ojbc.intermediaries.sn.notification.EmailNotification;
import org.ojbc.intermediaries.sn.notification.NotificationProcessor;
import org.ojbc.intermediaries.sn.notification.NotificationRequest;
import org.ojbc.intermediaries.sn.topic.arrest.ArrestNotificationRequest;
import org.ojbc.intermediaries.sn.util.SubjectIdentifierUtils;
import org.ojbc.util.model.rapback.Subscription;
import org.ojbc.util.xml.XmlUtils;
import org.w3c.dom.Document;

public class RapbackNotificationProcessor extends NotificationProcessor {
	
	List<String> activeSubjectIdentifiers= new ArrayList<>(Arrays.asList(SubscriptionNotificationConstants.SID));
	
	List<List<String>> alternateConfiguredSubjectIdentifiers;
	
	private SubscriptionSearchQueryDAO subscriptionSearchQueryDAO;
	
	private String civilNotificationDefaultEmailAddress="administrator@local.gov";
	
	private static final Log log = LogFactory.getLog( ArrestNotificationRequest.class );
	
	@Override
	protected NotificationRequest makeNotificationRequestFromIncomingMessage(Message msg) throws Exception{
		
		RapbackNotificationRequest rapbackNotificationRequest = new RapbackNotificationRequest(msg); 
		
		Map<String, String> allowedSubjectIdentifiers = rapbackNotificationRequest.getSubjectIdentifiers();

		Map<String, String> finalSubjectIdentifiers = SubjectIdentifierUtils.returnFinalSubjectIdentifiers(allowedSubjectIdentifiers, activeSubjectIdentifiers);	
		rapbackNotificationRequest.setSubjectIdentifiers(finalSubjectIdentifiers);
		
		if (alternateConfiguredSubjectIdentifiers != null)
		{
			for (List<String> alternateConfiguredSubjectIdentifier : alternateConfiguredSubjectIdentifiers)
			{
				Map<String, String> finalAlternateSubjectIdentifiers = SubjectIdentifierUtils.returnFinalSubjectIdentifiers(allowedSubjectIdentifiers, alternateConfiguredSubjectIdentifier);
				rapbackNotificationRequest.getAlternateSubjectIdentifiers().add(finalAlternateSubjectIdentifiers);
			}	
		}	
		
		return rapbackNotificationRequest;
	}

	public List<EmailNotification> findRapbackSubscriptionForNotification(Exchange exchange) throws Exception {
		
		Document notificationMessage = exchange.getIn().getBody(Document.class);
		
		String fbiRelatedSubscriptionID = XmlUtils.xPathStringSearch(notificationMessage, "/b-2:Notify/b-2:NotificationMessage/b-2:Message/notfm-exch:NotificationMessage/notfm-ext:NotifyingFederalCriminalHistoryUpdate/notfm-ext:RelatedFBISubscription/notfm-ext:RecordRapBackSubscriptionIdentification/nc:IdentificationID");
		log.debug("FBI related subscription ID");
		
		List<Subscription> subscriptions = new ArrayList<Subscription>();
		
		//Get subscription here
		Subscription subscription = subscriptionSearchQueryDAO.findSubscriptionByFbiSubscriptionId(fbiRelatedSubscriptionID);
		
		if (subscription == null)
		{
			throw new IllegalStateException("Unable to find FBI subscription for FBI related subscription ID: " + fbiRelatedSubscriptionID);
		}	
		
		log.debug("Matched rapback subscription: " + subscription);
		
		subscriptions.add(subscription);
		
		NotificationRequest request = makeNotificationRequestFromIncomingMessage(exchange.getIn());
		
		List<EmailNotification> emailNotifications = createUniqueNotifications(subscriptions, request);
		
		for (EmailNotification emailNotification : emailNotifications)
		{
			String subscriptionCategoryCode = subscription.getSubscriptionCategoryCode();
			String subscriptionId = subscription.getSubscriptionIdentifier();

			if (subscriptionCategoryCode.equals("F") || subscriptionCategoryCode.equals("J") || subscriptionCategoryCode.equals("I") || subscriptionCategoryCode.equals("S"))
			{	

				emailNotification.removeAllToEmailAddresses();
				
				
				List<String> emailAddressesToAdd = new ArrayList<String>();
				
	            emailAddressesToAdd = subscriptionSearchQueryDAO.returnAgencyProfileEmailForSubscription(subscriptionId, subscriptionCategoryCode);
	
	            if (emailAddressesToAdd.size() == 0)
	            {
	            	log.error("No email addresses for found for subscription ID: " + subscriptionId + ", and category: " + subscriptionCategoryCode +", using default email address: " + civilNotificationDefaultEmailAddress);
	            	emailAddressesToAdd.add(civilNotificationDefaultEmailAddress);
	            }	
	            
	            for (String emailAddress : emailAddressesToAdd)
	            {
	            	emailNotification.addToAddressee(emailAddress);
	            }	
			}	
		}
		
		log.info("Email notifications: " + emailNotifications);
		
		return emailNotifications;
		
	}
	
	public List<String> getActiveSubjectIdentifiers() {
		return activeSubjectIdentifiers;
	}

	public void setActiveSubjectIdentifiers(List<String> activeSubjectIdentifiers) {
		this.activeSubjectIdentifiers = activeSubjectIdentifiers;
	}

	public List<List<String>> getAlternateConfiguredSubjectIdentifiers() {
		return alternateConfiguredSubjectIdentifiers;
	}

	public void setAlternateConfiguredSubjectIdentifiers(
			List<List<String>> alternateConfiguredSubjectIdentifiers) {
		this.alternateConfiguredSubjectIdentifiers = alternateConfiguredSubjectIdentifiers;
	}

	public SubscriptionSearchQueryDAO getSubscriptionSearchQueryDAO() {
		return subscriptionSearchQueryDAO;
	}

	public void setSubscriptionSearchQueryDAO(
			SubscriptionSearchQueryDAO subscriptionSearchQueryDAO) {
		this.subscriptionSearchQueryDAO = subscriptionSearchQueryDAO;
	}

	public String getCivilNotificationDefaultEmailAddress() {
		return civilNotificationDefaultEmailAddress;
	}

	public void setCivilNotificationDefaultEmailAddress(
			String civilNotificationDefaultEmailAddress) {
		this.civilNotificationDefaultEmailAddress = civilNotificationDefaultEmailAddress;
	}
	
}
