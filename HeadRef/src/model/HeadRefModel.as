package model{
	import mx.collections.ArrayCollection;

	public class HeadRefModel{
		
		[Bindable]
		public var teams:ArrayCollection = new ArrayCollection();
		[Bindable]
		public var leagues:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		public var gameModel:GameModel = new GameModel();
		
		public var teamSelectedForEditing:String = "";
		public var rulesSelectedForEditing:String = "";
		
	
		
		public function HeadRefModel(){
			//we're going to use a string to signify that we're adding a new item to these
			//ArrayCollections. 

			if(teams.length<1){
				var ti:TeamModel = new TeamModel();
				ti.teamName = RefConstants.ADDTEAM;
				teams.addItem(ti);
			}
			if(leagues.length<1){				
				var ri:LeagueRules = new LeagueRules();
				ri.leagueName = RefConstants.ADDRULES;
				leagues.addItem(ri);
			}


		}
	
	}
}