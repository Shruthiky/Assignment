/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* End Point Url Service Handler Class.
*
* The Handler class performs all the execution logic and generates the response called 
* RestResponseHandler.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Shruthi.Yallaiah 
* @version        1.0
* @created        04-25-2017
* @modified       04-25-2017
* ──────────────────────────────────────────────────────────────────────────────────────────────────
*/
public class AccountReParentingServiceHandler{
    
    private static final String MESSAGE1 = 'Found 2 Accounts with matching brainTreeId and accountName, hence associating both.';
    private static final String MESSAGE2 = 'Found Account with brainTreeId, but there is no parent Account to associate it with.';      
    private static final String MESSAGE3 = 'No Account found matching brainTreeId but found an existing Account with matching accountName'+ 
                            ' hence created new Account and associated the matched Account as its parent Account';
    private static final String MESSAGE4 = 'No Accounts found matching brainTreeId and accountName, hence created new Account with given name and brainTreeId.';                        
  
  /**
  * ───────────────────────────────────────────────────────────────────────────────────────────────┐
  * handlePatchRequest() performs following: 
  * 1. If an Account exists in the database with the input Braintree ID.
  *    a. If an Account exists then issue another query to find a possible parent account in the database.
  *    b. Update the Account found in [1] with a “Parent Account” using the account found in [1.a].
  *
  * 2. If an Account does not exist by Braintree ID.
  *    a. Query for an existing Account by NAME.
  *    b. If no match, create an Account with that name.  
  *    c. If there is a match, create a new Account with that name and assign the matching Account 
  *        as the Parent Account.
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  * @param    brainTreeId    String
  * @param    accountName    String
  * @return   TYPE    RestResponseHandler
  * ───────────────────────────────────────────────────────────────────────────────────────────────┘
  */
    public RestResponseHandler handlePatchRequest(String brainTreeId, String accountName){
        
        //since the BraintreeID__c is unique expecting a single record.
        List<Account> brainTreeIdMatchedAccts;
        List<Account> acctNameMatchedAccs;
        RestResponseHandler response;
        
        try{
            //the input parameters should not be either NULL or BLANK. If they are NULL/BLANK
            //create an ERROR response using RestResponseHandler.
            if(isNotNullOrEmpty(brainTreeId) && isNotNullOrEmpty(accountName)){
                brainTreeIdMatchedAccts = searchAcctWithBrainTreeId(brainTreeId);
            }else{
                response = new RestResponseHandler(
                            'Error', 
                             null, 
                            'Input parameters are Null or Blank', 
                            'Braintree Code:001');
                return response;            
            }
            //if Account exist by Braintree ID
            if(brainTreeIdMatchedAccts != null && !brainTreeIdMatchedAccts.isEmpty() && brainTreeIdMatchedAccts.size() == 1){ 
                //query for existing record matching input accountName.
                acctNameMatchedAccs = searchAcctWithCriteria(accountName, brainTreeIdMatchedAccts[0]);
                
                if(acctNameMatchedAccs != null && !acctNameMatchedAccs.isEmpty() && acctNameMatchedAccs.size() == 1){
                    updateMatchedAcctParent(brainTreeIdMatchedAccts[0], acctNameMatchedAccs[0]);    
                        
                    response = new RestResponseHandler(
                        'Success', 
                        new List<sObject>{brainTreeIdMatchedAccts[0],acctNameMatchedAccs[0]},  
                        MESSAGE1, 
                        null);
                    }else{
                        response = new RestResponseHandler(
                            'Success', 
                             brainTreeIdMatchedAccts, 
                             MESSAGE2, 
                             NULL);
                    }    
            }else{ //Account does not exist by Braintree ID
                  
                //Query for an existing Account by accountName.
                acctNameMatchedAccs = [SELECT Id, Name FROM Account WHERE Name =: accountName LIMIT 1];
                response = createNewAccount(acctNameMatchedAccs, brainTreeId, accountName);
            } 
        }catch(Exception e){
            System.debug('Exception encountered: '+e.getMessage());
        }    
        return response;
    }
    
  /**
  * ───────────────────────────────────────────────────────────────────────────────────────────────┐
  * searchAcctWithBrainTreeId() queries on Account object for matching brainTreeId record.
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  * @param    brainTreeId    String
  * @return   TYPE    List<Account>
  * ───────────────────────────────────────────────────────────────────────────────────────────────┘
  */
    public List<Account> searchAcctWithBrainTreeId(String brainTreeId) {
        List<Account> acctList;
        try{
            //query the Account table to see if an Account exists in the database with that Braintree ID.
            acctList = [SELECT Id, Name, BraintreeID__c FROM Account 
                    WHERE BraintreeID__c =: brainTreeId];
        }catch(QueryException e){
            System.debug('Exception encountered: '+e.getMessage());
        }   
        return acctList;         
    }
    
