trigger JournalEntryLineTrigger on AcctSeed__Journal_Entry_Line__c (After Insert, After Update , After Delete) {

    if(Trigger.IsAfter){
        
        set<Id> setProjectId = new set<Id>();
        
        if(Trigger.IsInsert || Trigger.IsUpdate){
            
            for(AcctSeed__Journal_Entry_Line__c eachEntryLine : Trigger.New){
                
                if(Trigger.isInsert && eachEntryLine.Projects_MMCO_Custom_Tool__c!=null){
                    setProjectId.add(eachEntryLine.Projects_MMCO_Custom_Tool__c);
                }
                if(Trigger.isUpdate && ((eachEntryLine.Projects_MMCO_Custom_Tool__c!=null && 
                eachEntryLine.Projects_MMCO_Custom_Tool__c!= Trigger.OldMap.get(eachEntryLine.Id).Projects_MMCO_Custom_Tool__c) ||
                (eachEntryLine.AcctSeed__Debit__c  != Trigger.OldMap.get(eachEntryLine.Id).AcctSeed__Debit__c ||eachEntryLine.AcctSeed__Credit__c != Trigger.OldMap.get(eachEntryLine.Id).AcctSeed__Credit__c|| eachEntryLine.Project_Posting_Type__c != Trigger.OldMap.get(eachEntryLine.Id).Project_Posting_Type__c )
                ))
                {
                 
                     if(eachEntryLine.Project_Posting_Type__c == 'Labor' || eachEntryLine.Project_Posting_Type__c == 'Other Cost' ){
                          setProjectId.add(eachEntryLine.Projects_MMCO_Custom_Tool__c);  
                          
                     }else if(Trigger.OldMap.get(eachEntryLine.Id).Project_Posting_Type__c == 'Labor' ||  
                        Trigger.OldMap.get(eachEntryLine.Id).Project_Posting_Type__c == 'Other Cost'){
                         setProjectId.add(Trigger.OldMap.get(eachEntryLine.Id).Projects_MMCO_Custom_Tool__c);  
                     }
                }
            }
            
        }
        if(Trigger.IsUpdate || Trigger.isDelete){
            for(AcctSeed__Journal_Entry_Line__c eachEntryLine : Trigger.Old){
                
                if(eachEntryLine.Project_Posting_Type__c == 'Labor' || eachEntryLine.Project_Posting_Type__c == 'Other Cost'){
                    setProjectId.add(eachEntryLine.Projects_MMCO_Custom_Tool__c); 
                }
            
            }
        }
        
        if(!setProjectId.isEmpty()){
            Map<Id,Decimal> mapProjId_TotalLabourDebt = new Map<Id, Decimal>();
            Map<Id,Decimal> mapProjId_TotalLabourCredit = new Map<Id, Decimal>();
            Map<Id,Decimal> mapProjId_TotalOtherDebt = new Map<Id, Decimal>();
            Map<Id,Decimal> mapProjId_TotalOtherCredit = new Map<Id, Decimal>();
            list<Project__c> lstProjectUpdate = new list<Project__c>();
            
            for(AcctSeed__Journal_Entry_Line__c eachEntryLine : [SELECT Id,AcctSeed__Debit__c,AcctSeed__Credit__c,
                                                                        Projects_MMCO_Custom_Tool__c,Project_Posting_Type__c 
                                                                 FROM AcctSeed__Journal_Entry_Line__c 
                                                                 WHERE Projects_MMCO_Custom_Tool__c IN :setProjectId]){
                
                if(eachEntryLine.Project_Posting_Type__c == 'Labor'){
                    
                    Decimal totalLabourDebt = 0;
                    
                    if(mapProjId_TotalLabourDebt.containsKey(eachEntryLine.Projects_MMCO_Custom_Tool__c)){
                        totalLabourDebt  = eachEntryLine.AcctSeed__Debit__c!=null? eachEntryLine.AcctSeed__Debit__c :0;

                        if(mapProjId_TotalLabourDebt.containsKey(eachEntryLine.Projects_MMCO_Custom_Tool__c))
                        totalLabourDebt  += mapProjId_TotalLabourDebt.get(eachEntryLine.Projects_MMCO_Custom_Tool__c);
                        
                        mapProjId_TotalLabourDebt.put(eachEntryLine.Projects_MMCO_Custom_Tool__c,  totalLabourDebt );
                    }else{
                        totalLabourDebt = eachEntryLine.AcctSeed__Debit__c!= null ? eachEntryLine.AcctSeed__Debit__c: 0;
                        mapProjId_TotalLabourDebt.put(eachEntryLine.Projects_MMCO_Custom_Tool__c,totalLabourDebt );
                    }
                    
                    Decimal totalLabourCrdt = 0;
                    
                    if(mapProjId_TotalLabourCredit.containsKey(eachEntryLine.Projects_MMCO_Custom_Tool__c)){
                    
                        totalLabourCrdt = eachEntryLine.AcctSeed__Credit__c!= null ? eachEntryLine.AcctSeed__Credit__c: 0;

                        if (mapProjId_TotalLabourCredit.containsKey(eachEntryLine.Projects_MMCO_Custom_Tool__c))
                        totalLabourCrdt += mapProjId_TotalLabourCredit.get(eachEntryLine.Projects_MMCO_Custom_Tool__c);
                        
                        mapProjId_TotalLabourCredit.put(eachEntryLine.Projects_MMCO_Custom_Tool__c,  totalLabourCrdt );
                    }else{
                        TotalLabourCrdt = eachEntryLine.AcctSeed__Credit__c!= null ? eachEntryLine.AcctSeed__Credit__c: 0;
                        mapProjId_TotalLabourCredit.put(eachEntryLine.Projects_MMCO_Custom_Tool__c,totalLabourCrdt );
                    }
                }else if(eachEntryLine.Project_Posting_Type__c == 'Other Cost'){
                    
                    Decimal totalOtherDebt = 0;
                    if(mapProjId_TotalOtherDebt.containsKey(eachEntryLine.Projects_MMCO_Custom_Tool__c)){
                        totalOtherDebt = eachEntryLine.AcctSeed__Debit__c!=null? eachEntryLine.AcctSeed__Debit__c :0;

                        if (mapProjId_TotalLabourDebt.containsKey(eachEntryLine.Projects_MMCO_Custom_Tool__c))
                        totalOtherDebt += mapProjId_TotalLabourDebt.get(eachEntryLine.Projects_MMCO_Custom_Tool__c);
                        
                        mapProjId_TotalOtherDebt.put(eachEntryLine.Projects_MMCO_Custom_Tool__c, totalOtherDebt);
                    }else{
                        totalOtherDebt= eachEntryLine.AcctSeed__Debit__c!= null ? eachEntryLine.AcctSeed__Debit__c : 0;
                        mapProjId_TotalOtherDebt.put(eachEntryLine.Projects_MMCO_Custom_Tool__c,totalOtherDebt);
                    }
                    
                    Decimal totalOtherCrdt = 0;
                    
                    if(mapProjId_TotalOtherCredit.containsKey(eachEntryLine.Projects_MMCO_Custom_Tool__c)){
                        totalOtherCrdt  = eachEntryLine.AcctSeed__Credit__c!= null ? eachEntryLine.AcctSeed__Credit__c: 0;

                        if (mapProjId_TotalOtherCredit.containsKey(eachEntryLine.Projects_MMCO_Custom_Tool__c))
                        totalOtherCrdt += mapProjId_TotalOtherCredit.get(eachEntryLine.Projects_MMCO_Custom_Tool__c);

                        mapProjId_TotalOtherCredit.put(eachEntryLine.Projects_MMCO_Custom_Tool__c, totalOtherCrdt );
                    }else{
                        totalOtherCrdt = eachEntryLine.AcctSeed__Credit__c!= null ? eachEntryLine.AcctSeed__Credit__c: 0;
                        mapProjId_TotalOtherCredit.put(eachEntryLine.Projects_MMCO_Custom_Tool__c,totalOtherCrdt);
                    }
                }
            }
          
          for(Id eachProjectId : setProjectId){
            if (mapProjId_TotalLabourDebt.containsKey(eachProjectId) ||
                mapProjId_TotalLabourCredit.containsKey(eachProjectId) || 
                mapProjId_TotalOtherDebt.containsKey(eachProjectId) ||
                mapProjId_TotalOtherCredit.containsKey(eachProjectId)) {
                    Project__c objProj = new Project__c();
                    objProj.Id = eachProjectId;
                    objProj.Total_Labour_JE_Debit__c  = mapProjId_TotalLabourDebt.containsKey(eachProjectId)?mapProjId_TotalLabourDebt.get(eachProjectId):0;
                    objProj.Total_Labour_JE_Credit__c = mapProjId_TotalLabourCredit.containsKey(eachProjectId)?mapProjId_TotalLabourCredit.get(eachProjectId):0;
                    objProj.Total_Other_JE_Debit__c   = mapProjId_TotalOtherDebt.containsKey(eachProjectId)?mapProjId_TotalOtherDebt.get(eachProjectId):0;
                    objProj.Total_Other_JE_Credit__c  = mapProjId_TotalOtherCredit.containsKey(eachProjectId)?mapProjId_TotalOtherCredit.get(eachProjectId):0;
                    lstProjectUpdate.add(objProj);

            }   
          }  
          
          if(!lstProjectUpdate.isEmpty()){
              try{
                  update lstProjectUpdate;
              }catch(exception ex){
                  System.Debug('==ex=='+ex);
              }
          }
        }
    }
    

}