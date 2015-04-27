<!---
Filename: eventbrite.cfc
Creation Date: 11/March/2010
Original Author: Matt Gifford aka coldfumonkeh
Revision: $Rev$
$LastChangedBy$
$LastChangedDate$
Description:
the core eventBriteAPI facade object
--->
<cfcomponent name="eventbrite" output="false">
	
	<cfset variables.instance = structNew() />
	
	<cffunction name="init" access="public" output="false" returntype="Any" hint="I am the constructor method for the eventbrite class.">
		<cfargument name="applicationKey" 	required="true" 	type="string" 						hint="I am the application key." />
		<cfargument name="emailAddress"		required="true" 	type="string" 						hint="I am the email address associated with the Eventbrite account." />
		<cfargument name="password"			required="true" 	type="string" 						hint="I am the password associated with the Eventbrite account." /> 
		<cfargument name="userKey"			required="true"		type="string" 						hint="I am the user key, associated with the specific user." />
		<cfargument name="authLevel"		required="false"	type="string" 	default="Secure" 	hint="The level of authentication used against the API. Secure or Basic." />
		<cfargument name="parseResults"		required="false" 	type="boolean"	default="false" 	hint="A boolean value to determine if the output data is parsed or returned as a string." />
			<cfscript>
            	setUserAccess(
						applicationKey=arguments.applicationKey,
						emailAddress=arguments.emailAddress,
						password=arguments.password,
						userKey=arguments.userKey,
						authLevel=arguments.authLevel);
				setObjectFactory();
				setParseResults(arguments.parseResults);
            </cfscript>
		<cfreturn this />
	</cffunction>
	
	<!--- MUTATORS --->
	<cffunction name="setUserAccess" access="private" output="false" returntype="void" hint="I set the userAccess class into the variables.instance scope.">
		<cfargument name="applicationKey" 	required="true" 	type="string" hint="I am the application key." />
		<cfargument name="emailAddress"		required="true" 	type="string" hint="I am the email address associated with the Eventbrite account." />
		<cfargument name="password"			required="true" 	type="string" hint="I am the password associated with the Eventbrite account." /> 
		<cfargument name="userKey"			required="true"		type="string" hint="I am the user key, associated with the specific user." />
		<cfargument name="authLevel"		required="true"		type="string" hint="The level of authentication used against the API. Secure or Basic." />
		<cfset variables.instance.userAccess = createObject('component','userAccess').init(argumentCollection=arguments) />
	</cffunction>
	
	<cffunction name="setObjectFactory" access="private" output="false" returntype="void" hint="I set the objectFactory class into the variables.instance scope.">
		<cfset variables.instance.objectFactory = createObject('component','objectFactory').init(userAccess=getUserAccess()) />
	</cffunction>
	
	<cffunction name="setParseResults" access="private" output="false" returntype="void" hint="I set the parseResults value into the variables.instance scope.">
		<cfargument name="parseResults"	required="true" type="boolean" hint="A boolean value to determine if the output data is parsed or returned as a string." />
		<cfset variables.instance.parseResults = arguments.parseResults />
	</cffunction>
	
	<!--- ACCESSORS --->
	<cffunction name="getUserAccess" access="private" output="false" returntype="Any" hint="I return the userAccess class.">
		<cfreturn variables.instance.userAccess />
	</cffunction>
	
	<cffunction name="getObjectFactory" access="private" output="false" returntype="Any" hint="I return the objectFactory class.">
		<cfreturn variables.instance.objectFactory />
	</cffunction>
	
	<cffunction name="getParseResults" access="private" output="false" returntype="Boolean" hint="I return the parseResults value from the variables.instance scope.">
		<cfreturn variables.instance.parseResults />
	</cffunction>
	
	<!--- PUBLIC METHODS --->
	
	<!--- DISCOUNT RELATED METHODS --->
	<cffunction name="newDiscount" access="public" output="false" returntype="Any" hint="This method creates a new discount code. It returns the ID of the newly created discount code.">
		<cfargument name="event_id" 			required="true" 	type="numeric" 				hint="The event ID. The event must have been previously created using newEvent." />
		<cfargument name="code"					required="true" 	type="string" 				hint="The discount code. Spaces, apostrophes and non-alphanumeric characters are not allowed, except for dashes and underscores. Examples: 'earlybirdspecial_08', 'membersonly', 'dc121232'." />
		<cfargument name="amount_off"			required="true"		type="string" 	default=""	hint="The fixed amount off the ticket price. Each discount code can have a fixed discount amount or a variable (percentage) discount amount, but not both." />
		<cfargument name="percent_off"			required="false"	type="string"	default="" 	hint="The percentage off the ticket price. Each discount code can have a fixed discount amount or a variable (percentage) discount amount, but not both." />
		<cfargument name="tickets"				required="false" 	type="string" 				hint="Comma-separated list of ticket IDs for which the discount applies. If not provided, the discount will apply to all ticket types." />
		<cfargument name="quantity_available"	required="false" 	type="string" 				hint="Maximum number of times this discount can be used. If not provided, no maximum is set." />
		<cfargument name="start_date"			required="false" 	type="string" 				hint="The discount start date and time, in ISO 8601 format (e.g., '2007-12-31 23:59:59')." />
		<cfargument name="end_date"				required="false" 	type="string" 				hint="The discount end date and time, in ISO 8601 format (e.g., '2007-12-31 23:59:59'). " />
		<cfreturn handleReturn(getObjectFactory().load('Discounts').newDiscount(argumentCollection=arguments)) />
	</cffunction>
	
	<cffunction name="updateDiscount" access="public" output="false" returntype="Any" hint="This method update an existing discount code. Only the fields passed as arguments will be modified. This method returns the ID of the modified discount code.">
		<cfargument name="id" 					required="true" 	type="numeric" 	hint="The discount ID to update." />
		<cfargument name="code"					required="true" 	type="string" 	hint="The discount code. Spaces, apostrophes and non-alphanumeric characters are not allowed, except for dashes and underscores. Examples: 'earlybirdspecial_08', 'membersonly', 'dc121232'." />
		<cfargument name="amount_off"			required="true"		type="string" 	hint="The fixed amount off the ticket price. Each discount code can have a fixed discount amount or a variable (percentage) discount amount, but not both." />
		<cfargument name="percent_off"			required="false"	type="string"	hint="The percentage off the ticket price. Each discount code can have a fixed discount amount or a variable (percentage) discount amount, but not both." />
		<cfargument name="tickets"				required="false" 	type="string" 	hint="Comma-separated list of ticket IDs for which the discount applies. If not provided, the discount will apply to all ticket types." />
		<cfargument name="quantity_available"	required="false" 	type="string" 	hint="Maximum number of times this discount can be used. If not provided, no maximum is set." />
		<cfargument name="start_date"			required="false" 	type="string" 	hint="The discount start date and time, in ISO 8601 format (e.g., '2007-12-31 23:59:59')." />
		<cfargument name="end_date"				required="false" 	type="string" 	hint="The discount end date and time, in ISO 8601 format (e.g., '2007-12-31 23:59:59'). " />
		<cfreturn handleReturn(getObjectFactory().load('Discounts').updateDiscount(argumentCollection=arguments)) />
	</cffunction>
	<!--- END DISCOUNT RELATED METHODS --->
	
	<!--- EVENT RELATED METHODS --->
	<cffunction name="eventSearch" access="public" output="false" returntype="Any" hint="I look for events by keyword. Only public events are listed.">
		<cfargument name="keywords" 		required="false" type="string"			 		hint="The search keywords." />
		<cfargument name="category" 		required="false" type="string"			 		hint="Event categories (comma seperated): conference, conventions, entertainment, fundraisers, meetings, other, performances, reunions, sales, seminars, social, sports, tradeshows, travel, religion, fairs, food, music, recreation." />
		<cfargument name="address" 			required="false" type="string"			 		hint="The venue address." />
		<cfargument name="city" 			required="false" type="string"			 		hint="The venue city." />
		<cfargument name="region" 			required="false" type="string"			 		hint="The venue state/province/county/territory depending on the country. 2-letter state code is required for US addresses." />
		<cfargument name="postal_code" 		required="false" type="string"			 		hint="The postal/zip code of the venue." />
		<cfargument name="country" 			required="false" type="string"			 		hint="2-letter country code, according to the ISO 3166 format." />
		<cfargument name="within" 			required="false" type="string"			 		hint="If 'within' is set and the 'city' or 'zipcode' resolve to a specific geolocation, the search will be restricted to the specified within radius. The sorting default will be set to 'distance'." />
		<cfargument name="within_unit" 		required="false" type="string"			 		hint="If within is set, you can specify the unit to use: 'M' for miles, or 'K' for kilometers. By default, the API will use miles." />
		<cfargument name="latitude" 		required="false" type="string"			 		hint="If 'within' is set you can limit your search to wgs84 coordinates (latitude, longitude)." />
		<cfargument name="longitude" 		required="false" type="string"			 		hint="If 'within' is set you can limit your search to wgs84 coordinates (latitude, longitude)." />
		<cfargument name="date"				required="false" type="string"					hint="The event start date. Limit the list of results to a date range, specified by a label or by exact dates. Currently supported labels include: 'All', 'Future', 'Past', 'Today', 'Yesterday', 'Last Week', 'This Week', 'Next week', 'This Month', 'Next Month' and months by name, e.g. 'October'. Exact date ranges take the form 'YYYY-MM-DD YYYY-MM-DD', e.g. '2008-04-25 2008-04-27'." />
		<cfargument name="date_created"		required="false" type="string"					hint="The date range the event was created, specified by a label or by exact dates. Currently supported labels include: 'Today', 'Yesterday', 'Last Week', 'This Week', 'This Month'. Exact date ranges take the form 'YYYY-MM-DD YYYY-MM-DD', e.g. '2008-04-25 2008-04-27'." />
		<cfargument name="date_modified"	required="false" type="string"					hint="The date the event was last modified, specified by a label or by exact dates. Currently supported labels include: 'Today', 'Yesterday', 'Last Week', 'This Week', 'This Month'. Exact date ranges take the form 'YYYY-MM-DD YYYY-MM-DD', e.g. '2008-04-25 2008-04-27'." />
		<cfargument name="organizer" 		required="false" type="string"			 		hint="The organizer name." />
		<cfargument name="max" 				required="false" type="numeric" default="10" 	hint="Limit the number of events returned. Maximum limit is 100 events per page. Default is 10." />
		<cfargument name="count_only" 		required="false" type="boolean" default="false" hint="Only return the total number of events ('true' or 'false'). Default is 'false'." />
		<cfargument name="sort_by" 			required="false" type="string" 	default="date" 	hint="Sort the list of events by 'id', 'date', 'name', 'city'. The default is 'date'." />
		<cfargument name="page" 			required="false" type="numeric" default="1" 	hint="Allows for paging through the results of a query. Default is 1." />
		<cfargument name="since_id" 		required="false" type="numeric" default="1" 	hint="Returns events with id greater than 'since_id' value. Default is 1." />
		<cfargument name="tracking_link" 	required="false" type="string" 					hint="The tracking link code to add to the event URLs." />
		<cfreturn handleReturn(getObjectFactory().load('Events').eventSearch(argumentCollection=arguments)) />
	</cffunction>
	
	<cffunction name="getEvent" access="public" output="false" returntype="Any" hint="This method returns the data for a given event. Only public events are viewable if no authentication is passed.">
		<cfargument name="id" required="true" type="numeric" default="" hint="The ID of the requested event." />
		<cfreturn handleReturn(getObjectFactory().load('Events').getEvent(argumentCollection=arguments)) />
	</cffunction>
	
	<cffunction name="newEvent" access="public" output="false" returntype="Any" hint="This method creates a new event. It returns the ID of the newly created event.">
		<cfargument name="title" 						required="true" type="string" 					hint="The event title." />
		<cfargument name="description" 					required="false" type="string"			 		hint="The event description." />
		<cfargument name="start_date" 					required="false" type="string" 					hint="The event start date and time, in ISO 8601 format (e.g., '2007-12-31 23:59:59')." />
		<cfargument name="end_date" 					required="false" type="string" 					hint="The event end date and time, in ISO 8601 format (e.g., '2007-12-31 23:59:59')." />
		<cfargument name="timezone" 					required="false" type="string"					hint="The event time zone in relation to GMT (e.g., 'GMT+01', 'GMT+02', 'GMT-01')." />
		<cfargument name="privacy" 						required="false" type="numeric" default="1" 	hint="0 for a private event, 1 for a public event. If not provided, will default to 1." />
		<cfargument name="personalized_url" 			required="false" type="string" 					hint="The event registration URL. If you pass 'testevent', the event will be accessible at 'http://testevent.eventbrite.com'." />
		<cfargument name="venue_id"						required="false" type="numeric" 				hint="The event venue ID." />
		<cfargument name="organizer_id"					required="false" type="numeric" 				hint="The event organizer ID." />
		<cfargument name="capacity"						required="false" type="numeric" 				hint="The maximum number of people who can attend the event." />
		<cfargument name="currency"						required="false" type="string" 					hint="The event currency in ISO 4217 format (e.g., 'USD', 'EUR')." />
		<cfargument name="status"						required="false" type="string" default="draft" 	hint="The event status. Allowed values are 'draft', 'live' for new events. If not provided, status will be 'draft', meaning that the event registration page will not be available publicly." />
		<cfargument name="custom_header"				required="false" type="string" 					hint="Custom HTML header for your registration page." />
		<cfargument name="custom_footer"				required="false" type="string" 					hint="Custom HTML footer for your registration page." />
		<cfargument name="background_color"				required="false" type="string" 					hint="Custom hexadecimal color for your registration page. Format: FFFFFF without the pound." />
		<cfargument name="text_color"					required="false" type="string" 					hint="Custom hexadecimal color for your registration page. Format: FFFFFF without the pound." />
		<cfargument name="link_color"					required="false" type="string" 					hint="Custom hexadecimal color for your registration page. Format: FFFFFF without the pound." />
		<cfargument name="title_text_color"				required="false" type="string" 					hint="Custom hexadecimal color for your registration page. Format: FFFFFF without the pound." />
		<cfargument name="box_background_color"			required="false" type="string" 					hint="Custom hexadecimal color for your registration page. Format: FFFFFF without the pound." />
		<cfargument name="box_text_color"				required="false" type="string" 					hint="Custom hexadecimal color for your registration page. Format: FFFFFF without the pound." />
		<cfargument name="box_border_color"				required="false" type="string" 					hint="Custom hexadecimal color for your registration page. Format: FFFFFF without the pound." />
		<cfargument name="box_header_background_color"	required="false" type="string" 					hint="Custom hexadecimal color for your registration page. Format: FFFFFF without the pound." />
		<cfargument name="box_header_text_color"		required="false" type="string" 					hint="Custom hexadecimal color for your registration page. Format: FFFFFF without the pound." />
		<cfreturn handleReturn(getObjectFactory().load('Events').newEvent(argumentCollection=arguments)) />
	</cffunction>
	
	<cffunction name="updateEvent" access="public" output="false" returntype="Any" hint="This method updates an existing event. Only the fields passed as arguments will be modified. This method returns the ID of the modified event.">
		<cfargument name="event_id" 					required="true"  type="numeric" 	hint="The ID of the event to update." />
		<cfargument name="title" 						required="false" type="string" 		hint="The event title." />
		<cfargument name="description" 					required="false" type="string"		hint="The event description." />
		<cfargument name="start_date" 					required="false" type="string" 		hint="The event start date and time, in ISO 8601 format (e.g., '2007-12-31 23:59:59')." />
		<cfargument name="end_date" 					required="false" type="string"		hint="The event end date and time, in ISO 8601 format (e.g., '2007-12-31 23:59:59')." />
		<cfargument name="timezone" 					required="false" type="string"		hint="The event time zone in relation to GMT (e.g., 'GMT+01', 'GMT+02', 'GMT-01')." />
		<cfargument name="privacy" 						required="false" type="numeric"		hint="0 for a private event, 1 for a public event. If not provided, will default to 1." />
		<cfargument name="personalized_url" 			required="false" type="string" 		hint="The event registration URL. If you pass 'testevent', the event will be accessible at 'http://testevent.eventbrite.com'." />
		<cfargument name="venue_id"						required="false" type="numeric" 	hint="The event venue ID." />
		<cfargument name="organizer_id"					required="false" type="numeric" 	hint="The event organizer ID." />
		<cfargument name="capacity"						required="false" type="numeric" 	hint="The maximum number of people who can attend the event." />
		<cfargument name="currency"						required="false" type="string" 		hint="The event currency in ISO 4217 format (e.g., 'USD', 'EUR')." />
		<cfargument name="status"						required="false" type="string"		hint="The event status. Allowed values are 'draft', 'live' for new events. If not provided, status will be 'draft', meaning that the event registration page will not be available publicly." />
		<cfargument name="custom_header"				required="false" type="string" 		hint="Custom HTML header for your registration page." />
		<cfargument name="custom_footer"				required="false" type="string" 		hint="Custom HTML footer for your registration page." />
		<cfargument name="background_color"				required="false" type="string" 		hint="Custom hexadecimal color for your registration page. Format: FFFFFF without the pound." />
		<cfargument name="text_color"					required="false" type="string" 		hint="Custom hexadecimal color for your registration page. Format: FFFFFF without the pound." />
		<cfargument name="link_color"					required="false" type="string" 		hint="Custom hexadecimal color for your registration page. Format: FFFFFF without the pound." />
		<cfargument name="title_text_color"				required="false" type="string" 		hint="Custom hexadecimal color for your registration page. Format: FFFFFF without the pound." />
		<cfargument name="box_background_color"			required="false" type="string" 		hint="Custom hexadecimal color for your registration page. Format: FFFFFF without the pound." />
		<cfargument name="box_text_color"				required="false" type="string" 		hint="Custom hexadecimal color for your registration page. Format: FFFFFF without the pound." />
		<cfargument name="box_border_color"				required="false" type="string" 		hint="Custom hexadecimal color for your registration page. Format: FFFFFF without the pound." />
		<cfargument name="box_header_background_color"	required="false" type="string" 		hint="Custom hexadecimal color for your registration page. Format: FFFFFF without the pound." />
		<cfargument name="box_header_text_color"		required="false" type="string" 		hint="Custom hexadecimal color for your registration page. Format: FFFFFF without the pound." />
		<cfreturn handleReturn(getObjectFactory().load('Events').updateEvent(argumentCollection=arguments)) />
	</cffunction>
	
	<cffunction name="copyEvent" access="public" output="false" returntype="Any" hint="This method returns the ID of the new event copied.">
		<cfargument name="id" 			required="true" type="numeric" 	hint="The ID of the event to update." />
		<cfargument name="event_name" 	required="true" type="string" 	hint="The event title." />
		<cfreturn handleReturn(getObjectFactory().load('Events').copyEvent(argumentCollection=arguments)) />
	</cffunction>
	
	<cffunction name="listEventAttendees" access="public" output="false" returntype="Any" hint="This method returns a list of attendees for a given event. If no authentication is passed, only publicly available attendee records will be returned.">
		<cfargument name="id" 		required="true" type="numeric" 					hint="The ID of the event." />
		<cfargument name="count" 	required="false" type="numeric"	default="50" 	hint="Limit the number of attendees returned. Default limit is 50 attendees per page if paginate selected." />
		<cfargument name="page" 	required="false" type="numeric"	default="1" 	hint="Allows for paging through the results of a query. Default is 1. Page size will be setted with 'count' parameter." />
		<cfreturn handleReturn(getObjectFactory().load('Events').listEventAttendees(argumentCollection=arguments)) />
	</cffunction>
	
	<cffunction name="listEventDiscounts" access="public" output="false" returntype="Any" hint="This method returns the list of discount codes created for a given event.">
		<cfargument name="id" required="true" type="numeric" hint="The ID of the event." />
		<cfreturn handleReturn(getObjectFactory().load('Events').listEventDiscounts(argumentCollection=arguments)) />
	</cffunction>
	<!--- END EVENT RELATED METHODS --->
	
	<!--- ORGANIZER RELATED METHODS --->
	<cffunction name="newOrganizer" access="public" output="false" returntype="Any" hint="I create a new organizer, and I return the ID of the newly created organizer.">
		<cfargument name="name" 		required="true" 	type="string" 	hint="The organizer name." />
		<cfargument name="description"	required="false" 	type="string"	hint="The organizer description." />
		<cfreturn handleReturn(getObjectFactory().load('Organizer').newOrganizer(argumentCollection=arguments)) />
	</cffunction>
	
	<cffunction name="listOrganizerEvents" access="public" output="false" returntype="Any" hint="I list all events created by the supplied organizer. Only public events are returned if no authentication is passed.">
		<cfargument name="id" required="true" type="string" hint="The organizer ID" />
		<cfreturn handleReturn(getObjectFactory().load('Organizer').listOrganizerEvents(argumentCollection=arguments)) />
	</cffunction>
	
	<cffunction name="updateOrganizer" access="public" output="false" returntype="Any" hint="I update an existing organizer. Only the fields passed as arguments will be modified. It returns the ID of the updated organizer.">
		<cfargument name="id" 			required="true" 	type="string" 	hint="The organizer ID" />
		<cfargument name="name" 		required="true" 	type="string" 	hint="The organizer name." />
		<cfargument name="description"	required="false" 	type="string"	hint="The organizer description." />
		<cfreturn handleReturn(getObjectFactory().load('Organizer').updateOrganizer(argumentCollection=arguments)) />
	</cffunction>
	<!--- END ORGANIZER RELATED METHODS --->
	
	<!--- PAYMENT RELATED METHODS --->
	<cffunction name="updatePayment" access="public" output="false" returntype="Any" hint="This method creates or updates the payment options for this event. Only the fields passed as arguments will be modified. It returns the list of active method of payment.">
		<cfargument name="event_id" 				required="true" 	type="numeric" 	hint="The event ID." />
		<cfargument name="accept_paypal"			required="false" 	type="numeric" 	hint="Accept PayPal payments (1 or 0)." />
		<cfargument name="paypal_email"				required="false" 	type="string" 	hint="Your PayPal email. Defaults to the user email address if not provided." />
		<cfargument name="accept_google"			required="false" 	type="numeric" 	hint="Accept Google Checkout payments (1 or 0)." />
		<cfargument name="google_merchant_id"		required="false" 	type="string" 	hint="Google Checkout Merchant ID. Required if accept_google is 1." />
		<cfargument name="google_merchant_key"		required="false" 	type="string" 	hint="Google Checkout Merchant Key. Required if accept_google is 1." />	
		<cfargument name="accept_check"				required="false" 	type="numeric" 	hint="Accept 'Pay by Check' payments (1 or 0)." />
		<cfargument name="instructions_check"		required="false" 	type="string" 	hint="Instructions to attendees who want to pay by check." />
		<cfargument name="accept_cash"				required="false" 	type="numeric" 	hint="Accept 'Pay with Cash' payments (1 or 0)." />
		<cfargument name="instructions_cash"		required="false" 	type="string" 	hint="Instructions to attendees who want to pay with cash." />
		<cfargument name="accept_invoice"			required="false" 	type="numeric" 	hint="Accept 'Send an Invoice' payments (1 or 0)." />
		<cfargument name="instructions_invoice"		required="false" 	type="string" 	hint="Instructions to attendees who need to be sent an invoice." />
		<cfreturn handleReturn(getObjectFactory().load('Payment').updatePayment(argumentCollection=arguments)) />
	</cffunction>
	<!--- END PAYMENT RELATED METHODS --->
	
	<!--- TICKET RELATED METHODS --->
	<cffunction name="newTicket" access="public" output="false" hint="I create a new fixed-price ticket, and I return the ID of the newly created ticket.">
		<cfargument name="event_id" 	required="true" 	type="numeric" 				hint="The event ID. The event must have been previously created using newEvent." />
		<cfargument name="is_donation"	required="false" 	type="numeric" default="0" 	hint="0 for fixed-price tickets, 1 for donations. 0 will be used by default if not provided." />
		<cfargument name="name"			required="true" 	type="string" 				hint="The ticket name." />
		<cfargument name="description"	required="false" 	type="string"  				hint="The ticket description." />
		<cfargument name="price"		required="false" 	type="string"  default=""	hint="The ticket price. Enter 0.00 for free tickets. Leave blank for a donation." />
		<cfargument name="quantity"		required="false" 	type="string"  default=""	hint="The number of tickets available. Not required for donations." />
		<cfargument name="start_sales"	required="false" 	type="string"  				hint="The date and time when ticket sales start, in ISO 8601 format (e.g., '2007-12-31 23:59:59')." />
		<cfargument name="end_sales"	required="false" 	type="string"  				hint="The date and time when ticket sales stop, in ISO 8601 format (e.g., '2007-12-31 23:59:59')." />
		<cfargument name="include_fee"	required="false" 	type="numeric" default="0"	hint="0 to add the Eventbrite service fee on top of ticket price, or 1 to include it in the ticket price. 0 will be used by default if not provided." />
		<cfargument name="min"			required="false" 	type="string"  				hint="The minimum number of tickets per order." />
		<cfargument name="max"			required="false" 	type="string"  				hint="The maximum number of tickets per order." />
		<cfreturn handleReturn(getObjectFactory().load('Tickets').newTicket(argumentCollection=arguments)) />
	</cffunction>
	
	<cffunction name="updateTicket" access="public" output="false" hint="This method updates an existing ticket type. Only the fields passed as arguments will be modified. It returns the ID of the updated ticket.">
		<cfargument name="id" 			required="true" 	type="numeric" 	hint="The ticket ID." />
		<cfargument name="is_donation"	required="false" 	type="numeric" 	hint="0 for fixed-price tickets, 1 for donations. 0 will be used by default if not provided." />
		<cfargument name="name"			required="true" 	type="string" 	hint="The ticket name." />
		<cfargument name="description"	required="false" 	type="string"	hint="The ticket description." />
		<cfargument name="price"		required="false" 	type="string"  	hint="The ticket price. Enter 0.00 for free tickets. Leave blank for a donation." />
		<cfargument name="quantity"		required="false" 	type="string"  	hint="The number of tickets available. Not required for donations." />
		<cfargument name="start_sales"	required="false" 	type="string"	hint="The date and time when ticket sales start, in ISO 8601 format (e.g., '2007-12-31 23:59:59')." />
		<cfargument name="end_sales"	required="false" 	type="string"	hint="The date and time when ticket sales stop, in ISO 8601 format (e.g., '2007-12-31 23:59:59')." />
		<cfargument name="include_fee"	required="false" 	type="numeric" 	hint="0 to add the Eventbrite service fee on top of ticket price, or 1 to include it in the ticket price. 0 will be used by default if not provided." />
		<cfargument name="min"			required="false" 	type="string"	hint="The minimum number of tickets per order." />
		<cfargument name="max"			required="false" 	type="string"	hint="The maximum number of tickets per order." />
		<cfargument name="hide"			required="false" 	type="string"  	hint="Show or hide the ticket type. Valid options: (y or n)." />
		<cfreturn handleReturn(getObjectFactory().load('Tickets').updateTicket(argumentCollection=arguments)) />
	</cffunction>
	<!--- END TICKET RELATED METHODS --->
	
	<!--- USER RELATED METHODS --->
	<cffunction name="newUser" access="public" output="false" hint="I create a new user, and I return the ID of the newly created user.">
		<cfargument name="email" 	required="true" type="string" hint="The user email address." />
		<cfargument name="passwd"	required="true" type="string" hint="The user password (needs to be at least 4 characters long)." />
		<cfreturn handleReturn(getObjectFactory().load('Users').newUser(argumentCollection=arguments)) />
	</cffunction>
	
	<cffunction name="getUser" access="public" output="false" hint="I return the data for a given user. Only User or sub user which match login credentials are viewable.">
		<cfargument name="user_id"	required="true" type="string" default="" hint="The ID of the subuser account." />
		<cfargument name="email" 	required="true" type="string" default="" hint="The email address of the subuser account." />
		<cfreturn handleReturn(getObjectFactory().load('Users').getUser(argumentCollection=arguments)) />
	</cffunction>
	
	<cffunction name="updateUser" access="public" output="false" hint="I update an existing user. Only the fields passed as arguments will be modified. It returns the ID of the updated user.">
		<cfargument name="new_email"	required="true" type="string" default="" hint="New user email address." />
		<cfargument name="new_password" required="true" type="string" default="" hint="New user password (needs to be at least 4 characters long)." />
		<cfreturn handleReturn(getObjectFactory().load('Users').updateUser(argumentCollection=arguments)) />
	</cffunction>
	
	<cffunction name="listUserEvents" access="public" output="false" hint="This method lists the events created by this user. Only public events are returned if no authentication is passed.">
		<cfargument name="user"	required="false" type="string" default="" hint="The user email. Defaults to the authenticated user if not provided." />
		<cfreturn handleReturn(getObjectFactory().load('Users').listUserEvents(argumentCollection=arguments)) />
	</cffunction>
	
	<cffunction name="listUserOrganizers" access="public" output="false" hint="This method lists the organizers created by this user.">
		<cfargument name="user"		required="false" type="string" hint="The user email." />
		<cfargument name="password"	required="true"  type="string" hint="The user password." />
		<cfreturn handleReturn(getObjectFactory().load('Users').listUserOrganizers(argumentCollection=arguments))/>
	</cffunction>
	
	<cffunction name="listUserTickets" access="public" output="false" hint="This method lists the tickets purchased by the authenticated user. Each transaction is an order in our system and an order may contain one or more tickets. Tickets to free events are included.">
		<cfargument name="user"		required="false" 	type="string" hint="The user email." />
		<cfargument name="password"	required="false" 	type="string" hint="The user password." />
		<cfreturn handleReturn(getObjectFactory().load('Users').listUserTickets(argumentCollection=arguments))/>
	</cffunction>
	
	<cffunction name="listUserVenues" access="public" output="false" hint="This method lists the venues created by this user.">
		<cfargument name="user"		required="false" type="string" hint="The user email." />
		<cfargument name="password"	required="true"  type="string" hint="The user password." />
		<cfreturn handleReturn(getObjectFactory().load('Users').listUserVenues(argumentCollection=arguments)) />
	</cffunction>
	<!--- END USER RELATED METHODS --->
	
	<!--- VENUE RELATED METHODS --->
	<cffunction name="newVenue" access="public" output="false" hint="I create a new venue, and I return the ID of the newly created venue.">
		<cfargument name="organizer_id" required="true" 	type="numeric" 	hint="The organizer ID" />
		<cfargument name="venue" 		required="true" 	type="string" 	hint="The venue name." />
		<cfargument name="adress"		required="false" 	type="string" 	hint="The venue address (line 1)." />
		<cfargument name="adress_2"		required="false" 	type="string" 	hint="The venue address (line 2)." />
		<cfargument name="city"			required="false" 	type="string" 	hint="The venue city." />
		<cfargument name="region"		required="true" 	type="string" 	hint="The venue state/province/county/territory depending on the country. 2-letter state code is required for US addresses." />
		<cfargument name="postal_code"	required="false" 	type="string"	hint="The postal code of the venue." />
		<cfargument name="country_code"	required="true" 	type="string" 	hint="2-letter country code, according to the ISO 3166 format." />
		<cfreturn handleReturn(getObjectFactory().load('Venue').newVenue(argumentCollection=arguments)) />
	</cffunction>
	
	<cffunction name="updateVenue" access="public" output="false" hint="This method updates an existing venue. Only the fields passed as arguments will be modified. It returns the ID of the updated venue.">
		<cfargument name="id" 			required="true" 	type="numeric" 	hint="The venue ID" />
		<cfargument name="venue" 		required="true" 	type="string" 	hint="The venue name." />
		<cfargument name="adress"		required="false" 	type="string" 	hint="The venue address (line 1)." />
		<cfargument name="adress_2"		required="false" 	type="string" 	hint="The venue address (line 2)." />
		<cfargument name="city"			required="false" 	type="string" 	hint="The venue city." />
		<cfargument name="region"		required="false" 	type="string" 	hint="The venue state/province/county/territory depending on the country. 2-letter state code is required for US addresses." />
		<cfargument name="postal_code"	required="false" 	type="string"	hint="The postal code of the venue." />
		<cfargument name="country_code"	required="false" 	type="string"	hint="2-letter country code, according to the ISO 3166 format." />
		<cfreturn handleReturn(getObjectFactory().load('Venue').updateVenue(argumentCollection=arguments)) />
	</cffunction>
	<!--- END VENUE RELATED METHODS --->
	
	<!--- PRIVATE METHODS --->
	<cffunction name="handleReturn" access="private" output="false" returntype="Any" hint="I handle the return format of the data. Parsed or literal.">
		<cfargument name="data" required="true" type="string" hint="I am the data response from the API remote call." />
			<cfif getParseResults()>
				<cfreturn XmlParse(arguments.data) />
			<cfelse>
				<cfreturn arguments.data />
			</cfif>
	</cffunction>
	

</cfcomponent>