package com.newloop.roboteyes.automation {
	
	import cursors.Cursors;
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	import gs.TweenMax;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import gs.events.TweenEvent;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	
	public class GhostMouse extends Sprite {
		
		public static var ARROW_MAC:Class = Cursors.ArrowMac;
		
		public static var ARROW_PC:Class = Cursors.ArrowPC;

		public static var HAND:Class = Cursors.Hand; 
		
		protected var _targetApplication:DisplayObjectContainer;
		
		protected var _cursorClass:Class;

		public function GhostMouse(targetApplication:DisplayObjectContainer) {
			init(targetApplication);
		}
		
		public function mouseTo(newX:Number, newY:Number):TweenMax
		{
			var xDiff:Number = newX - this.x;
			var yDiff:Number = newY - this.y;
			
			var xControl:Number = this.x + (2* xDiff / 3);
			var yControl:Number = this.y + (1* yDiff / 2);
			
			xControl = Math.min(xControl, stage.width);
			xControl = Math.max(xControl, 0);
			
			yControl = Math.min(yControl, stage.height);
			yControl = Math.max(yControl, 0);
			
			return TweenMax.to(this, 1.5, {x:newX, y:newY, onComplete:moveCompleteHandler, bezierThrough:[{x:xControl, y:yControl}]})
		}
		
		public function jumpTo(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function mouseToObject(targetObject:DisplayObject, useHandCursor:Boolean=false):void
		{
			var globalBounds:Rectangle = targetObject.getRect(_targetApplication);  
			trace("GhostMouse::mouseToObject()",  globalBounds);
			var targetX:Number = globalBounds.x + (globalBounds.width/2);
			var targetY:Number = globalBounds.y + (globalBounds.height/2);
			var tweenMax:TweenMax = mouseTo(targetX, targetY);
			if(targetObject is Sprite)
			{
				if(((targetObject as Sprite).buttonMode || useHandCursor))
				{
					var handler:Function = createUpdateHandler(globalBounds, targetObject);
					tweenMax.addEventListener(TweenEvent.UPDATE, handler);
					tweenMax.addEventListener(TweenEvent.COMPLETE, cleanUpFor(tweenMax, handler));
				}
			} 
		}
		
		public function set cursor(cursorClass:Class):void
		{
			if(_cursorClass != cursorClass)
			{
				_cursorClass = cursorClass;
				removeChildren();
				addChild(new cursorClass());
			}
		}
		
		public function kill():void
		{
			if(_targetApplication.contains(this))
			{
				_targetApplication.removeChild(this);
			}
		}   
		
		
		protected function init(targetApplication:DisplayObjectContainer):void
		{
			_targetApplication = targetApplication;
			x = _targetApplication.width/2;
			y = _targetApplication.height/2;
			
			_targetApplication.addChild(this);
		}
		
		protected function removeChildren():void
		{
			while(numChildren > 0)
			{
				removeChildAt(0);
			}
		}
		
		protected function moveCompleteHandler():void
		{			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function createUpdateHandler(bounds:Rectangle, targetObject:DisplayObject):Function
		{
			var leftEdge:Number = bounds.x;
			var rightEdge:Number = bounds.x + bounds.width;
			var topEdge:Number = bounds.y;
			var bottomEdge:Number = bounds.y + bounds.height;
			
			var handler:Function = function(e:TweenEvent):void
			{
                checkCursorStatus(leftEdge, rightEdge, topEdge, bottomEdge, targetObject);
			}
			
			return handler;
		}
		
		protected function checkCursorStatus(leftEdge:Number, rightEdge:Number, topEdge:Number, bottomEdge:Number, targetObject:DisplayObject):void
		{
			var xPos:Number = this.x;
			var yPos:Number = this.y;
			
			if((xPos > leftEdge) && (xPos < rightEdge) && (yPos > topEdge) && (yPos < bottomEdge))
			{
				if(_cursorClass != HAND)
				{
					targetObject.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
				}
				this.cursor = HAND;
			}
			else
			{
				this.cursor = ARROW_PC;
			}
		}
		
		protected function cleanUpFor(tweenMax:TweenMax, handler:Function):Function
		{
			var handler:Function = function(e:TweenEvent):void
			{
				tweenMax.removeEventListener(TweenEvent.UPDATE, handler);
			}
			
			return handler;
		}
		
	}
}