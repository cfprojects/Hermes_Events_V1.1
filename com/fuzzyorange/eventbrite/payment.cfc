<!---
Filename: payment.cfc
Creation Date: 11/March/2010
Original Author: Matt Gifford aka coldfumonkeh
Revision: $Rev$
$LastChangedBy$
$LastChangedDate$
Description:
the payment class object

Methods contained:
	- payment_update
	
--->
<cfcomponent name="payment" output="false" extends="base">

	
	<cfset variables.instance = structNew() />
	
	<cffunction name="init" access="public" output="false" returntype="Any" hint="I am the constructor method for the payment class.">
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
	<cffunction name="updatePayment" access="public" output="false" returntype="Any" hint="This method creates or updates the payment options for this event. Only the fields passed as arguments will be modified. It returns the list of active method of payment.">
		<cfargument name="event_id" 				required="true" 	type="numeric" 	hint="The event ID." />
		<cfargument name="accept_paypal"			required="false" 	type="numeric" 	hint="Accept PayPal payments (1 or 0)." />
		<cfargument name="paypal_email"				required="false" 	type="string" 	hint="Your PayPal email. Defaults to the user email address if not provided." />
		<cfargument name="accept_google"			required="false" 	type="numeric" 	hint="Accept Google Checkout payments (1 or 0)." />
		<cfargument name="google_merchant_id"		required="false" 	type="string" 	hint="Google Checkout Merchant ID. Required if accept_google is 1." />
		<cfargument name="google_merchant_key"		required="false" 	type="string" 	hint="Google Checkout Merchant Key. Required if accept_google is 1." />	
		<cfargument name="accept_check"				required="false" 	type="numeric" 	hint="Accept 'Pay by Check' payments (1 or 0)." />
		<cfargument name="instructions_check"		required="false" 	type="string" 	hint="Instructions to attendees who want to pay by check." />
		<cfargument name="accept_cash"				required="false" 	type="numeric" 	hint="Accept 'Pay with Cash' payments (1 or 0)." />
		<cfargument name="instructions_cash"		required="false" 	type="string" 	hint="Instructions to attendees who want to pay with cash." />
		<cfargument name="accept_invoice"			required="false" 	type="numeric" 	hint="Accept 'Send an Invoice' payments (1 or 0)." />
		<cfargument name="instructions_invoice"		required="false" 	type="string" 	hint="Instructions to attendees who need to be sent an invoice." />
			<cfset var strURL 		= '' />
			<cfset var stuResponse 	= structNew() />
				<cfscript>
					strURL 		= strURL & 'payment_update?' & buildAuthString(getUserAccess()) & buildParamString(arguments,true);
					stuResponse = makeCall(strURL);  
                </cfscript>
		<cfreturn stuResponse />
	</cffunction>	

</cfcomponent>