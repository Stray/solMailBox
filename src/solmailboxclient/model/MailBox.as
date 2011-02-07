package solmailboxclient.model {
	
	import solmailboxclient.controller.MessageSignal;
	import flash.utils.Dictionary; 
	import org.osflash.signals.Signal;
	import flash.errors.IllegalOperationError;
	
	public class MailBox implements IMailBox { 
		
		protected var _newMessageSignal:MessageSignal;   
		protected var _updatedSignal:Signal;
		
		protected var _currentIndex:uint;  
		   	
		protected var _messagesByID:Dictionary;		
		protected var _messageListsByStatus:Dictionary;
		
		public function MailBox(currentIndex:uint = 1) {
			_currentIndex = currentIndex;
   	    	init();
		} 
		
		public function addMessage(messageBody:String, link:uint = 0):IMailMessage
		{
			var mailMessage:IMailMessage = new MailMessage(nextID, link, messageBody, dateTimeStamp, MessageStatus.NEW);
			
			storeMessage(mailMessage);
			newMessageSignal.dispatch(mailMessage);
			return mailMessage;
		} 

		public function get hasNewMessages():Boolean
		{
			return (numberOfNewMessages > 0);
		}

		public function get newMessageSignal():MessageSignal
		{
			return _newMessageSignal ||= new MessageSignal();
		} 
		
		public function get updatedSignal():Signal
		{
			return _updatedSignal ||= new Signal();
		}
		  
		public function getAllMessages():Vector.<IMailMessage>
		{
			var allMessagesVector:Vector.<IMailMessage> = newMessagesVector
															.concat(pendingMessagesVector)
															.concat(readMessagesVector);
			return allMessagesVector;
		}

		public function getNewMessages():Vector.<IMailMessage>
		{
			var requestedMessages:Vector.<IMailMessage> = newMessagesVector.splice(0, numberOfNewMessages);

			updateMessageStatusTo(requestedMessages, MessageStatus.PENDING);

		 	pendingMessagesVector = pendingMessagesVector.concat(requestedMessages);
			
			return requestedMessages;
		}

		public function getPendingMessages():Vector.<IMailMessage>
		{
			return pendingMessagesVector.slice();
		}
		
		public function getReadMessages():Vector.<IMailMessage>
		{
			return readMessagesVector.slice();
		}

		public function confirmRead(messageIDs:Vector.<uint>):Vector.<uint>
		{
			return processMessages(messageIDs, MessageStatus.READ);
		}
		
		public function resetMessagesToNew(messageIDs:Vector.<uint>):Vector.<uint>
		{
			return processMessages(messageIDs, MessageStatus.NEW);
		}   
		
		public function deleteMessages(messageIDs:Vector.<uint>):Vector.<uint>
		{
			return processMessages(messageIDs, MessageStatus.DELETED);
		}
		
		public function deleteAll():void
		{
			deletedMessagesVector = deletedMessagesVector.concat(getAllMessages());
			empty(newMessagesVector);
			empty(pendingMessagesVector);
			empty(readMessagesVector);
			
			updateMessageStatusTo(deletedMessagesVector, MessageStatus.DELETED);
  		}
		
		public function populateWith(messages:Vector.<IMailMessage>):void
		{
			var iLength:uint = messages.length;
			for (var i:int = 0; i < iLength; i++)
			{
				storeMessage(messages[i]);
			}
		}
		
		protected function storeMessage(message:IMailMessage):void
		{
			storeMessageReference(message);
			getMessageListForStatus(message.status).push(message);
		}
		
		protected function processMessages(messageIDs:Vector.<uint>, targetStatus:MessageStatus):Vector.<uint>
		{
			var processedItemIDs:Vector.<uint> = new Vector.<uint>();
            var targetMessageLocation:Vector.<IMailMessage> = getMessageListForStatus(targetStatus); 
		    var itemID:uint; 
			var itemProcessedOk:Boolean = false;
		
			var iLength:uint = messageIDs.length;
			for (var i:int = 0; i < iLength; i++)
			{
				itemID = messageIDs[i];
				itemProcessedOk = processItem(itemID, targetStatus, targetMessageLocation);
				if(itemProcessedOk)
				{
					processedItemIDs.push(itemID);
				}
			} 
			
			updatedSignal.dispatch();
		    
			return processedItemIDs; 
		} 
		
		protected function processItem(itemID:uint, targetStatus:MessageStatus, targetMessageLocation:Vector.<IMailMessage>):Boolean
		{
			var messageToProcess:IMailMessage = _messagesByID[itemID]; 
			
			if(messageToProcess == null)
			{
				return false;
			} 
			var currentMessageLocation:Vector.<IMailMessage> = getCurrentMessageLocation(messageToProcess);
			
		    var currentIndex:int = currentMessageLocation.indexOf(messageToProcess);
		 	if(currentIndex >= 0)
			{
				currentMessageLocation.splice(currentIndex,1);
				targetMessageLocation.push(messageToProcess);
				messageToProcess.status = targetStatus;
			}
			return true;
		}
		
		protected function init():void
		{
			_messagesByID = new Dictionary();
			_messageListsByStatus = new Dictionary();
   		} 
		
		protected function getCurrentMessageLocation(message:IMailMessage):Vector.<IMailMessage>
		{
			return getMessageListForStatus(message.status);
		}  
		
		protected function getMessageListForStatus(status:MessageStatus):Vector.<IMailMessage>
		{
			return _messageListsByStatus[status] ||= new Vector.<IMailMessage>();
		}
		
		protected function empty(vector:Vector.<IMailMessage>):void
		{
			vector.splice(0, vector.length);
		}
		  
		protected function updateMessageStatusTo(messages:Vector.<IMailMessage>, status:MessageStatus):void
		{
			var iLength:uint = messages.length;
			for (var i:int = 0; i < iLength; i++)
			{
				messages[i].status = status;
			}
		}
		
		protected function get dateTimeStamp():Date
		{
			return new Date();
		}
		
		protected function get nextID():uint
		{
			return _currentIndex++;
		}
		
		protected function get newMessagesVector():Vector.<IMailMessage>
		{
			return _messageListsByStatus[MessageStatus.NEW] ||= new Vector.<IMailMessage>();
		}
		
		protected function set newMessagesVector(value:Vector.<IMailMessage>):void
		{
			_messageListsByStatus[MessageStatus.NEW] = value;
		} 
		
		protected function get pendingMessagesVector():Vector.<IMailMessage>
		{
			return _messageListsByStatus[MessageStatus.PENDING] ||= new Vector.<IMailMessage>();
		}
		
		protected function set pendingMessagesVector(value:Vector.<IMailMessage>):void
		{
			_messageListsByStatus[MessageStatus.PENDING] = value;
		}
		 
		protected function get readMessagesVector():Vector.<IMailMessage>
		{
			return _messageListsByStatus[MessageStatus.READ] ||= new Vector.<IMailMessage>();
		}
		
		protected function set readMessagesVector(value:Vector.<IMailMessage>):void
		{
			_messageListsByStatus[MessageStatus.READ] = value;
		}
		
		protected function get deletedMessagesVector():Vector.<IMailMessage>
		{
			return _messageListsByStatus[MessageStatus.DELETED] ||= new Vector.<IMailMessage>();
		}
		
		protected function set deletedMessagesVector(value:Vector.<IMailMessage>):void
		{
			_messageListsByStatus[MessageStatus.DELETED] = value;
		}
		
		protected function storeMessageReference(mailMessage:IMailMessage):void
		{
		 	if(_messagesByID[mailMessage.id] != null)
			{
				throw new IllegalOperationError("You cannot have 2 messages with the same id - ids should be unique");
			}
			_messagesByID[mailMessage.id] = mailMessage;
		}
		
		protected function get numberOfNewMessages():uint
		{
			return newMessagesVector.length;
		}
	}
}