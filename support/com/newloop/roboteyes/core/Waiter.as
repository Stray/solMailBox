package com.newloop.roboteyes.core
{

	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class Waiter extends Object
	{
	    
		private var _waitSeconds:Number;
		private var _timer:Timer; 
		
		private static var _waiters:Vector.<Waiter>;
	
		public function Waiter(waitSeconds:Number)
		{
			trace("Waiter::Waiter()");
			startWaiting(waitSeconds);
		}
		
		public static function createWaiter(waitSeconds:Number):Waiter
		{
			trace("Waiter::createWaiter()");
			var waitersList:Vector.<Waiter> = _waiters ||= new Vector.<Waiter>();
			var newWaiter:Waiter = new Waiter(waitSeconds);
			waitersList.push(newWaiter);
			
			return newWaiter;
		} 
		
		public function andThen(action:Function):Waiter
		{
			trace("Waiter::andThen(): " + action);
			addAction(action);
			
			return this;
		}   
        
		private function startWaiting(waitSeconds:Number):void
		{
			_waitSeconds = waitSeconds;
			timer.start(); 
		}
		
		private function addAction(action:Function)
		{
			timer.addEventListener(TimerEvent.TIMER, createTimerHandler(action));
		}
			
		private function get timer():Timer
		{
		    return _timer ||= new Timer(_waitSeconds*1000);
		}
		
		private function createTimerHandler(action:Function):Function
		{
			trace("Waiter::createTimerHandler()");
			var handler:Function = function(e:TimerEvent):void
			{
				trace("Waiter::handler()");
				action();
				timer.removeEventListener(TimerEvent.TIMER, arguments.callee);
				cleanUp();
			}
			
			return handler;
		}
		
		private function cleanUp():void
		{
			trace("Waiter::cleanUp()");
			if(timer.hasEventListener(TimerEvent.TIMER))
			{
				return;
			} 
			
			var index:uint = _waiters.indexOf(this);
			_waiters.splice(index, 1);
		}
	
	}

}

