package org.sunlightlabs.ClearMaps
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class Feature extends Sprite
	{
		public var _selected:Boolean = false;
		
		public var _layer:Layer;
		
		public var data:Object;
		
		public var id:int;
		
		public var tooltipText:String;
		
		public var useDefaultStyle:Boolean = true;
		
		private var tooltip:Sprite;
		
		private var _fill:Number;
		private var useDefaultFill:Boolean = true;
		
		private var _fillSelected:Number;
		private var useDefaultFillSelected:Boolean = true;
		
		private var _outline:Number;
		private var useDefaultOutline:Boolean = true;
		
		public var _outlineSelected:Number;
		private var useDefaultOutlineSelected:Boolean = true;
		
		public var _outlineThicknes:Number;
		private var useDefaultOutlineThicknes:Boolean = true;
		
		public var infoTip:Sprite;
		
		public function Feature():void
		{

		}
		
		public function get fill():uint
		{
			if(this.useDefaultFill)
				return this.layer.fill;
			else
				return this._fill;
		}
		
		public function set fill(value:uint):void
		{
			this.useDefaultFill = false;
			this._fill = value;
		}
		
		public function get fillSelected():uint
		{
			if(this.useDefaultFillSelected)
				return this.layer.fillSelected;
			else
				return this._fillSelected;
		}
	
		public function set fillSelected(value:uint):void
		{
			this.useDefaultFillSelected = false;
			this._fillSelected = value;
		}
		
		public function get outline():uint
		{
			if(this.useDefaultOutline)
				return this.layer.outline;
			else
				return this._outline;
		}
		
		public function set outline(value:uint):void
		{
			this.useDefaultOutline = false;
			this._outline = value;
		}
		
		public function get outlineSelected():uint
		{
			if(this.useDefaultOutlineSelected)
				return this.layer.outlineSelected;
			else
				return this._outlineSelected;
		}
		
		public function set outlineSelected(value:uint):void
		{
			this.useDefaultOutlineSelected = false;
			this._outlineSelected = value;
		}
		
		public function get outlineThicknes():uint
		{
			if(this.useDefaultOutlineThicknes)
				return this.layer.outlineThicknes;
			else
				return this._outlineThicknes;
		}
	
		public function set outlineThicknes(value:uint):void
		{
			this.useDefaultOutlineThicknes = false;
			this._outlineThicknes = value;
		}
		
		
		public function set layer(l:Layer):void
		{
			_layer = l;
			
			if(_layer.selectable)
				this.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
		}
		
		public function get layer():Layer
		{
			return _layer;
		}
		
		public function set selected(s:Boolean):void
		{
			this._selected = s;
		
			this.draw();
			if(this._selected)
			{
				if(this.layer.tooltip && this.tooltipText && !this.tooltip)
				{
					this.tooltip = new Sprite();
					
					var tooltipTextField:TextField = new TextField();
					tooltipTextField.embedFonts = true;
					tooltipTextField.text = this.tooltipText;
					tooltipTextField.autoSize = TextFieldAutoSize.LEFT;
					tooltipTextField.setTextFormat(new TextFormat("mapFont", 10, 0x000000, true));
					
					this.tooltip.graphics.beginFill(0xffffff, 0.75);
					this.tooltip.graphics.drawRect(0,0, tooltipTextField.width, tooltipTextField.height);
					
					this.tooltip.addChild(tooltipTextField);
					
					this.tooltip.x = this.transform.pixelBounds.x + this.transform.pixelBounds.width;
					this.tooltip.y = this.transform.pixelBounds.y - this.tooltip.height;
					
					if(this.tooltip.x + this.tooltip.width > this.stage.width)
						this.tooltip.x -= (this.tooltip.x + this.tooltip.width) - this.stage.width;
					
					
					this.stage.addChild(this.tooltip);
				}
			}
			else
			{
				if(this.tooltip && this.stage.contains(this.tooltip))
					this.stage.removeChild(this.tooltip);
					
				this.tooltip = null;
			}
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function mouseOver(event:MouseEvent):void
		{
			event.stopPropagation();
			
			this.stage.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			
			this.layer.selectFeature(this);		
		}
		
		public function mouseOut(event:MouseEvent):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			this.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			
			this.layer.selectFeature(null);
		}
		
		
		public function draw():void
		{
			
		}
	}	

}