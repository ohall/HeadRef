package model
{
	public class TeamModel{
				
		[Bindable] public var teamName		: String;
		[Bindable] public var teamColor		: uint;
		[Bindable] public var captainEmail	: String;
		
		public function TeamModel(pTeamName:String,pTeamColor:uint){
			teamName = pTeamName;
			teamColor = pTeamColor;
		}
	}
}