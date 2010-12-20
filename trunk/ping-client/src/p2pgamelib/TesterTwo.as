package p2pgamelib
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	[SWF (width="1280", height="480", frameRate="60", backgroundColor="0x0")]
	public class TesterTwo extends Sprite
	{
		private var one:Loader;
		private var two:Loader;
		public function TesterTwo()
		{
			one = new Loader();
			one.load(new URLRequest("Ping.swf"), new LoaderContext(false, 
				new ApplicationDomain(ApplicationDomain.currentDomain)));
			addChild(one);
			
			two = new Loader();
			two.load(new URLRequest("Ping.swf"), new LoaderContext(false, 
				new ApplicationDomain(ApplicationDomain.currentDomain)));
			two.x = 640;
			addChild(two);
		}
	}
}