  /**
  * ───────────────────────────────────────────────────────────────────────────────────────────────┐
  * searchAcctWithCriteria() queries on Account object with the following criteria.
  * 1.  Name matches the name provided in the rest request
  * 2.  Braintree ID != the ID from the rest request
  * 3.  “Parent Account” is empty
  * 4.  Limit 1 record in the response
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  * @param    accountName    String
  * @param    brainTreeIdMatchedAcct    Account
  * @return   TYPE    List<Account>
  * ───────────────────────────────────────────────────────────────────────────────────────────────┘
  */
    public List<Account> searchAcctWithCriteria(String accountName, Account brainTreeIdMatchedAcct){
        List<Account> acctList;
        try{
            //query for existing record matching input accountName.
            acctList = [SELECT Id, Name FROM Account WHERE 
                        Name =: accountName AND 
                        Id !=: brainTreeIdMatchedAcct.BraintreeID__c AND
                        ParentId = NULL LIMIT 1];
        }catch(QueryException e){
            System.debug('Exception encountered: '+e.getMessage());
        } 
        return acctList;               
    }
    
  /**
  * ───────────────────────────────────────────────────────────────────────────────────────────────┐
  * updateMatchedAcctParent() updates the 2 Account records by associating them with parentId.
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  * @param    acctNameMatchedAccount    Account
  * @param    brainTreeIdMatchedAcct    Account
  * @return   TYPE    void
  * ───────────────────────────────────────────────────────────────────────────────────────────────┘
  */
    public void updateMatchedAcctParent(Account brainTreeIdMatchedAcct, Account acctNameMatchedAccount){
        //Update the Account found in 5.) with a “Parent Account” using the account found in 6.)
        brainTreeIdMatchedAcct.ParentId = acctNameMatchedAccount.Id;
        try{
            update brainTreeIdMatchedAcct;
        }catch(DMLException e){
            System.debug('Exception encountered: '+e.getMessage());
        }    
    }
    
  /**
  * ───────────────────────────────────────────────────────────────────────────────────────────────┐
  * createNewAccount() createa a new Account record with Name = 'Newly Created Acct' by associating 
  * them with parentId if parentId is available otherwise it creates a new Account record with just 
  * Name = input parameters accountName and BraintreeID__c = brainTreeId.
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  * @param    brainTreeId    String
  * @param    accountName    String
  * @param    acctNameMatchedAccts    List<Account>
  * @return   TYPE    RestResponseHandler
  * ───────────────────────────────────────────────────────────────────────────────────────────────┘
  */ 
    public RestResponseHandler createNewAccount(List<Account> acctNameMatchedAccts, String brainTreeId, String accountName){
        
        Account newAccount;
        String message;
        List<Account> responseData = new List<Account>();
        try{      
            if(acctNameMatchedAccts != null && !acctNameMatchedAccts.isEmpty()){ 
                //create a new Account with that name and assign the matching Account as the Parent Account
                newAccount = new Account(Name = 'Newly Created Acct', BraintreeID__c = brainTreeId, parentId = acctNameMatchedAccts[0].Id);
            }else{ //create an Account with that name
                newAccount = new Account(Name = accountName, BraintreeID__c = brainTreeId);
            }
            try{
                insert newAccount;
            }catch(DMLException e){
                System.debug('Exception encountered: '+e.getMessage());
            }
            if(newAccount.Id != null){
                responseData.add(newAccount);
                if(newAccount.parentId != null){
                    message = MESSAGE3;
                    responseData.add(acctNameMatchedAccts[0]);
                }else{
                    message = MESSAGE4;
                } 
            }
        }catch(Exception ex){
            System.debug('Exception encountered: '+ex.getMessage());
        }    
        return new RestResponseHandler(
                'Success', 
                responseData, 
                message, 
                null);
    }
    
  /**
  * ───────────────────────────────────────────────────────────────────────────────────────────────┐
  * isNotNullOrEmpty() verifies if the input parameter is not NULL/BLANK
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  * @param    str    String
  * @return   TYPE   boolean
  * ───────────────────────────────────────────────────────────────────────────────────────────────┘
  */
    public static boolean isNotNullOrEmpty(string str){
        return str!=null && !String.isBlank(str); 
    }

}