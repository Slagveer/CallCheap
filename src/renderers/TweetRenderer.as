package renderers
{
	import flash.display.DisplayObject;
	import flash.text.TextField;
	
	import spark.primitives.BitmapImage;
	import spark.primitives.Graphic;
	
	import utils.TextUtil;
	
	public class TweetRenderer extends BaseRenderer
	{
		//--------------------------------------------------------------------------
		//  Protected properties
		//--------------------------------------------------------------------------
		
		protected var nameField:TextField;
		protected var goedkoopField:TextField;
		protected var duurField:TextField;
		protected var avatar:BitmapImage;
		protected var arrow:BitmapImage;
		protected var avatarHolder:Graphic;
		protected var arrowHolder:Graphic;
		protected var background:DisplayObject;
		protected var backgroundClass:Class;
		protected var separator:DisplayObject;
		
		protected var paddingLeft:int;
		protected var paddingRight:int;
		protected var paddingBottom:int;
		protected var paddingTop:int;
		protected var horizontalGap:int;
		protected var verticalGap:int;
		
		[Embed(source="assets/skins/mobile_icn.png")]
		public var mobileClass : Class;
		
		[Embed(source="assets/skins/arrow_icn_lt.png")]
		public var arrowClass : Class;
		
		//--------------------------------------------------------------------------
		//  Contructor
		//--------------------------------------------------------------------------
		
		public function TweetRenderer()
		{
			percentWidth = 100;
		}
		
		//--------------------------------------------------------------------------
		//  Override Protected Methods
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		
		override protected function createChildren():void
		{
			readStyles();
			
			setBackground();
			
			var separatorAsset:Class = getStyle( "separator" );
			if( separatorAsset )
			{
				separator = new separatorAsset();
				addChild( separator );
			}
			
			nameField  = TextUtil.createSimpleTextField( getStyle( "userStyle" ) );
			addChild( nameField );
			
			duurField  = TextUtil.createSimpleTextField( getStyle( "contentStyle" ) , false, "none" );
			duurField.wordWrap = true;
			duurField.multiline = true;
			addChild( duurField );
			
			goedkoopField  = TextUtil.createSimpleTextField( getStyle( "nameStyle" ) );
			addChild( goedkoopField );
			
			avatarHolder = new Graphic();
			avatar = new BitmapImage();
			avatar.fillMode = "clip";
			avatarHolder.width = 32;
			avatarHolder.height = 53;
			avatarHolder.addElement( avatar );
			addChild( avatarHolder );
			
			arrowHolder = new Graphic();
			arrow = new BitmapImage();
			arrow.fillMode = "clip";
			arrowHolder.width = 14;
			arrowHolder.height = 26;
			arrowHolder.addElement( arrow );
			addChild( arrowHolder );
			
			// if the data is not null, set the text
			if( data )
				setValues();
			
		}
		
		protected function setBackground():void
		{
			var backgroundAsset:Class = getStyle( "background" );
			if( backgroundAsset && backgroundClass != backgroundAsset )
			{
				if( background && contains( background ) )
					removeChild( background );
				
				backgroundClass = backgroundAsset;
				background = new backgroundAsset();
				addChildAt( background, 0 );
				if( layoutHeight && layoutWidth )
				{
					background.width = layoutWidth;
					background.height = layoutHeight;
				}
			}
		}
		
		//--------------------------------------------------------------------------
		
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			avatarHolder.x = paddingLeft;
			avatarHolder.y = paddingTop;
			avatarHolder.setLayoutBoundsSize( avatarHolder.getPreferredBoundsWidth(), avatarHolder.getPreferredBoundsHeight() );
			
			arrowHolder.x = unscaledWidth - paddingRight - arrowHolder.width;
			arrowHolder.y = paddingTop;
			arrowHolder.setLayoutBoundsSize( arrowHolder.getPreferredBoundsWidth(), arrowHolder.getPreferredBoundsHeight() );
				
			nameField.x = avatarHolder.x + avatarHolder.width + horizontalGap;
			nameField.y = paddingTop;
			
			goedkoopField.x = avatarHolder.x + avatarHolder.width + horizontalGap;
			goedkoopField.y = paddingTop + ( nameField.textHeight + goedkoopField.textHeight ) / 1;
			
			duurField.x = avatarHolder.x + avatarHolder.width + horizontalGap;
			duurField.y = paddingTop + nameField.textHeight + verticalGap;
			duurField.width = unscaledWidth - paddingLeft - paddingRight - avatarHolder.getLayoutBoundsWidth() - horizontalGap;
			
			layoutHeight = Math.max( duurField.y + paddingBottom + verticalGap + duurField.textHeight + verticalGap + goedkoopField.textHeight + paddingTop, avatarHolder.height + paddingBottom + paddingTop );
			
			background.width = unscaledWidth;
			background.height = layoutHeight;
			
			avatarHolder.y = layoutHeight/2 - avatarHolder.height/2;
			arrowHolder.y = layoutHeight/2 - arrowHolder.height/2;
			
			separator.width = unscaledWidth;
			separator.y = layoutHeight - separator.height;
		}
		
		override public function getLayoutBoundsHeight(postLayoutTransform:Boolean=true):Number
		{
			return layoutHeight;
		}
		override protected function setValues():void
		{
			nameField.text = String(data.naam).slice(0, 30).concat(String(data.naam).length > 30 ? "..." : "");;
			goedkoopField.text =  data.goedkoop;
			duurField.text = data.duur;
			avatar.source = mobileClass;
			arrow.source = arrowClass;
		}
		
		protected function getIcon(item:Object):String{
			return "@Embed('/assets/skins/mobile_icn.png')"; 
		}
		
		override protected function updateSkin():void
		{
			currentCSSState = ( selected ) ? "selected" : "up";
			setBackground();
		}
		
		protected function readStyles():void
		{
			paddingTop = getStyle( "paddingTop" );
			paddingLeft = getStyle( "paddingLeft" );
			paddingRight = getStyle( "paddingRight" );
			paddingBottom = getStyle( "paddingBottom" );
			horizontalGap = getStyle( "horizontalGap" );
		}
	}
}