/*
    *@author:Marwa Abroud marwa-majdoub@hotmail.com
    *@description:A REST Web Service Class who receives calls from API REST to manage Contracts
    */
@RestResource(urlMapping='/Contracts/*')
global with sharing class ContractManager {
    
     /*
    *@author:Marwa Abroud marwa-majdoub@hotmail.com
    *@description:Creat a Contract and return the Contract Id 
    */
    @HttpPost
    global static Id createContract(Id contId, Date startDate, Integer term, String status) {

        //if the contact does not exist return null
        List<Contact> conts = [SELECT Id, Name, AccountId FROM Contact WHERE Id =: contId ];
        if (conts.size()==0){ 
           return null;
        }
        Contact cont = conts[0];
        Id actId= cont.AccountId;
        //if the contact already has an account, we create the contract
        if (actId != null){
            Contract thisContract = new Contract( AccountId=actId, StartDate=startDate, ContractTerm =term, Status =status);
            insert thisContract;
           return thisContract.Id;
        }
        //if the contact does not have an account, we create an account then a contract
        Account act = new Account(Name='act'+ cont.Name);
        insert act;
        cont.AccountId= act.Id;
        update cont;
        Contract thisContract = new Contract( AccountId=act.Id, StartDate=startDate, ContractTerm =term, Status =status);
        insert thisContract;
        return thisContract.Id;
    
    }  
    /*
    *@author:Marwa Abroud marwa-majdoub@hotmail.com
    *@description:Update Contact Fields
    */
    @HttpPatch
    global static ID updateContractFields() {
        RestRequest request = RestContext.request;
        String contractId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        List<Contract> theContract = [SELECT Id FROM Contract WHERE Id = :contractId];
        //If the contract does not exist return null
        if(theContract.size()==0){
            return null;
        }

        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        // Iterate through each parameter field and value
        for(String fieldName : params.keySet()) {
            // Set the field and value on the Contract sObject
            theContract[0].put(fieldName, params.get(fieldName));
        }
        update theContract[0];
        return theContract[0].Id;
    }   
}
