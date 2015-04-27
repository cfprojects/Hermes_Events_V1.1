<!---
Filename: venue.cfc
Creation Date: 11/March/2010
Original Author: Matt Gifford aka coldfumonkeh
Revision: $Rev$
$LastChangedBy$
$LastChangedDate$
Description:
the venue class object

Methods contained:
	- venue_new
	- venue_update

--->
<cfcomponent name="venue" output="false" extends="base">
	
	<cfset variables.instance = structNew() />
	
	<cffunction name="init" access="public" output="false" returntype="Any" hint="I am the constructor method for the venue class.">
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
	<cffunction name="newVenue" access="public" output="false" hint="I create a new venue, and I return the ID of the newly created venue.">
		<cfargument name="organizer_id" required="true" 	type="numeric" 	hint="The organizer ID" />
		<cfargument name="venue" 		required="true" 	type="string" 	hint="The venue name." />
		<cfargument name="adress"		required="false" 	type="string"	hint="The venue address (line 1)." />
		<cfargument name="adress_2"		required="false" 	type="string" 	hint="The venue address (line 2)." />
		<cfargument name="city"			required="false" 	type="string"	hint="The venue city." />
		<cfargument name="region"		required="true" 	type="string" 	hint="The venue state/province/county/territory depending on the country. 2-letter state code is required for US addresses." />
		<cfargument name="postal_code"	required="false" 	type="string"	hint="The postal code of the venue." />
		<cfargument name="country_code"	required="true" 	type="string"  	hint="2-letter country code, according to the ISO 3166 format." />
			<cfset var strURL 		= '' />
			<cfset var stuResponse 	= structNew() />
				<cfscript>
					strURL 		= strURL & 'venue_new?' & buildAuthString(getUserAccess()) & '&' & buildParamString(arguments,true);
					stuResponse = makeCall(strURL);  
                </cfscript>
		<cfreturn stuResponse />
	</cffunction>
	
	<cffunction name="updateVenue" access="public" output="false" hint="This method updates an existing venue. Only the fields passed as arguments will be modified. It returns the ID of the updated venue.">
		<cfargument name="id" 			required="true" 	type="numeric" 	hint="The venue ID" />
		<cfargument name="venue" 		required="true" 	type="string" 	hint="The venue name." />
		<cfargument name="adress"		required="false" 	type="string" 	hint="The venue address (line 1)." />
		<cfargument name="adress_2"		required="false" 	type="string" 	hint="The venue address (line 2)." />
		<cfargument name="city"			required="false" 	type="string" 	hint="The venue city." />
		<cfargument name="region"		required="false" 	type="string" 	hint="The venue state/province/county/territory depending on the country. 2-letter state code is required for US addresses." />
		<cfargument name="postal_code"	required="false" 	type="string" 	hint="The postal code of the venue." />
		<cfargument name="country_code"	required="false" 	type="string"	hint="2-letter country code, according to the ISO 3166 format." />
			<cfset var strURL 		= '' />
			<cfset var stuResponse 	= structNew() />
				<cfscript>
					strURL 		= strURL & 'venue_update?' & buildAuthString(getUserAccess()) & '&' & buildParamString(arguments,true);
					stuResponse = makeCall(strURL);  
                </cfscript>
		<cfreturn stuResponse />
	</cffunction>

</cfcomponent>