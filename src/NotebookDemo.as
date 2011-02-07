package 
{

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import view.Notebook;
	import flash.net.registerClassAlias;
	import solmailboxclient.model.MailMessage;
	import solmailboxclient.model.MailMessageVO;
	import view.NotebookView;

	public class NotebookDemo extends Sprite
	{
	
		public function NotebookDemo()
		{
			init();
		}          
		
		protected function init():void
		{
		    var notebookView:NotebookView = new NotebookView();
			addChild(notebookView);
			
			var notebook:Notebook = new Notebook(notebookView.notesField, 'notebook', '/', 4); 
	    	
		}
	
	} 

}