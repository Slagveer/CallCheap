package renderers
{
	import com.slagveer.callcheap.ImageCache;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	
	import spark.components.Group;
	import spark.components.IconItemRenderer;
	import spark.components.LabelItemRenderer;
	import spark.components.supportClasses.StyleableTextField;
	import spark.primitives.BitmapImage;
	
	public class ItemListRenderer extends IconItemRenderer
	{
		
		[Embed(source='/assets/skins/rule.png')]
		private static var rule1:Class;
		
		[Embed(source='/assets/skins/rule240.png')]
		private static var rule2:Class;
		
		[Embed(source='/assets/skins/rule320.png')]
		private static var rule3:Class;
		
		[Embed(source='/assets/skins/itemListIconUp240.png')]
		private static var itemListIconDown:Class;
		
		[Embed(source='/assets/skins/itemListIconUp240.png')]
		private static var itemListIconUp:Class;

		[Embed(source='/assets/skins/itemListDecoratorUp240.png')]
		private static var itemListDecoratorDown:Class;
		
		[Embed(source='/assets/skins/itemListDecoratorUp240.png')]
		private static var itemListDecoratorUp:Class;

		protected var decoratorClass:Class;
		protected var decoratorCoverClass:Class;
		protected var decoratorWidth:int;
		protected var decoratorHeight:int;
		
		protected var iconClass:Class;
		protected var iconCoverClass:Class;
		
		protected var highlightClass:Class;
		protected var highlightWidth:int;
		protected var highlightHeight:int;
		
		protected var xOffset:int = 0;
		protected var rendererHeight:int = 0;
		
		protected var rule:BitmapImage = new BitmapImage();
		protected var holder:Group = new Group();
		protected var hl:BitmapImage = new BitmapImage();
		protected var iconCover:BitmapImage = new BitmapImage();
		protected var decoratorCover:BitmapImage = new BitmapImage();
		
		private var t:StyleableTextField = new StyleableTextField();
		
		public function ItemListRenderer()
		{
			super();
			this.iconContentLoader = ImageCache.getInstance().cache;
			
			xOffset = 60;
			rendererHeight = 135;
			iconWidth = 32;
			iconHeight = 53;
			iconClass = itemListIconUp;
			iconCoverClass = itemListIconDown;
			decoratorHeight = 92;
			decoratorWidth = 94;
			decoratorCoverClass = itemListDecoratorDown;
			decoratorClass = itemListDecoratorUp;
			highlightWidth = 493;
			highlightHeight = 113;
			
			addChild(holder);
			
			setElementSize(hl, highlightWidth, highlightHeight);
			hl.source = highlightClass;
			hl.visible = false;
			holder.addElement(hl);
			
			iconCover.source = iconCoverClass;
			setElementSize(iconCover, iconWidth, iconHeight);
			iconCover.visible = false;
			holder.addElement(iconCover);
			
			decoratorCover.source = decoratorCoverClass;
			setElementSize(decoratorCover, decoratorWidth, decoratorHeight);
			decoratorCover.visible = false;
			holder.addElement(decoratorCover);
			
			t.width = 200;
			t.text = "55556777767767879686788898976567899564545787678998457888658906558";
			t.wordWrap = true;
			t.multiline = false;
			t.antiAliasType = flash.text.AntiAliasType.NORMAL;
			t.embedFonts = true;
			//t.truncateToFit();
			t.styleName = "test";
			t.y =  60;
			
			holder.addElement(t);

			this.addEventListener(MouseEvent.CLICK, toggleHighlight);
		}
		
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void{
			super.layoutContents(unscaledWidth, unscaledHeight);
			setElementPosition(labelDisplay, xOffset, labelDisplay.y);
			setElementPosition(messageDisplay, xOffset, messageDisplay.y);
			this.height = rendererHeight;
			
			var ruleNumber:Number = labelDisplay.text.length % 3;
			
			switch(ruleNumber)
			{
				case 1:
				{
					rule.source = rule2;
					break;
				}
				case 2:
				{
					rule.source = rule3;
					break;
				}
					
				default:
				{
					rule.source = rule1;
					break;
				}
			}
			
			holder.addElement(rule);
			
			decoratorDisplay.source = decoratorClass;
			
			//iconDisplay.source = iconClass;
			
			this.iconPlaceholder = iconClass;
			
			setElementPosition(decoratorCover, decoratorDisplay.x, decoratorDisplay.y);
			
			this.labelDisplay.setStyle("color", 0xFFFFFFF);
			
			this.messageDisplay.setStyle("color", 0x2BBDED);
		}
		
		protected function toggleHighlight(event:MouseEvent):void
		{
				hl.visible = true;
		}		
		
		
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void{
			
		}

	}
}