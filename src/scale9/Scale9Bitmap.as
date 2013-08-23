package scale9
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class Scale9Bitmap extends Sprite
	{
		private var _scale9Bmd:Scale9BitmapData;
		private var _vBitmaps:Vector.<Bitmap>;
		private var _height:Number;
		private var _width:Number;
		private var _iScaleX:Number;
		private var _iScaleY:Number;
		public function Scale9Bitmap(scale9BitmapData:Scale9BitmapData=null)
		{
			_scale9Bmd = scale9BitmapData;
			_iScaleX = 1;
			_iScaleY = 1;
			if(_scale9Bmd!=null)
				initBitmap();
		}
		
		public function get scale9Bmd():Scale9BitmapData
		{
			return _scale9Bmd;
		}

		public function set scale9Bmd(value:Scale9BitmapData):void
		{
			_scale9Bmd = value;
			initBitmap();
		}
		
		override public function set scaleX(value:Number):void
		{
			if(_scale9Bmd!=null)
			{
				width = _scale9Bmd.width * value;
			}
			_iScaleX = value;
		}
		
		override public function get scaleX():Number
		{
			return _iScaleX;
		}
		
		override public function set scaleY(value:Number):void
		{
			if(_scale9Bmd!=null)
			{
				height = _scale9Bmd.height * value;
			}
			_iScaleY = value;
		}
		
		override public function get scaleY():Number
		{
			return _iScaleY;
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
			if(_scale9Bmd!=null)
				_width = _width>_scale9Bmd.minWidth ? _width : _scale9Bmd.minWidth;
			resetBitmaps();
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			if(_scale9Bmd!=null)
				_height = _height>_scale9Bmd.minHeight ? _height : _scale9Bmd.minHeight;
			resetBitmaps();
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		private function initBitmap():void
		{
			_vBitmaps = new Vector.<Bitmap>(9);
			if(_scale9Bmd!=null && _scale9Bmd.vBmdVector!=null)
			{
				_width = _scale9Bmd.width * scaleX;
				_height = _scale9Bmd.height * scaleY;
				var bmds:Vector.<BitmapData> = _scale9Bmd.vBmdVector;
				var len:int = bmds.length;
				for(var i:int = 0; i < len; ++i)
				{
					_vBitmaps[i] = new Bitmap(bmds[i]);
					addChild(_vBitmaps[i]);
				}
				resetBitmaps();
			}
		}
		
		private function resetBitmaps():void
		{
			if(_vBitmaps!=null)
			{
				_vBitmaps[1].width = _width - _vBitmaps[0].width - _vBitmaps[2].width;
				_vBitmaps[1].x = _vBitmaps[0].width;
				
				_vBitmaps[2].x = _width - _vBitmaps[2].width;
				
				_vBitmaps[3].height = _height - _vBitmaps[0].height - _vBitmaps[6].height;
				_vBitmaps[3].y = _vBitmaps[0].height;
				
				_vBitmaps[4].x = _vBitmaps[1].x;
				_vBitmaps[4].y = _vBitmaps[3].y;
				_vBitmaps[4].width = _vBitmaps[1].width;
				_vBitmaps[4].height = _vBitmaps[3].height;
				
				_vBitmaps[5].x = _vBitmaps[2].x;
				_vBitmaps[5].y = _vBitmaps[3].y;
				_vBitmaps[5].height = _vBitmaps[3].height;
				
				_vBitmaps[6].y = _height - _vBitmaps[6].height;
				
				_vBitmaps[7].x = _vBitmaps[1].x;
				_vBitmaps[7].y = _vBitmaps[6].y;
				_vBitmaps[7].width = _vBitmaps[1].width;
				
				_vBitmaps[8].x = _vBitmaps[2].x;
				_vBitmaps[8].y = _vBitmaps[6].y;
			}
		}

		private function removeAllBitmap():void
		{
			if(_vBitmaps!=null)
			{
				var len:int = _vBitmaps.length;
				for(var i:int = 0; i<len; ++i)
				{
					var bmp:Bitmap = _vBitmaps[i];
					if(bmp!=null && contains(bmp)==true)
					{
						removeChild(bmp);
					}
				}
				_vBitmaps.length = 0;
				_vBitmaps = null;
			}
		}
	}
}