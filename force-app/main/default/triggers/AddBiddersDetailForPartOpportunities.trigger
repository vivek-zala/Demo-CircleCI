/**
 * @description       : 
 * @author            : Nilesh Badrakiya
 * @group             : 
 * @last modified on  : 01-17-2024
 * @last modified by  : Nilesh Badrakiya
**/
trigger AddBiddersDetailForPartOpportunities on Opportunity (after insert, after update) {
    
    for(Opportunity opp : trigger.new){
        
        
            if(trigger.isInsert){
                if(opp.Office__c != '' && SalesEngineerSplitTriggerHandler.mapOfficeNameSalesRepId.containsKey(opp.Office__c)){
                    SalesEngineerSplitTriggerHandler.createSalesRepEntry(opp.Id, opp.Office__c);
                }
            }
            else if(trigger.isUpdate){
                if(trigger.newMap.get(opp.Id).Office__c != trigger.oldMap.get(opp.Id).Office__c && opp.Office__c != '' && SalesEngineerSplitTriggerHandler.mapOfficeNameSalesRepId.containsKey(opp.Office__c)){
                    SalesEngineerSplitTriggerHandler.updateSalesRepEntry(opp.Id, opp.Office__c);
                }
            }
    }
    
}