package view {
	
	import flash.text.TextField;
	import flash.events.Event;
	import solmailboxclient.model.SolMailBox;
	import solmailboxclient.model.IMailMessage;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.KeyboardEvent;
	import model.UndoableNote;
	
	public class Notebook {
		
	    protected var _notesField:TextField;        
		protected var _mailBox:SolMailBox;             
		protected var _autoSaveTimer:Timer; 
		
		protected var _edited:Boolean = false; 
		
		protected var _timer:Timer;
		
		protected const AUTOSAVE_INTERVAL:Number = 1000;    
		
		protected const UNDO_CODE:uint = "z".charCodeAt(0);
		protected const REDO_CODE:uint = "y".charCodeAt(0);
		
		protected const WORD_BOUNDARIES:Array = [" ".charCodeAt(0), ",".charCodeAt(0), ".".charCodeAt(0)];
		
		protected var _undoableNote:UndoableNote;  
		
		protected var _link:uint;
				
		public function Notebook(notesField:TextField, solName:String, solPath:String, link:uint) {
			init(notesField, solName, solPath, link);
		}
		
		protected function init(notesField:TextField, solName:String, solPath:String, link:uint):void
		{
			_link = link;
			_notesField = notesField;
			_mailBox = new SolMailBox(solName, solPath);
			createListeners();
			_mailBox.load(_link);
		}                     
		
		protected function createListeners():void
		{
			_notesField.addEventListener(Event.CHANGE, textChangedHandler);
			_notesField.addEventListener(KeyboardEvent.KEY_UP, checkForUndoAndRedo);
			_mailBox.loadedSignal.addOnce(setInitialText);
		}    
		
		protected function checkForUndoAndRedo(e:KeyboardEvent):void
		{
			if(WORD_BOUNDARIES.indexOf(e.charCode) > -1)
			{
				storeForUndo();
				return;
			}
			
			if(!e.ctrlKey)
			{
				return;
			} 
			
			if(e.charCode == UNDO_CODE)
			{
				undoTyping();
			}
			else if(e.charCode == REDO_CODE) 
			{
				redoTyping();
			}
		}
		
		protected function undoTyping():void
		{
			_undoableNote = _undoableNote.undoTo;
			_notesField.text = _undoableNote.text;
		}   
		
		protected function redoTyping():void
		{
			_undoableNote = _undoableNote.redoTo;
			_notesField.text = _undoableNote.text;
		}
		
		protected function storeForUndo():void
		{
			if(_notesField.text != _undoableNote.text)
			{
				_undoableNote = new UndoableNote(_notesField.text, _undoableNote);
			}
		}
		
		protected function textChangedHandler(e:Event):void
		{
        	_edited = true;
			timer.start();
		}
		
		protected function timedSaveHandler(e:TimerEvent):void
		{
			if(_edited)
			{
				saveCurrentText(); 
			}
			
			timer.stop();
		}
		
		protected function saveCurrentText():void
		{
			var currentText:String = _notesField.text;
			_mailBox.saveMessage(currentText, _link);
			_edited = false;
			_undoableNote = new UndoableNote(currentText, _undoableNote);
		}   
		
		protected function setInitialText(message:IMailMessage):void
		{
			_notesField.text = message.body;
		}
		
		protected function get timer():Timer
		{
			if(_timer == null)
			{
				_timer = new Timer(AUTOSAVE_INTERVAL);
				_timer.addEventListener(TimerEvent.TIMER, timedSaveHandler);
			} 
			
			return _timer;
		}
		 
	}
}