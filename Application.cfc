<!---
Filename: Application.cfc
Creation Date: 11/March/2010
Original Author: Matt Gifford aka coldfumonkeh
Revision: $Rev$
$LastChangedBy$
$LastChangedDate$
Description:
the Application.cfc file for the Hermes Event project
--->
<cfcomponent output="false">

	<cfscript>
		this.name = hash(getCurrentTemplatePath());
		this.applicationtimeout = createTimeSpan(0,2,0,0);
	</cfscript>

	<cffunction name="onApplicationStart" output="false">
		<cfscript>
			this.applicationKey = '<enter your eventbrite api key>';
	 		this.emailAddress	= '<enter your eventbrite account email address>';
			this.password		= '<enter your eventbrite account password>';
			this.userKey		= '<enter your eventbrite user key>';
			
			Application.objEventbrite = createObject('component',
				'com.fuzzyorange.eventbrite.eventbrite')
				.init(applicationKey=this.applicationKey,
					emailAddress=this.emailAddress,
					password=this.password,
					userKey=this.userKey,
					parseResults=false,
					authLevel='Basic');
		</cfscript>
	</cffunction>
	
	<cffunction name="onRequestStart">
		<cfif structKeyExists(URL, "reinit")>
			<cfscript>
				onApplicationStart();
			</cfscript>
		</cfif>
	</cffunction>

</cfcomponent>