package solmailboxclient.model {

	import asunit.framework.TestCase;

	public class MessageStatusTest extends TestCase {
		private var instance:MessageStatus;
		private const STATUS:String = 'test status';

		public function MessageStatusTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new MessageStatus(STATUS);
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is MessageStatus", instance is MessageStatus);
		}

		public function testFailure():void {
			assertTrue("Failing test", true);
		}
		
		public function test_get_status():void {
			assertEquals("Get status", STATUS, instance.status);
		}
		
		public function test_status_NEW():void {
			assertEquals("Status NEW", 'NEW', MessageStatus.NEW.status);
		}
		
		public function test_status_PENDING():void {
			assertEquals("Status PENDING", 'PENDING', MessageStatus.PENDING.status);
		} 
		
		public function test_status_READ():void {
			assertEquals("Status READ", 'READ', MessageStatus.READ.status);
		}
		
		public function test_status_DELETED():void {
			assertEquals("Status DELETED", 'DELETED', MessageStatus.DELETED.status);
		} 
		
	}
}