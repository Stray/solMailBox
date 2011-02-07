package solmailboxclient.model {
		
	import solmailboxclient.controller.MessageSignal;
	import org.osflash.signals.Signal;
	
	public interface IMailBox {
		
	    function addMessage(messageBody:String, link:uint = 0):IMailMessage; 
	
	    function get hasNewMessages():Boolean;
	
	    function get newMessageSignal():MessageSignal;
	
		function get updatedSignal():Signal;
	
	    function getAllMessages():Vector.<IMailMessage>;
	
	    function getNewMessages():Vector.<IMailMessage>;
	
	    function getPendingMessages():Vector.<IMailMessage>;
	
	    function confirmRead(messageIDs:Vector.<uint>):Vector.<uint>;
	
	    function deleteMessages(messageIDs:Vector.<uint>):Vector.<uint>;
	
	    function deleteAll():void;
	}
}