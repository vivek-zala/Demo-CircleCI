trigger PurchaseOrderTrigger on AcctSeedERP__Purchase_Order__c (before insert,after Insert, after Update,after Delete) {
    
    if(trigger.isBefore && trigger.isInsert){
        if(trigger.new[0] != null) {
            system.debug('purchaseorder trigger');
            SystemUtil.generateCustomAutoNumber(trigger.new);
    
        }
    }
    
    if(Trigger.isAfter){
        //RollUp PO to Opportunity
        set<Id> setSOId = new set <Id>();
        
         If(Trigger.IsInsert || Trigger.IsUpdate){
             for(AcctSeedERP__Purchase_Order__c POrder : Trigger.New){
                 if(Trigger.IsInsert && POrder.Sales_Order__c!=null && POrder.AcctSeedERP__Total__c!=null){
                     setSOId.add(POrder.Sales_Order__c);
                 }else if(Trigger.IsUpdate && ((POrder.Sales_Order__c!=null && POrder.Sales_Order__c != Trigger.OldMap.get(POrder.Id).Sales_Order__c) || (POrder.AcctSeedERP__Total__c != Trigger.OldMap.get(POrder.Id).AcctSeedERP__Total__c))){
                     setSOId.add(POrder.Sales_Order__c);
                     setSOId.add(Trigger.OldMap.get(POrder.Id).Sales_Order__c);
                 }
             }
         }
         if(Trigger.IsDelete){
            
            for(AcctSeedERP__Purchase_Order__c POrder : Trigger.Old){
                
                if(POrder.Sales_Order__c!=null && POrder.AcctSeedERP__Total__c!=null){
                    setSOId.add(POrder.Sales_Order__c);
                }
            }
        }
        
        if(!setSOId.isEmpty()){
        
            
            set<Id> setOppId = new set<Id>();
            map<Id,Decimal> mapOppId_PoTotal = new Map<Id,Decimal>();
            list<Opportunity> lstOppUpdate = new List<Opportunity>();
            
            
            for(AcctSeedERP__Sales_Order__c eachSO : [SELECT Id,AcctSeedERP__Opportunity__c FROM AcctSeedERP__Sales_Order__c WHERE Id IN:setSOId]){
                    
                setOppId.add(eachSO.AcctSeedERP__Opportunity__c);
            }
            
            for(AcctSeedERP__Purchase_Order__c eachPO : [SELECT Id,AcctSeedERP__Total__c,Sales_Order__r.AcctSeedERP__Opportunity__c FROM AcctSeedERP__Purchase_Order__c WHERE Sales_Order__r.AcctSeedERP__Opportunity__c IN:setOppId]){
                
                Decimal tempTotal = 0;
                if(mapOppId_PoTotal.containsKey(eachPO.Sales_Order__r.AcctSeedERP__Opportunity__c) ){
                    tempTotal = eachPO.AcctSeedERP__Total__c != 0 ? eachPO.AcctSeedERP__Total__c : 0;
                    tempTotal = tempTotal + mapOppId_PoTotal.get(eachPO.Sales_Order__r.AcctSeedERP__Opportunity__c);
                    
                    mapOppId_PoTotal.put(eachPO.Sales_Order__r.AcctSeedERP__Opportunity__c,tempTotal );
                }else{
                   tempTotal = eachPO.AcctSeedERP__Total__c != 0 ? eachPO.AcctSeedERP__Total__c : 0;
                   mapOppId_PoTotal.put(eachPO.Sales_Order__r.AcctSeedERP__Opportunity__c,tempTotal );
                }
            }
        
            for(Id eachOppId : setOppId){
                opportunity opp = new Opportunity(Id = eachOppId );
                opp.PO_Total__c = mapOppId_PoTotal.get(eachOppId)!=null?mapOppId_PoTotal.get(eachOppId) : 0;
                lstOppUpdate.add(opp);
            }
            
            if(lstOppUpdate.size()>0){
                try{
                    update lstOppUpdate;
                }catch (exception ex){
                    System.Debug('==ex=='+ex);
                }
            }
        }
        
        
    }
}