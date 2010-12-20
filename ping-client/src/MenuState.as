package
{
	import mx.messaging.*;
	import mx.messaging.channels.*;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.*;
	import mx.utils.URLUtil;
	import mx.messaging.config.ServerConfig;
	
	import org.flixel.*;


	public class MenuState extends FlxState
	{
		public function MenuState()
		{
			var txt:FlxText
				txt = new FlxText(0, (FlxG.height / 2) - 80, FlxG.width, "P1ng");
				txt.setFormat(null,48,0xFFFFFFFF,"center");
				this.add(txt);
				txt = new FlxText(0, FlxG.height  -24, FlxG.width, "PRESS X For 1 Player PRESS C For Online Multiplayer")
				txt.setFormat(null, 8, 0xFFFFFFFF, "center");
				this.add(txt);
		}

		override public function update():void
		{
			super.update();
			if(FlxG.keys.X) {
				FlxG.flash.start(0xffffffff, 0.75);
        		FlxG.fade.start(0xff000000, 1, onFadeToPlayState);
			} else if (FlxG.keys.C) {
				FlxG.flash.start(0xffff0000, 0.75);
        		FlxG.fade.start(0xff000000, 1, onFadeToNetworkState);
			}
		}
		
		public function onFadeToPlayState():void {
			FlxG.state = new PlayState();
		}
		
		public function onFadeToNetworkState():void {
			var echoService:RemoteObject = new RemoteObject();
			echoService.destination = "echoServiceDestination";
			
			echoService.echo.addEventListener("result", handleEchoResult);
			
			echoService.addEventListener("fault", handleEchoFault);
			
			echoService.echo("Test echo");			
			FlxG.state = new NetworkPlayState();
		}	
		
		private function handleEchoResult(event:ResultEvent):void {
                FlxG.log("ECHO RPC result: " + event.result );
        }
        
        private function handleEchoFault(event:FaultEvent):void {
                FlxG.log("ECHO RPC FAULT: " + event.fault );
        }        
	}
}
