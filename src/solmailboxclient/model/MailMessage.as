package solmailboxclient.model {
		
	public class MailMessage implements IMailMessage {
		
		protected var _id:uint;
		protected var _body:String;
		protected var _dateTimeStamp:Date;
		protected var _status:MessageStatus;
		protected var _link:uint;
		
		public function MailMessage(id:uint, link:uint, body:String, dateTimeStamp:Date, status:MessageStatus) {
			_id = id;
			_body = body;
			_dateTimeStamp = dateTimeStamp;
			_status = status;
			_link = link;
		} 
		
		//---------------------------------------
		// IMailMessage Implementation
		//---------------------------------------

		//import solmailboxclient.model.IMailMessage;
		public function get body():String
		{
			return _body;
		}
		
		public function set body(value:String):void
		{
			_body = value;
			_dateTimeStamp = new Date();
		}

		public function get id():uint
		{
			return _id;
		}
		
		public function get link():uint
		{
			return _link;
		}

		public function get status():MessageStatus
		{
			return _status;
		}

		public function set status(value:MessageStatus):void
		{
			_status = value;
		}

		public function get dateTimeStamp():Date
		{
			return _dateTimeStamp;
		}
        
		public function toString():String
		{
			return '[object MailMessage -> ' + _id + ']';
		}
		
		public function get vo():MailMessageVO
		{
			var mailMessageVO:MailMessageVO = new MailMessageVO();
			mailMessageVO.id = _id;
			mailMessageVO.status = _status.status;
			mailMessageVO.dateTimeStamp = _dateTimeStamp;
			mailMessageVO.body = _body;   
			mailMessageVO.link = _link;
			
			return mailMessageVO;
		}
		
	}
}