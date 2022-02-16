
/*
    *@author:Marwa Abroud marwa-majdoub@hotmail.com
    *@description: test the methods of the class ContactManager
    */
@isTest
private with sharing class ContactManagerTest {

    /*
    *@author:Marwa Abroud marwa-majdoub@hotmail.com
    *@description:Test  Contact lastName Update
    */
    @isTest 
    static void testUpdateContactFields() {
        Id recordId = createTestContactId('Marwa', 'Abroud', 'marwa-majdoub@hotmail.com');
        RestRequest request = new RestRequest();
        request.requestUri ='https://yourInstance.my.salesforce.com/services/apexrest/Contacts/'
            + recordId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"LastName": "Majdoub Abroud"}');
        RestContext.request = request;
        // Update lastName of existing record to "Majdoub Abroud"
        ID thisContactId = ContactManager.updateContactFields();
        // Verify record was updated
        System.assert(thisContactId != null);
        Contact thisContact = [SELECT Id,LastName FROM Contact WHERE Id=:thisContactId];
        System.assert(thisContact != null);
        System.assertEquals(thisContact.LastName, 'Majdoub Abroud');
    }  
    /*
    *@author:Marwa Abroud marwa-majdoub@hotmail.com
    *@description:Test the creation of a contact
    */
    @isTest 
    static void testCreateContact() {
        // Call the method to test
        ID thisContactId = ContactManager.createContact(
            'Abroud', 'Marwa', 'marwa-majdoub@hotmail.com');
        // Verify results
        System.assert(thisContactId != null);
        Contact thisContact = [SELECT Id, Email FROM Contact WHERE Id=:thisContactId];
        System.assert(thisContact != null);
        System.assertEquals(thisContact.Email, 'marwa-majdoub@hotmail.com');
    }

    /*
    *@author:Marwa Abroud marwa-majdoub@hotmail.com
    *@description:test the creation of a contact whose email address already exists
    */
    @isTest 
    static void testCreateExistContact() {
        // Call the method to test
        ID contactId =createTestContactId('Marwa', 'Abroud', 'marwa-majdoub@hotmail.com');
        Test.startTest();
        System.assert(contactId != null);
        ID thisContactId = ContactManager.createContact(
            'Abroud', 'Marwa', 'marwa-majdoub@hotmail.com');
        Test.stopTest();
        // Verify results
        System.assert(thisContactId != null);
        System.assertEquals (contactId, thisContactId);
        Contact thisContact = [SELECT Id, Email FROM Contact WHERE Id=:thisContactId];
        System.assert(thisContact != null);
    }

    /*
    *@author:Marwa Abroud marwa-majdoub@hotmail.com
    *@description:test the creation of a contact whose email address already exists
    */
    @isTest 
    static void deactiveContact() {
        // Call the method to test
        ID contactId =createTestContactId('Marwa', 'Abroud', 'marwa-majdoub@hotmail.com');
        RestRequest request = new RestRequest();
        request.requestUri ='https://yourInstance.my.salesforce.com/services/apexrest/Contacts/'
            + contactId;
        request.httpMethod = 'DELETE';
        request.addHeader('Content-Type', 'application/json');
        RestContext.request = request;
        // Call the method to test
        ID thisContactId = ContactManager.deactivateContact();
        // Verify results
        System.assert(thisContactId != null);
        Contact thisContact = [SELECT Id, Active__c FROM Contact WHERE Id=:thisContactId];
        System.assert(thisContact != null);
        System.assertEquals(thisContact.Active__c, false);

    }
    
    static ID createTestContactId(String firstName, String lastName, String mail){
        Contact cont = new Contact (FirstName =firstName, LastName=lastName, Email=mail);
        insert cont;
        return cont.Id; 
    }

}
