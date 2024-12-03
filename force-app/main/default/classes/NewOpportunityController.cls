/**
 * @description       : 
 * @author            : Nilesh Badrakiya
 * @group             : 
 * @last modified on  : 03-01-2024
 * @last modified by  : Nilesh Badrakiya
**/
public with sharing class NewOpportunityController{
    
    public Id generalContractorContactId {get; set;}
    public Opportunity opp {get;set;}
    public Id marrsRecordTypeId {get;set;}
    public Id generalContractingRecordTypeId {get;set;}
    public Id partsRecordTypeId {get;set;}
    public Id equipmentPlanSpecRecordTypeId {get;set;}
    public Id equipmentDesignBuildRecordTypeId {get;set;}

    public NewOpportunityController(Apexpages.StandardController stdCon){
        opp = new Opportunity();
        opp.recordTypeId = apexpages.currentpage().getparameters().get('RecordType');
        marrsRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MaRRS').getRecordTypeId();
        generalContractingRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('General Contracting').getRecordTypeId();
        partsRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Parts').getRecordTypeId();
        equipmentPlanSpecRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Equipment - Plan/Spec').getRecordTypeId();
        equipmentDesignBuildRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Equipment - Design/Build').getRecordTypeId();
        
        if(opp.recordTypeId == null) {
            opp.recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MaRRS').getRecordTypeId();
        }
        system.debug('Opportunity=>'+opp);
    }
    
    public void populateGeneralContractorAccount(){
        Contact con = [Select accountId From contact Where Id =: generalContractorContactId];
        opp.General_Contractor__c = con.accountId;
    }
     
    public PageReference saveOpportunity(){
        
        insert opp;
        
        PageReference pr = new PageReference('/'+ opp.Id);
        pr.setRedirect(true);
        return pr;
    } 
        
}