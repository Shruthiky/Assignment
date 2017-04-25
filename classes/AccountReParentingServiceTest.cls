/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Test Class.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Shruthi.Yallaiah 
* @version        1.0
* @created        04-25-2017
* @modified       04-25-2017
* ──────────────────────────────────────────────────────────────────────────────────────────────────
*/
@isTest
private class AccountReParentingServiceTest{
    
  /**
  * ───────────────────────────────────────────────────────────────────────────────────────────────┐
  * testServiceWithBlankBtId().
  *
  * This method tests the service method by passing (brainTreeId = '' and accountName = 'Test Account')
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  * FUNCTIONAL TEST LOGIC:
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  * Asserting the results by verifying the RestResponseHandler properties like (Status, Data, errorcode).
  * ───────────────────────────────────────────────────────────────────────────────────────────────┘
  */
    testMethod static void testServiceWithBlankBtId(){
        
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/BrainTree/AccountReParentingService';
        req.httpMethod = 'PATCH';
        RestContext.request = req;
        
        String brainTreeId = '';
        String accountName = 'Test Account';
        RestResponseHandler response = AccountReParentingService.doPatch(brainTreeId, accountName);
        
        //verify the response
        System.assert(response != null , 'RestResponseHandler is not null');
        System.assertEquals('Error', response.Status, 'Status should be Error since accountName is BLANK');
        System.assertEquals(null, response.Data, 'No Data is returned');
        System.assertEquals('Braintree Code:001', response.ErrorCode);
    }
    
  /**
  * ───────────────────────────────────────────────────────────────────────────────────────────────┐
  * testServiceWithValidBtIdAndNull().
  *
  * This method tests the service method by passing (brainTreeId = '12345' and accountName = null)
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  * FUNCTIONAL TEST LOGIC:
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  * Asserting the results by verifying the RestResponseHandler properties like (Status, Data, errorcode).
  * ───────────────────────────────────────────────────────────────────────────────────────────────┘
  */
    testMethod static void testServiceWithValidBtIdAndNull(){
        
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/BrainTree/AccountReParentingService';
        req.httpMethod = 'PATCH';
        RestContext.request = req;
        
        String brainTreeId = '12345';
        String accountName = null;
        RestResponseHandler response = AccountReParentingService.doPatch(brainTreeId, accountName);
        
        //verify the response
        System.assert(response != null , 'RestResponseHandler is not null');
        System.assertEquals('Error', response.Status, 'Status should be Error since accountName is NULL');
        System.assertEquals(null, response.Data, 'No Data is returned');
        System.assertEquals('Braintree Code:001', response.ErrorCode);
    }
    
  /**
  * ───────────────────────────────────────────────────────────────────────────────────────────────┐
  * testServiceWithExistingBtId().
  *
  * This method tests the service method by passing 
  *     (brainTreeId = '12345' and accountName = 'Non-Existing Account').
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  * FUNCTIONAL TEST LOGIC:
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  *    1. Asserting the results by verifying the RestResponseHandler properties like 
  *        (Status, Data, errorcode).
  *    2. Asserting the Data to contains a single Account record (Name = 'Existing Acct With BTId') 
  *       that is matching the input param brainTreeId = '12345'.
  * ───────────────────────────────────────────────────────────────────────────────────────────────┘
  */
    testMethod static void testServiceWithExistingBtId(){
        
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/BrainTree/AccountReParentingService';
        req.httpMethod = 'PATCH';
        RestContext.request = req;
        
        String brainTreeId = '12345';
        String accountName = 'Non-Existing Account';
        RestResponseHandler response = AccountReParentingService.doPatch(brainTreeId, accountName);
        
        //verify the response
        System.assert(response != null , 'RestResponseHandler is not null');
        System.assertEquals('Success', response.Status, 'Status should be SUCCESS');
        System.assert(response.Data != null);
        System.assert((response.Data).size() == 1);
        List<Account> resultantAccount = response.Data;
        System.assertEquals('Existing Acct With BTId', resultantAccount[0].Name, 
            'Response should contain the account with Name = Existing Acct With BTId');
    }  
    
  /**
  * ───────────────────────────────────────────────────────────────────────────────────────────────┐
  * testServiceWithExistingBtIdNAcctName().
  *
  * This method tests the service method by passing valid inputs
  *     (brainTreeId = '12345' and accountName = 'Existing Acct').
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  * FUNCTIONAL TEST LOGIC:
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  *    1. Asserting the results by verifying the RestResponseHandler properties like 
  *        (Status, Data, errorcode).
  *    2. Asserting the Data to contains a 2 Account records,
  *        1. One matching the input param brainTreeId.
  *        2. And other matching the input param accountName.
  *    3. Finally verifying the both records are associated using parentId.
  * ───────────────────────────────────────────────────────────────────────────────────────────────┘
  */
    testMethod static void testServiceWithExistingBtIdNAcctName(){
        
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/BrainTree/AccountReParentingService';
        req.httpMethod = 'PATCH';
        RestContext.request = req;
        
        String brainTreeId = '12345';
        String accountName = 'Existing Acct';
        RestResponseHandler response = AccountReParentingService.doPatch(brainTreeId, accountName);
        
        //verify the response
        System.assert(response != null , 'RestResponseHandler is not null');
        System.assertEquals('Success', response.Status, 'Status should be SUCCESS');
        System.assert(response.Data != null);
        System.assert((response.Data).size() == 2);
        List<Account> resultantAccount = response.Data;
        System.assertEquals('Existing Acct With BTId', resultantAccount[0].Name, 
            'Response should contain the account with Name = Existing Acct With BTId');
        System.assertEquals('Existing Acct', resultantAccount[1].Name, 
            'Response should contain the account with Name = Existing Acct');   
        System.assertEquals(resultantAccount[0].parentId, resultantAccount[1].Id, 
            'Associate the 2 matching records using parentId');     
    }
    
