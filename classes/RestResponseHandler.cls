/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Response Wrapper Class.
*
* The Wrapper class forms the response that needs to be sent when Rest resqest is made for the End Point
* URL AccountReParentingService.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Shruthi.Yallaiah 
* @version        1.0
* @created        04-25-2017
* @modified       04-25-2017
* ──────────────────────────────────────────────────────────────────────────────────────────────────
*/
global class RestResponseHandler {
    
    public String Status {get; set;}
    public List<sObject> Data {get;set;}
    public String Message {get;set;}
    public String ErrorCode {get; set;}
    
    global RestResponseHandler(String Status, List<sObject> Data, String Message, String ErrorCode){
        this.Status = Status;
        this.Data = Data;
        this.Message = Message;
        this.ErrorCode = ErrorCode;
    }
    
}