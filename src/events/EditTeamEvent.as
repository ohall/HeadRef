package events{
	import flash.events.Event;
	
	public class EditTeamEvent extends Event{
		public static const EDIT_TEAM:String = "editTeam";
		
		public var teamToEdit:String = "";
		
		public function EditTeamEvent(pTeamSelected:String){
			teamToEdit = pTeamSelected;
			super(EDIT_TEAM, false, false);
		}
		
		override public function clone():Event{
			return new EditTeamEvent(teamToEdit);
		}
		
	}
}