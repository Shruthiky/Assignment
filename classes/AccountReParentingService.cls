/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* End Point Url Class.
*
* The class contains a single http method @HttpPatch.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Shruthi.Yallaiah 
* @version        1.0
* @created        04-25-2017
* @modified       04-25-2017
* ──────────────────────────────────────────────────────────────────────────────────────────────────
*/
@RestResource(urlMapping='/BrainTree/AccountReParentingService/*')
global class AccountReParentingService{

    
  /**
  * ───────────────────────────────────────────────────────────────────────────────────────────────┐
  * doPatch() simply handles the request to the handler.
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  * @param    brainTreeId    String
  * @param    accountName    String
  * @return   TYPE    RestResponseHandler
  * ───────────────────────────────────────────────────────────────────────────────────────────────┘
  */
    @HttpPatch
    global static RestResponseHandler doPatch(String brainTreeId, String accountName){
        AccountReParentingServiceHandler handler = new AccountReParentingServiceHandler();
        return handler.handlePatchRequest(brainTreeId, accountName);
    }    
}