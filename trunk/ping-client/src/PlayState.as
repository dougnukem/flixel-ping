package
{
	import org.flixel.*;

	public class PlayState extends FlxState
	{
		protected var player1Score:int = 5;
		
		protected var player2Score:int = 3;
		
		protected var player1ScoreTxt:FlxText;
		
		protected var player2ScoreTxt:FlxText;
		
		protected var p1Position:FlxText;
		
		protected var player1Paddle:Paddle = new Paddle(10, FlxG.height/2, "S", "X");
		
		protected var player2Paddle:Paddle = new Paddle(FlxG.width-30, FlxG.height/2, "UP", "DOWN");
		
		public function PlayState()
		{
			
			player1ScoreTxt = new FlxText(0, (FlxG.height / 8), FlxG.width/2, player1Score.toString());
			player1ScoreTxt.setFormat(null, 24, 0xFFFFFFFF, "center");
			this.add(player1ScoreTxt);
			
			player2ScoreTxt = new FlxText(FlxG.width/2, (FlxG.height / 8) , FlxG.width/2, player2Score.toString());
			player2ScoreTxt.setFormat(null, 24, 0xFFFFFFFF, "center");
			this.add(player2ScoreTxt);
			
			p1Position = new FlxText(0, FlxG.height-24, FlxG.width, player1Score.toString());
			p1Position.setFormat(null, 8, 0xFFFFFFFF, "center");
			this.add(p1Position);
			
			//Add the paddles
			this.add(player1Paddle);
			this.add(player2Paddle);
			
			
		}
		
		override public function update():void
		{
			//p1Position.text = Math.floor(player1Paddle.x) + " " + Math.floor(player1Paddle.y);
			super.update();
		}		
	}
}
