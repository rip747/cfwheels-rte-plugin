<cfcomponent output="false" mixin="Controller">

    <cfscript>
    /* 
        richTextField() should work with objectname and property
        richTextTag() shoud be standalone
    */
    
    function init(){
        this.version = "1.0.1";
        return this;
    }

    </cfscript>
    
    <cffunction name="richTextField" returntype="string" access="public" output="false">
		<cfargument name="objectName" type="any" required="true" hint="See documentation for @textField.">
		<cfargument name="property" type="string" required="true" hint="See documentation for @textField.">
		<cfargument name="association" type="string" required="false" hint="See documentation for @textfield.">
		<cfargument name="position" type="string" required="false" hint="See documentation for @textfield.">
		<cfargument name="label" type="string" required="false" hint="See documentation for @textField.">
		<cfargument name="labelPlacement" type="string" required="false" hint="See documentation for @textField.">
		<cfargument name="prepend" type="string" required="false" hint="See documentation for @textField.">
		<cfargument name="append" type="string" required="false" hint="See documentation for @textField.">
		<cfargument name="prependToLabel" type="string" required="false" hint="See documentation for @textField.">
		<cfargument name="appendToLabel" type="string" required="false" hint="See documentation for @textField.">
		<cfargument name="errorElement" type="string" required="false" hint="See documentation for @textField.">
		<cfargument name="errorClass" type="string" required="false" hint="See documentation for @textField.">
    	<cfargument name="editor" type="string" required="false" default="markitup" hint="Must contain the name of one of the supported RTE's.">
    	<cfargument name="includeJSLibrary" type="boolean" required="false" default="true" hint="Tells the plugin wether or not it should add the primary JS library to the html head section.">
    	<cfscript>
			var loc = {};

    		loc.ret = textArea(argumentCollection=arguments);
    		
			if (!StructKeyExists(arguments, "id"))
				arguments.id = $tagId(arguments.objectName, arguments.property);
    		
    		// call our editor methods
    		if (arguments.editor is 'markitup'){
    		    $markItUp(argumentCollection=arguments);
    		}
    		if (arguments.editor is 'ckeditor'){
    		    $ckeditor(argumentCollection=arguments);
    		}
    	</cfscript>
    	<cfreturn loc.ret>
    </cffunction>
    
    
    <cffunction name="richTextTag" returntype="string" access="public" output="false">
		<cfargument name="name" type="string" required="true" hint="See documentation for @textFieldTag.">
		<cfargument name="content" type="string" required="false" default="" hint="Content to display in `textarea` on page load.">
		<cfargument name="label" type="string" required="false" hint="See documentation for @textField.">
		<cfargument name="labelPlacement" type="string" required="false" hint="See documentation for @textField.">
		<cfargument name="prepend" type="string" required="false" hint="See documentation for @textField.">
		<cfargument name="append" type="string" required="false" hint="See documentation for @textField.">
		<cfargument name="prependToLabel" type="string" required="false" hint="See documentation for @textField.">
		<cfargument name="appendToLabel" type="string" required="false" hint="See documentation for @textField.">
        <cfargument name="editor" type="string" required="false" default="markitup" hint="Must contain the name of one of the supported RTE's.">
    	<cfargument name="includeJSLibrary" type="boolean" required="false" default="true" hint="Tells the plugin wether or not it should add the primary JS library to the html head section.">
        <cfscript>
            var loc = {};
            
            loc.ret  = textAreaTag(argumentCollection=arguments);
            
			if (!StructKeyExists(arguments, "id"))
				arguments.id = $tagId(StructNew(), arguments.name);
            
            // call our editor methods
    		if (arguments.editor is 'markitup'){
    		    $markItUp(argumentCollection=arguments);
    		}
    		if (arguments.editor is 'ckeditor') {
    		    $ckeditor(argumentCollection=arguments);
    		}
        </cfscript>
        <cfreturn ret>
    </cffunction>

    <!--- *********************** EDITOR SPECIFIC METHODS *************************** --->
	
	<cffunction name="$PluginRTEIncludeJQuery" output="false">
		<cfargument name="includeJSLibrary" type="boolean" required="false" default="true">
		<cfif arguments.includeJSLibrary && !StructKeyExists(request, "PluginRTEIncludedJQuery")>
			<cfset request.PluginRTEIncludedJQuery = true>
			<cfhtmlhead text="<script src='http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js' type='text/javascript'></script>" />
		</cfif>
	</cffunction>
	
	
    <cffunction name="$markItUp" output="false">
		<cfargument name="id" type="string" required="true">
		<cfargument name="includeJSLibrary" type="boolean" required="false" default="true">
        <cfset var loc = {}>
		<cfset loc.ret = []>
		<cfset ArrayAppend(loc.ret, '<script type="text/javascript">$(document).ready(function(){$("###arguments.id#").markItUp(mySettings);});</script>')>
            
        <cfif !structKeyExists(request,'PluginRTEIncludedMarkitup')>
			<cfset request.PluginRTEIncludedMarkitup = true>
			<cfset ArrayPrepend(loc.ret, '<link rel="stylesheet" type="text/css" href="#application.wheels.webPath#plugins/richtext/editors/markitup/skins/simple/style.css" /><link rel="stylesheet" type="text/css" href="#application.wheels.webPath#plugins/richtext/editors/markitup/sets/html/style.css" />')>
			<cfset ArrayPrepend(loc.ret, '<script src="#application.wheels.webPath#plugins/richtext/editors/markitup/jquery.markitup.pack.js" type="text/javascript"></script><script src="#application.wheels.webPath#plugins/richtext/editors/markitup/sets/html/set.js" type="text/javascript"></script>')>
		</cfif>
		
		<cfhtmlhead text="#ArrayToList(loc.ret, '')#">
    </cffunction>
    
    <cffunction name="$ckeditor" output="false" >
		<cfargument name="id" type="string" required="true">
		<cfargument name="includeJSLibrary" type="boolean" required="false" default="true">
		<cfset var loc = {}>
		
		<cfset loc.ret = []>
		<cfset ArrayAppend(loc.ret, '<script type="text/javascript">$(document).ready(function(){$("###arguments.id#").ckeditor(')>
        <cfif structKeyExists(arguments, 'options')>
           <cfset ArrayAppend(loc.ret, 'function() {#arguments.options#}')>
        </cfif>
		<cfset ArrayAppend(loc.ret, ');});</script>')>
		
        <cfif !structKeyExists(request,'PluginRTEIncludedCKEditor')>
			<cfset request.PluginRTEIncludedCKEditor = true>
			<cfset ArrayPrepend(loc.ret, '<script type="text/javascript" src="#application.wheels.webPath#plugins/richtext/editors/ckeditor/ckeditor.js"></script><script type="text/javascript" src="#application.wheels.webPath#plugins/richtext/editors/ckeditor/adapters/jquery.js"></script>')>
		</cfif>
        
        <cfhtmlhead text="#ArrayToList(loc.ret, '')#">
    </cffunction>
    
</cfcomponent>