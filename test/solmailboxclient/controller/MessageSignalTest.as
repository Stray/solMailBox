package solmailboxclient.controller {

	import asunit.framework.TestCase;

	public class MessageSignalTest extends TestCase {
		private var instance:MessageSignal;

		public function MessageSignalTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new MessageSignal();
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is MessageSignal", instance is MessageSignal);
		}

		public function testFailure():void {
			assertTrue("Failing test", true);
		}
	}
}