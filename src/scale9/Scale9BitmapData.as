package scale9
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * @author Vector.Lee
	 */
	public class Scale9BitmapData
	{
		
		private var _bmd:BitmapData;
		private var _vBmdVector:Vector.<BitmapData>;
		
		private var _height:Number;
		private var _width:Number;
		private var _minHeight:Number;
		private var _minWidth:Number;
		public function Scale9BitmapData(source:*, scale9Rect:Rectangle, bDisposeSource:Boolean = true)
		{
			create(source, scale9Rect, bDisposeSource);
		}
		
		private function create(source:*, scale9Rect:Rectangle, bDisposeSource:Boolean):void
		{
			if (source == null || scale9Rect == null)
			{
				throw "Scale9BitmapData error. param source or scale9Rect is null";
				return;
			}
			_vBmdVector = new Vector.<BitmapData>(9);
			/*
			 * 0 1 2
			 * 3 4 5
			 * 6 7 8
			 * */
			if (source is BitmapData)
			{
				var srcbmd:BitmapData = source as BitmapData;
				if (scale9Rect.x <= 0 || scale9Rect.y <= 0)
				{
					throw "Scale9BitmapData error. param scale9Rect.x<=0 or scale9Rect.y<=0";
					return;
				}
				if (scale9Rect.right >= srcbmd.width || scale9Rect.bottom >= srcbmd.height)
				{
					throw "Scale9BitmapData error. param scale9Rect.right >= source.width or scale9Rect.bottom >= source.height";
					return;
				}
				_width = srcbmd.width;
				_height = srcbmd.height;
				_minWidth = scale9Rect.x + srcbmd.width - scale9Rect.right;
				_minHeight = scale9Rect.y + srcbmd.height - scale9Rect.bottom;
				var point:Point = new Point();
				var rect:Rectangle = new Rectangle();
				_vBmdVector[0] = new BitmapData(scale9Rect.x, scale9Rect.y);
				rect.width = scale9Rect.x;
				rect.height = scale9Rect.y;
				_vBmdVector[0].copyPixels(srcbmd, rect, point);
				
				_vBmdVector[1] = new BitmapData(scale9Rect.width, scale9Rect.x);
				rect.x = scale9Rect.x;
				rect.y = 0;
				rect.width = scale9Rect.width;
				rect.height = scale9Rect.y;
				_vBmdVector[1].copyPixels(srcbmd, rect, point); 
				
				rect.x = scale9Rect.right;
				rect.y = 0;
				rect.width = srcbmd.width-scale9Rect.right;
				rect.height = scale9Rect.y;
				_vBmdVector[2] = new BitmapData(rect.width, scale9Rect.y);
				_vBmdVector[2].copyPixels(srcbmd, rect, point);
				
				rect.x = 0; rect.y = scale9Rect.y;
				rect.height = scale9Rect.height;
				rect.width = scale9Rect.x;
				_vBmdVector[3] = new BitmapData(rect.width, rect.height);
				_vBmdVector[3].copyPixels(srcbmd, rect, point);
				
				rect.x = scale9Rect.x; rect.y = scale9Rect.y;
				rect.width = scale9Rect.width; rect.height = scale9Rect.height;
				_vBmdVector[4] = new BitmapData(rect.width, rect.height);
				_vBmdVector[4].copyPixels(srcbmd, rect, point);
				
				rect.x = scale9Rect.right; rect.y = scale9Rect.y;
				rect.width = srcbmd.width - scale9Rect.right;
				rect.height = scale9Rect.height;
				_vBmdVector[5] = new BitmapData(rect.width, rect.height);
				_vBmdVector[5].copyPixels(srcbmd, rect, point);
				
				rect.x = 0;				rect.y = scale9Rect.bottom;
				rect.width = scale9Rect.x;
				rect.height = srcbmd.height - scale9Rect.bottom;
				_vBmdVector[6] = new BitmapData(rect.width, rect.height);
				_vBmdVector[6].copyPixels(srcbmd, rect, point);
				
				rect.x = scale9Rect.x; rect.y = scale9Rect.bottom;
				rect.width = scale9Rect.width;
				rect.height = srcbmd.height - scale9Rect.bottom;
				_vBmdVector[7] = new BitmapData(rect.width, rect.height);
				_vBmdVector[7].copyPixels(srcbmd, rect, point);
				
				rect.x = scale9Rect.right; rect.y = scale9Rect.bottom;
				rect.width = srcbmd.width - scale9Rect.right;
				rect.height = srcbmd.height - scale9Rect.bottom;
				_vBmdVector[8] = new BitmapData(rect.width, rect.height);
				_vBmdVector[8].copyPixels(srcbmd, rect, point);
			}
		}
		
		public function dispose():void
		{
			if(_vBmdVector!=null)
			{
				var len:int = _vBmdVector.length;
				for (var i:int = 0; i < len; ++i)
				{
					var bmd:BitmapData = _vBmdVector[i];
					if(bmd!=null)
						bmd.dispose();
				}
			}
		}

		public function get vBmdVector():Vector.<BitmapData>
		{
			return _vBmdVector;
		}

		public function set vBmdVector(value:Vector.<BitmapData>):void
		{
			_vBmdVector = value;
		}

		public function get height():Number
		{
			return _height;
		}

		public function get width():Number
		{
			return _width;
		}

		public function get minHeight():Number
		{
			return _minHeight;
		}

		public function get minWidth():Number
		{
			return _minWidth;
		}


	}

}