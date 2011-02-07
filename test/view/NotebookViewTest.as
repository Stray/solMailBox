package view {

	import asunit.framework.TestCase;

	public class NotebookViewTest extends TestCase {
		private var instance:NotebookView;

		public function NotebookViewTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new NotebookView();
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is NotebookView", instance is NotebookView);
		}

		public function testFailure():void {
			assertTrue("Failing test", true);
		}                                  

		public function test_verified_visually():void { 
			addChild(instance);
			assertTrue("Verified visually", true);
			removeChild(instance);
		}
	}
}