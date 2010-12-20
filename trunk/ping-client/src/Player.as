package
{
    import org.flixel.*;
    
    public class Player extends FlxSprite
    {
        [Embed(source='../resources/images/Player.png')] private var ImgPlayer:Class;
        
        private var _move_speed:int = 400;
        private var _jump_power:int = 800;   
        private var _max_health:int = 10;
        private var _hurt_counter:Number = 0;
        
        public function Player(X:Number,Y:Number):void
        {
            super(X,Y);
	    	loadGraphic(ImgPlayer, true, true, 16, 16);
            maxVelocity.x = 200;
            maxVelocity.y = 200;
            //Set the player health
            health = 10;
            //Gravity
            acceleration.y = 420;            
            //Friction
            drag.x = 300;
            //bounding box tweaks
            width = 8;
            height = 14;
            offset.x = 4;
            offset.y = 2;
            addAnimation("normal", [0, 1, 2, 3], 10);
            addAnimation("jump", [2]);
            addAnimation("attack", [4,5,6],10);
            addAnimation("stopped", [0]);
            addAnimation("hurt", [2,7],10);
            addAnimation("dead", [7, 7, 7], 5);
        }
    
        override public function update():void
        {

            if(dead)
            {
                if(finished) exists = false;
                else
                    super.update();
                return;
            }
            if (_hurt_counter > 0)
            {
                _hurt_counter -= FlxG.elapsed*3;
            }

            if (FlxG.keys.LEFT)
			{
				facing = LEFT;
				velocity.x -= _move_speed * FlxG.elapsed;
			}
			else if (FlxG.keys.RIGHT)
			{
				facing = RIGHT;
				velocity.x += _move_speed * FlxG.elapsed;
			}
			//jumping
			if (FlxG.keys.justPressed("X") && velocity.y == 0)
			{
				velocity.y = -_jump_power;
			}
            if (_hurt_counter > 0)
            {
                play("hurt");
            }
            else            
            {
                if (velocity.y != 0)
                {
                    play("jump");
                }
                else
                {
                    if (velocity.x == 0)
                    {
                        play("stopped");
                    }
                    else
                    {
                       play("normal");
                    }
                }
            }

            super.update();
        }

        override public function hurt(Damage:Number):void
        {
            _hurt_counter = 1;
            return super.hurt(Damage);
        }       
    }
}

}