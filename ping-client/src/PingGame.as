package
{
	import org.flixel.*;
	[SWF(width="640", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]
	public class PingGame extends FlxGame
	{
		public function PingGame()
		{
			//This game we won't pause when focus is lost
			_pauseOnFocus = false;
			//super(320,240,MenuState,2);
			super(320,240,MenuState,2);
		    //showLogo = false;
		}
	}
}
