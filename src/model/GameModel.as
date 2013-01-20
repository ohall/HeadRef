package model{
	
	import events.GameCompleteEvent;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.managers.PopUpManager;

	public class GameModel{
		

		
		private var _strikes			: Number = 0;
		[Bindable] private var _balls			: Number = 0;
		[Bindable] private var _fouls			: Number = 0;
		[Bindable] private var _outs			: Number = 0;
		[Bindable] private var _inning			: Number = 1;
		[Bindable] private var _homeTeamScore	: Number = 0;
		[Bindable] private var _awayTeamScore	: Number = 0;
		
		[Bindable] private var _homeTeam : TeamModel = new TeamModel("HOME", RefConstants.GENERIC_HOME_COLOR);
		[Bindable] private var _awayTeam : TeamModel = new TeamModel("AWAY", RefConstants.GENERIC_AWAY_COLOR);


		private var _halfInning : String = RefConstants.INNING_TOP;
		
		public var dispatcher:EventDispatcher = new EventDispatcher();

		
		[Bindable] public var leagueRules : LeagueRules;		
		[Bindable] public var allTeams : ArrayCollection = new ArrayCollection();
		
		
		[Bindable]
		public function get strikes():Number{ return _strikes;}
		public function set strikes(pVal:Number):void{
			_strikes = pVal;
			if(_strikes >= leagueRules.strikesAllowed){
				kickerOut();
			}
		}
		[Bindable]
		public function get balls():Number{ return _balls;}
		public function set balls(pVal:Number):void{
			_balls = pVal;
			if(leagueRules.walkOnBalls && _balls >= leagueRules.ballsAllowed){
				kickerSafe();
			}
		}
		[Bindable]
		public function get fouls():Number{ return _fouls;}
		public function set fouls(pVal:Number):void{
			_fouls = pVal;
			if(leagueRules.foulsAreStrikes){
				strikes++;
			}
			if(_fouls>=leagueRules.foulsAllowed){
				kickerOut();
			}
		
		}
		[Bindable]
		public function get outs():Number{ return _outs;}
		public function set outs(pVal:Number):void{
			_outs = pVal;
			newAtBat();

		}
		[Bindable]
		public function get inning():Number{ return _inning;}
		public function set inning(pVal:Number):void{
			_inning = pVal;
			resetInning();
			if(_inning > leagueRules.numberOfInnings){
				gameOver();
			}
		}
		
		
		//team names
		[Bindable]
		public function get homeTeam():TeamModel{ return _homeTeam;}
		public function set homeTeam(pVal:TeamModel):void{_homeTeam = pVal;}
		
		[Bindable]
		public function get awayTeam():TeamModel{ return _awayTeam;}
		public function set awayTeam(pVal:TeamModel):void{_awayTeam = pVal;}
		
		//team scores
		[Bindable]
		public function get homeTeamScore():Number{ return _homeTeamScore;}
		public function set homeTeamScore(pVal:Number):void{_homeTeamScore = pVal;}
		[Bindable]
		public function get awayTeamScore():Number{ return _awayTeamScore;}
		public function set awayTeamScore(pVal:Number):void{_awayTeamScore = pVal;}
				
		public function get halfInning():String{ return _halfInning;}
		public function set halfInning(pVal:String):void{_halfInning = pVal;}
		
		public function newAtBat():void{
			balls=0;
			strikes=0;
			fouls=0;
		}		
		
		
		public function kickerOut():void{
			outs++;
			if( _outs >= 3){
				nextHalfInning();
			}
			
		}
		
		public function kickerSafe():void{
			newAtBat();
		}
		
		
		// private functions
		private function resetInning():void{
			newAtBat();
			outs=0;
		}
		
		private function isTiedAtEnd():Boolean{
			return( _inning >= leagueRules.numberOfInnings && 
					homeTeamScore == awayTeamScore && 
					leagueRules.allowsTies );
		}
		
		private function getWinner():TeamModel{
			return( awayTeamScore > homeTeamScore)?awayTeam:homeTeam;
		}
		
		private function nextHalfInning():void{
			if(_halfInning == RefConstants.INNING_TOP){
				_halfInning = RefConstants.INNING_BOT;
			}else if(_halfInning == RefConstants.INNING_BOT){
				inning++;
				_halfInning = RefConstants.INNING_TOP;
			}	
			resetInning();
		}
		
		private function gameOver():void{
			dispatcher.dispatchEvent( new GameCompleteEvent() );
		}
		
		public function GameModel(){}
	}
}