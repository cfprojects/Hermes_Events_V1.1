<!---
Filename: organizer.cfc
Creation Date: 11/March/2010
Original Author: Matt Gifford aka coldfumonkeh
Revision: $Rev$
$LastChangedBy$
$LastChangedDate$
Description:
the organizer class object

Methods contained:
	- organizer_list_events
	- organizer_new
	- organizer_update
	
--->
<cfcomponent name="organizer" output="false" extends="base">
	
	<cfset variables.instance = structNew() />
	
	<cffunction name="init" access="public" output="false" returntype="Any" hint="I am the constructor method for the organizer class.">
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
	<cffunction name="newOrganizer" access="public" output="false" hint="I create a new organizer, and I return the ID of the newly created organizer.">
		<cfargument name="name" 		required="true" 	type="string" 	hint="The organizer name." />
		<cfargument name="description"	required="false" 	type="string"	hint="The organizer description." />
			<cfset var strURL 		= '' />
			<cfset var stuResponse 	= structNew() />
				<cfscript>
					strURL 		= strURL & 'organizer_new?' & buildAuthString(getUserAccess()) & buildParamString(arguments,true);
					stuResponse = makeCall(strURL);  
                </cfscript>
		<cfreturn stuResponse />
	</cffunction>
	
	<cffunction name="listOrganizerEvents" access="public" output="false" returntype="Any" hint="I list all events created by the supplied organizer. Only public events are returned if no authentication is passed.">
		<cfargument name="id" required="true" type="string" hint="The organizer ID" />
			<cfset var strURL 		= '' />
			<cfset var stuResponse 	= structNew() />
				<cfscript>
					strURL 		= strURL & 'organizer_list_events?' & buildAuthString(getUserAccess()) & buildParamString(arguments,true);
					stuResponse = makeCall(strURL);  
                </cfscript>
		<cfreturn stuResponse />
	</cffunction>
	
	<cffunction name="updateOrganizer" access="public" output="false" returntype="Any" hint="I update an existing organizer. Only the fields passed as arguments will be modified. It returns the ID of the updated organizer.">
		<cfargument name="id" 			required="true" 	type="string" 	hint="The organizer ID" />
		<cfargument name="name" 		required="true" 	type="string" 	hint="The organizer name." />
		<cfargument name="description"	required="false" 	type="string"	hint="The organizer description." />
			<cfset var strURL 		= '' />
			<cfset var stuResponse 	= structNew() />
				<cfscript>
					strURL 		= strURL & 'organizer_update?' & buildAuthString(getUserAccess()) & buildParamString(arguments,true);
					stuResponse = makeCall(strURL);  
                </cfscript>
		<cfreturn stuResponse />
	</cffunction>

</cfcomponent>