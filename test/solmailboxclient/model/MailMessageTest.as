package solmailboxclient.model {

	import asunit.framework.TestCase;

	public class MailMessageTest extends TestCase {
		private var instance:MailMessage;
		
		private const BODY:String = "Test body";
		private const ID:uint = 234;
		private const DATE:Date = new Date();
		private const STATUS:MessageStatus = MessageStatus.PENDING   
		private const LINK:uint = 3;

		public function MailMessageTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new MailMessage(ID, LINK, BODY, DATE, STATUS);
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is MailMessage", instance is MailMessage);
		}
		
		public function testImplementsInterface():void {
			assertTrue("instance is IMailMessage", instance is IMailMessage);
		}

		public function testFailure():void {
			assertTrue("Failing test", true);
		}
		
		public function test_get_body():void {
			assertEquals("Get body", BODY, instance.body);
		}
		
		public function test_get_id():void {
			assertEquals("Get id", ID, instance.id);
		}
		
		public function test_get_dateTimeStamp():void {
			assertEquals("Get dateTimeStamp", DATE, instance.dateTimeStamp);
		}
		
		public function test_get_status():void {
			assertEquals("Get status", STATUS, instance.status);
		}

		public function test_set_status():void {
			instance.status =  MessageStatus.READ;
			assertEquals("Set status", MessageStatus.READ, instance.status);
		}
		
		public function test_set_body_updates_date():void {
			instance.body = "New body";
			var updatedDate:Date = instance.dateTimeStamp;
			assertTrue("Set body updates date", updatedDate.time > DATE.time );
		} 
		
	    public function test_get_link():void {
	    	assertEquals("Get link", LINK, instance.link);
	    }
		
		
		
	}
}