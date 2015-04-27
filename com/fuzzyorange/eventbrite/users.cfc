<!---
Filename: users.cfc
Creation Date: 11/March/2010
Original Author: Matt Gifford aka coldfumonkeh
Revision: $Rev$
$LastChangedBy$
$LastChangedDate$
Description:
the users class object

Changelog:

11th October 2010
	- added user_list_tickets method (listUserTickets)

Methods contained:
	- user_get
	- user_list_events
	- user_list_organizers
	- user_list_tickets
	- user_list_venues
	- user_new
	- user_update
--->
<cfcomponent name="users" output="false" extends="base">
	
	<cfset variables.instance = structNew() />
	
	<cffunction name="init" access="public" output="false" returntype="Any" hint="I am the constructor method for the users class.">
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
	<cffunction name="newUser" access="public" output="false" hint="I create a new user, and I return the ID of the newly created user.">
		<cfargument name="email" 	required="true" type="string" hint="The user email address." />
		<cfargument name="passwd"	required="true" type="string" hint="The user password (needs to be at least 4 characters long)." />
			<cfset var strURL 		= '' />
			<cfset var stuResponse 	= structNew() />
				<cfif len(arguments.passwd) LT 4>
					<cfdump var="Your password must be at least 4 characters long." />
					<cfabort>
				</cfif>
				<cfscript>
					strURL 		= strURL & 'user_new?' & buildAuthString(getUserAccess()) & '&' & buildParamString(arguments,true);
					stuResponse = makeCall(strURL);  
                </cfscript>
		<cfreturn stuResponse />
	</cffunction>
	
	<cffunction name="getUser" access="public" output="false" hint="I return the data for a given user. Only User or sub user which match login credentials are viewable.">
		<cfargument name="user_id"	required="true" type="string" default="" hint="The ID of the subuser account." />
		<cfargument name="email" 	required="true" type="string" default="" hint="The email address of the subuser account." />
			<cfset var strURL 		= '' />
			<cfset var stuResponse 	= structNew() />
				<cfscript>
					strURL 		= strURL & 'user_get?' & buildAuthString(getUserAccess()) & '&' & buildParamString(arguments,true);
					stuResponse = makeCall(strURL);  
                </cfscript>
		<cfreturn stuResponse />
	</cffunction>
	
	<cffunction name="updateUser" access="public" output="false" hint="I create a new user. Only the fields passed as arguments will be modified. It returns the ID of the updated user.">
		<cfargument name="new_email"	required="true" type="string" default="" hint="New user email address." />
		<cfargument name="new_password" required="true" type="string" default="" hint="New user password (needs to be at least 4 characters long)." />
			<cfset var strURL 		= '' />
			<cfset var stuResponse 	= structNew() />
				<cfif len(arguments.new_password) LT 4>
					<cfdump var="Your password must be at least 4 characters long." />
					<cfabort>
				</cfif>
				<cfscript>
					strURL 		= strURL & 'user_update?' & buildAuthString(getUserAccess()) & '&' & buildParamString(arguments,true);
					stuResponse = makeCall(strURL);  
                </cfscript>
		<cfreturn stuResponse />
	</cffunction>
	
	<cffunction name="listUserEvents" access="public" output="false" hint="This method lists the events created by this user. Only public events are returned if no authentication is passed.">
		<cfargument name="user"	required="false" type="string" default="" hint="The user email. Defaults to the authenticated user if not provided." />
			<cfset var strURL 		= '' />
			<cfset var stuResponse 	= structNew() />
				<cfscript>
					strURL 		= strURL & 'user_list_events?' & buildAuthString(getUserAccess()) & '&' & buildParamString(arguments,true);
					stuResponse = makeCall(strURL);  
                </cfscript>
		<cfreturn stuResponse />
	</cffunction>
	
	<cffunction name="listUserOrganizers" access="public" output="false" hint="This method lists the organizers created by this user.">
		<cfargument name="user"		required="false" 	type="string" hint="The user email." />
		<cfargument name="password"	required="true" 	type="string" hint="The user password." />
			<cfset var strURL 		= '' />
			<cfset var stuResponse 	= structNew() />
				<cfscript>
					strURL 		= strURL & 'user_list_organizers?' & buildAuthString(getUserAccess()) & '&' & buildParamString(arguments,true);
					stuResponse = makeCall(strURL);  
                </cfscript>
		<cfreturn stuResponse />
	</cffunction>
	
	<cffunction name="listUserTickets" access="public" output="false" hint="This method lists the tickets purchased by the authenticated user. Each transaction is an order in our system and an order may contain one or more tickets. Tickets to free events are included.">
		<cfargument name="user"		required="false" 	type="string" hint="The user email." />
		<cfargument name="password"	required="false" 	type="string" hint="The user password." />
			<cfset var strURL 		= '' />
			<cfset var stuResponse 	= structNew() />
				<cfscript>
					strURL 		= strURL & 'user_list_tickets?' & buildAuthString(getUserAccess()) & '&' & buildParamString(arguments,true);
					stuResponse = makeCall(strURL);  
                </cfscript>
		<cfreturn stuResponse />
	</cffunction>

	<cffunction name="listUserVenues" access="public" output="false" hint="This method lists the venues created by this user.">
		<cfargument name="user"		required="false" 	type="string" hint="The user email." />
		<cfargument name="password"	required="true" 	type="string" hint="The user password." />
			<cfset var strURL 		= '' />
			<cfset var stuResponse 	= structNew() />
				<cfscript>
					strURL 		= strURL & 'user_list_venues?' & buildAuthString(getUserAccess()) & '&' & buildParamString(arguments,true);
					stuResponse = makeCall(strURL);  
                </cfscript>
		<cfreturn stuResponse />
	</cffunction>

</cfcomponent>