package { 

	import org.flixel.FlxPreloader; 
	
	public class Preloader extends FlxPreloader {
		
		 public function Preloader():void {
		    className = "PingGame";
		    //myURL = "adamatomic.com/mode";
		    super();
	     }
	}
}