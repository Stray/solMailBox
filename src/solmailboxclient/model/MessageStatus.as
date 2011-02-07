package solmailboxclient.model {
	
	public class MessageStatus {
		
		public static const NEW:MessageStatus = new MessageStatus('NEW');
		public static const PENDING:MessageStatus = new MessageStatus('PENDING');
		public static const READ:MessageStatus = new MessageStatus('READ');
		public static const DELETED:MessageStatus = new MessageStatus('DELETED');
		
		protected var _status:String;
		
		public function MessageStatus(status:String) {
			_status = status;
		}
		
		public function get status():String
		{
			return _status;
		}
		
		public function toString():String
		{
			return '[object MessageStatus -> '+ _status +']';
		} 
	}
}
