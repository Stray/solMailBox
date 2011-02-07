package {
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import skins.SolMailboxClientSkin;
	
	public class SolMailboxClient extends Sprite {

		public function SolMailboxClient() {
			addChild(new SolMailboxClientSkin.ProjectSprouts() as DisplayObject);
			trace("SolMailboxClient instantiated!");
		}
	}
}
