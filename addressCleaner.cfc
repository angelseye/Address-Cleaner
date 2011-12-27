<!---------------------------------------------------------------------
***********************************************************************
	Copyright 2011 Coldbox Generator by Erick Wilson and AngelsEye, Inc.
	www.angelseyeinc.com | ewilson@angelseyeinc.com
***********************************************************************

	Author: 	Erick Wilson
	Date:			Dec 7, 2011
	License:	Apache 2 License
	Version:	0.1.0
	Description:
		Allows the user to generate model, modelService, and handler CFC's
		as well as view CFM's for their Coldbox based applications.  There
		are not add'l requirements when using this plugin.  Simply put the
		generator plugin in your plugins directory and create an event
		handler to access and call the plugin.

	Future Work:
		-	Break out model, handler, and view to separate functions
		-	Refactor to use cfdbinfo to make it DB generic
		-	Allow model to build DB tables and columns

---------------------------------------------------------------------->

<cfcomponent name="addressCleaner" extends="coldbox.system.Plugin" hint="Takes an address string and tries to clean it up and make it more presentable" output="false">


	<!--- dependencies --->
	<cfproperty name="messageBox" inject="coldbox:plugin:messageBox">


	<!--- init(): initialize the object --->
	<cffunction name="init" access="public" returntype="addressCleaner" output="false">
		<cfargument name="controller" type="any" required="true">
		<cfscript>
			super.init(arguments.controller);

			// Plug-in Properties
			setpluginName("Address Cleaner");
			setpluginVersion("0.1.0");
			setpluginDescription("I am an address cleaner where you give me a string and I try to give back a presentable address");
			setpluginAuthor("Erick Wilson");
			setpluginAuthorURL("http://www.angelseyeinc.com");
		</cfscript>
		<!--- return data --->
		<cfreturn this>
	</cffunction>


<!--- ********************** PUBLIC METHODS ********************** --->


	<!--- cleanAddress(): main function that tries to clean up a given address --->
	<cffunction name="cleanAddress" access="public" returntype="any" output="false">
		<!--- ***** ARGUMENTS / VARIABLES ***** --->
		<cfargument name="address" type="string" required="true" />
		<cfscript>
			var addressStruct = {};
			var errors = [];
			var newAddress = "";
			//do some address parsing
			var jGeoCoder = getPlugin("JavaLoader").setup([ExpandPath("plugins\addressCleaner\jgeocoder.jar")]);
			var parser = getPlugin("JavaLoader").create("net.sourceforge.jgeocoder.us.AddressParser").parseAddress(arguments.address);
			//if parsed correctly, do this...
			if(structKeyExists(local,"parser")){
				var addressStruct = cleanParserData(parser.toString());
				//build new address...
				if(arrayLen(errors) == 0){
					newAddress &= (structKeyExists(addressStruct,'number')) ? addressStruct.number & ' ' : '';
					newAddress &= (structKeyExists(addressStruct,'predir')) ? addressStruct.predir & ' ' : '';
					newAddress &= (structKeyExists(addressStruct,'street')) ? addressStruct.street & ' ' : '';
					newAddress &= (structKeyExists(addressStruct,'type')) ? addressStruct.type & ' ' : '';
					newAddress &= (structKeyExists(addressStruct,'postdir')) ? addressStruct.postdir & ' ' : '';
					newAddress &= (structKeyExists(addressStruct,'city')) ? addressStruct.city & ', ' : '';
					newAddress &= (structKeyExists(addressStruct,'state')) ? addressStruct.state & ' ' : '';
					newAddress &= (structKeyExists(addressStruct,'zip')) ? addressStruct.zip : '';
				//...or return errors
				}else{
					newAddress = errors;
				}
			//...else return error
			}else{
				ArrayAppend(errors,"Could not properly read an address. Please go back and be sure it is a valid and formatted address.");
				newAddress = arguments.address;
			}
			//return data
			return newAddress;
		</cfscript>
	</cffunction>




<!--- ********************** PRIVATE METHODS ********************** --->


	<!--- cleanParserData(): cleans up the returned parsing data (may be my limited understanding of java and the jgeocoder) --->
	<cffunction name="cleanParserData" access="private" returntype="struct" output="false">
		<!--- ***** ARGUMENTS / VARIABLES ***** --->
		<cfargument name="data" type="string" required="true" />
		<cfscript>
			var returnObj = {};
			//strip off the brackets
			arguments.data = REReplaceNoCase(arguments.data,'[\{\}]','','ALL');
			//get array of keys
			var keyArray = ListToArray(arguments.data);
			//loop through and create struct
			for(r=1; r<=arrayLen(keyArray); r++){
				StructInsert(returnObj, Trim(ListFirst(keyArray[r],'=')), Trim(ListLast(keyArray[r],'=')));
			}
			//return data
			return returnObj;
		</cfscript>
	</cffunction>


	<!--- getZip(): tries to get the zip code from an address string --->
	<cffunction name="getZip" access="private" returntype="any" output="false">
		<!--- ***** ARGUMENTS / VARIABLES ***** --->
		<cfargument name="address" type="string" required="true" />
		<cfscript>
			var returnObj = '';
			var regex = "\d{5}(-\d{4})?";
			var match = REMatch(regex,arguments.address);
			//do errors if no match
			if(arrayLen(match) < 1){
				returnObj = ["There does not appear to be a valid U.S. Zip Code in this address."];
			}else{
				returnObj = match[1];
			}
			//return data
			return returnObj;
		</cfscript>
	</cffunction>




</cfcomponent>