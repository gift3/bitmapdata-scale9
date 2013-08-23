/**
 * stats.as
 * https://github.com/mrdoob/Hi-ReS-Stats
 *
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 *
 * How to use:
 *
 *	addChild( new Stats() );
 *
 **/

package debug
{
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.LocalConnection;
	import flash.system.System;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	public class Stats extends Sprite
	{
		
		protected const WIDTH:uint = 70;
		protected const HEIGHT:uint = 100;
		
		protected var xml:XML;
		
		protected var text:TextField;
		protected var style:StyleSheet;
		
		protected var timer:uint;
		protected var fps:uint;
		protected var ms:uint;
		protected var ms_prev:uint;
		protected var mem:Number;
		protected var mem_max:Number;
		
		protected var graph:BitmapData;
		protected var rectangle:Rectangle;
		
		protected var fps_graph:uint;
		protected var mem_graph:uint;
		protected var mem_max_graph:uint;
		
		protected var colors:Colors = new Colors();
		
		protected var gcBtn:SpriteButton;
		protected var addFrameBtn:SpriteButton;
		protected var reduceFrameBtn:SpriteButton;
		
		/**
		 * <b>Stats</b> FPS, MS and MEM, all in one.
		 */
		public function Stats():void
		{
			
			mem_max = 0;
			
			xml =  <xml><fps>FPS:</fps><ms>MS:</ms><mem>MEM:</mem><memMax>MAX:</memMax></xml>;
			
			style = new StyleSheet();
			style.setStyle('xml', {fontSize: '9px', fontFamily: '_sans', leading: '-2px'});
			style.setStyle('fps', {color: hex2css(colors.fps)});
			style.setStyle('ms', {color: hex2css(colors.ms)});
			style.setStyle('mem', {color: hex2css(colors.mem)});
			style.setStyle('memMax', {color: hex2css(colors.memmax)});
			
			text = new TextField();
			text.width = WIDTH;
			text.height = 50;
			text.styleSheet = style;
			text.condenseWhite = true;
			text.selectable = false;
			text.mouseEnabled = false;
			
			rectangle = new Rectangle(WIDTH - 1, 0, 1, HEIGHT - 50);
			
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			
			gcBtn = new SpriteButton(WIDTH, 25, "Force GC Immediately");
			addChild(gcBtn);
			gcBtn.addEventListener(MouseEvent.CLICK, onBtnHandler);
			
			addFrameBtn = new SpriteButton(40, 25, "Frame+");
			reduceFrameBtn = new SpriteButton(40, 25, "Frame-");
			addChild(addFrameBtn);
			addChild(reduceFrameBtn);
			addFrameBtn.addEventListener(MouseEvent.CLICK, onBtnHandler);
			reduceFrameBtn.addEventListener(MouseEvent.CLICK, onBtnHandler);
		}
		
		private function onBtnHandler(e:MouseEvent):void
		{
			switch (e.currentTarget)
			{
				case gcBtn: 
				{
					try
					{
						new LocalConnection().connect("foo");
						new LocalConnection().connect("foo");
					}
					catch (error:Error)
					{
						trace("force gc already. stage.frameRate=", stage.frameRate);
					}
					break;
				}
				case addFrameBtn: 
				{
					changeFrame(true);
					break;
				}
				case reduceFrameBtn: 
				{
					changeFrame();
					break;
				}
			}
		
		}
		
		private function init(e:Event):void
		{
			
			graphics.beginFill(colors.bg);
			graphics.drawRect(0, 0, WIDTH, HEIGHT);
			graphics.endFill();
			
			addChild(text);
			
			graph = new BitmapData(WIDTH, HEIGHT - 50, false, colors.bg);
			graphics.beginBitmapFill(graph, new Matrix(1, 0, 0, 1, 0, 50));
			graphics.drawRect(0, 50, WIDTH, HEIGHT - 50);
			
			addEventListener(Event.ENTER_FRAME, update);
			
			gcBtn.y = this.height + 2;
			addFrameBtn.x = this.width + 2;
			reduceFrameBtn.x = addFrameBtn.x;
			reduceFrameBtn.y = 27;
		}
		
		private function destroy(e:Event):void
		{
			
			graphics.clear();
			
			gcBtn.removeEventListener(MouseEvent.CLICK, onBtnHandler);
			addFrameBtn.removeEventListener(MouseEvent.CLICK, onBtnHandler);
			reduceFrameBtn.removeEventListener(MouseEvent.CLICK, onBtnHandler);
			while (numChildren > 0)
				removeChildAt(0);
			
			graph.dispose();
			
			removeEventListener(Event.ENTER_FRAME, update);
		
		}
		
		private function update(e:Event):void
		{
			
			timer = getTimer();
			
			if (timer - 1000 > ms_prev)
			{
				
				ms_prev = timer;
				mem = Number((System.totalMemory * 0.000000954).toFixed(3));
				mem_max = mem_max > mem ? mem_max : mem;
				
				fps_graph = Math.min(graph.height, (fps / stage.frameRate) * graph.height);
				mem_graph = Math.min(graph.height, Math.sqrt(Math.sqrt(mem * 5000))) - 2;
				mem_max_graph = Math.min(graph.height, Math.sqrt(Math.sqrt(mem_max * 5000))) - 2;
				
				graph.scroll(-1, 0);
				
				graph.fillRect(rectangle, colors.bg);
				graph.setPixel(graph.width - 1, graph.height - fps_graph, colors.fps);
				graph.setPixel(graph.width - 1, graph.height - ((timer - ms) >> 1), colors.ms);
				graph.setPixel(graph.width - 1, graph.height - mem_graph, colors.mem);
				graph.setPixel(graph.width - 1, graph.height - mem_max_graph, colors.memmax);
				
				xml.fps = "FPS: " + fps + " / " + stage.frameRate;
				xml.mem = "MEM: " + mem;
				xml.memMax = "MAX: " + mem_max;
				
				fps = 0;
				
			}
			
			fps++;
			
			xml.ms = "MS: " + (timer - ms);
			ms = timer;
			
			text.htmlText = xml;
		}
		
		private function changeFrame(bAdd:Boolean=false):void
		{
			
			bAdd==false ? stage.frameRate-- : stage.frameRate++;
			xml.fps = "FPS: " + fps + " / " + stage.frameRate;
			text.htmlText = xml;
		
		}
		
		// .. Utils
		
		private function hex2css(color:int):String
		{
			
			return "#" + color.toString(16);
		
		}
	
	}

}

