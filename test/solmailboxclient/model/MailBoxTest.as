package solmailboxclient.model {

	import asunit.framework.TestCase;
	import flash.errors.IllegalOperationError;

	public class MailBoxTest extends TestCase {
		private var instance:MailBox; 
		private var _messageSignalReceived:Boolean; 
		
		private const FIRST_MESSAGE_BODY:String = "Test message";

		public function MailBoxTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new MailBox();
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is MailBox", instance is MailBox);
		} 
		
		public function testInterface():void {
			assertTrue("instance is IMailBox", instance is IMailBox);
		}

		public function testFailure():void {
			assertTrue("Failing test", true);
		}
		
		public function test_adding_a_message_fires_the_new_message_signal():void {
			_messageSignalReceived = false;   
			instance.newMessageSignal.add(messageSignalReceiver);
			instance.addMessage(FIRST_MESSAGE_BODY);   
			assertTrue("message signal fired", _messageSignalReceived);
		}
		
		private function messageSignalReceiver(message:IMailMessage):void
		{
			_messageSignalReceived = true; 
		    assertEquals("correct message dispatched", FIRST_MESSAGE_BODY, message.body)
		}
		
		public function test_consecutive_messages_have_consecutive_ids():void {
			assertEquals("Consecutive messages have consecutive ids", 1, instance.addMessage('test msg 1').id);
			assertEquals("Consecutive messages have consecutive ids", 2, instance.addMessage('test msg 2').id);
			assertEquals("Consecutive messages have consecutive ids", 3, instance.addMessage('test msg 3').id);
		}
		
		public function test_get_new_messages_returns_new_messages():void {
            var msg1:IMailMessage = instance.addMessage('test msg 1');
			var msg2:IMailMessage = instance.addMessage('test msg 2');
            var msg3:IMailMessage = instance.addMessage('test msg 3');
			var messages:Vector.<IMailMessage> = instance.getNewMessages();
			assertEquals("correct number of new messages", 3, messages.length);
			assertEquals("correct first item", msg1, messages[0]);
			assertEquals("correct 2nd item", msg2, messages[1]);
			assertEquals("correct 3rd item", msg3, messages[2]);
		}
		                
		public function test_has_new_messages_is_true_until_messages_taken():void {
			assertFalse("Has new messages is false initially", instance.hasNewMessages);
            instance.addMessage('test msg 1')
			instance.addMessage('test msg 2')
            instance.addMessage('test msg 3')
			assertTrue("Has new messages is true after messages added", instance.hasNewMessages);
			var messages:Vector.<IMailMessage> = instance.getNewMessages();
			assertFalse("Has new messages is no longer true", instance.hasNewMessages);
		}
		
		public function test_new_messages_are_put_in_to_pending():void {
			var msg1:IMailMessage = instance.addMessage('test msg 1')
			var msg2:IMailMessage = instance.addMessage('test msg 2')
            var msg3:IMailMessage = instance.addMessage('test msg 3')
			var newMessages:Vector.<IMailMessage> = instance.getNewMessages();
  		    var pendingMessages:Vector.<IMailMessage> = instance.getPendingMessages();
			assertEqualsVectorsIgnoringOrder("items now in pending", newMessages, pendingMessages);
			assertEquals("no new messages remain", 0, instance.getNewMessages().length);
		} 
		
		public function test_new_messages_are_put_in_to_pending_in_diff_order():void {
			var msg1:IMailMessage = instance.addMessage('test msg 1')
			var msg2:IMailMessage = instance.addMessage('test msg 2')
			var newMessages1:Vector.<IMailMessage> = instance.getNewMessages();
	    	var pendingMessages1:Vector.<IMailMessage> = instance.getPendingMessages();
			assertEqualsVectorsIgnoringOrder("items now in pending", newMessages1, pendingMessages1);   
			
            var msg3:IMailMessage = instance.addMessage('test msg 3')
			var newMessages2:Vector.<IMailMessage> = instance.getNewMessages();
			assertEquals("only one new message", 1, newMessages2.length);

  		    var pendingMessages2:Vector.<IMailMessage> = instance.getPendingMessages();
			assertEqualsVectorsIgnoringOrder("all items now in pending", new <IMailMessage>[msg1, msg2, msg3], pendingMessages2);   
		}
		
		public function test_status_of_message_is_changed_to_pending_when_retrieved():void { 
			var msg1:IMailMessage = instance.addMessage('test msg 1');
			assertEquals("Status of message is originally 'new'", MessageStatus.NEW, msg1.status); 
			var newMessages:Vector.<IMailMessage> = instance.getNewMessages();
			assertEquals("Status of message is changed to 'pending' when retrieved", MessageStatus.PENDING, msg1.status); 
		}
		
		public function test_pending_messages_are_moved_to_read_when_confirmed_read():void {
			var msg1:IMailMessage = instance.addMessage('test msg 1');
			var msg2:IMailMessage = instance.addMessage('test msg 2');
			var msg3:IMailMessage = instance.addMessage('test msg 3');
			instance.getNewMessages();
			instance.getPendingMessages();
			instance.confirmRead(new <uint>[1,2]); 
			
			assertEqualsVectorsIgnoringOrder("unread messages are still pending", new <IMailMessage>[msg3], instance.getPendingMessages());
			assertEqualsVectorsIgnoringOrder("read messages are moved", new <IMailMessage>[msg1, msg2], instance.getReadMessages());
			
			assertEquals('status of read messages changed', MessageStatus.READ, msg1.status);
			assertEquals('status of read messages changed', MessageStatus.READ, msg2.status);
			assertEquals('status of pending messages unchanged', MessageStatus.PENDING, msg3.status);
		}   
		
		public function test_all_messages_includes_every_message():void {
			var msg1:IMailMessage = instance.addMessage('test msg 1');
			var msg2:IMailMessage = instance.addMessage('test msg 2');
			var msg3:IMailMessage = instance.addMessage('test msg 3');
			instance.getNewMessages();
			instance.getPendingMessages();
			instance.confirmRead(new <uint>[1,2]);   
			var msg4:IMailMessage = instance.addMessage('test msg 4');
			
			assertEqualsVectorsIgnoringOrder("includes new, pending and read messages", new <IMailMessage>[msg1, msg2, msg3, msg4], instance.getAllMessages());
		}
		
		public function test_pending_messages_returned_to_new_status():void {
			var msg1:IMailMessage = instance.addMessage('test msg 1')
			var msg2:IMailMessage = instance.addMessage('test msg 2')
			var newMessages1:Vector.<IMailMessage> = instance.getNewMessages();
	    	var pendingMessages1:Vector.<IMailMessage> = instance.getPendingMessages();
			assertEqualsVectorsIgnoringOrder("items now in pending", newMessages1, pendingMessages1);   
			
            var msg3:IMailMessage = instance.addMessage('test msg 3');
		   
		 	instance.resetMessagesToNew(new <uint>[1,2]);

			assertEquals('status of pending messages changed back to new', MessageStatus.NEW, msg1.status);
			assertEquals('status of pending messages changed back to new', MessageStatus.NEW, msg2.status);
			assertEquals('status of new messages unchanged', MessageStatus.NEW, msg3.status);

			var newMessages2:Vector.<IMailMessage> = instance.getNewMessages();
			assertEqualsVectorsIgnoringOrder("all items now in pending", new <IMailMessage>[msg1, msg2, msg3], newMessages2);   
		} 
		
		public function test_delete_messages_by_id_deletes_correct_messages():void {
			var msg1:IMailMessage = instance.addMessage('test msg 1');
			var msg2:IMailMessage = instance.addMessage('test msg 2');
			var msg3:IMailMessage = instance.addMessage('test msg 3');
			var msg4:IMailMessage = instance.addMessage('test msg 4'); 
			
			instance.getNewMessages();
			instance.confirmRead(new <uint>[1,2]);   
			
			assertEqualsVectorsIgnoringOrder("pending messages correct 1", new <IMailMessage>[msg3, msg4], instance.getPendingMessages());
			assertEqualsVectorsIgnoringOrder("read messages correct 1", new <IMailMessage>[msg1, msg1], instance.getReadMessages());
			
			var msg5:IMailMessage = instance.addMessage('test msg 5');
			var msg6:IMailMessage = instance.addMessage('test msg 6'); 

			assertEquals("6 items before", 6, instance.getAllMessages().length);
			trace(instance.getAllMessages());
			
			var deletedIDs:Vector.<uint> = instance.deleteMessages(new <uint>[2,4,6,8]);  
            trace(instance.getAllMessages());
			assertEquals("3 items after", 3, instance.getAllMessages().length);
			
			assertEqualsVectorsIgnoringOrder("only existing messages deleted", new <uint>[2,4,6], deletedIDs);

			var pendingMessages:Vector.<IMailMessage> = instance.getPendingMessages();
			var readMessages:Vector.<IMailMessage> = instance.getReadMessages();
			var newMessages:Vector.<IMailMessage> = instance.getNewMessages(); 
			
			assertEqualsVectorsIgnoringOrder("read messages correct", new <IMailMessage>[msg1], readMessages);   
			assertEqualsVectorsIgnoringOrder("pending messages correct", new <IMailMessage>[msg3], pendingMessages);   
			assertEqualsVectorsIgnoringOrder("new messages correct", new <IMailMessage>[msg5], newMessages);   
		}
		 
		public function test_delete_all():void {
			var msg1:IMailMessage = instance.addMessage('test msg 1');
			var msg2:IMailMessage = instance.addMessage('test msg 2');
			var msg3:IMailMessage = instance.addMessage('test msg 3');
			var msg4:IMailMessage = instance.addMessage('test msg 4'); 
			
			instance.getNewMessages();
			instance.confirmRead(new <uint>[1,2]);   
			
			assertEqualsVectorsIgnoringOrder("pending messages correct 1", new <IMailMessage>[msg3, msg4], instance.getPendingMessages());
			assertEqualsVectorsIgnoringOrder("read messages correct 1", new <IMailMessage>[msg1, msg1], instance.getReadMessages());
			
			var msg5:IMailMessage = instance.addMessage('test msg 5');
			var msg6:IMailMessage = instance.addMessage('test msg 6');
			
			assertEquals("6 items before", 6, instance.getAllMessages().length);
			
			instance.deleteAll();
			
			assertEquals("0 items after", 0, instance.getAllMessages().length);
			
			assertEquals('status of pending messages changed to deleted 1', MessageStatus.DELETED, msg1.status);
			assertEquals('status of pending messages changed to deleted 2', MessageStatus.DELETED, msg2.status);
			assertEquals('status of pending messages changed to deleted 3', MessageStatus.DELETED, msg3.status);
			assertEquals('status of pending messages changed to deleted 4', MessageStatus.DELETED, msg4.status);
			assertEquals('status of pending messages changed to deleted 5', MessageStatus.DELETED, msg5.status);
			assertEquals('status of pending messages changed to deleted 6', MessageStatus.DELETED, msg6.status);
			 
		}
		
		public function test_populate_throws_error_for_existing_key():void {
			var messages:Vector.<IMailMessage> = createMessages(new <uint>[1,2,3,4,5,3], MessageStatus.NEW);
			assertThrows(IllegalOperationError, function():void {instance.populateWith(messages)});
		}
		
		public function test_populate():void {
			var newMessages:Vector.<IMailMessage> = createMessages(new <uint>[1,2,3], MessageStatus.NEW);
			var readMessages:Vector.<IMailMessage> = createMessages(new <uint>[4,5,6,7], MessageStatus.READ);
			instance.populateWith(newMessages);
			instance.populateWith(readMessages);                                    
			var allMessages:Vector.<IMailMessage> = instance.getAllMessages();
			var newMessagesReturned:Vector.<IMailMessage> = instance.getNewMessages();
			var readMessagesReturned:Vector.<IMailMessage> = instance.getReadMessages();
			
			assertEquals("Total 7 messages", 7, allMessages.length);
			assertEquals("3 new messages", 3, newMessagesReturned.length);
			assertEquals("4 new messages", 4, readMessagesReturned.length);			
		}
		
		private function createMessages(messageKeys:Vector.<uint>, messageStatus:MessageStatus):Vector.<IMailMessage>
		{
			var messagesVector:Vector.<IMailMessage> = new Vector.<IMailMessage>();
			
			var iLength:uint = messageKeys.length;
			for (var i:int = 0; i < iLength; i++)
			{
				var msg:MailMessage = new MailMessage(messageKeys[i], messageKeys[i]+1, 'test message', new Date(), messageStatus);
				messagesVector.push(msg);
			}                            
			
			return messagesVector;
		}
		
		
	}
}