package solmailboxclient.service {

	import org.osflash.signals.Signal;

	public interface IMailMonitor {
			
		function get monitoringInterval():Number;
	    
		function set monitoringInterval(seconds:Number):void;
	    
		function get hasNewMessagesSignal():Signal;
	    
		function startMonitoring():void;
	    
		function stopMonitoring():void;
	    
		function checkNow():void;		
	}
}