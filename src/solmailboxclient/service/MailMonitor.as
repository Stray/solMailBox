package solmailboxclient.service {
	
	import solmailboxclient.model.IMailBox;
	import org.osflash.signals.Signal;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class MailMonitor implements IMailMonitor {
		
		protected var _mailBox:IMailBox;
		protected var _monitoringIntervalMS:Number;
		protected var _hasNewMessagesSignal:Signal; 
		protected var _timer:Timer;
		
		public function MailMonitor(mailBox:IMailBox, monitoringIntervalSeconds:Number) {
			_mailBox = mailBox;
			monitoringInterval = monitoringIntervalSeconds;
		}  
		
		//---------------------------------------
		// IMailMonitor Implementation
		//---------------------------------------

		//import solmailboxclient.service.IMailMonitor;
		public function get monitoringInterval():Number
		{
			return _monitoringIntervalMS/1000;
		}

		public function set monitoringInterval(seconds:Number):void
		{
			if(seconds != _monitoringIntervalMS/1000)
			{
				_monitoringIntervalMS = seconds*1000;
				timer.delay = _monitoringIntervalMS;
			}
		}

		public function get hasNewMessagesSignal():Signal
		{
			return _hasNewMessagesSignal ||= new Signal();
		}

		public function startMonitoring():void
		{
			checkNow(); 
			timer.start();
		}

		public function stopMonitoring():void
		{
			timer.stop();
		}

		public function checkNow():void
		{
			if(_mailBox.hasNewMessages)
			{
				hasNewMessagesSignal.dispatch();
			}
		}
		
		protected function get timer():Timer
		{
			return _timer ||= prepareTimer();
		}
		
		protected function prepareTimer():Timer
		{
			var localTimer:Timer = new Timer(_monitoringIntervalMS);
			localTimer.addEventListener(TimerEvent.TIMER, checkForNewMessages);
			return localTimer;
		}  
		
		protected function checkForNewMessages(e:TimerEvent):void
		{
			checkNow();
		}
		
	}
}