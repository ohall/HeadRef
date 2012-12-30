package events
{
	import flash.events.Event;
	
	public class GameCompleteEvent extends Event{

		public static const GAME_COMPLETE:String = "gameComplete";

		public function GameCompleteEvent(){
			super(GAME_COMPLETE, false, false);
		}
		
		override public function clone():Event {
			return new GameCompleteEvent();
		}
	}
}