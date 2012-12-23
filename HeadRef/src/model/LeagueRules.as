package model{
	
	
	public class LeagueRules{
		public var leagueManagerEmail : String;
		public var leagueName		: String;
		
		public var strikesAllowed	: Number;
		public var ballsAllowed		: Number;
		public var foulsAllowed		: Number;
		public var numberOfInnings	: Number;
		
		public var allowsTies		: Boolean;
		
		public var foulsAreStrikes	: Boolean;
		public var walkOnBalls		: Boolean;
		
		public function LeagueRules(){}
	}
}