package events{
	import flash.events.Event;
	
	public class GameTimeExpiredEvent extends Event{
		
		public const GAME_TIME_EXP:String = "gameTimeExpired";
		public function GameTimeExpiredEvent(){
			super(GAME_TIME_EXP, false, false);
		}
	}
}