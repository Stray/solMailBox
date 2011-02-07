package xend_to_end {

	import asunit.framework.TestCase;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	
	import flash.utils.Timer;
	
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.text.TextField;
	
	import com.newloop.roboteyes.inViewOf;
	import com.newloop.roboteyes.core.RobotEyes;
	import com.newloop.roboteyes.drivers.DisplayObjectDriver; 
	import com.newloop.roboteyes.drivers.TextFieldDriver;
	import com.newloop.roboteyes.drivers.InteractiveObjectDriver;
	import flash.net.SharedObject;
	import asunit.errors.AssertionFailedError;
	import solmailboxclient.model.IMailMessage;
	import solmailboxclient.model.MailMessage;
	import solmailboxclient.model.MailMessageVO;

	public class NotebookSavesLocallyEndToEndTest extends TestCase {
		private var robotEyes:RobotEyes; 
		
		private const SOL_NAME:String = "notebook";
		private const SOL_PATH:String = "/";  

		private const SAVED_TEXT:String = "Saved text to check.";
		
		private const CHANGED_TEXT:String = "Changed text to check.";    
		
		private const LINK:uint = 4;

		public function  NotebookSavesLocallyEndToEndTest (methodName:String=null) {
			super(methodName)
		}

		override public function run():void{
			resetSol();
			if(robotEyes==null){
				robotEyes = new RobotEyes(NotebookDemo);
				addChild(robotEyes);
				robotEyes.visible = false;
			}
			// need to wait a while
			var timer:Timer = new Timer(1000,1);
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
			timer.start();
		}
		
		private function timerHandler(e:TimerEvent):void{
			robotEyes.visible = true;
			super.run();
		}

		override protected function setUp():void {
			super.setUp();
		}   
		
		override protected function tearDown():void {
			super.tearDown();
		}
		
		override protected function cleanUp():void{
			removeChild(robotEyes);
			robotEyes = null;
		}

		public function testApplicationInitiated():void{
			assertTrue("Application or Module initiated ok", robotEyes.testApplication is NotebookDemo);
		}
		
		public function testFailure():void {
			assertTrue("Failing test", true);
		}
		 
		public function test_picks_up_sol_contents():void {
			assertTrue("sol is used to populate notes", notesTextDriver.checkText(SAVED_TEXT));
			addAsync(null, 100, check_writing_content_puts_it_in_the_sol);
		}
		
		public function check_writing_content_puts_it_in_the_sol(e:Event):void {
			notesTextDriver.enterText(CHANGED_TEXT);
			
			addAsync(null, 5000, checkSolContents);
		}                                          

		protected function get notesTextDriver():TextFieldDriver {
		    return inViewOf(NotebookDemo).getA(TextField).named("notes_txt") as TextFieldDriver;
		}
		
		public function checkSolContents(e:Event):void {
			try 
			{
            	var solData:Object = readSol();
				printObject("solData: " + solData);    
			    var mailMessageVO:MailMessageVO = solData.newMessages.pop();
				var messageText:String = mailMessageVO.body;
				assertEquals("message is stored propery", CHANGED_TEXT, messageText);
			}
			catch(assertionFailedError:AssertionFailedError) {
				getResult().addFailure(this, assertionFailedError);
			}
			catch(error:Error) {
				getResult().addFailure(this, new AssertionFailedError(error.message));
			}
			
		   
		}
		
		public function resetSol():void
		{
			var testSO:SharedObject = getSol();
			testSO.clear();
			populateSol();
		}                 
		
		private function populateSol():void
		{
			var solData:Object = {};                  
			
			var mailMessage1:MailMessageVO = new MailMessageVO();
			mailMessage1.body = SAVED_TEXT + "1";
			mailMessage1.id = 6;
			mailMessage1.status = "READ";
			mailMessage1.dateTimeStamp = new Date();
			mailMessage1.link = LINK;
			
			var mailMessage2:MailMessageVO = new MailMessageVO();
			mailMessage2.body = SAVED_TEXT;
			mailMessage2.id = 8;
			mailMessage2.status = "READ";
			mailMessage2.dateTimeStamp = new Date();
			mailMessage2.link = LINK;

			var mailMessage3:MailMessageVO = new MailMessageVO();
			mailMessage3.body = SAVED_TEXT + "3";
			mailMessage3.id = 9;
			mailMessage3.status = "READ";
			mailMessage3.dateTimeStamp = new Date();
			mailMessage3.link = 3;
			
			solData.readMessages = new <MailMessageVO>[mailMessage1, mailMessage2, mailMessage3];
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