/**
 * @description       : 
 * @author            : Nilesh Badrakiya
 * @group             : 
 * @last modified on  : 10-29-2023
 * @last modified by  : Nilesh Badrakiya
**/
trigger SalesOrderLineTrigger on AcctSeedERP__Sales_Order_Line__c (before insert, before Update,after delete) {

    If((trigger.isInsert || trigger.isUpdate) && trigger.isBefore){
    set <Id> setIV_Id = new set<Id>(); 
    map<Id,AcctSeed__Inventory_Cost__c> mapId_IV; 
        for(AcctSeedERP__Sales_Order_Line__c SOLine : trigger.new){
            if(Trigger.IsInsert && SOLine.Inventory_Cost__c != null){
                setIV_Id.add(SOLine.Inventory_Cost__c); 
            } else if (Trigger.isUpdate && SOLine.Inventory_Cost__c  != Trigger.OldMap.get(SOLine.Id).Inventory_Cost__c){
                setIV_Id.add(SOLine.Inventory_Cost__c); 
            }
        }
        
       if(!setIV_Id.isEmpty()){
           mapId_IV = new map<Id,AcctSeed__Inventory_Cost__c>([SELECT Id,AcctSeed__Unit_Cost__c FROM AcctSeed__Inventory_Cost__c WHERE ID IN: setIV_Id]);
           
           for(AcctSeedERP__Sales_Order_Line__c SOLine : trigger.new){
               if(SOLine.Inventory_Cost__c!=null){
                 SOLine.InvestoryCost__c = SOLine.AcctSeedERP__Quantity_Ordered__c * mapId_IV.get(SOLine.Inventory_Cost__c).AcctSeed__Unit_Cost__c; 
                 }
           }
       } 
    }
    
    if(Trigger.isInsert && Trigger.isBefore){
        Set<Id> quoteLineId = new Set<Id>();
        for (AcctSeedERP__Sales_Order_Line__c SOLine : trigger.new) {
            if (SOLine.Quote_Line_Item__c != null) {
                quoteLineId.add(SOLine.Quote_Line_Item__c);    
            }
        }

        Map<Id,Product_Select__c> quoteLine = new Map<Id,Product_Select__c>([SELECT Id,
                                                                                    Descriptions__c,
                                                                                    Quote__c,
                                                                                    Quote__r.OpportunityId,
                                                                                    Quote__r.Opportunity.RecordType.Name
                                                                            FROM Product_Select__c
                                                                            WHERE Id IN :quoteLineId]);
        AcctSeed__Accounting_Variable__c GLVariable1 = null;
        for (AcctSeedERP__Sales_Order_Line__c SOLine : trigger.new) {
            if (quoteLine.containsKey(SOLine.Quote_Line_Item__c)) {
                Product_Select__c quoteLineSO = quoteLine.get(SOLine.Quote_Line_Item__c);
                SOLine.Description__c = quoteLineSO.Descriptions__c;   

                if (quoteLineSO.Quote__c != null 
                    && quoteLineSO.Quote__r.OpportunityId != null
                    && quoteLineSO.Quote__r.Opportunity.RecordType.Name == UtilitySharePointToSFIntegration.OPP_REPAIR_RECORDTYPE) {
                        if (GLVariable1 == null) {
                            GLVariable1 = [SELECT Id 
                                            FROM AcctSeed__Accounting_Variable__c 
                                            WHERE Name = 'MIB'
                                            AND AcctSeed__Type__c = 'GL Account Variable 1'];                        
                        }
                        SOLine.AcctSeedERP__GL_Account_Variable_1__c = GLVariable1.Id;


                }
            }
            
        }
    }
    

    if(Trigger.isDelete && Trigger.isAfter){
        
        List<Product_Select__c> lstLineItemToUpdate = new List<Product_Select__c>();
        Set<Id> salesOrderLineIds = new Set<Id>();
        List<AcctSeed__Billing_Line__c> billingItemsToDelete  = new List<AcctSeed__Billing_Line__c>(); 
        
        for(AcctSeedERP__Sales_Order_Line__c orderLine : trigger.old){

            salesOrderLineIds.add(orderLine.Id);
            
            if(orderLine.Quote_Line_Item__c != null){
                Product_Select__c quoteLineItem = new Product_Select__c(
                    Id = orderLine.Quote_Line_Item__c,
                    Is_Locked__c = false
                );
                lstLineItemToUpdate.add(quoteLineItem);
            }
        }

        if (!salesOrderLineIds.isEmpty()){
            billingItemsToDelete =  [   SELECT Id
                                        FROM AcctSeed__Billing_Line__c
                                        WHERE AcctSeedERP__Sales_Order_Line__c IN : salesOrderLineIds
                                    ];
        }

        if (lstLineItemToUpdate.size() > 0) {
            update lstLineItemToUpdate;
        }

        if (billingItemsToDelete.size() > 0) {
            delete billingItemsToDelete;
        }

    }
}