class Colors
{
	
	public var bg:uint = 0x000033;
	public var fps:uint = 0xffff00;
	public var ms:uint = 0x00ff00;
	public var mem:uint = 0x00ffff;
	public var memmax:uint = 0xff0070;

}

import flash.display.GradientType;
import flash.display.SpreadMethod;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

internal class SpriteButton extends Sprite
{
	private var _iWidth:Number;
	private var _iHeight:Number;
	private var _sTitle:String;
	
	public function SpriteButton(iWidth:Number = 80, iHeight:Number = 25, sTitle:String = null)
	{
		iWidth = iWidth <= 0 ? 80 : iWidth;
		iHeight = iHeight <= 0 ? 20 : iHeight;
		_sTitle = sTitle;
		_iWidth = iWidth;
		_iHeight = iHeight;
		addEventListener(Event.ADDED_TO_STAGE, onStageEvent);
		this.mouseChildren = false;
	}
	
	private function init():void
	{
		var mat:Matrix = new Matrix(1, 0, 0, 1);
		mat.createGradientBox(10, _iHeight * 4, Math.PI / 2, (_iWidth - 10) / 2, -_iHeight * 2);
		graphics.beginGradientFill(GradientType.LINEAR, [0x0, 0x1BD7FF, 0], [0.5, 1, 0.5], [0, 127.5, 255], mat, SpreadMethod.PAD);
		graphics.drawRoundRect(0, 0, _iWidth, _iHeight, _iWidth / 80 + 6);
		graphics.endFill();
		if (_sTitle != null)
		{
			var tf:TextField = new TextField();
			
			tf.multiline = true;
			tf.wordWrap = true;
			tf.mouseEnabled = tf.mouseWheelEnabled = false;
			tf.selectable = false;
			tf.text = _sTitle;
			//var fmt:TextFormat = new TextFormat();
			//fmt.align = TextFormatAlign.CENTER;
			//tf.setTextFormat(fmt);
			tf.autoSize = TextFieldAutoSize.CENTER;
			tf.x = width / 2 - tf.textWidth / 2;
			tf.y = height / 2 - tf.textHeight / 2;
			addChild(tf);
		}
		buttonMode = true;
		addEventListener(Event.REMOVED_FROM_STAGE, onStageEvent);
	}
	
	private function destroy():void
	{
		removeEventListener(Event.REMOVED_FROM_STAGE, onStageEvent);
		removeEventListener(Event.ADDED_TO_STAGE, onStageEvent);
		graphics.clear();
		while (numChildren > 0)
			removeChildAt(0);
	}
	
	private function onStageEvent(e:Event):void
	{
		switch (e.type)
		{
			case Event.ADDED_TO_STAGE: 
			{
				removeEventListener(Event.ADDED_TO_STAGE, onStageEvent);
				init();
				break;
			}
			
			case Event.REMOVED_FROM_STAGE: 
			{
				init();
				break;
			}
		}
	}
}
