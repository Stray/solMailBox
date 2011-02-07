package solmailboxclient.model {
		
	public interface IMailMessage {
		
	    function get body():String;

	    function set body(value:String):void;
	    
		function get id():uint; 
		
		function get link():uint;
			    
		function get status():MessageStatus;

		function set status(value:MessageStatus):void;
	    
		function get dateTimeStamp():Date;
		
		function get vo():MailMessageVO;
		
	}
}
