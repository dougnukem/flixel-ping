package
{
	import org.flixel.*;
	
	public class Paddle extends FlxSprite
	{

		private var upKey:String;
		private var downKey:String;
		private var keyInputDisabled:Boolean = false;
		
					
		public function Paddle(X:Number,Y:Number, upKey:String, downKey:String):void
        {
            super(X,Y);
			this.upKey = upKey;
			this.downKey = downKey;
			
            //maxVelocity.x = 200;
            //maxVelocity.y = 200;

            width = 10;
            height = 30;
            this.createGraphic(width, height, 0xFFFFFFFF, true);

        }
          	
        override public function update():void {
        	var screenHeight:uint = FlxG.height;
        	if (!keyInputDisabled && FlxG.keys.pressed(upKey) && this.y > 0) {
        		velocity.y = -200;
        	} else if (!keyInputDisabled && FlxG.keys.pressed(downKey) && this.y < (screenHeight - this.height)) {
        		velocity.y = 200;
        	} else {
        		velocity.y = 0;
        	}
        	
        	super.update();
        }
        
        public function setPosition(position:FlxPoint) {
        	this.x = position.x;
        	this.y = position.y;
        }
        
        public function disableKeyInput() {
        	keyInputDisabled = true;
        }

        public function enableKeyInput() {
            keyInputDisabled = false;
        }

	}
}