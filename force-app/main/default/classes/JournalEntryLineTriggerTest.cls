@isTest
public with sharing class JournalEntryLineTriggerTest {
        
        static testMethod void testJournalEntryLineDetails() {
          
          Test.startTest();  
            AcctSeed__GL_Account__c GLAcc = new AcctSeed__GL_Account__c(Name='GL Acc', 
                                                                    AcctSeed__Type__c='Balance Sheet',
                                                                    AcctSeed__Sub_Type_1__c = 'Assets',
                                                                    AcctSeed__Bank__c = true);
        insert GLAcc;

        // pdf format
        AcctSeed__Billing_Format__c pdfFormateSO = new AcctSeed__Billing_Format__c(
            name = 'pdf123',
            AcctSeed__Type__c = 'Activity Statement',
            AcctSeed__Visualforce_PDF_Page__c = 'BillingActivityStmtModernPDF',
            AcctSeed__Default_Email_Template__c = 'Activity_Statement_Email_Template'
        );
        insert pdfFormateSO;

        AcctSeed__Billing_Format__c pdfFormateSO2 = new AcctSeed__Billing_Format__c(
            name = 'Billing Outstanding Statement',
            AcctSeed__Type__c = 'Outstanding Statement',
            AcctSeed__Visualforce_PDF_Page__c = 'BillingOutstandingStmtModernPDF',
            AcctSeed__Default_Email_Template__c = 'Outstanding_Statement_Email_Template'
        );
        insert pdfFormateSO2;

        AcctSeed__Billing_Format__c pdfFormateSO3 = new AcctSeed__Billing_Format__c(
            name = 'Default Billing Product',
            AcctSeed__Type__c = 'Billing',
            AcctSeed__Visualforce_PDF_Page__c = 'InvoicePDFDocument',
            AcctSeed__Default_Email_Template__c = 'Billing_Email_Template'
        );
        insert pdfFormateSO3;

        AcctSeed__Billing_Format__c pdfFormateSO4 = new AcctSeed__Billing_Format__c(
            name = 'Billing Outstanding Statement',
            AcctSeed__Type__c = 'Outstanding Statement',
            AcctSeed__Visualforce_PDF_Page__c = 'BillingOutstandingStmtModernPDF',
            AcctSeed__Default_Email_Template__c = 'Outstanding_Statement_Email_Template'
        );
        insert pdfFormateSO4;

        AcctSeed__Billing_Format__c pdfFormateSO5 = new AcctSeed__Billing_Format__c(
            name = 'Default Purchase Order',
            AcctSeed__Type__c = 'Purchase Order',
            AcctSeed__Visualforce_PDF_Page__c = 'PurchaseOrderPDF',
            AcctSeed__Default_Email_Template__c = 'Purchase_Order_Email_Template'
        );
        insert pdfFormateSO5;

        AcctSeed__Billing_Format__c pdfFormateSO6 = new AcctSeed__Billing_Format__c(
            name = 'Default Packing Slip',
            AcctSeed__Type__c = 'Packing Slip',
            AcctSeed__Visualforce_PDF_Page__c = 'ShipmentPDF',
            AcctSeed__Default_Email_Template__c = 'Purchase_Order_Email_Template'
        );
        insert pdfFormateSO6;

        AcctSeed__Ledger__c ledg = new AcctSeed__Ledger__c(
                                    Name='ledger',
                                    AcctSeed__Type__c='Transactional',
                                    AcctSeed__Billing_Activity_Statement_Format__c = pdfFormateSO.Id,
                                    AcctSeed__Default_Bank_Account__c = GLAcc.Id,
                                    AcctSeed__Billing_Outstanding_Statement_Format__c = pdfFormateSO2.Id,
                                    AcctSeed__Default_Billing_Format__c = pdfFormateSO3.Id,
                                    AcctSeed__Default_Purchase_Order_Format__c = pdfFormateSO5.Id,
                                    AcctSeed__Default_Packing_Slip_Format__c = pdfFormateSO6.Id);
        insert ledg;
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.closeDate = Date.today();
        objOpportunity.Name = 'Test Opportunity';
        objOpportunity.stageName = 'TARGET/NEGOTIATING';
        objOpportunity.Targeted__c = true;
        objOpportunity.Total_Project_Margin__c = 1000;
        objOpportunity.Office__c = 'MaRRs';
        insert objOpportunity;
        
         AcctSeed__Accounting_Period__c accPeriod = new AcctSeed__Accounting_Period__c(
            Name = Datetime.now().format('YYYY-MM'), 
            AcctSeed__Start_Date__c = Date.today(),
            AcctSeed__End_Date__c = Date.today().addDays(31),
            AcctSeed__Status__c = 'open'
        );
        insert accPeriod;
        
        Project__c testProject = new Project__c();
        testProject.Name = 'Test Project';
        testProject.Receipt_of_Order_Date__c = System.Now().Date();
        insert testProject;
        
        AcctSeed__Journal_Entry__c testjonEntry = new AcctSeed__Journal_Entry__c();
        testjonEntry.Name = 'Test journal Entry';
        testjonEntry.AcctSeed__Status__c = 'Approved';
        testjonEntry.AcctSeed__Ledger__c = ledg.Id;
        testjonEntry.AcctSeed__Journal_Date__c = System.Now().Date();
        testjonEntry.AcctSeed__Accounting_Period__c = accPeriod.Id;
        insert testjonEntry;

        AcctSeed__Journal_Entry_Line__c testJonEntline = new AcctSeed__Journal_Entry_Line__c();
        testJonEntline.AcctSeed__Journal_Entry__c = testjonEntry.Id;
        testJonEntline.AcctSeed__Debit__c = 500 ;
        testJonEntline.Projects_MMCO_Custom_Tool__c = testProject.Id;
        testJonEntline.Project_Posting_Type__c = 'Labor';
        testJonEntline.AcctSeed__GL_Account__c = GLAcc.Id;
        insert testJonEntline;
        
        AcctSeed__Journal_Entry_Line__c testJonEntline1 = new AcctSeed__Journal_Entry_Line__c();
        testJonEntline1.AcctSeed__Journal_Entry__c = testjonEntry.Id;
        testJonEntline1.AcctSeed__credit__c = 500 ;
        testJonEntline1.Projects_MMCO_Custom_Tool__c = testProject.Id;
        testJonEntline1.Project_Posting_Type__c = 'Labor';
        testJonEntline1.AcctSeed__GL_Account__c = GLAcc.Id;
        insert testJonEntline1;
        
        testJonEntline.Project_Posting_Type__c = 'Other Cost';
        testJonEntline.AcctSeed__Debit__c = 700;
        update testJonEntline;
       
        
        Test.stopTest();  
        }
}