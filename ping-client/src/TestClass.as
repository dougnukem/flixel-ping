package
{
	import org.flixel.*;
	import mx.rpc.remoting.RemoteObject;

	public class TestClass extends FlxState
	{
		public function TestClass()
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
				FlxG.flash(0xffffffff, 0.75);
        		FlxG.fade(0xff000000, 1, onFadeToPlayState);
			} else if (FlxG.keys.C) {
				FlxG.flash(0xffff0000, 0.75);
        		FlxG.fade(0xff000000, 1, onFadeToNetworkState);
			}
		}
		
		public function onFadeToPlayState():void {
			
			FlxG.switchState(PlayState);
		}
		
		public function onFadeToNetworkState():void {
			var remoteObject:RemoteObject = new RemoteObject("echoServiceDestination");
			remoteObject.
			
			FlxG.switchState(NetworkPlayState);
		}		
	}
}
