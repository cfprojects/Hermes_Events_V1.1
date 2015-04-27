<!---
Filename: discount.cfc
Creation Date: 11/March/2010
Original Author: Matt Gifford aka coldfumonkeh
Revision: $Rev$
$LastChangedBy$
$LastChangedDate$
Description:
the discount class object

Methods contained:
	- discount_new
	- discount_update

--->
<cfcomponent name="discount" output="false" extends="base">

	
	<cfset variables.instance = structNew() />
	
	<cffunction name="init" access="public" output="false" returntype="Any" hint="I am the constructor method for the discount class.">
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
	<cffunction name="newDiscount" access="public" output="false" returntype="Any" hint="This method creates a new discount code. It returns the ID of the newly created discount code.">
		<cfargument name="event_id" 			required="true" 	type="numeric" 				hint="The event ID. The event must have been previously created using newEvent." />
		<cfargument name="code"					required="true" 	type="string" 				hint="The discount code. Spaces, apostrophes and non-alphanumeric characters are not allowed, except for dashes and underscores. Examples: 'earlybirdspecial_08', 'membersonly', 'dc121232'." />
		<cfargument name="amount_off"			required="true"		type="string" 	default=""	hint="The fixed amount off the ticket price. Each discount code can have a fixed discount amount or a variable (percentage) discount amount, but not both." />
		<cfargument name="percent_off"			required="false"	type="string"	default="" 	hint="The percentage off the ticket price. Each discount code can have a fixed discount amount or a variable (percentage) discount amount, but not both." />
		<cfargument name="tickets"				required="false" 	type="string" 				hint="Comma-separated list of ticket IDs for which the discount applies. If not provided, the discount will apply to all ticket types." />
		<cfargument name="quantity_available"	required="false" 	type="string" 				hint="Maximum number of times this discount can be used. If not provided, no maximum is set." />
		<cfargument name="start_date"			required="false" 	type="string" 				hint="The discount start date and time, in ISO 8601 format (e.g., '2007-12-31 23:59:59')." />
		<cfargument name="end_date"				required="false" 	type="string" 				hint="The discount end date and time, in ISO 8601 format (e.g., '2007-12-31 23:59:59'). " />
			<cfset var strURL 		= '' />
			<cfset var stuResponse 	= structNew() />
				<cfscript>
					strURL 		= strURL & 'discount_new?' & buildAuthString(getUserAccess()) & buildParamString(arguments,true);
					stuResponse = makeCall(strURL);  
                </cfscript>
		<cfreturn stuResponse />
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
			<cfset var strURL 		= '' />
			<cfset var stuResponse 	= structNew() />
				<cfscript>
					strURL 		= strURL & 'discount_update?' & buildAuthString(getUserAccess()) & buildParamString(arguments,true);
					stuResponse = makeCall(strURL);  
                </cfscript>
		<cfreturn stuResponse />
	</cffunction>
	
	
	<!--- PRIVATE METHODS --->

</cfcomponent>