package view {
	
	import flash.display.Sprite;
	import skins.SolMailboxClient.NotebookSkin;
	import flash.text.TextField;

	public class NotebookView extends Sprite {
		
		protected var _notes_text:TextField;
		
		public function NotebookView() {
			init();
		}          
		
		protected function init():void
		{
			setSkin(new NotebookSkin.Notebook() as Sprite)
		}  
		
		public function setSkin(skin:Sprite):void
		{                                                
			addChild(skin);
			_notes_text = skin['notes_txt'] as TextField;
		}
		
		public function get notesField():TextField
		{
			return _notes_text;
		}
	}
}