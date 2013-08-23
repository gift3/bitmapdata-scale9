package 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import scale9.Scale9Bitmap;
	import scale9.Scale9BitmapData;
	
	
	/**
	 * ...
	 * @author Vector.Lee
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoad);
			loader.load(new URLRequest("1.png"));
			tabChildren = tabEnabled = false;
		}
		
		private function onLoad(e:Event):void
		{
			var li:LoaderInfo = e.target as LoaderInfo;
			var bmd:Bitmap = li.content as Bitmap;
			
			var scale9bmd:Scale9BitmapData = new Scale9BitmapData(bmd.bitmapData, new Rectangle(3,3,75,25));
			
			li.loader.unload();
			var bmp1:Scale9Bitmap = new Scale9Bitmap(scale9bmd);
			addChild(bmp1);
			
			var bmp2:Scale9Bitmap = new Scale9Bitmap(scale9bmd);
			bmp2.scaleY = bmp2.scaleX =4;
			bmp2.y = bmp1.height;
			addChild(bmp2);
			
		}
		
	}
	
}