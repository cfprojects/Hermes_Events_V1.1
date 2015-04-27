<!---
Filename: objectFactory.cfc
Creation Date: 11/March/2010
Original Author: Matt Gifford aka coldfumonkeh
Revision: $Rev$
$LastChangedBy$
$LastChangedDate$
Description:
the objectFactory component
--->
<cfcomponent name="objectFactory" output="false">

	<cfset variables.instance = structNew() />

    <cffunction name="init" access="public" output="false" returntype="Any" hint="I am the constructor method for the objectFactory class">
    	<cfargument name="userAccess" required="true" type="Any" hint="I am the userAccess class object" />
	        <cfscript>
	        	variables.instance.singletons = structNew();
				setUserAccess(arguments.userAccess);
	        	createSingletons();
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

    <!--- PUBLIC FUNCTIONS --->
    <cffunction name="load" access="public" output="false" returntype="Any" hint="I return an instantiated object from the factory.">
        <cfargument name="name" required="true" type="string" hint="The name of the object to return." />
	        <cfif not structKeyExists(variables.instance.singletons,arguments.name)>
	            <cfthrow message="Cannot create object #arguments.name#" />
	        </cfif>
        <cfreturn variables.instance.singletons[arguments.name] />
    </cffunction>

    <!--- PRIVATE FUNCTIONS --->
	<cffunction name="createSingletons" access="private" output="false" returntype="void" hint="I create the singleton objects."> 
		<cfset var stulocal = structNew() />
			<cfscript>
				// Create the objects
				stulocal.discount 	= createObject("component","discount").init(userAccess=getUserAccess());
				stulocal.events 	= createObject("component","events").init(userAccess=getUserAccess());
				stulocal.organizer 	= createObject("component","organizer").init(userAccess=getUserAccess());
				stulocal.payment 	= createObject("component","payment").init(userAccess=getUserAccess());
				stulocal.tickets 	= createObject("component","tickets").init(userAccess=getUserAccess());
				stulocal.users 		= createObject("component","users").init(userAccess=getUserAccess());
				stulocal.venue 		= createObject("component","venue").init(userAccess=getUserAccess());
				
				// Add the service objects to the "singleton" struct
				addSingleton("Discounts",stulocal.discount);
				addSingleton("Events",stulocal.events);
				addSingleton("Organizer",stulocal.organizer);
				addSingleton("Payment",stulocal.payment);
				addSingleton("Tickets",stulocal.tickets);
				addSingleton("Users",stulocal.users);
				addSingleton("Venue",stulocal.venue);
	        </cfscript>
	</cffunction>

    <cffunction name="addSingleton" access="private" output="false" returntype="void" hint="I add a singleton object to the variables.instance.singletons structure.">
        <cfargument name="name" 	required="true" type="string" 	hint="The name of the struct entry." />
        <cfargument name="object" 	required="true" type="Any" 		hint="The object to be placed into the singleton struct." />
        <cfset variables.instance.singletons[arguments.name] = arguments.object />
    </cffunction>

</cfcomponent>