package components{
	import model.LeagueRules;
	
	import mx.collections.ArrayCollection;

	public class HeadRefDefaults{
		
		
		public function defaultRules():ArrayCollection{
			
			
			var circuitPoolPlay:LeagueRules = new LeagueRules();
				circuitPoolPlay.id="TournamentPoolPlay";
				circuitPoolPlay.leagueName="Tournament Pool Play";
				circuitPoolPlay.leagueManagerEmail="";
				circuitPoolPlay.strikesAllowed=3;
				circuitPoolPlay.ballsAllowed=4;
				circuitPoolPlay.foulsAllowed=3;
				circuitPoolPlay.numberOfInnings=5;
				circuitPoolPlay.allowsTies=true;
				circuitPoolPlay.foulsAreStrikes=false;
				circuitPoolPlay.walkOnBalls=true;
				circuitPoolPlay.timeLimitInMilliseconds=3600000;
			
			
			var circuitElims:LeagueRules = new LeagueRules();
				circuitElims.id="TournamentElim";
				circuitElims.leagueName="Tournament Elimination";
				circuitElims.leagueManagerEmail="";
				circuitElims.strikesAllowed=3;
				circuitElims.ballsAllowed=4;
				circuitElims.foulsAllowed=3;
				circuitElims.numberOfInnings=6;
				circuitElims.allowsTies=false;
				circuitElims.foulsAreStrikes=false;
				circuitElims.walkOnBalls=true;
				circuitElims.timeLimitInMilliseconds=3600000;
				
			var casual:LeagueRules = new LeagueRules();
				casual.id="Casual";
				casual.leagueName="Casual";
				casual.leagueManagerEmail="";
				casual.strikesAllowed=3;
				casual.ballsAllowed=4;
				casual.foulsAllowed=4;
				casual.numberOfInnings=5;
				casual.allowsTies=true;
				casual.foulsAreStrikes=false;
				casual.walkOnBalls=true;
				casual.timeLimitInMilliseconds=3600000;
			
				return new ArrayCollection([circuitPoolPlay,circuitElims,casual]);
			
			
		}
		
		public function HeadRefDefaults(){
		}
	}
}