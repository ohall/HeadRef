package events
{
	import flash.events.Event;
	
	public class EndGamePopUpButtonEvent extends Event{
		
		public static const CONTINUE_CLICK:String = "contClick";
		public static const END_CLICK:String = "endClick";
		
		public function EndGamePopUpButtonEvent(type:String):void{
			super(type, false, false);
		}
		
		override public function clone():Event{
			return EndGamePopUpButtonEvent(type);
		}
	}
}