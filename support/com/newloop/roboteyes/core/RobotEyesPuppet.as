package com.newloop.roboteyes.core {
		
	import flash.display.Sprite;
	
	import com.newloop.roboteyes.core.RobotEyesMaster;
	
	public class RobotEyesPuppet {
		
		private var _testApplication:Sprite;
		
		public function RobotEyesPuppet(testApplication:Sprite) {
			
			init(testApplication);
			
		}
		
		private function init(testApplication:Sprite):void{
			_testApplication = testApplication;
			RobotEyesMaster.viewRoot = _testApplication;
		}
		
		public function get testApplication():*{
			return _testApplication;
		} 
	}
}