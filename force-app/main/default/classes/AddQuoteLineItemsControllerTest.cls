/**
 * @description       : 
 * @author            : Nilesh Badrakiya
 * @group             : 
 * @last modified on  : 03-06-2024
 * @last modified by  : Nilesh Badrakiya
**/
@isTest
private class AddQuoteLineItemsControllerTest{

    @testSetup static void setup() 
    { 
        AcctSeed__GL_Account__c GLAcc = new AcctSeed__GL_Account__c(Name='GL Acc', 
                                                                    AcctSeed__Type__c='Balance Sheet',
                                                                    AcctSeed__Sub_Type_1__c = 'Assets',
                                                                    AcctSeed__Bank__c = true);
        insert GLAcc;

        AcctSeed__GL_Account__c[] glAccounts = new List<AcctSeed__GL_Account__c>();
            // 0
            glAccounts.add(
            new AcctSeed__GL_Account__c(
            Name = '1000-Cash',
            AcctSeed__Active__c = true,
            AcctSeed__Type__c = 'Balance Sheet',
            AcctSeed__Bank__c = true,
            AcctSeed__Sub_Type_1__c = 'Assets',
            AcctSeed__Sub_Type_2__c = 'Cash')
            );
            
            // 1
            glAccounts.add(
            new AcctSeed__GL_Account__c(
            Name = '1205-Unapplied A/R',
            AcctSeed__Active__c = true,
            AcctSeed__Type__c = 'Balance Sheet',
            AcctSeed__Sub_Type_1__c = 'Assets',
            AcctSeed__Sub_Type_2__c = 'Cash'
            )
            );
            
            // 2
            glAccounts.add(
            new AcctSeed__GL_Account__c(
            Name = '1200-Accounts Receivable',
            AcctSeed__Active__c = true,
            AcctSeed__Type__c = 'Balance Sheet',
            AcctSeed__Sub_Type_1__c = 'Assets',
            AcctSeed__Sub_Type_2__c = 'Current Assets'
            )
            );
            
            // 3
            glAccounts.add(
            new AcctSeed__GL_Account__c(
            Name = '2000-Accounts Payable',
            AcctSeed__Active__c = true,
            AcctSeed__Type__c = 'Balance Sheet',
            AcctSeed__Sub_Type_1__c = 'Liabilities',
            AcctSeed__Sub_Type_2__c = 'Current Liabilities'
            )
            );
            
            // 4
            glAccounts.add(
            new AcctSeed__GL_Account__c(
            Name = '3050-Retained Earnings',
            AcctSeed__Active__c = true,
            AcctSeed__Type__c = 'Balance Sheet',
            AcctSeed__Sub_Type_1__c = 'Owners Equity',
            AcctSeed__Sub_Type_2__c = 'Equity'
            )
            );
            
            // 5
            glAccounts.add(
            new AcctSeed__GL_Account__c(
            Name = '3060-Current Year Earnings',
            AcctSeed__Active__c = true,
            AcctSeed__Type__c = 'Balance Sheet',
            AcctSeed__Sub_Type_1__c = 'Owners Equity',
            AcctSeed__Sub_Type_2__c = 'Equity'
            )
            );
            
            // 6
            glAccounts.add(
            new AcctSeed__GL_Account__c(
            Name = '4000-Product Revenue',
            AcctSeed__Active__c = true,
            AcctSeed__Type__c = 'Revenue',
            AcctSeed__Sub_Type_1__c = 'Product Revenue',
            AcctSeed__Sub_Type_2__c = 'Product Family 1'
            )
            );
            
            // 7
            glAccounts.add(
            new AcctSeed__GL_Account__c(
            Name = '5010-Inventory Cost Variance',
            AcctSeed__Active__c = true,
            AcctSeed__Type__c = 'Expense',
            AcctSeed__Sub_Type_1__c = 'Cost of Goods Sold',
            AcctSeed__Sub_Type_2__c = 'Materials'
            )
            );
            
            // 8
            glAccounts.add(
            new AcctSeed__GL_Account__c(
            Name = '5040-Vendor Payment Discounts',
            AcctSeed__Active__c = true,
            AcctSeed__Type__c = 'Expense',
            AcctSeed__Sub_Type_1__c = 'Cost of Goods Sold',
            AcctSeed__Sub_Type_2__c = 'Materials'
            )
            );
            
            // 9
            glAccounts.add(
            new AcctSeed__GL_Account__c(
            Name = 'zLabor Clearing',
            AcctSeed__Active__c = true,
            AcctSeed__Type__c = 'Expense'
            )
            );
            
            // 10
            glAccounts.add(
            new AcctSeed__GL_Account__c(
            Name = 'zProject Labor',
            AcctSeed__Active__c = true,
            AcctSeed__Type__c = 'Expense'
            )
            );
            
            insert glAccounts;
        
        AcctSeed__GL_Account__c GLAccActive = new AcctSeed__GL_Account__c(Name='GLAcc Active', 
        AcctSeed__Type__c='Balance Sheet',
        AcctSeed__Sub_Type_1__c = 'Assets',
        AcctSeed__Bank__c = false,
        AcctSeed__Active__c = true);
        insert GLAccActive;

        system.debug('used query limit 1='+limits.getQueries());
        AcctSeed__Accounting_Variable__c GLAVar = new AcctSeed__Accounting_Variable__c(
            Name = 'MIB',
            AcctSeed__Type__c = 'GL Account Variable 1'
        );
        system.debug('used query limit 2='+limits.getQueries());

        insert GLAVar;
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

        // insert 1 Ledger records
        AcctSeed__Ledger__c ledg = new AcctSeed__Ledger__c(
                                    Name = 'Actual',
                                    AcctSeed__Type__c = 'Transactional',
                                    AcctSeed__Default_Bank_Account__c = glAccounts[0].Id,
                                    AcctSeed__Default_Billing_Format__c = pdfFormateSO3.Id,
                                    AcctSeed__Billing_Outstanding_Statement_Format__c = pdfFormateSO2.Id,
                                    AcctSeed__Billing_Activity_Statement_Format__c = pdfFormateSO.Id,
                                    AcctSeed__Default_Purchase_Order_Format__c = pdfFormateSO5.Id,
                                    AcctSeed__Default_Packing_Slip_Format__c = pdfFormateSO6.Id);
    
        insert ledg;

        Opportunity objOpportunity = new Opportunity();
        objOpportunity.closeDate = Date.today();
        objOpportunity.Name = 'Test Opportunity';
        objOpportunity.stageName = 'Draft';
        objOpportunity.Office__c = 'MaRRs';
        insert objOpportunity;

        Quote newQuote = new Quote();
        newQuote.Name = 'Test Quote';
        newQuote.opportunityId = objOpportunity.Id;
        newQuote.Scope_Revision_Number__c = '01';
        newQuote.Submittal_Revision_Number__c = '01';
        insert newQuote;

        Opportunity objOpportunity2 = new Opportunity();
        objOpportunity2.closeDate = Date.today();
        objOpportunity2.Name = 'Test Opportunity';
        objOpportunity2.stageName = 'Draft';
        objOpportunity2.Office__c = 'Spark';
        insert objOpportunity2;

        Quote syncQuote = new Quote();
        syncQuote.Name = 'sync Quote';
        syncQuote.opportunityId = objOpportunity2.Id;
        syncQuote.Scope_Revision_Number__c = '01';
        syncQuote.Submittal_Revision_Number__c = '01';
        insert syncQuote;

        objOpportunity2.Sync_Quote__c = syncQuote.Id;
        update objOpportunity2;

        Project__c newProject = new Project__c();
        newProject.Name = 'Test Project';
        newProject.Receipt_of_Order_Date__c = System.Now().Date();
        newProject.Opportunity__c = objOpportunity2.Id;
        newProject.Quote__c = syncQuote.Id;
        newProject.Schedule_End_Date__c = system.today();
        insert newProject;
        
        Product_Group__c objParentProductGroup = new Product_Group__c();
        objParentProductGroup.Name = 'Parent Group';
        objParentProductGroup.Quote__c = newQuote.Id;
        insert objParentProductGroup;
        
        Product_Group__c objChildProductGroup = new Product_Group__c();
        objChildProductGroup.Name = 'Parent Group';
        objChildProductGroup.Quote__c = newQuote.Id;
        objChildProductGroup.Parent_Product_Group__c = objParentProductGroup.Id;
        insert objChildProductGroup;
        
        Product_Select__c objParentLineItem = new Product_Select__c();
        objParentLineItem.Product_Name__c = 'Parent Product Name';
        objParentLineItem.Quote__c = newQuote.Id;
        objParentLineItem.Product_Group__c = objChildProductGroup.Id;
        insert objParentLineItem;
        
        Product_Select__c objChildLineItem = new Product_Select__c();
        objChildLineItem.Product_Name__c = 'Child Product Name';
        objChildLineItem.Quote__c = newQuote.Id;
        objChildLineItem.Product_Group__c = objChildProductGroup.Id;
        insert objChildLineItem;
        
		List<AcctSeed__GL_Account__c> GLToInsert = new List<AcctSeed__GL_Account__c>();
        AcctSeed__GL_Account__c GLAccRev = new AcctSeed__GL_Account__c(Name='GL Acc', 
        AcctSeed__Type__c='Revenue',
        AcctSeed__Sub_Type_1__c = 'Operating Revenue',
        AcctSeed__Bank__c = false);
        GLToInsert.add(GLAccRev);

        AcctSeed__GL_Account__c GLAccExp = new AcctSeed__GL_Account__c(Name='GL Acc', 
        AcctSeed__Type__c='Expense',
        AcctSeed__Sub_Type_1__c = 'Operating Expenses',
        AcctSeed__Bank__c = false);
        GLToInsert.add(GLAccExp);
		insert GLToInsert;

        GLCode_System_Properties__c glDetail = new GLCode_System_Properties__c(Name = 'Parts Quote',
                                                                                    Revenue_GL_AccountId__c = GLAccRev.Id,
                                                                                    Expense_GL_AccountId__c = GLAccExp.Id);
        insert glDetail; 
        
        Pricebook2 prb= new Pricebook2(Name='Standard Price Book 2009',Description ='Price Book 2009 Products',IsActive = true);
        insert prb;
        
        Product2 pr = new Product2(Name='Freight',IsActive=true, Midwest_Group_Office__c = 'Spark');
        insert pr;

        AcctSeed__Inventory_Cost__c Ic = new AcctSeed__Inventory_Cost__c();
        Ic.AcctSeed__Ledger__c = ledg.Id;
        Ic.AcctSeed__Product__c = pr.Id;
        Ic.AcctSeed__Unit_Cost__c = 500;
        //insert Ic;
    
        Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = pr.Id, UnitPrice = 10000, IsActive = true);
        insert pbe;
    }
 
    @isTest
    static void testMethod1() {

        
        Map<Id,AcctSeed__Inventory_Cost__c> productInventoryCostMap = new Map<Id,AcctSeed__Inventory_Cost__c>();



        Quote syncQuote = [Select Id from Quote Where Name = 'sync Quote' Limit 1];
        Quote newQuote = [Select Id from Quote Where Name = 'Test Quote' Limit 1];
        //AcctSeed__Inventory_Cost__c Ic = [Select Id from AcctSeed__Inventory_Cost__c Limit 1];
        Product2 pr = [Select Id from Product2 Where Name = 'Freight' Limit 1];

        AcctSeed__Ledger__c ledger = [Select Id From AcctSeed__Ledger__c limit 1];
        AcctSeed__Inventory_Cost__c Ic = new AcctSeed__Inventory_Cost__c();
        Ic.AcctSeed__Ledger__c = ledger.Id;
        Ic.AcctSeed__Product__c = pr.Id;
        Ic.AcctSeed__Unit_Cost__c = 500;
        
        productInventoryCostMap.put(pr.Id, Ic);


        Test.startTest();

        
        PageReference pageRef = ApexPages.currentPage();
        pageRef.getParameters().put('id', String.valueOf(syncQuote.Id));
        Test.setCurrentPage(pageRef);
        AddQuoteLineItemsController objAddQuoteLineItemsController1 = new AddQuoteLineItemsController();

        ApexPages.StandardController sc = new ApexPages.StandardController(newQuote);
        AddQuoteLineItemsController objAddQuoteLineItemsController = new AddQuoteLineItemsController(sc);
        objAddQuoteLineItemsController.addAdditionDeductionLineItem();
        
        Boolean hasNext = objAddQuoteLineItemsController.hasNext;
        Boolean hasPrevious = objAddQuoteLineItemsController.hasPrevious;
        Integer pageNumber = objAddQuoteLineItemsController.pageNumber;
        objAddQuoteLineItemsController.hidProductRowIndex = 0;
        objAddQuoteLineItemsController.deleteAdditionDeduction();
        objAddQuoteLineItemsController.addProduct();
        
        objAddQuoteLineItemsController.hidGroupIndex = 0;
        objAddQuoteLineItemsController.hidSubGroupIndex = 0;
        objAddQuoteLineItemsController.addCustomProduct();
        objAddQuoteLineItemsController.deleteScratchPadProductRow();
        objAddQuoteLineItemsController.cloneGroup();
        objAddQuoteLineItemsController.newGroup();
        
        objAddQuoteLineItemsController.createSubGroup();
        objAddQuoteLineItemsController.cloneSubGroup();
        objAddQuoteLineItemsController.newSubGroup();
        
        objAddQuoteLineItemsController.backToQuote();
        objAddQuoteLineItemsController.backToCart();
        objAddQuoteLineItemsController.saveDescription();
        
        objAddQuoteLineItemsController.deleteProductRow();
        objAddQuoteLineItemsController.cloneProductRow();
        objAddQuoteLineItemsController.deleteGroup();
        objAddQuoteLineItemsController.deleteSubGroup();
        objAddQuoteLineItemsController.deleteGroup();
        objAddQuoteLineItemsController.Save();

        // objAddQuoteLineItemsController.newProduct = pr;
        // objAddQuoteLineItemsController.insertNewProduct();
        objAddQuoteLineItemsController.getProducts();
        objAddQuoteLineItemsController.searchProducts();
        //objAddQuoteLineItemsController.saveAndExit();
        objAddQuoteLineItemsController.selectProducts();
        objAddQuoteLineItemsController.first();
        objAddQuoteLineItemsController.last();
        objAddQuoteLineItemsController.previous();
        objAddQuoteLineItemsController.next();

        //objAddQuoteLineItemsController.moveToDesignQuote();
        //objAddQuoteLineItemsController.previewDocument();
        //objAddQuoteLineItemsController.generateDocument();
        PricebookEntry priceBookentry = [Select Id, Product2.Name, Product2.ProductCode, Product2.Family, UnitPrice, Product2.Product_Description__c, Product2.Weight__c, Product2.Description,
                                                Product2.Manufacturer__c, 
                                                Product2.Product_Type__c 
                                        FROM PricebookEntry
                                        limit 1];

        AddQuoteLineItemsController.ProductWrapperClass productWrapper = new AddQuoteLineItemsController.ProductWrapperClass(priceBookentry);
        //productWrapper = objAddQuoteLineItemsController.addDefaultFreightProduct();
        system.debug('productWrapper='+productWrapper);
        objAddQuoteLineItemsController.convertPricebookEntryToProductDetails(productWrapper,productInventoryCostMap);

          
        MarrsConfigureQuoteController marsQuoteConfigure = new MarrsConfigureQuoteController(sc);
        marsQuoteConfigure.addNewGroup();
        marsQuoteConfigure.cloneGroup();
        marsQuoteConfigure.addNewSubGroup();
        marsQuoteConfigure.cloneSubGroup();
        marsQuoteConfigure.cloneLineItem();
        marsQuoteConfigure.deleteGroup();
        marsQuoteConfigure.deleteLineItem();
        marsQuoteConfigure.deleteSubGroup();
        marsQuoteConfigure.saveAndExit();
        marsQuoteConfigure.redirectToQuote();
        marsQuoteConfigure.addProduct();

        marsQuoteConfigure.searchProduct = 'testSA';
        marsQuoteConfigure.searchProducts();
        marsQuoteConfigure.getProducts();
        marsQuoteConfigure.addProducts();
        marsQuoteConfigure.addProductsToCart();
        // marsQuoteConfigure.updateDescription();
        marsQuoteConfigure.previewQuote();
        /*marsQuoteConfigure.pageNumber;
        marsQuoteConfigure.hasPrevious;
        marsQuoteConfigure.hasNext;
        marsQuoteConfigure.totalPageNumber;*/

        
        marsQuoteConfigure.first();
        marsQuoteConfigure.previous();
        marsQuoteConfigure.last();
        marsQuoteConfigure.next();
        Test.stopTest();
    }
    
}