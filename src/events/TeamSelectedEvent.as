package events{
	import flash.events.Event;
	
	import model.TeamModel;
	
	public class TeamSelectedEvent extends Event{
		
		private var _teamSelected:TeamModel;
		
		public static const TEAM_SELECTED:String = "teamSelected";
		
		public function TeamSelectedEvent(pTeamSelected:TeamModel){
			_teamSelected = pTeamSelected;
			super(TEAM_SELECTED, false, false);
		}
	
		public function get teamSelected():TeamModel{
			return _teamSelected;
		}
		
		override public function clone():Event{
			return new TeamSelectedEvent(_teamSelected);
		}

	}
}