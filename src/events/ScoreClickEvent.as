package events{
	import flash.events.Event;
	
	public class ScoreClickEvent extends Event{
		
		public static const SCORECLICK:String = "scoreClick";
		public function ScoreClickEvent(){
			super(SCORECLICK, false, false);
		}
	}
}