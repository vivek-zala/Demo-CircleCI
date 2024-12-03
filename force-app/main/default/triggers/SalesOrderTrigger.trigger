/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-04-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger SalesOrderTrigger on AcctSeedERP__Sales_Order__c (before insert, before update, before delete, after Insert, after Update , after delete) {

    List<Id> opportunityIds = new List<Id>();
    

    if (Trigger.isUpdate && Trigger.isBefore) {
        for(AcctSeedERP__Sales_Order__c salesOrder : Trigger.New) {

            if (trigger.isUpdate  
                && Trigger.oldMap.get(salesOrder.Id).AcctSeedERP__Status__c !='Closed' 
                && Trigger.newMap.get(salesOrder.Id).AcctSeedERP__Status__c == 'Closed') {
                // check if user is assigened with Accounting Manager - Modified permission set
                    Integer permissionAssignmentCount = [SELECT Count() 
                                                    FROM PermissionSetAssignment 
                                                    WHERE  PermissionSet.Name = 'Accounting_Manager' 
                                                    AND PermissionSet.NamespacePrefix  = null 
                                                    AND Assignee.Id = :UserInfo.getUserId()];
                if (permissionAssignmentCount != null && permissionAssignmentCount > 0) {
                    continue;
                }  else {
                    salesOrder.adderror('only people with Accounting Manager - Modified permission can close the order');
                }                                  
                
            }
        }
    }

    if (Trigger.isInsert && Trigger.IsBefore) {
        for(AcctSeedERP__Sales_Order__c salesOrder : Trigger.New) {
        

            /*if (trigger.isUpdate  
                && Trigger.newMap.get(salesOrder.Id).AcctSeedERP__Status__c =='Closed' ) {
                    Integer permissionAssignmentCount = [SELECT Count() 
                                                        FROM PermissionSetAssignment 
                                                        WHERE  PermissionSet.Name = 'Accounting_Manager' 
                                                        AND PermissionSet.NamespacePrefix  = null 
                                                        AND Assignee.Id = UserInfo.getUserId()];
                    if (permissionAssignmentCount != null && permissionAssignmentCount > 0) {
                        contine;
                    }  else {
                        salesOrder.adderror('only people with Accounting Manager - Modified permission can close the order');
                    } 
    
                }*/
            
            opportunityIds.add(salesOrder.AcctSeedERP__Opportunity__c);
        }  
    
        Id marsOppTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('MaRRS').getRecordTypeId();
    
        if (opportunityIds.size() > 0) {
    
            Map<Id,Opportunity> oppList = new Map<Id, Opportunity>([SELECT Id,
                                                                           Destination_City__c,
                                                                           Destination_Country__c,
                                                                           Destination_PostalCode__c,
                                                                           Destination_State__c,
                                                                           Destination_Street__c,
                                                                           RecordType.Name,
                                                                           Shipping_Name__c
                                                                    FROM Opportunity
                                                                    WHERE RecordTypeId = :marsOppTypeId
                                                                    AND Id IN :opportunityIds]);
            if (!oppList.isEmpty()) {
                for(AcctSeedERP__Sales_Order__c salesOrder : Trigger.New) {
                    If (oppList.containsKey(salesOrder.AcctSeedERP__Opportunity__c)) {
                        salesOrder.AcctSeedERP__Shipping_City__c = oppList.get(salesOrder.AcctSeedERP__Opportunity__c).Destination_City__c;
                        salesOrder.AcctSeedERP__Shipping_Country__c = oppList.get(salesOrder.AcctSeedERP__Opportunity__c).Destination_Country__c;
                        salesOrder.AcctSeedERP__Shipping_PostalCode__c = oppList.get(salesOrder.AcctSeedERP__Opportunity__c).Destination_PostalCode__c;
                        salesOrder.AcctSeedERP__Shipping_State__c = oppList.get(salesOrder.AcctSeedERP__Opportunity__c).Destination_State__c;
                        salesOrder.AcctSeedERP__Shipping_Street__c = oppList.get(salesOrder.AcctSeedERP__Opportunity__c).Destination_Street__c;
                        if(oppList.get(salesOrder.AcctSeedERP__Opportunity__c).RecordType.Name == 'MaRRS'){
                            salesOrder.Shipping_Name__c = oppList.get(salesOrder.AcctSeedERP__Opportunity__c).Shipping_Name__c;
                        }
                    }
            }       
            }    
        }
        
        if(trigger.new.size() == 1) {
            SystemUtil.generateCustomAutoNumber(trigger.new[0]);
        }
    }
    
    if (Trigger.isDelete && Trigger.isBefore) {

        List<Product_Select__c> lstLineItemToUpdate = new List<Product_Select__c>();
        List<AcctSeedERP__Sales_Order_Line__c> salesOrderLineItems = [SELECT Id, Quote_Line_Item__c FROM AcctSeedERP__Sales_Order_Line__c WHERE AcctSeedERP__Sales_Order__c IN :Trigger.oldMap.keySet()];
        System.debug('the list of order line is ' + salesOrderLineItems);
        for (AcctSeedERP__Sales_Order_Line__c orderLine : salesOrderLineItems) {
            
            Product_Select__c quoteLineItem = new Product_Select__c(
                Id = orderLine.Quote_Line_Item__c,
                Is_Locked__c = false
            );
            lstLineItemToUpdate.add(quoteLineItem);
        }

        System.debug('the update list is ' + lstLineItemToUpdate);

        if (lstLineItemToUpdate.size() > 0) {
            update lstLineItemToUpdate;
        }
    }
    
    if(Trigger.IsAfter ){
        //RollUp SO to Opportunity
        set<Id> setOppId = new set <Id>();
        
        If(Trigger.IsInsert || Trigger.IsUpdate){
            
            for(AcctSeedERP__Sales_Order__c salesOrder : Trigger.New){
                
                if(Trigger.IsInsert && salesOrder.AcctSeedERP__Opportunity__c!=null && salesOrder.InventoryCost__c!=null){
                    setOppId.add(salesOrder.AcctSeedERP__Opportunity__c);
                }
                
                if(Trigger.IsUpdate && ((salesOrder.AcctSeedERP__Opportunity__c!=null && salesOrder.AcctSeedERP__Opportunity__c != Trigger.OldMap.get(salesOrder.Id).AcctSeedERP__Opportunity__c) || (salesOrder.InventoryCost__c != Trigger.OldMap.get(salesOrder.Id).InventoryCost__c ))){
                    setOppId.add(salesOrder.AcctSeedERP__Opportunity__c);
                    setOppId.add(Trigger.OldMap.get(salesOrder.Id).AcctSeedERP__Opportunity__c);
                }
            }
            
        }
        if(Trigger.IsDelete){
            
            for(AcctSeedERP__Sales_Order__c salesOrder : Trigger.Old){
                
                if(salesOrder.AcctSeedERP__Opportunity__c!=null && salesOrder.InventoryCost__c!=null){
                    setOppId.add(salesOrder.AcctSeedERP__Opportunity__c);
                }
            }
            
        }
        
        if(!setOppId.isEmpty()){
                Map<Id,Decimal> mapOppId_Total_IC = new Map<Id,Decimal>();
                list<Opportunity> lstOppUpdate = new list<Opportunity>();
                
                for(AcctSeedERP__Sales_Order__c each : [SELECT Id,InventoryCost__c,AcctSeedERP__Opportunity__c FROM AcctSeedERP__Sales_Order__c WHERE AcctSeedERP__Opportunity__c IN:setOppId]){
                    
                    if(mapOppId_Total_IC != null && mapOppId_Total_IC.containsKey(each.AcctSeedERP__Opportunity__c) ){
                        mapOppId_Total_IC.put(each.AcctSeedERP__Opportunity__c, mapOppId_Total_IC.get(each.AcctSeedERP__Opportunity__c) + each.InventoryCost__c);
                    }else{
                        mapOppId_Total_IC.put(each.AcctSeedERP__Opportunity__c,each.InventoryCost__c);
                    }
                }
                
                for(id eachOppId : setOppId){
                    
                    opportunity opp = new opportunity(Id= eachOppId);
                    opp.Inventory_Cost_total__c = mapOppId_Total_IC.get(eachOppId)!=null ? mapOppId_Total_IC.get(eachOppId) :0;
                    lstOppUpdate.add(opp);
                }
                
            if(lstOppUpdate.size()>0){
                try{
                    update lstOppUpdate;
                }catch(exception ex){
                    System.Debug('==ex=='+ex);
                }
            }
        }
    }
}