  /**
  * ───────────────────────────────────────────────────────────────────────────────────────────────┐
  * test4NonExistingBtIdNExistingAcctName().
  *
  * This method tests the service method by passing valid inputs
  *     (brainTreeId = '001' and accountName = 'Existing Acct').
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  * FUNCTIONAL TEST LOGIC:
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  *    1. Asserting the results by verifying the RestResponseHandler properties like 
  *        (Status, Data, errorcode).
  *    2. Asserting the Data to contains a 2 Account records,
  *        1. A newly created Account record with Name = 'Newly Created Acct' and BraintreeID__c = 001.
  *        2. An Account record matching the input param accountName.
  *    3. Finally verifying the both records are associated using parentId.
  * ───────────────────────────────────────────────────────────────────────────────────────────────┘
  */
    testMethod static void test4NonExistingBtIdNExistingAcctName(){
        
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/BrainTree/AccountReParentingService';
        req.httpMethod = 'PATCH';
        RestContext.request = req;
        
        String brainTreeId = '001';
        String accountName = 'Existing Acct';
        RestResponseHandler response = AccountReParentingService.doPatch(brainTreeId, accountName);
        
        //verify the response
        System.assert(response != null , 'RestResponseHandler is not null');
        System.assertEquals('Success', response.Status, 'Status should be SUCCESS');
        System.assert(response.Data != null);
        System.assert((response.Data).size() == 2);
        List<Account> resultantAccount = response.Data;
        System.assertEquals('Newly Created Acct', resultantAccount[0].Name, 
            'Response should contain the newly created account with Name = Newly Created Acct');
        System.assertEquals('001', resultantAccount[0].BraintreeID__c,
            'Newly created record should have the BraintreeID__c = 001');    
        System.assertEquals('Existing Acct', resultantAccount[1].Name, 
            'Response should contain the account with Name = Existing Acct');   
        System.assertEquals(resultantAccount[0].parentId, resultantAccount[1].Id, 
            'Associate the 2 matching records using parentId');     
    }
    
  /**
  * ───────────────────────────────────────────────────────────────────────────────────────────────┐
  * test4NonExistingBtIdNNonExistingAcctName().
  *
  * This method tests the service method by passing valid inputs
  *     (brainTreeId = '011' and accountName = 'Non Existing Acct').
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  * FUNCTIONAL TEST LOGIC:
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  *    1. Asserting the results by verifying the RestResponseHandler properties like 
  *        (Status, Data, errorcode).
  *    2. Asserting the Data to contains only 1 Account record i.e. A newly created Account record 
  *        with Name = 'Non Existing Acct'(input param accountName) and BraintreeID__c = 001.
  * ───────────────────────────────────────────────────────────────────────────────────────────────┘
  */
    testMethod static void test4NonExistingBtIdNNonExistingAcctName(){
        
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/BrainTree/AccountReParentingService';
        req.httpMethod = 'PATCH';
        RestContext.request = req;
        
        String brainTreeId = '011';
        String accountName = 'Non Existing Acct';
        RestResponseHandler response = AccountReParentingService.doPatch(brainTreeId, accountName);
        
        //verify the response
        System.assert(response != null , 'RestResponseHandler is not null');
        System.assertEquals('Success', response.Status, 'Status should be SUCCESS');
        System.assert(response.Data != null);
        System.assert((response.Data).size() == 1);
        List<Account> resultantAccount = response.Data;
        System.assertEquals('Non Existing Acct', resultantAccount[0].Name, 
            'Response should contain the newly created account with Name = Newly Created Acct');
        System.assertEquals('011', resultantAccount[0].BraintreeID__c, 
            'Response should contain the newly created account with BraintreeID__c = 011');    
        System.assertEquals(null, resultantAccount[0].parentId, 
            'parentId for the newly created record should be null');     
    } 
        
  /**
  * ───────────────────────────────────────────────────────────────────────────────────────────────┐
  * @testSetup.
  *
  * Creating 2 Account records for testing, 
  *    1.  "existingAcctWithBtId" record with valid BraintreeID__c = '12345'.
  *    2.  "existingAcctWithNoParent" record without parentId meaning parentId = null.
  * ───────────────────────────────────────────────────────────────────────────────────────────────┘
  */
    @testSetup static void createTestData(){
        
        List<Account> testRecords = new List<Account>();
        //Account record with brainTreeId
        Account existingAcctWithBtId = new Account(Name = 'Existing Acct With BTId', BraintreeID__c = '12345');
        
        //Account record with NULL ParentId.
        Account existingAcctWithNoParent = new Account(Name = 'Existing Acct', ParentId = null);
        
        testRecords.add(existingAcctWithBtId);
        testRecords.add(existingAcctWithNoParent);
        
        if(!testRecords.isEmpty()){
            try{
                insert testRecords;
            }catch(Exception e){
                System.debug('Exception Occured in Test class '+e.getMessage());
            }
        }     
    }

}