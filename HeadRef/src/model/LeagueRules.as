package model{
	
	
	public class LeagueRules{
		[Bindable] public var leagueManagerEmail 	: String = "";
		[Bindable] public var leagueName			: String = "";
		
		[Bindable] public var strikesAllowed	: Number = 3;
		[Bindable] public var ballsAllowed		: Number = 4;
		[Bindable] public var foulsAllowed		: Number = 3;
		[Bindable] public var numberOfInnings	: Number = 5;
		
		[Bindable] public var allowsTies		: Boolean = true;
		
		[Bindable] public var foulsAreStrikes	: Boolean = false;
		[Bindable] public var walkOnBalls		: Boolean = true;
		
		public function LeagueRules(){}
	}
}