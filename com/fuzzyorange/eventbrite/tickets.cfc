<!---
Filename: tickets.cfc
Creation Date: 11/March/2010
Original Author: Matt Gifford aka coldfumonkeh
Revision: $Rev$
$LastChangedBy$
$LastChangedDate$
Description:
the tickets class object

Methods contained:
	- ticket_new
	- ticket_update
	
--->
<cfcomponent name="tickets" output="false" extends="base">

	
	<cfset variables.instance = structNew() />
	
	<cffunction name="init" access="public" output="false" returntype="Any" hint="I am the constructor method for the tickets class.">
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
	<cffunction name="newTicket" access="public" output="false" hint="I create a new fixed-price ticket, and I return the ID of the newly created ticket.">
		<cfargument name="event_id" 	required="true" 	type="numeric" 				hint="The event ID. The event must have been previously created using newEvent." />
		<cfargument name="is_donation"	required="false" 	type="numeric" default="0" 	hint="0 for fixed-price tickets, 1 for donations. 0 will be used by default if not provided." />
		<cfargument name="name"			required="true" 	type="string" 				hint="The ticket name." />
		<cfargument name="description"	required="false" 	type="string"				hint="The ticket description." />
		<cfargument name="price"		required="false" 	type="string"  default=""	hint="The ticket price. Enter 0.00 for free tickets. Leave blank for a donation." />
		<cfargument name="quantity"		required="false" 	type="string"  default=""	hint="The number of tickets available. Not required for donations." />
		<cfargument name="start_sales"	required="false" 	type="string"  				hint="The date and time when ticket sales start, in ISO 8601 format (e.g., '2007-12-31 23:59:59')." />
		<cfargument name="end_sales"	required="false" 	type="string"  				hint="The date and time when ticket sales stop, in ISO 8601 format (e.g., '2007-12-31 23:59:59')." />
		<cfargument name="include_fee"	required="false" 	type="numeric" default="0"	hint="0 to add the Eventbrite service fee on top of ticket price, or 1 to include it in the ticket price. 0 will be used by default if not provided." />
		<cfargument name="min"			required="false" 	type="string"  				hint="The minimum number of tickets per order." />
		<cfargument name="max"			required="false" 	type="string"  				hint="The maximum number of tickets per order." />
			<cfset var strURL 		= '' />
			<cfset var stuResponse 	= structNew() />
				<cfscript>
					strURL 		= strURL & 'ticket_new?' & buildAuthString(getUserAccess()) & buildParamString(arguments,true);
					stuResponse = makeCall(strURL);  
                </cfscript>
		<cfreturn stuResponse />
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
			<cfset var strURL 		= '' />
			<cfset var stuResponse 	= structNew() />
				<cfscript>
					strURL 		= strURL & 'ticket_update?' & buildAuthString(getUserAccess()) & buildParamString(arguments,true);
					stuResponse = makeCall(strURL);  
                </cfscript>
		<cfreturn stuResponse />
	</cffunction>
	
	<!--- PRIVATE METHODS --->

</cfcomponent>