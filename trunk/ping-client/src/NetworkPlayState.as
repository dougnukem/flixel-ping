package
{
	import flash.events.*;
	import flash.net.*;
	import flash.utils.Timer;
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	import mx.messaging.*;
	import mx.messaging.channels.*;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.*;
	
	import org.flixel.*;
    
	public class NetworkPlayState extends PlayState
	{
		
		private const RTMFPRendevousAddress:String = "rtmfp://p2p.rtmfp.net";
		
		private const DeveloperKey:String = "182436131b35c91d6e535a26-47736a445322";
		
		//SERVER STREAMS
		private var serverListenStream:NetStream;
		
		private var incomingClientStream:NetStream;
		
		//CLIENT STREAMS
		private var incomingServerStream:NetStream;
		
		private var outgoingClientStream:NetStream;
		
		private var netConnection:NetConnection;
		
		private var gameID:Number;
		
		private var networkRole:int = -1;
		
		private var networkPlayerPosition:FlxPoint = new FlxPoint(0,0);
		
		public function NetworkPlayState()
		{
			super();
			
			//Setup network communication	

			//Initialize Adobe Stratus connection to negotiate P2P RTMFP connection
			netConnection = new NetConnection();
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			netConnection.connect(RTMFPRendevousAddress + "/" + DeveloperKey);
			
		}
		
		private function log(logMsg:String):void {
            FlxG.log(logMsg);
            trace(logMsg);
            	
		}
		
		private function netStatusHandler(event:NetStatusEvent):void {
            switch (event.info.code) {
                case "NetConnection.Connect.Success":
                	log("RTMFP Connect success : " + netConnection.nearID);
                	//this.p1Position.text = netConnection.nearID;
                	
                    connectStream();
                    break;
                case "NetStream.Play.StreamNotFound":
                    log("Unable to locate stream: " );
                    break;
            }
        }

		private function serverListenStreamHandler(event:NetStatusEvent):void {
            switch (event.info.code) {
            	case "NetStream.Play.Start":
            	   serverListenStream.send("onClientConnected", "[SERVER NetStream.Play.Start: client connected: ]");
            	   //serverListenStream.client.onPeerConnect(event.target);
                default:
                	log("serverListenStreamHandler: " + event.info.code);
            }
        }
        
        private function incomingClientStreamHandler(event:NetStatusEvent):void {
            switch (event.info.code) {
                default:
                    log("incomingClientStreamHandler: " + event.info.code);
            }
        }
        
        private function incomingServerStreamHandler(event:NetStatusEvent):void {
            switch (event.info.code) {
                default:
                    log("incomingServerStreamHandler: " + event.info.code);
            }
        }   
        
        private function outgoingClientStreamHandler(event:NetStatusEvent):void {
            switch (event.info.code) {
                case "NetStream.Play.Start":
                default:
                    log("outgoingClientStreamHandler: " + event.info.code);
            }
        }                
                

		private function connectStream() : void{
			var gameService:RemoteObject = new RemoteObject();
            gameService.destination = "gameServiceDestination";
            
            gameService.getActiveGames.addEventListener("result", handleGetActiveGames);
            
            gameService.addEventListener("fault", handleGameServiceFault);

            FlxG.log("Requesting active games...");
            
            gameService.getActiveGames();
			

		}
		
        private function handleCreateGame(event:ResultEvent):void {
        	    var result:* = event.result;
                FlxG.log("[CreateNewGame] result: gameID: " + result.id +   " peerID:\n" + result.peerID + "\nname: "+ result.gameName+ "\n\n");
                
                this.gameID = result.id;
                var gameService:RemoteObject = new RemoteObject();
                gameService.destination = "gameServiceDestination";
                gameService.refreshGame.addEventListener("result", handleGameRefresh);
                
                var timer:Timer = new Timer(15000);
                timer.addEventListener(TimerEvent.TIMER,refreshGame);
                timer.start();
                
                //SERVER:
                networkRole = NetworkRole.SERVER;
                this.player2Paddle.disableKeyInput();
                
	            //Create the stream to send data
	            serverListenStream = new NetStream(netConnection, NetStream.DIRECT_CONNECTIONS);
	            serverListenStream.addEventListener(NetStatusEvent.NET_STATUS, serverListenStreamHandler);    
	            log("[PUBLISH server2client stream]");
	            
	            
	            //Setup server "client" handler
	            var serverListenerClient:Object = new Object;
	            
	            serverListenerClient.onPeerConnect = function(remoteClient:NetStream):Boolean {
	            	log("[server2client onPeerConnect : Incoming client connection : farID = " + remoteClient.farID + "]");
	            	//Connect to client P2P
	            	incomingClientStream = new NetStream(netConnection, remoteClient.farID);
	            	incomingClientStream.addEventListener(NetStatusEvent.NET_STATUS, incomingClientStreamHandler);
	                
	                log("[SUBSCRIBE client2server stream]");
	                serverListenStream.send("onClientConnected", "[client connected: "+ remoteClient.farID+"]");
	                
	               var incomingClient = new Object;
	               
	               incomingClient.onPositionUpdate = function(id:String, x:Number, y:Number, dx:Number, dy:Number) : void {
	                   //log("[p2 Position update: id=" + id + " x=" + x + " y=" + y + " dx="+dx + " dy="+dy + "]");
	                   networkPlayerPosition.x = x;
	                   networkPlayerPosition.y = y;
	               }
	               
	               incomingClient.onPingRequest = function(clientID:String, time:uint) : void {
	               	   //Simply send a ping back (the round trip time will be used to calculate ping time)
	               	   serverListenStream.send("onPingResponse", time);
	               	   
	               }
	               
	               incomingClientStream.client = incomingClient;
	               incomingClientStream.play("client2server");
	               
                    var timer:Timer = new Timer(100);
                    timer.addEventListener(TimerEvent.TIMER, sendPositionUpdateServer);
                    timer.start();
                    
                    return true;
	            }
	            
	            serverListenStream.client = serverListenerClient;
	            
	            serverListenStream.publish("server2client");
        }
        
        private function refreshGame(event:TimerEvent) {
            var gameService:RemoteObject = new RemoteObject();
            gameService.destination = "gameServiceDestination";
            gameService.refreshGame.addEventListener("result", handleGameRefresh);
            gameService.refreshGame(this.gameID);
        }
        
        private function handleGameRefresh(event:ResultEvent):void {
                var result:* = event.result;
                if (result != null) {
                    //FlxG.log("[Refresh game lobby] result: gameID: " + result.id +   " peerID:" + result.peerID + "\nname: "+ result.gameName + "\n");
                } else {
                	FlxG.log("[Refresh game lobby] result NULL (the gameID: " + this.gameID + " has expired?)");
                }

        }        
        
        private function  handleGetActiveGames(event:ResultEvent):void {
        	
        	if (event.result != null && event.result.length > 0) {
        		var listOfGames:ArrayCollection = event.result as ArrayCollection;
                log("[GetActiveGames] result: ");
                for each( var game:Object in listOfGames )
                {
                    FlxG.log("Game: id="+game.id + "\npeerID:" + game.peerID + "\nname="+ game.gameName+ "\n\n");
                }
                
                //CLIENT
                networkRole = NetworkRole.CLIENT;
                this.player1Paddle.disableKeyInput();
                
                var game:Object = listOfGames[0];
                
                log("RTMFP connecting...");
                
                //Connect to game
                incomingServerStream = new NetStream(netConnection, game.peerID);
                incomingServerStream.addEventListener(NetStatusEvent.NET_STATUS, incomingServerStreamHandler);
                
                log("[SUBSCRIBE server2client stream]");
                var incomingServerClient:Object = new Object;
                
                incomingServerClient.onClientConnected = function (msg:String) {
                    log("[CLIENT onClientConnected]: " + msg);
                }
                
                incomingServerClient.onPingResponse = function(time:uint) {
                	var ping:PingRequest = new PingRequest;
                	ping.timeSent = time;
                	//Track received time so we can calc roundtrip
                	ping.onPingResponseReceived();
                	log ("[CLIENT] ping : " + ping.getPingTime());
                	this.p1Position.text = ping.getPingTime();
                }
                
                incomingServerClient.onPositionUpdate = function(id:String, x:Number, y:Number, dx:Number, dy:Number) : void {
                       //log("[p1 Position update: id=" + id + " x=" + x + " y=" + y + " dx="+dx + " dy="+dy + "]");
                       networkPlayerPosition.x = x;
                       networkPlayerPosition.y = y;
                }
                
                incomingServerStream.client = incomingServerClient;
                incomingServerStream.play("server2client");
                
                outgoingClientStream = new NetStream(netConnection, NetStream.DIRECT_CONNECTIONS);
                outgoingClientStream.addEventListener(NetStatusEvent.NET_STATUS, outgoingClientStreamHandler);
                
                log("[PUBLISH client2server stream]");
                
                var outgoingClientStreamClient = new Object;
                outgoingClientStreamClient.onPeerConnect = function(caller:NetStream):Boolean
                {
                    log("[client2server] onPeerConnect: " + caller.farID + "\n");
                    //send position (we should do this on a timer)
                    //outgoingClientStream.send("onPositionUpdate", netConnection.nearID, 1, 2, 3, 4);
                    
                    var timer:Timer = new Timer(100);
			        timer.addEventListener(TimerEvent.TIMER, sendPositionUpdate);
			        timer.start();
                    
                    return true; 
                }

                outgoingClientStream.client = outgoingClientStreamClient;
                outgoingClientStream.publish("client2server");
                

            } else {
            	log("[GetActiveGames] result: NO ACTIVE GAMES \n"+
            	           "Creating game...");
	            var gameService:RemoteObject = new RemoteObject();
	            gameService.destination = "gameServiceDestination";
	            gameService.createNewGame.addEventListener("result", handleCreateGame);
	            gameService.addEventListener("fault", handleGameServiceFault);
	            gameService.createNewGame(netConnection.nearID);  
            }
        }
        
        public function sendPositionUpdate(event:TimerEvent) : void{
        	//We should be sending the actual paddle state
            outgoingClientStream.send("onPositionUpdate", netConnection.nearID, this.player2Paddle.x, this.player2Paddle.y, 0, 0);
            outgoingClientStream.send("onPingRequest", netConnection.nearID, getTimer());
        }
        
        public function sendPositionUpdateServer(event:TimerEvent) : void{
            //We should be sending the actual paddle state
            serverListenStream.send("onPositionUpdate", netConnection.nearID, this.player1Paddle.x, this.player1Paddle.y, 0, 0);
        }        
        
        private function handleGameServiceFault(event:FaultEvent):void {
            FlxG.log("gameServiceDestination FAULT: " + event.fault );
        }  
        		
		override public function update():void
		{
			//Move the network controlled paddle
			if (networkRole == NetworkRole.CLIENT) {
				//Move the p1 paddle
				player1Paddle.setPosition(networkPlayerPosition);
			} else if (networkRole == NetworkRole.SERVER) {
                //Move the p2 paddle
                player2Paddle.setPosition(networkPlayerPosition);
            } 
			super.update();
		}		
	}
}
