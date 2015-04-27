<!---
Filename: userAccess.cfc
Creation Date: 11/March/2010
Original Author: Matt Gifford aka coldfumonkeh
Revision: $Rev$
$LastChangedBy$
$LastChangedDate$
Description:
the userAccess bean, holding login details to access the API
--->
<cfcomponent name="userAccess" output="false">

	<cfset variables.instance = structNew() />
	
	<cffunction name="init" access="public" output="false" returntype="Any" hint="I am the constructor method for the userAccess class">
		<cfargument name="applicationKey" 	required="true" 	type="string" 					hint="I am the application key" />
		<cfargument name="emailAddress"		required="true" 	type="string" 					hint="I am the email address associated with the Eventbrite account" />
		<cfargument name="password"			required="true" 	type="string" 					hint="I am the password associated with the Eventbrite account" /> 
		<cfargument name="userKey"			required="true"		type="string" 					hint="I am the user key, associated with the specific user" />
		<cfargument name="authLevel"		required="false"	type="string" default="Secure" 	hint="The level of authentication used against the API. Secure or Basic." />
			<cfscript>
				setAppKey(arguments.applicationKey);
				setEmail(arguments.emailAddress);
				setPassword(arguments.password);
				setUserKey(arguments.userKey);
				setAuthLevel(arguments.authLevel);        	            
            </cfscript>
		<cfreturn this />
	</cffunction>
	
	<!--- MUTATORS --->
	<cffunction name="setAppKey" access="private" output="false" returntype="void" hint="I set the application key">
		<cfargument name="applicationKey" required="true" type="string" hint="I am the application key" />
		<cfset variables.instance.appKey = arguments.applicationKey />
	</cffunction>
	
	<cffunction name="setEmail" access="private" output="false" returntype="void" hint="I set the email address">
		<cfargument name="emailAddress"	required="true" type="string" hint="I am the email address associated with the Eventbrite account" />
		<cfset variables.instance.email = arguments.emailAddress />
	</cffunction>
	
	<cffunction name="setPassword" access="private" output="false" returntype="void" hint="I set the password">
		<cfargument name="password"	required="true" type="string" hint="I am the password associated with the Eventbrite account" /> 
		<cfset variables.instance.password = arguments.password />
	</cffunction>
	
	<cffunction name="setUserKey" access="private" output="false" returntype="void" hint="I set the user key">
		<cfargument name="userKey"	required="true"	type="string" hint="I am the user key, associated with the specific user" />
		<cfset variables.instance.userKey = arguments.userKey />
	</cffunction>
	
	<cffunction name="setAuthLevel" access="private" output="false" returntype="void" hint="I set the authentication level.">
		<cfargument name="authLevel" required="true" type="string" hint="The level of authentication used against the API. Secure or Basic." />
		<cfset variables.instance.authLevel = arguments.authLevel />
	</cffunction>
	
	<!--- ACCESSORS --->
	<cffunction name="getAppKey" access="public" output="false" returntype="string" hint="I return the application key">
		<cfreturn variables.instance.appKey />
	</cffunction>
	
	<cffunction name="getEmail" access="public" output="false" returntype="string" hint="I return the email address">
		<cfreturn variables.instance.email />
	</cffunction>
	
	<cffunction name="getPassword" access="public" output="false" returntype="string" hint="I return the password">
		<cfreturn variables.instance.password />
	</cffunction>
	
	<cffunction name="getUserKey" access="public" output="false" returntype="string" hint="I return the user key">
		<cfreturn variables.instance.userKey />
	</cffunction>
	
	<cffunction name="getAuthLevel" access="public" output="false" returntype="Any" hint="I return the authLevel variable.">
		<cfreturn variables.instance.authLevel />
	</cffunction>

</cfcomponent>