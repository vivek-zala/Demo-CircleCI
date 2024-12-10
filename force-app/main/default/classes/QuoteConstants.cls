/**
 * @description       : 
 * @author            : Nilesh Badrakiya
 * @group             : 
 * @last modified on  : 03-21-2024
 * @last modified by  : Nilesh Badrakiya
**/
public with sharing class QuoteConstants {
    
    // sobject name
    public static final String SOBJECT_NAME = 'Quote';
	
    // field names
    public static final String FIELD_NAME_QUOTE_NUMBER = 'QuoteNumber';
    public static final String FIELD_NAME_TOTAL_BASE_BID_TOTAL = 'Total_Base_Bid_Total__c';
    public static final string FIELD_NAME_HIDE_TOTAL_BASE_BID_TOTAL = 'Hide_Total_Base_Bid_Total__c';
    public static final String FIELD_NAME_TOTAL_EXTENDED_COST = 'Total_Extended_Cost__c';
    public static final String FIELD_NAME_TOTAL_DIRECT_SELL_PRICE = 'Total_Direct_Sell_Price__c';
    public static final String FIELD_NAME_TOTAL_BUY_RESELL_PRICE = 'Total_Buy_Resell_Price__c';
    public static final String FIELD_NAME_TOTAL_BUY_RESELL_MARGIN = 'Total_Buy_Resell_Margin__c';
    public static final String FIELD_NAME_TOTAL_BUY_RESELL_MARGIN_PERCENTAGE = 'Total_Buy_Resell_Margin_Percentage__c';
    public static final String FIELD_NAME_COMMISSIONS_AND_REBATES = 'Commissions_and_Rebates__c';
    public static final String FIELD_NAME_TOTAL_PROJECT_MARGIN = 'Total_Project_Margin__c';
    public static final String FIELD_NAME_TOTAL_PROJECT_MARGIN_PERCENTAGE = 'Total_Project_Margin_Percentage__c';
    public static final String FIELD_NAME_QUANTITY_TOTAL = 'Quantity_Total__c';
    public static final String FIELD_NAME_IS_ACTIVE_PROJECT_FINANCIALS = 'Is_Active_Project_Financials__c';
    public static final String FIELD_NAME_DOCUMENT_VERSION = 'QuoteDocumentVersion__c';
    public static final String FIELD_NAME_OPPORTUNITY_NAME = 'Opportunity_Name__c'; 
    public static final String FIELD_NAME_BID_DATE = 'Bid_Date__c'; 
    public static final String FIELD_NAME_IS_SYNC_QUOTE = 'Is_Sync_Quote__c'; 
    public static final String FIELD_NAME_OPPORTUNITY_SYNC_QUOTE = 'Opportunity_Sync_Quote__c'; 
    public static final String FIELD_NAME_OPPORTUNITY_CLOSE_DATE = 'Opportunity_Close_Date__c'; 
    public static final String FIELD_NAME_IS_LOCKED = 'Is_Locked__c'; 
    public static final String FIELD_NAME_OPPORTUNITY_ID = 'OpportunityId';
    public static final String FIELD_NAME_OPPORTUNITY_NUMBER = 'Opportunity_Number__c';
    public static final String FIELD_NAME_SUBMITTED_BY = 'Submitted_By__c';
    public static final String FIELD_NAME_PREPARE_BY_USER = 'prepared_by_user__c';
    public static final String FIELD_NAME_BIDDING_TO = 'Bidding_To__c';
    public static final String FIELD_NAME_ATTENTION_TO_ACCOUNT = 'Attention_to_Account__c';
    public static final String FIELD_NAME_RUN_TIME_LOCK = 'Run_Time_Lock__c';
    public static final String FIELD_NAME_IS_LOCKED_BY = 'Is_Locked_By__c';



    // Relation Fields
    public static final String RELATIONSHIP_OPPORTUNITY_OFFICE = 'Opportunity.Office__c';
    public static final String RELATIONSHIP_OPPORTUNITY_ID = 'OpportunityId';
    public static final String RELATIONSHIP_OPPORTUNITY_NUMBER = 'Opportunity.Opportunity_Number__c';
    public static final String RELATIONSHIP_OPPORTUNITY_ORIGINAL_NAME = 'Opportunity.OriginalName__c';
    public static final String RELATIONSHIP_OPPORTUNITY_RECORD_TYPE_NAME = 'Opportunity.RecordType.Name';
    public static final String RELATIONSHIP_OPPORTUNITY_CREATED_DATE = 'Opportunity.CreatedDate';
    public static final String RELATIONSHIP_OPPORTUNITY_NAME = 'Opportunity.Name';
    public static final String RELATIONSHIP_OPPORTUNITY_TAXABLE = 'Opportunity.Account.Is_Taxable__c';
    public static final String RELATIONSHIP_OPPORTUNITY_ACCOUNT_ID = 'Opportunity.AccountId';
    public static final String RELATIONSHIP_OPPORTUNITY_LEDGER = 'Opportunity.Ledger__c';
    public static final String RELATIONSHIP_OPPORTUNITY_BID_DATE = 'Opportunity.Bid_Date__c';
    // public static final String RELATIONSHIP_OPPORTUNITY_NAME = 'Opportunity_Name__c'; 
}