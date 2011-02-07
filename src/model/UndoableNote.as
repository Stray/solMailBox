package model {
	
	public class UndoableNote {
		
		protected var _text:String;
		protected var _undoTo:UndoableNote;
		public var redoTo:UndoableNote;
		
		public function UndoableNote(text:String, undoTo:UndoableNote) {
			_text = text;
			_undoTo = (undoTo || this);
			_undoTo.redoTo = this;
			redoTo = this;
		}
		
		public function get text():String
		{
			return _text;
		}                
		
		public function get undoTo():UndoableNote
		{
			return _undoTo;
		}
	}
}
