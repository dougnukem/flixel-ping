package
{
	import flash.utils.getTimer;
	
	public class PingRequest
	{
		
		public var timeSent:uint = 0;
		
		public var timeReceived:uint = 0;
		
		public function PingRequest()
		{
			 timeSent = getTimer();
		}
		public function onPingResponseReceived() {
			timeReceived = getTimer();
		}
		public function getPingTime() : uint {
			return timeReceived - timeSent;
		}
		

	}
}