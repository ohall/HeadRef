package components{
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.display.Sprite;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	
	import model.HeadRefModel;
	import model.LeagueRules;
	import model.TeamModel;
	
	import mx.collections.ArrayCollection;
	
	public class SqlConnect extends Sprite
	{
		
		private var sqlConnection:SQLConnection;
		private var _model:HeadRefModel;
		
		public function SqlConnect(pModel:HeadRefModel){
			_model = pModel;
			loadDatabase();
			populateDatabase();
			outputDatabase();
		}	
		
		
		private function loadDatabase():void{
			var filePath:String = File.applicationDirectory.resolvePath("refData.db").nativePath;
			var dbFile:File = new File( filePath );
			
			if( dbFile.exists ) dbFile.deleteFile();
			
			sqlConnection = new SQLConnection();
			try	
			{
				sqlConnection.open(dbFile)
			}
			catch(err:Error)
			{ 
				trace(err.message + "Function: loadDatabase"); 
			}
		}
		
		
		private function populateDatabase():void{
			var createTable:SQLStatement = new SQLStatement();
			createTable.sqlConnection = sqlConnection;
			
			createTable.text = "CREATE TABLE IF NOT EXISTS Teams ( "
				+"ID INTEGER PRIMARY KEY AUTOINCREMENT, teamName TEXT, teamColor TEXT, captainEmail TEXT )";
			
			try {
				createTable.execute();
			}catch( err:Error ){
				trace( err.message );
			}
			
			createTable.text = "CREATE TABLE IF NOT EXISTS Rules ( "
				+"leagueManagerEmail TEXT, " +
					"leagueName TEXT, " +
					"strikesAllowed INTEGER, " +
					"foulsAllowed INTEGER, " +
					"numberOfInnings INTEGER, " +
					"allowsTies BOOL, " +
					"foulsAreStrikes BOOL, " +
					"walkOnBalls BOOL, " +
					"timeLimitInMilliseconds INTEGER)";
			
			try{
				createTable.execute();
			}catch( err:Error ) {
				trace( err.message );
			}
			
			addRules(_model.leagues);
//			addTeams(_model.teams);
			
			
			/*[ {object parameters}, {object parameters}, {etc} ];
			This creates an Array with Dynamic Objects. */
//			addItems([
//				{firstName:"Bob", lastName:"Marshall"},
//				{firstName:"Ani", lastName:"Mahmud"},
//				{firstName:"John", lastName:"Shaw"},
//				{firstName:"Markus", lastName:"Clause"},
//				{firstName:"Paula", lastName:"Bobson"},
//				{firstName:"James", lastName:"Bradley"},
//				{firstName:"Paul", lastName:"Lobbs"},
//				{firstName:"Benjamin", lastName:"Stall"}
//			]);
		}	
		
		private function addTeams( items:ArrayCollection ):void{
			var sqlStatement:SQLStatement = new SQLStatement();
			sqlStatement.sqlConnection = sqlConnection;
			
			for each( var team:TeamModel in items ){
				sqlStatement.text = "INSERT INTO Teams (teamName, teamColor, captainEmail) "+
					"VALUES (?, ?)";
				sqlStatement.parameters[0] = team.teamName;
				sqlStatement.parameters[1] = team.teamColor;
				sqlStatement.parameters[2] = team.captainEmail;
				
				try{
					sqlStatement.execute();
				}
				catch(err:Error){
					trace(err.message + " Function: addTeams");
				}
			}
			
			sqlStatement = null;
		}
		
		
		private function addRules( items:ArrayCollection ):void{
			var sqlStatement:SQLStatement = new SQLStatement();
			sqlStatement.sqlConnection = sqlConnection;
			
			for each( var item:LeagueRules in items ){
				sqlStatement.text = "INSERT INTO Rules " +
					"(leagueManagerEmail, leagueName, " +
					"strikesAllowed, foulsAllowed, ballsAllowed " +
					"numberOfInnings, allowsTies, " +
					"foulsAreStrikes, walkOnBalls, " +
					"timeLimitInMilliseconds) "+
					"VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
				sqlStatement.parameters[0] = item.leagueManagerEmail;
				sqlStatement.parameters[1] = item.leagueName;
				sqlStatement.parameters[2] = item.strikesAllowed;
				sqlStatement.parameters[3] = item.ballsAllowed;
				sqlStatement.parameters[4] = item.foulsAllowed;
				sqlStatement.parameters[5] = item.numberOfInnings;
				sqlStatement.parameters[6] = item.allowsTies;
				sqlStatement.parameters[7] = item.foulsAreStrikes;
				sqlStatement.parameters[8] = item.walkOnBalls;
				sqlStatement.parameters[9] = item.timeLimitInMilliseconds;
				
				try{
					sqlStatement.execute();
				}catch(err:Error){
					trace(err.message + " Function: addRules");
					trace(err.name );
				}
			}
			
			sqlStatement = null;
		}
		
		
//		private function addItems( items:Array ):void
//		{
//			var sqlStatement:SQLStatement = new SQLStatement();
//			sqlStatement.sqlConnection = sqlConnection;
//			
//			for each( var item:Object in items )
//			{
//				sqlStatement.text = "INSERT INTO Users (firstName, lastName) "+
//					"VALUES (?, ?)";
//				sqlStatement.parameters[0] = item.firstName;
//				sqlStatement.parameters[1] = item.lastName;
//				
//				try
//				{
//					sqlStatement.execute();
//				}
//				catch(err:Error)
//				{
//					trace(err.message + " Function: addItems");
//				}
//			}
//			
//			sqlStatement = null;
//		}
		
		
		private function closeDatabase():void{
			sqlConnection.close();
		}		
		
		
		private function outputDatabase():void{
			var sqlStatement:SQLStatement = new SQLStatement();
			sqlStatement.sqlConnection = sqlConnection;
			sqlStatement.text = "SELECT * FROM Teams";
			sqlStatement.addEventListener(SQLEvent.RESULT, printTeams);
			sqlStatement.execute();
			
			sqlStatement = null;
			sqlStatement = new SQLStatement();
			sqlStatement.sqlConnection = sqlConnection;
			sqlStatement.text = "SELECT * FROM Rules";
			sqlStatement.addEventListener(SQLEvent.RESULT, printLeagueRules);
			sqlStatement.execute();
			
			
			
		}	
		
		
		private function printTeams(event:SQLEvent):void{
		//	sqlStatement.removeEventListener(SQLEvent.RESULT, printTeams);
			var sqlStatement:SQLStatement = event.target as SQLStatement;
			var result:SQLResult = sqlStatement.getResult();
			
			if( result == null ) return;
			
			var numberOfRows:int = result.data.length;
			trace("TEAMNAME        TEAMCOLOR        CAPTAINSEMAIL");
			
			for( var i:int = 0; i < numberOfRows; i++ )
			{
				var item:TeamModel = result.data[i];
				
				trace( item.teamName + fillSpaces(item.teamName, 17) +
					item.teamColor + fillSpaces(item.teamName, 17) +
					item.captainEmail);
			}
		}

			
		private function printLeagueRules(event:SQLEvent):void{
		//	sqlStatement.removeEventListener(SQLEvent.RESULT, printLeagueRules);
			var sqlStatement:SQLStatement = event.target as SQLStatement;
			var result:SQLResult = sqlStatement.getResult();
			
			if( result == null ) return;
			
			var numberOfRows:int = result.data.length;
			trace("MGREMAIL        LEAGUENAME        " +
				"STRIKES        BALLS        " +
				"FOULS        INNINGS        " +
				"TIES        FOULSTRIKES        " +
				"WALKONBALLS        TIMELIMITMS");
			
			for( var i:int = 0; i < numberOfRows; i++ )
			{
				var item:LeagueRules = result.data[i];
				
				trace(item.leagueManagerEmail + fillSpaces(item.leagueManagerEmail, 17) +
					item.leagueName + fillSpaces(item.leagueName, 17) +
					item.strikesAllowed + fillSpaces(item.strikesAllowed.toString(), 17) +
					item.ballsAllowed + fillSpaces(item.ballsAllowed.toString(), 17) +
					item.foulsAllowed + fillSpaces(item.foulsAllowed.toString(), 17) +
					item.numberOfInnings + fillSpaces(item.numberOfInnings.toString(), 17) +
					item.allowsTies + fillSpaces(item.allowsTies.toString(), 17) +
					item.foulsAreStrikes + fillSpaces(item.foulsAreStrikes.toString(), 17) +
					item.walkOnBalls + fillSpaces(item.walkOnBalls.toString(), 17) +
					item.timeLimitInMilliseconds);
			}			
			closeDatabase();
		}

		
		
		
		
//		private function selectedAll(event:SQLEvent):void
//		{
//			var sqlStatement:SQLStatement = event.target as SQLStatement;
//			var result:SQLResult = sqlStatement.getResult();
//			
//			if( result == null ) return;
//			
//			var numberOfRows:int = result.data.length;
//			trace("ID        FIRSTNAME        LASTNAME");
//			
//			for( var i:int = 0; i < numberOfRows; i++ )
//			{
//				var item:Object = result.data[i];
//				
//				trace(item.ID + fillSpaces(item.ID, 10) + 
//					item.firstName + fillSpaces(item.firstName, 17) +
//					item.lastName);
//			}
//			
//		}		
		
		
		private function fillSpaces( item:String, length:int ):String{
			var spaces:String = "";
			var currentLength:int = item.length;
			for( var i:int = 0; i < length - currentLength; i++ ){
				spaces += " ";
			}
			return spaces;
		}
	}
}