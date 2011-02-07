package solmailboxclient.service {

	import asunit.framework.TestCase;
	import solmailboxclient.controller.MessageSignal;

	import asunit.errors.AssertionFailedError;     

	import mockolate.prepare;
	import mockolate.nice;
	import mockolate.stub;
   	import mockolate.verify;
	import mockolate.errors.VerificationError;
	
	import org.hamcrest.core.anything;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.nullValue;
	import org.hamcrest.object.strictlyEqualTo;
	import org.hamcrest.object.hasPropertyWithValue;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import solmailboxclient.model.IMailBox;

	public class MailMonitorTest extends TestCase {
		private var instance:MailMonitor;
		
		protected const MONITORING_INTERVAL:Number = 0.5;
		protected const NEW_MONITORING_INTERVAL:Number = 1; 
		
		protected var mockMailBox:IMailBox; 
		
		protected var _newMessagesSignalHandlerFired:Boolean;

		public function MailMonitorTest(methodName:String=null) {
			super(methodName)
		}
        
		override public function run():void{
			var mockolateMaker:IEventDispatcher = prepare(IMailBox);
			mockolateMaker.addEventListener(Event.COMPLETE, prepareCompleteHandler);
		}

		private function prepareCompleteHandler(e:Event):void{
			IEventDispatcher(e.target).removeEventListener(Event.COMPLETE, prepareCompleteHandler);
			super.run();
		}

		override protected function setUp():void {
			super.setUp();   
			mockMailBox = nice(IMailBox);
			instance = new MailMonitor(mockMailBox, MONITORING_INTERVAL);
			instance.hasNewMessagesSignal.add(newMessagesSignalHandler);
			_newMessagesSignalHandlerFired = false;
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is MailMonitor", instance is MailMonitor);
		}
		
		public function test_implements_interface():void {
			assertTrue("instance is IMailMonitor", instance is IMailMonitor);
		}

		public function testFailure():void {
			assertTrue("Failing test", true);
		} 
		
		public function test_get_monitoringInterval():void {
			assertEquals("Get monitoringInterval", MONITORING_INTERVAL, instance.monitoringInterval);
		}

		public function test_set_monitoringInterval():void {
			instance.monitoringInterval =  NEW_MONITORING_INTERVAL;
			assertEquals("Set monitoringInterval", NEW_MONITORING_INTERVAL , instance.monitoringInterval);
		}
		
		public function test_get_newMessageSignal():void {
			assertTrue("Get newMessageSignal", instance.hasNewMessagesSignal != null);
		}
		
		public function test_checkNow_doesnt_fire_signal_when_no_new_messages():void {
			stub(mockMailBox).property('hasNewMessages').returns(false);
			instance.checkNow();
			assertFalse("signal didn't fire", _newMessagesSignalHandlerFired);
		}
		
		public function test_checkNow_does_fire_signal_when_new_messages():void {
			stub(mockMailBox).property('hasNewMessages').returns(true);  
			instance.checkNow();
			assertTrue("signal did fire", _newMessagesSignalHandlerFired);
		}
		
		public function test_start_and_stop_monitoring_control_calls_on_the_mailbox():void {
			instance.startMonitoring();
			try {
				verify(mockMailBox).getter('hasNewMessages');
				addAsync(null, 1800, stopMonitoring);
			}
			catch(verificationError:VerificationError) {
				getResult().addFailure(this, new AssertionFailedError(verificationError.message));
			}
		}
		
		protected function stopMonitoring(e:Event):void
		{
			instance.stopMonitoring();
			try {
				verify(mockMailBox).getter('hasNewMessages').times(4);
				addAsync(null, 1000, checkNoLongerMonitoringAndRestart);
			}
			catch(verificationError:VerificationError) {
				getResult().addFailure(this, new AssertionFailedError(verificationError.message));
			}
		}
		
		protected function checkNoLongerMonitoringAndRestart(e:Event):void
		{
		   	try {
				verify(mockMailBox).getter('hasNewMessages').times(4);
				addAsync(null, 1200, checkRestartedMonitoring); 
				instance.startMonitoring();
			}
			catch(verificationError:VerificationError) {
				getResult().addFailure(this, new AssertionFailedError(verificationError.message));
			}
		} 
		
		protected function checkRestartedMonitoring(e:Event):void
		{
		   	try {
				verify(mockMailBox).getter('hasNewMessages').times(7);
				instance.stopMonitoring();
			}
			catch(verificationError:VerificationError) {
				getResult().addFailure(this, new AssertionFailedError(verificationError.message));
			}
		}
		
		protected function newMessagesSignalHandler():void
		{
			_newMessagesSignalHandlerFired = true;
		}
		
	}
}