<!---
Filename: events.cfc
Creation Date: 11/March/2010
Original Author: Matt Gifford aka coldfumonkeh
Revision: $Rev$
$LastChangedBy$
$LastChangedDate$
Description:
the event class object

Methods contained:

	- event_copy
	- event_get	
	- event_list_attendees
	- event_list_discounts
	- event_new
	- event_search
	- event_update
--->
<cfcomponent name="events" output="false" extends="base">
	
	<cfset variables.instance = structNew() />
	
	<cffunction name="init" access="public" output="false" returntype="Any" hint="I am the constructor method for the events class.">
		<cfargument name="userAccess" required="true" type="Any" hint="I am the userAccess class object" />
			<cfscript>
				setUserAccess(arguments.userAccess);
				super.init();
            </cfscript>
		<cfreturn this />
	</cffunction>
	
	<!--- MUTATORS --->
	<cffunction name="setUserAccess" access="private" output="false" returntype="void" hint="I set the userAccess class into the variables.instance scope.">
		<cfargument name="userAccess" required="true" type="Any" hint="I am the userAccess class object" />
		<cfset variables.instance.userAccess = arguments.userAccess />
	</cffunction>
	
	<!--- ACCESSORS --->
	<cffunction name="getUserAccess" access="public" output="false" returntype="Any" hint="I return the userAccess class.">
		<cfreturn variables.instance.userAccess />
	</cffunction>
	
	<!--- PUBLIC METHODS --->
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
			<cfset var strURL 		= '' />
			<cfset var stuResponse 	= structNew() />
				<cfscript>
					strURL 		= strURL & 'event_search?' & buildAuthString(getUserAccess()) & buildParamString(arguments,true);
					stuResponse = makeCall(strURL);  
                </cfscript>
		<cfreturn stuResponse />
	</cffunction>
	
	<cffunction name="getEvent" access="public" output="false" returntype="Any" hint="This method returns the data for a given event. Only public events are viewable if no authentication is passed.">
		<cfargument name="id" required="true" type="numeric" default="" hint="The ID of the requested event." />
			<cfset var strURL 		= '' />
			<cfset var stuResponse 	= structNew() />
				<cfscript>
					strURL 		= strURL & 'event_get?' & buildAuthString(getUserAccess()) & buildParamString(arguments,true);
					stuResponse = makeCall(strURL);  
                </cfscript>
		<cfreturn stuResponse />
	</cffunction>
	
	<cffunction name="newEvent" access="public" output="false" returntype="Any" hint="This method creates a new event. It returns the ID of the newly created event.">
		<cfargument name="title" 						required="true" type="string" 					hint="The event title." />
		<cfargument name="description" 					required="false" type="string" 					hint="The event description." />
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
			<cfset var strURL 		= '' />
			<cfset var stuResponse 	= structNew() />
				<cfscript>
					strURL 		= strURL & 'event_new?' & buildAuthString(getUserAccess()) & buildParamString(arguments,true);
					stuResponse = makeCall(strURL);  
                </cfscript>
		<cfreturn stuResponse />
	</cffunction>
	
	<cffunction name="updateEvent" access="public" output="false" returntype="Any" hint="This method updates an existing event. Only the fields passed as arguments will be modified. This method returns the ID of the modified event.">
		<cfargument name="event_id" 					required="true"  type="numeric" 	hint="The ID of the event to update." />
		<cfargument name="title" 						required="false" type="string" 		hint="The event title." />
		<cfargument name="description" 					required="false" type="string" 		hint="The event description." />
		<cfargument name="start_date" 					required="false" type="string" 		hint="The event start date and time, in ISO 8601 format (e.g., '2007-12-31 23:59:59')." />
		<cfargument name="end_date" 					required="false" type="string"		hint="The event end date and time, in ISO 8601 format (e.g., '2007-12-31 23:59:59')." />
		<cfargument name="timezone" 					required="false" type="string"		hint="The event time zone in relation to GMT (e.g., 'GMT+01', 'GMT+02', 'GMT-01')." />
		<cfargument name="privacy" 						required="false" type="numeric" 	hint="0 for a private event, 1 for a public event. If not provided, will default to 1." />
		<cfargument name="personalized_url" 			required="false" type="string" 		hint="The event registration URL. If you pass 'testevent', the event will be accessible at 'http://testevent.eventbrite.com'." />
		<cfargument name="venue_id"						required="false" type="numeric" 	hint="The event venue ID." />
		<cfargument name="organizer_id"					required="false" type="numeric" 	hint="The event organizer ID." />
		<cfargument name="capacity"						required="false" type="numeric" 	hint="The maximum number of people who can attend the event." />
		<cfargument name="currency"						required="false" type="string" 		hint="The event currency in ISO 4217 format (e.g., 'USD', 'EUR')." />
		<cfargument name="status"						required="false" type="string" 		hint="The event status. Allowed values are 'draft', 'live' for new events. If not provided, status will be 'draft', meaning that the event registration page will not be available publicly." />
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
			<cfset var strURL 		= '' />
			<cfset var stuResponse 	= structNew() />
				<cfscript>
					strURL 		= strURL & 'event_update?' & buildAuthString(getUserAccess()) & buildParamString(arguments,true);
					stuResponse = makeCall(strURL);  
                </cfscript>
		<cfreturn stuResponse />
	</cffunction>
	
	<cffunction name="copyEvent" access="public" output="false" returntype="Any" hint="This method returns the ID of the new event copied.">
		<cfargument name="id" 			required="true" type="numeric" 	hint="The ID of the event to update." />
		<cfargument name="event_name" 	required="true" type="string" 	hint="The event title." />
			<cfset var strURL 		= '' />
			<cfset var stuResponse 	= structNew() />
				<cfscript>
					strURL 		= strURL & 'event_copy?' & buildAuthString(getUserAccess()) & buildParamString(arguments,true);
					stuResponse = makeCall(strURL);  
                </cfscript>
		<cfreturn stuResponse />
	</cffunction>
	
	<cffunction name="listEventAttendees" access="public" output="false" returntype="Any" hint="This method returns a list of attendees for a given event. If no authentication is passed, only publicly available attendee records will be returned.">
		<cfargument name="id" 		required="true" type="numeric" 					hint="The ID of the event." />
		<cfargument name="count" 	required="false" type="numeric"	default="50" 	hint="Limit the number of attendees returned. Default limit is 50 attendees per page if paginate selected." />
		<cfargument name="page" 	required="false" type="numeric"	default="1" 	hint="Allows for paging through the results of a query. Default is 1. Page size will be setted with 'count' parameter." />
			<cfset var strURL 		= '' />
			<cfset var stuResponse 	= structNew() />
				<cfscript>
					strURL 		= strURL & 'event_list_attendees?' & buildAuthString(getUserAccess()) & buildParamString(arguments,true);
					stuResponse = makeCall(strURL);  
                </cfscript>
		<cfreturn stuResponse />
	</cffunction>
	
	<cffunction name="listEventDiscounts" access="public" output="false" returntype="Any" hint="This method returns the list of discount codes created for a given event.">
		<cfargument name="id" required="true" type="numeric" hint="The ID of the event." />
			<cfset var strURL 		= '' />
			<cfset var stuResponse 	= structNew() />
				<cfscript>
					strURL 		= strURL & 'event_list_discounts?' & buildAuthString(getUserAccess()) & buildParamString(arguments,true);
					stuResponse = makeCall(strURL);  
                </cfscript>
		<cfreturn stuResponse />
	</cffunction>

</cfcomponent>