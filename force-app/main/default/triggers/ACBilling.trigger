/**
 * @description       : 
 * @author            : Nilesh Badrakiya
 * @group             : 
 * @last modified on  : 03-06-2024
 * @last modified by  : Nilesh Badrakiya
**/
trigger ACBilling on AcctSeed__Billing__c (before insert, after insert, after update, after delete, before delete) {


    List<Id> opportunityIds = new List<Id>();
    Set<Id> setSalesOrderIds = new Set<Id>();
    Id marsOppTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('MaRRS').getRecordTypeId();
    if (Trigger.isBefore && Trigger.isInsert) {
        for(AcctSeed__Billing__c billing : Trigger.New) {
            if(billing.AcctSeed__Opportunity__c != null) {
                opportunityIds.add(billing.AcctSeed__Opportunity__c);
            }
            if(billing.AcctSeedERP__Sales_Order__c != null) {
                setSalesOrderIds.add(billing.AcctSeedERP__Sales_Order__c);
            }
            
        }  
        
        if (opportunityIds.size() > 0) {
            Map<Id,Opportunity> oppList = new Map<Id, Opportunity>([SELECT Id,
                                                                        Destination_City__c,
                                                                        Destination_Country__c,
                                                                        Destination_PostalCode__c,
                                                                        Destination_State__c,
                                                                        Destination_Street__c
                                                               FROM Opportunity
                                                               WHERE RecordTypeId = :marsOppTypeId
                                                               AND Id IN :opportunityIds]);
            if (!oppList.isEmpty()) {
                for(AcctSeed__Billing__c billing : Trigger.New) {
                    If (oppList.containsKey(billing.AcctSeed__Opportunity__c)) {
                        billing.AcctSeed__Shipping_City__c = oppList.get(billing.AcctSeed__Opportunity__c).Destination_City__c;
                        billing.AcctSeed__Shipping_Country__c = oppList.get(billing.AcctSeed__Opportunity__c).Destination_Country__c;
                        billing.AcctSeed__Shipping_PostalCode__c = oppList.get(billing.AcctSeed__Opportunity__c).Destination_PostalCode__c;
                        billing.AcctSeed__Shipping_State__c = oppList.get(billing.AcctSeed__Opportunity__c).Destination_State__c;
                        billing.AcctSeed__Shipping_Street__c = oppList.get(billing.AcctSeed__Opportunity__c).Destination_Street__c;
                    }
            }       
            }    
        }
    
        if(!setSalesOrderIds.isEmpty()) {
    
            Map<Id, AcctSeedERP__Sales_Order__c> mapSalesOrder = new Map<Id, AcctSeedERP__Sales_Order__c>();
            
            List<AcctSeedERP__Sales_Order__c> lstSalesOrder = [SELECT ID, Shipping_Name__c, 
                                                                        Customer_PO_Number__c,
                                                                        Ship_Via__c,
                                                                        Collect_Account_number__c
                                                                FROM AcctSeedERP__Sales_Order__c
                                                                WHERE ID IN :setSalesOrderIds];
            for(AcctSeedERP__Sales_Order__c so : lstSalesOrder) {
                mapSalesOrder.put(so.Id, so);
            }
    
            for(AcctSeed__Billing__c billing : Trigger.New) {
                if(billing.AcctSeedERP__Sales_Order__c != null) {
                    billing.Shipping_Name__c = mapSalesOrder.get(billing.AcctSeedERP__Sales_Order__c).Shipping_Name__c;
                    billing.AcctSeed__PO_Number__c = mapSalesOrder.get(billing.AcctSeedERP__Sales_Order__c).Customer_PO_Number__c;
                    billing.Ship_Via__c = mapSalesOrder.get(billing.AcctSeedERP__Sales_Order__c).Ship_Via__c;
                    billing.Collect_Account_number__c = mapSalesOrder.get(billing.AcctSeedERP__Sales_Order__c).Collect_Account_number__c;
                }
            }
        }
        
        if(trigger.new.size() > 0) {
            SystemUtil.generateCustomAutoNumber(trigger.new[0]);
        }

    }

    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate || Trigger.isDelete)) {
        set<Id> opportunityIds = new set<Id>();
        set<Id> setPaidOppId = new set<Id>();
        List<AcctSeed__Billing__c> billingsRecords = new List<AcctSeed__Billing__c>();
        List<Opportunity> oppListToBeUpdated = new List<Opportunity>();
        Map<Id,Opportunity> mapId_opp = new Map<Id,Opportunity>();
        if (trigger.isInsert || trigger.isUpdate) {
            billingsRecords = trigger.new;
        }

        if (trigger.isDelete) {
            billingsRecords = trigger.old;    
        }

        for (AcctSeed__Billing__c billing : billingsRecords) {
            opportunityIds.add(billing.AcctSeed__Opportunity__c);
            
            if((Trigger.isInsert || Trigger.isDelete) && (billing.AcctSeed__Received_Amount__c != null && billing.AcctSeed__Billing_Cash_Receipt_Count__c>0)){
                setPaidOppId.add(billing.AcctSeed__Opportunity__c);
            }else if (Trigger.isUpdate && (billing.AcctSeed__Received_Amount__c != Trigger.oldMap.get(billing.id).AcctSeed__Received_Amount__c && billing.AcctSeed__Billing_Cash_Receipt_Count__c != Trigger.oldMap.get(billing.id).AcctSeed__Billing_Cash_Receipt_Count__c ) ){
                setPaidOppId.add(billing.AcctSeed__Opportunity__c);
            }
        }
        
        if(setPaidOppId.size()>0){
            List<aggregateResult> results=[SELECT AcctSeed__Opportunity__c,
                                            sum(AcctSeed__Received_Amount__c) total
                                        FROM AcctSeed__Billing__c 
                                        WHERE AcctSeed__Opportunity__c IN :opportunityIds
                                        AND AcctSeed__Opportunity__c != null
                                        GROUP BY AcctSeed__Opportunity__c];
            for (AggregateResult agResult : results) {
                
                    Opportunity oppToUpdate = new Opportunity();
                    ID opportunityId = (ID)agResult.get('AcctSeed__Opportunity__c');
                    if(mapId_opp.containsKey(opportunityId)){
                        oppToUpdate = mapId_opp.get(opportunityId);
                    }else{
                        oppToUpdate.ID = opportunityId;
                    }
                    oppToUpdate.Paid_Billings__c = (Decimal)agResult.get('total');
                    mapId_opp.put(opportunityId,oppToUpdate);
            }
            oppListToBeUpdated  = mapId_opp.values();
            if(oppListToBeUpdated.size()>0){
                update oppListToBeUpdated;
            }
        }
        //billingsRecords.clear();
        List<aggregateResult> results=[SELECT AcctSeed__Opportunity__c,
                                            sum(AcctSeed__Total__c) total
                                        FROM AcctSeed__Billing__c 
                                        WHERE AcctSeed__Opportunity__c IN :opportunityIds
                                        AND AcctSeed__Opportunity__c != null
                                        GROUP BY AcctSeed__Opportunity__c];
        for (AggregateResult agResult : results) {
            
                Opportunity oppToUpdate = new Opportunity();
                ID opportunityId = (ID)agResult.get('AcctSeed__Opportunity__c');
                if(mapId_opp.containsKey(opportunityId)){
                    oppToUpdate = mapId_opp.get(opportunityId);
                }else{
                    oppToUpdate.ID = opportunityId;
                }
                oppToUpdate.Billings__c = (Decimal)agResult.get('total');
                mapId_opp.put(opportunityId,oppToUpdate);
        }
        oppListToBeUpdated  = mapId_opp.values();
        if(oppListToBeUpdated.size()>0){
            update oppListToBeUpdated;
        }
        

        // to calcxulate Most Recent Billing Date
        if(Trigger.IsAfter && Trigger.IsInsert) {
            List<Opportunity> oppList = new List<Opportunity>();    
            for(AcctSeed__Billing__c billing : Trigger.New) {
                if (billing.AcctSeed__Opportunity__c != null) {
                    system.debug('Billing List New Size: '+Trigger.New.size());
                    Opportunity toBeUpdate = new Opportunity();
                    toBeUpdate.Id = billing.AcctSeed__Opportunity__c;
                    // Created Date will work with only after insert 
                    tobeUpdate.MostRecentBillingDate__c = billing.CreatedDate.date();
                    oppList.add(toBeUpdate);
                }
      
            }
            update oppList;    
        }        
    }
    
    // to calcxulate most recent billing date ( if record is Deleted then second most recent date should be update)
    if(Trigger.IsAfter && Trigger.isDelete){
  
        List<AcctSeed__Billing__c> lstBilling = Trigger.old;
        system.debug('Size of old: '+lstBilling.size());
        AcctSeed__Billing__c billing = lstBilling.get(0);
        
        List<AcctSeed__Billing__c> billingsRecords = [SELECT
                                                        CreatedDate 
                                                      FROM AcctSeed__Billing__c
                                                      WHERE AcctSeed__Opportunity__c = :billing.AcctSeed__Opportunity__c
                                                      ORDER BY CreatedDate desc limit 1];
        List<Opportunity> oppList = new List<Opportunity>(); 
        if(billingsRecords.size() > 0 &&  billing.AcctSeed__Opportunity__c != null){
            
            Opportunity oppr = new Opportunity(Id = billing.AcctSeed__Opportunity__c);
            oppr.MostRecentBillingDate__c = billingsRecords.get(0).CreatedDate.date();
            oppList.add(oppr);
            system.debug('Date updated successfully :- ' +oppList);
        }
        update oppList; 

    }

    //WhenEver user delete the Billing it releated BLT deletes and its QLT isBillingCreated field should be false
    if(Trigger.IsBefore && Trigger.isDelete){
        List<AcctSeed__Billing__c> billing = Trigger.old;
        List<Product_Select__c> quoteLineToUpdateAfterDelete = new List<Product_Select__c>();
        for (AcctSeed__Billing_Line__c billingLineItem : [SELECT ID, AcctSeedERP__Sales_Order_Line__r.Quote_Line_Item__c
                                                          FROM AcctSeed__Billing_Line__c 
                                                          WHERE AcctSeed__Billing__c IN :billing
                                                          AND AcctSeedERP__Sales_Order_Line__r.Quote_Line_Item__c != null]){
                                                    
            Product_Select__c quoteLineToUpdate = new Product_Select__c();
            quoteLineToUpdate.Id = billingLineItem.AcctSeedERP__Sales_Order_Line__r.Quote_Line_Item__c;
            quoteLineToUpdate.IsBillingCreated__c = false;  
            quoteLineToUpdateAfterDelete.add(quoteLineToUpdate);
        }

        if(!quoteLineToUpdateAfterDelete.isEmpty()){
            system.debug('Billing delete & QLI isBillingCreated uncheck :- ' +quoteLineToUpdateAfterDelete.size());
            update quoteLineToUpdateAfterDelete;
        }            

    }

    if(Trigger.isAfter && (Trigger.isUpdate)){

        Set<Id> OppIdsToProcess = new Set<Id>();
        Map<Id, Id> opportunityToProjectMap = new Map<Id, Id>();
        List<Project__c> lstProjectToUpdate = new List<Project__c>();

        // 1: On update of Billing, Filter the list of billings where Payment Received field is being updated.
        for (AcctSeed__Billing__c billing : Trigger.new) {
            if (Trigger.NewMap.get(billing.Id).AcctSeed__Balance__c != Trigger.OldMap.get(billing.Id).AcctSeed__Balance__c && billing.AcctSeed__Opportunity__c != null) {
                OppIdsToProcess.add(billing.AcctSeed__Opportunity__c);
            }
        }
  
        // 2. Remove any Opportunities from the set if their LineItems do not have Billing records created
        for (Product_Select__c QL : [SELECT Quote__r.OpportunityId  
                                    FROM Product_Select__c 
                                    WHERE Quote__r.Is_Active_Project_Financials__c = true AND
                                    Quote__r.OpportunityId IN :OppIdsToProcess AND
                                    IsBillingCreated__c = false]) {
            OppIdsToProcess.remove(QL.Quote__r.OpportunityId);                                    
        }
 
        // 3. Remove any Opportunities from the set if their Billings Balance field is not equal to zero.
        for (AcctSeed__Billing__c BillingSO : [SELECT AcctSeed__Opportunity__c
                                                FROM AcctSeed__Billing__c
                                                WHERE AcctSeed__Balance__c != 0
                                                AND AcctSeed__Opportunity__c IN :OppIdsToProcess ]) {
            if(OppIdsToProcess.Contains(BillingSO.AcctSeed__Opportunity__c)) {
                OppIdsToProcess.Remove(BillingSO.AcctSeed__Opportunity__c);
            }     
        }

        // 4. Map opportunity to its related project
        for (Opportunity opp : [SELECT Id, Active_Financial_Quote__c, Project__c  FROM Opportunity WHERE Id IN :OppIdsToProcess]) {
    
            opportunityToProjectMap.put(opp.Id, opp.Project__c);
        }

        // 5. For each Opportunity in the set, update its related project to 'Archived'.
        for(Id oppId : OppIdsToProcess){
            Id projectId = opportunityToProjectMap.get(oppId);

            if (projectId != null) {
                    
                Project__c projectToUpdate = new Project__c(
                                                Id = projectId,
                                                Project_Stage__c = 'Archived' 
                                            );
                lstProjectToUpdate.add(projectToUpdate);
            }  
        }

        if(lstProjectToUpdate != null){

            update lstProjectToUpdate;
        }
    }
}