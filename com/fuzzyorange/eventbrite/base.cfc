<!---
Filename: base.cfc
Creation Date: 11/March/2010
Original Author: Matt Gifford aka coldfumonkeh
Revision: $Rev$
$LastChangedBy$
$LastChangedDate$
Description:
the base utils class, holding common functions and methods
--->
<cfcomponent displayname="base" output="false" hint="I am the base class containing util methods and common functions">

	<cfset variables.instance = StructNew() />
	
	<cffunction name="init" access="public" output="false" returntype="Any" hint="I am the constructor method for the base class.">
			<cfscript>
				variables.instance.apiURL 	= 'https://www.eventbrite.com/xml/';
			</cfscript>
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getapiURL" access="public" output="false" returntype="string" hint="I return the api url for use in the method calls.">
		<cfreturn variables.instance.apiURL />
	</cffunction>
		
	<cffunction name="buildParamString" access="public" output="false" returntype="String" hint="I loop through a struct to convert to query params for the URL.">
		<cfargument name="argScope" required="true" 	type="struct" 					hint="I am the struct containing the method params." />
		<cfargument name="encodeIt" required="false" 	type="boolean" default="false" 	hint="I am set to true if you need the parameters URLEncoded." />
			<cfset var strURLParam 	= '' />
			<cfset var strParams	= '' />
			<cfloop collection="#arguments.argScope#" item="key">
				<cfif len(arguments.argScope[key]) and arguments.argScope[key] NEQ ''>
					<cfif listLen(strURLParam)>
						<cfset strURLParam = strURLParam & '&' />
					</cfif>
					<cfset strURLParam = strURLParam & lcase(key) & '=' />
					<cfif arguments.encodeIt>
						<cfset strURLParam = strURLParam & urlEncodedFormat(arguments.argScope[key]) />
					<cfelse>
						<cfset strURLParam = strURLParam & arguments.argScope[key] />
					</cfif>
				</cfif>
			</cfloop>
			<cfif len(strURLParam)>
				<cfset strParams = '&' & strURLParam />
			</cfif>
		<cfreturn strParams />
	</cffunction>
	
	<cffunction name="buildAuthString" access="public" output="false" returntype="String" hint="I build the authentication query param string for the remote API calls.">
		<cfargument name="userAccess" required="true" type="Any" hint="I am the userAccess class object." />
			<cfset var strURLAuth = '' />
				<cfswitch expression="#arguments.userAccess.getAuthLevel()#">
					<cfcase value="Secure">
						<cfset strURLAuth = strURLAuth & 'app_key=#arguments.userAccess.getAppKey()#&user_key=#arguments.userAccess.getUserKey()#' />
					</cfcase>
					<cfdefaultcase>
						<cfset strURLAuth = strURLAuth & 'app_key=#arguments.userAccess.getAppKey()#&user=#arguments.userAccess.getEmail()#&password=#arguments.userAccess.getPassword()#' />
					</cfdefaultcase>
				</cfswitch>
		<cfreturn strURLAuth />
	</cffunction>
	
	<cffunction name="makeCall" access="package" output="false" returntype="Any" hint="I am the function that makes the cfhttp GET requests.">
		<cfargument name="remoteURL" 	required="true" type="string" hint="The URL to which the call is made." />
			<cfset var strURL = '' />
			<cfset var cfhttp	 = '' />
				<cfset strURL = arguments.remoteURL />
				<cfhttp url="#getapiURL()##strURL#"
					 method="get"
					 useragent="eventBriteAPI" />
		<cfreturn cfhttp.FileContent />
	</cffunction>

</cfcomponent>