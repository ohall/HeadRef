package model{
	
	
	public class LeagueRules{
		private var _leagueName	: String = "";
		private var _id 		: String = "";

		[Bindable] public var leagueManagerEmail 	: String = "";
		
		[Bindable] public var strikesAllowed	: Number = 3;
		[Bindable] public var ballsAllowed		: Number = 4;
		[Bindable] public var foulsAllowed		: Number = 3;
		[Bindable] public var numberOfInnings	: Number = 5;
		
		[Bindable] public var allowsTies		: Boolean = true;
		
		[Bindable] public var foulsAreStrikes	: Boolean = false;
		[Bindable] public var walkOnBalls		: Boolean = true;
		
		[Bindable] public var timeLimitInMilliseconds : Number = -1;
		
		public function set leagueName(pName:String):void{
			_leagueName = pName;
			_id = _leagueName.split(" ").join("");//strip out spaces
		}
		
		[Bindable]
		public function get leagueName():String{
			return _leagueName;	
		}
		
		[Bindable]
		public function get id():String{
			return _id;
		}
		
		public function set id(pId:String):void{
			_id = pId;
		}
		
		public function LeagueRules(){}
	}
}