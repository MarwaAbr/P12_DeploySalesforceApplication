/*
    *@author:Marwa Abroud marwa-majdoub@hotmail.com
    *@description:A REST Web Service Class who receives calls from API REST to manage contacts
    */
@RestResource(urlMapping='/Contacts/*')
global with sharing class ContactManager {
   
    /*
    *@author:Marwa Abroud marwa-majdoub@hotmail.com
    *@description:Creat a Contact  -if it does not already exist- and return the Contact Id 
    */
    @HttpPost
    global static ID createContact(String name,String firstName, String mail) {

        //Check if a contact with this email address already exists
       List<Contact> conts = [SELECT Id FROM Contact WHERE Email=: mail];
        if (conts.size()>0){
            return conts[0].Id;
        }
        Contact thisContact = new Contact( Email=mail,LastName=name, FirstName=firstName);
        insert thisContact;
        return thisContact.Id;
    }  
    /*
    *@author:Marwa Abroud marwa-majdoub@hotmail.com
    *@description:Update Contact Fields
    */
    @HttpPatch
    global static ID updateContactFields() {
        RestRequest request = RestContext.request;
        String contactId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        Contact thisContact = [SELECT Id FROM Contact WHERE Id = :contactId];
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        // Iterate through each parameter field and value
        for(String fieldName : params.keySet()) {
            // Set the field and value on the Contact sObject
            thisContact.put(fieldName, params.get(fieldName));
        }
        update thisContact;
        return thisContact.Id;
    }   
    /*
    *@author:Marwa Abroud marwa-majdoub@hotmail.com
    *@description:Deactivate Contact
    */
    @HttpDelete
    global static Id deactivateContact(){
        RestRequest request = RestContext.request;
        String contactId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        Contact thisContact = [SELECT Id FROM Contact WHERE Id =:contactId];
        if(thisContact.Active__c=false){
            return contactId;}
        else {
            thisContact.Active__c =false;
            update thisContact;
            return contactId;
        }
    }
}