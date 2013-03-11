package model{
	public class TeamModel{
				
		private var _id			: String;
		private var _teamName 	: String;
		
		[Bindable] public var teamColor		: uint;
		[Bindable] public var captainEmail	: String;
		
		public function set teamName(pName:String):void{
			_teamName = pName;
			_id = _teamName.split(" ").join("");//strip out spaces
		}
		
		[Bindable]
		public function get teamName():String{
			return _teamName;	
		}
		
		[Bindable]
		public function get id():String{
			return _id;
		}
		
		public function set id(pId:String):void{
			_id = pId;
		}
		
		public function TeamModel(pTeamName:String,pTeamColor:uint){
			teamName = pTeamName;
			teamColor = pTeamColor;
		}
	}
}