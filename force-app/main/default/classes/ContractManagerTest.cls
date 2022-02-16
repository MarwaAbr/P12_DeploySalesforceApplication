/*
    *@author:Marwa Abroud marwa-majdoub@hotmail.com
    *@description: test the methods of the class "ContractManager"
    */
@isTest
private with sharing class ContractManagerTest {

    /*
    *@author:Marwa Abroud marwa-majdoub@hotmail.com
    *@description:Test the creation of a contract
    */
    @isTest
    static void testCreateContract() {
        Id contId =createContact('Abroud', 'Marwa', 'marwa-majdoub@hotmail.com');
        // Call the method to test
        ID thisContractId = ContractManager.createContract(contId , System.today(), 1, 'Draft');
        // Verify results
        System.assert(thisContractId != null);
        Contract thisContract = [SELECT Id,Status FROM Contract WHERE Id=:thisContractId];
        System.assert(thisContract != null);
        System.assertEquals(thisContract.Status, 'Draft');
    }

    /*
    *@author:Marwa Abroud marwa-majdoub@hotmail.com
    *@description:test the creation of a contract for a contact who does not have an account
    */

    @isTest
    static void testCreateContractAndAccount() {
        Id contId = createContactWithoutAccount('Abroud', 'Marwa', 'marwa-majdoub@hotmail.com');
        Test.startTest();
        List<Account> acts =[SELECT Id FROM Account];
        System.assertEquals(acts.size() , 0);
        // Call the method to test
        ID thisContractId = ContractManager.createContract(contId , System.today(), 1, 'Draft');
        Test.stopTest();
        // Verify results
        Contact cont = [SELECT Id, AccountId FROM Contact WHERE Id=: contId];
        Account act1 =[SELECT Id FROM Account WHERE Id=: cont.AccountId];
        System.assert(act1 != null);
        System.assert(thisContractId != null);
        Contract thisContract = [SELECT Id,Status FROM Contract WHERE Id=:thisContractId];
        System.assert(thisContract != null);
        System.assertEquals(thisContract.Status, 'Draft');
    }
    /*
    *@author:Marwa Abroud marwa-majdoub@hotmail.com
    *@description:Test  Contract Status Update
    */
    @isTest 
    static void testUpdateContractFields() {
        Id recordId = createTestContract();
        RestRequest request = new RestRequest();
        request.requestUri ='https://yourInstance.my.salesforce.com/services/apexrest/Contracts/'
            + recordId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Status": "Activated", "ContractTerm":2}');
        RestContext.request = request;
        // Update status of existing record to Working
        ID thisContractId = ContractManager.updateContractFields();
        // Verify record was updated
        System.assert(thisContractId != null);
        Contract thisContract = [SELECT Id,Status,ContractTerm FROM Contract WHERE Id=:thisContractId];
        System.assert(thisContract != null);
        System.assertEquals(thisContract.Status, 'Activated');
        System.assertEquals(thisContract.ContractTerm, 2);
    }  

    //Test data
    static Id createTestContract(){
        Id contId = createContact('Abroud', 'Marwa', 'marwa-majdoub@hotmail.com');
        Contact cont = [SELECT Id, AccountId FROM Contact WHERE Id=: contId];
        // Create test record
        Contract contractTest = new Contract(
            AccountId= cont.AccountId,
            StartDate=System.today(),
            ContractTerm=1,
            Status='Draft');
        insert contractTest;
        return contractTest.Id;
    }
    //Test data
    static Id createContact(String firstName, String lastName, String mail){
        Contact cont = new Contact (FirstName =firstName, LastName=lastName, Email=mail);
        insert cont;
        Account act = new Account(Name='actTest');
        insert act;
        cont.AccountId= act.Id;
        update cont;
        return cont.Id;
    }

   //Test data 
    static Id createContactWithoutAccount(String firstName, String lastName, String mail){
        Contact cont = new Contact (FirstName =firstName, LastName=lastName, Email=mail);
        insert cont;
        return cont.Id;

    }
 
}
