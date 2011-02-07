package view {

	import asunit.framework.TestCase;
	import flash.text.TextField;

	public class NotebookTest extends TestCase {
		private var notebook:Notebook;

		public function NotebookTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			notebook = new Notebook(new TextField(), "notebook_test", "/", 3);
		}

		override protected function tearDown():void {
			super.tearDown();
			notebook = null;
		}

		public function testInstantiated():void {
			assertTrue("notebook is Notebook", notebook is Notebook);
		}

		public function testFailure():void {
			assertTrue("Failing test", true);
		}
	}
}