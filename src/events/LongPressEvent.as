package events
{
	import flash.events.Event;
	
	public class LongPressEvent extends Event{
		public static const LONGPRESS:String = "longPress";
		
		public function LongPressEvent(){
			super(LONGPRESS);
		}
		
		override public function clone():Event{
			return new LongPressEvent();
		}
	}
}