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
package org.ojbc.bundles.intermediaries.personhealthsearch.aggregator;

import java.util.List;

import org.apache.camel.Exchange;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

public class PersonHealthResponseAggregator {

	private Logger logger = Logger.getLogger(PersonHealthResponseAggregator.class);
	
	private static final String REQUEST_TIMER_MSG = "START_PERSON_HEALTH_TIMER";
	
	@SuppressWarnings("unchecked")
	public void prepareResponseExchange(Exchange groupedExchange){
		
		List<Exchange> groupExchList = groupedExchange.getProperty(Exchange.GROUPED_EXCHANGE, List.class);
		        					
		if(groupExchList.isEmpty() || groupExchList.size() != 2 
				|| groupedExchange.getProperty(Exchange.AGGREGATED_COMPLETED_BY).equals("timeout") ){
			
			logger.error("\n\n\n Missing an exchange, Stopping route. \n\n\n");
			
			groupedExchange.setProperty(Exchange.ROUTE_STOP, Boolean.TRUE);
			
			return;
		}
				
		Exchange exchange1 = groupExchList.get(0);
		Exchange exchange2 = groupExchList.get(1);
		
		Exchange timerExchange = null;
		Exchange messageExchange=null;
		
		if (exchange1.getIn().getBody().equals("START_PERSON_HEALTH_TIMER"))
		{
			timerExchange = exchange1;
			messageExchange = exchange2;
		}	

		if (exchange2.getIn().getBody().equals("START_PERSON_HEALTH_TIMER"))
		{
			messageExchange = exchange1;
			timerExchange = exchange2;
		}	

		
		
		String requestFileName = (String)timerExchange.getIn().getHeader("inboundFileName");
		
		if (StringUtils.isNotEmpty(requestFileName))
		{
			requestFileName = StringUtils.lowerCase(requestFileName);
			
			requestFileName = StringUtils.replace(requestFileName, "request", "response");
			
			groupedExchange.getIn().setHeader("CamelFileName", requestFileName);
		}	
		
		
		Exchange personHealthResponseExchange = messageExchange;
				
		groupedExchange.getIn().setBody(personHealthResponseExchange.getIn().getBody(String.class));
		
		// grouped exchange doesn't get message headers from 1st timer exchange so manually copy them
		groupedExchange.getIn().setHeader("federatedQueryRequestGUID", timerExchange.getIn().getHeader("federatedQueryRequestGUID"));
												
		groupedExchange.getIn().setHeader("operationName", personHealthResponseExchange.getIn().getHeader("operationName"));

		logger.info("\n\n\n Successfully prepared Person Health Response in group exchange \n\n\n");
	}
	
}
