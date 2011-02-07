package solmailboxclient.controller {
	
	import solmailboxclient.model.IMailMessage; 
	import org.osflash.signals.Signal;
	
	public class MessageSignal extends Signal {
		
		public function MessageSignal() {
			super(IMailMessage);
		} 
	}
}