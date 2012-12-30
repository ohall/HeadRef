package events{
	import flash.events.Event;
	
	public class AddTeamEvent extends Event{
		public static const ADD_TEAM:String = "addTeam";
		
		public function AddTeamEvent(){
			super(ADD_TEAM, false, false);
		}
		
		override public function clone():Event{
		 	return new AddTeamEvent();
		}
			
			
	}
}