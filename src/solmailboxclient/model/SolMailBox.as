package solmailboxclient.model {
	
	import solmailboxclient.model.IMailMessage;
	import flash.net.SharedObject;
	import org.osflash.signals.Signal;
	import flash.utils.Dictionary;
	import flash.net.registerClassAlias; 
	import flash.utils.getTimer;
	
	public class SolMailBox extends MailBox implements IMailBox {
		
		protected var _solName:String;
		protected var _solPath:String;

		protected var _loadedSignal:Signal;
		
		protected var _currentMessage:IMailMessage;
		
		protected var _messagesByLink:Dictionary;
		
		public function SolMailBox(solName:String, solPath:String) {
			super();
			_solName = solName;
			_solPath = solPath; 
			registerClassAlias("solmailboxclient.model.MailMessageVO", MailMessageVO);
  		}


		public function get loadedSignal():Signal
		{
			return _loadedSignal ||= new Signal(IMailMessage);
		}
		
		public function load(link:uint=0):void
		{
			var mailSol:SharedObject = getSol();
			var solData:Object = mailSol.data;
			
			if(solData.newMessages != null)
			{
				newMessagesVector = createFromVOs(solData.newMessages, MessageStatus.NEW);
				readMessagesVector = createFromVOs(solData.readMessages, MessageStatus.READ);
			    loadedSignal.dispatch(findNewestMessageForLink(link));
			}               
		} 
		
		public function saveMessage(message:String, link:uint):IMailMessage
		{
			if(_currentMessage == null || (_currentMessage.status != MessageStatus.NEW) || (_currentMessage.link != link))
			{
				_currentMessage = addMessage(message, link);
				messagesForLink(link).push(_currentMessage); 
			} 
			else
			{
				_currentMessage.body = message;                               
			}
			
			saveToSol();
			return _currentMessage;
		}
		 
		protected function saveToSol():void
		{
			var mailSol:SharedObject = getSol();
		    var solData:Object = mailSol.data;
			
			solData.newMessages = getVOsFrom(newMessagesVector.concat(pendingMessagesVector));
			solData.readMessages = getVOsFrom(readMessagesVector);
			
			printObject(solData);
			
			mailSol.flush();
			mailSol.close();
		}
		
		protected function messagesForLink(link:uint):Vector.<IMailMessage>
		{
			return (messagesByLink[link] ||= new Vector.<IMailMessage>());
		} 
		
		protected function get messagesByLink():Dictionary
		{
			return _messagesByLink ||= sortMessagesByLink();
   		}  

		protected function findNewestMessageForLinkComparison(link:uint):IMailMessage
		{
			var allMessages:Vector.<IMailMessage> = getAllMessages();
			allMessages.sort(byDate);
			
			var iStart:int = allMessages.length-1;
			                     
			for (var i:int = iStart; i >= 0; i--)
			{
				if(allMessages[i].link == link)
				{
					return allMessages[i];
				}
			}
			
			return null;
		}
		
		protected function findNewestMessageForLink(link:uint):IMailMessage
		{
			var messageStackForLink:Vector.<IMailMessage> = messagesForLink(link);
			
			if(messageStackForLink.length == 0)
			{
				return saveMessage('', link);
			}
			
			messageStackForLink.sort(byDate);
			
			return messageStackForLink[messageStackForLink.length-1];
		}                                 
		
		protected function sortMessagesByLink():Dictionary
		{
			var allMessages:Vector.<IMailMessage> = getAllMessages();
			
			var messagesByLinkDictionary:Dictionary = new Dictionary();
			var iLength:uint = allMessages.length;
			for (var i:int = 0; i < iLength; i++)
			{
				var nextMessage:IMailMessage = allMessages[i];
				var link:uint = nextMessage.link;
				var messageStackForLink:Vector.<IMailMessage> = (messagesByLinkDictionary[link] ||= new Vector.<IMailMessage>())
				messageStackForLink.push(nextMessage);
			}
			
			return messagesByLinkDictionary;
		}
		
		protected function byDate(item1:IMailMessage, item2:IMailMessage):int
		{
			var utcDate1:Number = item1.dateTimeStamp.time;
			var utcDate2:Number = item2.dateTimeStamp.time;
			
			if(utcDate1 < utcDate2)
			{
				return -1;
			}
			
			if(utcDate2 > utcDate1)
			{
				return 1;
			}
			
			return 0;
		}  
		
		protected function getVOsFrom(messages:Vector.<IMailMessage>):Vector.<MailMessageVO>
		{
			var messageVOs:Vector.<MailMessageVO> = new <MailMessageVO>[];
			
			var iLength:uint = messages.length;
			for (var i:int = 0; i < iLength; i++)
			{
				messageVOs.push(messages[i].vo);
			}
			
			return messageVOs;
		}
		
		protected function createFromVOs(messageVOs:Vector.<MailMessageVO>, status:MessageStatus):Vector.<IMailMessage>
		{
			var messages:Vector.<IMailMessage> = new <IMailMessage>[];
			var nextVO:MailMessageVO;
			var nextMessage:IMailMessage;
			
			var iLength:uint = messageVOs.length;
			for (var i:int = 0; i < iLength; i++)
			{
				nextVO = messageVOs[i];
				nextMessage = new MailMessage(nextVO.id, nextVO.link, nextVO.body, nextVO.dateTimeStamp, status);
				messages.push(nextMessage);
			}
			
			return messages;
		}
		
		protected function getSol():SharedObject
		{
			return SharedObject.getLocal(_solName, _solPath);
		}
		
		private function printObject(o:Object):void
		{
			//trace("SolMailBox::printObject()");
			for(var v:* in o)
			{
				trace(v + " -> " + o[v]);
			}
		} 
		
		/*
		public function speedTestStraightSort(totalItems:uint, linkSets:uint):void
		{
		    populateForTest(totalItems, linkSets);
		
			var t:Number = getTimer();
			
			findNewestMessageForLinkComparison(5);
			
			trace("sort time: " + String(getTimer()-t));
			
		}  
		
		public function speedTestLinkedSort(totalItems:uint, linkSets:uint):void
		{
		    populateForTest(totalItems, linkSets);
		
			var t:Number = getTimer();
			
			findNewestMessageForLink(5);
			
			trace("sort time: " + String(getTimer()-t)); 			
		} 
		
		private function populateForTest(totalItems:uint, linkSets:uint):void
		{
			_messagesByLink = null;
			
			var messages:Vector.<IMailMessage> = new <IMailMessage>[];
			var nextMessage:IMailMessage;

			for (var i:int = 0; i < totalItems; i++)
			{
				nextMessage = new MailMessage(i+1, (i+1) % linkSets, 'test text', new Date(), MessageStatus.READ);
				messages.push(nextMessage);
			}

			readMessagesVector = messages;     
		}  
		*/
		 
	}
}