package solmailboxclient.model {

	import asunit.framework.TestCase;
	import flash.net.SharedObject;
	import solmailboxclient.model.IMailMessage;
	import asunit.errors.AssertionFailedError;

	public class SolMailBoxTest extends TestCase {
		private var solMailBox:SolMailBox;
        private const SOL_NAME:String = "solMailBox";
		private const SOL_PATH:String = "/";  

		public function SolMailBoxTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();                                     
			resetSol();
			solMailBox = new SolMailBox(SOL_NAME, SOL_PATH);
		}

		override protected function tearDown():void {
			super.tearDown();
			solMailBox = null;
		}

		public function testInstantiated():void {
			assertTrue("solMailBox is SolMailBox", solMailBox is SolMailBox);
		}

		public function testFailure():void {
			assertTrue("Failing test", true);
		} 
		
		public function test_load_finds_correct_newest_item():void {
			solMailBox.loadedSignal.add(loadedHandler);
			solMailBox.load(5);
		} 
		
		/*
		public function test_speed_straight_sort():void {
			trace("--- STRAIGHT ---")                     
			solMailBox.speedTestStraightSort(500000,500);
			solMailBox.speedTestStraightSort(100000,500);
			solMailBox.speedTestStraightSort(100000,100);
			solMailBox.speedTestStraightSort(10000,200);
			solMailBox.speedTestStraightSort(10000,50);
			solMailBox.speedTestStraightSort(1000,50);
			solMailBox.speedTestStraightSort(100,10);
		}
		
		public function test_speed_linked_sort():void {  
			trace("--- LINKED ---")
			solMailBox.speedTestLinkedSort(500000,500);
			solMailBox.speedTestLinkedSort(100000,500);
			solMailBox.speedTestLinkedSort(100000,100);
			solMailBox.speedTestLinkedSort(10000,200);
			solMailBox.speedTestLinkedSort(10000,50);
			solMailBox.speedTestLinkedSort(1000,50);
			solMailBox.speedTestLinkedSort(100,10);
		}
		*/
		
		
		private function loadedHandler(message:IMailMessage):void
		{
			try {                                                          
             	assertEquals("Picks item with correct link", 5, message.link);
             	assertEquals("Picks item with correct ID", 15, message.id);
			}
			catch(assertionFailedError:AssertionFailedError) {
				getResult().addFailure(this, assertionFailedError);
			}
		}
		
		private function resetSol():void
		{
			var testSO:SharedObject = getSol();
			testSO.clear();
			populateSol(20);
		}                 
		
		private function populateSol(totalItems:uint):void
		{   
			var solData:Object = {};                  
			var mailMessageVO:MailMessageVO;  
			var readMessages:Vector.<MailMessageVO> = new <MailMessageVO>[];
			
			var iLength:uint = totalItems;
			for (var i:int = 0; i < iLength; i++)
			{
			   	mailMessageVO = new MailMessageVO();
			   	mailMessageVO.body = "some text";
			    mailMessageVO.id = i+1;
				mailMessageVO.link = (i+1) % 10;
				mailMessageVO.status = "READ";
				mailMessageVO.dateTimeStamp = new Date(); 
				readMessages[readMessages.length] = mailMessageVO;
			}
  
			solData.readMessages = readMessages;
			solData.newMessages = new <MailMessageVO>[];
			
			writeSol(solData);
		}
		
		private function writeSol(data:Object):void
		{			
			var testSO:SharedObject = getSol();
			
			for(var v:* in data)
			{
				testSO.data[v] = data[v];
			}
			
			testSO.flush();
			testSO.close();
		}
		
		private function readSol():Object
		{
			var testSO:SharedObject = getSol();
			
		    var solData:Object = testSO.data;
		
			testSO.close();
			return solData;
		}
		
		private function getSol():SharedObject
		{
			return SharedObject.getLocal(SOL_NAME, SOL_PATH);
		}
		
		private function printObject(o:Object):void
		{
			for(var v:* in o)
			{
				trace(v + " -> " + o[v]);
			}
		}
	}
}