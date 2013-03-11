package components{
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLSchemaResult;
	import flash.data.SQLStatement;
	import flash.data.SQLTableSchema;
	import flash.display.Sprite;
	import flash.errors.SQLError;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.text.ReturnKeyLabel;
	
	import model.HeadRefModel;
	import model.LeagueRules;
	import model.TeamModel;
	
	import mx.collections.ArrayCollection;
	
	public class SqlConnect extends Sprite{
		
		private var _sqlConnection 	: SQLConnection;
		private var _model 			: HeadRefModel;
		
		private static const DB_NAME 			: String = "refData.db";
		
		private static const TABLE_NAME_RULES 	: String = "Rules";
		private static const TABLE_NAME_TEAMS 	: String = "Teams";		
		private static const CREATE_TABLE_TEAMS : String = "CREATE TABLE IF NOT EXISTS Teams (id TEXT, teamName TEXT, teamColor TEXT, captainEmail TEXT)";
		private static const CREATE_TABLE_RULES : String = "CREATE TABLE IF NOT EXISTS Rules (id TEXT, leagueName TEXT, leagueManagerEmail TEXT, " +
			"strikesAllowed INTEGER, foulsAllowed INTEGER, ballsAllowed INTEGER, numberOfInnings INTEGER, allowsTies BOOL, foulsAreStrikes BOOL, " +
			"walkOnBalls BOOL, timeLimitInMilliseconds INTEGER)";
		
		private static const CREATE_UNIQUE_INDEX_TEAMS : String = "CREATE UNIQUE INDEX `id_UNIQUE` ON `Teams` (`id` ASC)";
		private static const CREATE_UNIQUE_INDEX_RULES : String = "CREATE UNIQUE INDEX `id_UNIQUE` ON `Rules` (`id` ASC)";
		
		private static const INSERT_INTO_TEAMS_IF_NOT_THERE 	: String = "INSERT OR REPLACE INTO Teams (id, teamName, teamColor, captainEmail) VALUES (?, ?, ?, ?)";
		private static const INSERT_INTO_RULES_IF_NOT_THERE 	: String = "INSERT OR REPLACE INTO Rules (id, leagueName, leagueManagerEmail,  strikesAllowed, foulsAllowed, " +
			"ballsAllowed, numberOfInnings, allowsTies, foulsAreStrikes, walkOnBalls, timeLimitInMilliseconds) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		
		private static const GET_TEAMS 			: String = "SELECT * FROM Teams";
		private static const GET_RULES 			: String = "SELECT * FROM Rules";
		
		public function SqlConnect(){}	
		
		/**
		 * Loads MYSqlLite Database and populates with teams and rules
		 * */
		public function saveModel(pModel:HeadRefModel):void{
			_model = pModel;
			if(!_sqlConnection){ _sqlConnection = new SQLConnection(); }
			if( loadDatabase() ){
				createTableIfDoesntExist(TABLE_NAME_TEAMS);
				createTableIfDoesntExist(TABLE_NAME_RULES);	
				addTeamsIfDoesntExist(_model.teams);
				addRulesIfDoesntExist(_model.leagues);
			}
		}

		/**
		 * Gets saved rules and teams from database adds to new HeadRef
		 * model and returns.
		 * */
		public function getSavedModelFromDatabase():HeadRefModel{
			_model = new HeadRefModel();
			if(!_sqlConnection){ _sqlConnection = new SQLConnection();}
			if( loadDatabase() ){
				_model.teams = getTeams();
				_model.leagues = getRules();
				closeDatabase();
			}
			return _model;
		}
		
		public function databaseExists():Boolean{
			var dbFile:File = new File( "app:/"+DB_NAME );
			return dbFile.exists;
		}
		
		/////////////////////////
		// private methods  ////
		////////////////////////

		private function loadDatabase():Boolean{
			var dbFile:File = new File( "app:/"+DB_NAME );
			var didExist:Boolean = dbFile.exists;
			try	{ 
				_sqlConnection.open(dbFile)
			}catch(err:Error){ 
				trace(err.message + "Function: loadDatabase"); 
			}
			return didExist;
		}
		
		private function createTableIfDoesntExist(pTableName:String):void{
			var cTable:SQLStatement = new SQLStatement();
			cTable.sqlConnection = _sqlConnection;
			cTable.text = ( pTableName==TABLE_NAME_RULES )?CREATE_TABLE_RULES:CREATE_TABLE_TEAMS;
			try { 
				cTable.execute();
			}catch( err:SQLError ){ 
				trace( err.message );
			}
		}

		private function addTeamsIfDoesntExist( items:ArrayCollection ):void{
			var sqlStatement:SQLStatement = new SQLStatement();
			sqlStatement.sqlConnection = _sqlConnection;
			for each( var team:TeamModel in items ){
				sqlStatement.text = INSERT_INTO_TEAMS_IF_NOT_THERE;
				sqlStatement.parameters[0] = team.id;
				sqlStatement.parameters[1] = team.teamName;
				sqlStatement.parameters[2] = team.teamColor;
				sqlStatement.parameters[3] = team.captainEmail;
				try{ 
					sqlStatement.execute();
				}catch(err:SQLError){ 
					var error:SQLError = err;
					trace(err.message + " Function: addTeams"); 
				}
				sqlStatement = null;
				sqlStatement = new SQLStatement();
				sqlStatement.sqlConnection = _sqlConnection;
				sqlStatement.text = "CREATE UNIQUE INDEX "+team.id+" ON `Teams` (`id` ASC)";
				
				try{ 
					sqlStatement.execute();
				}catch(err:SQLError){ 
					error = err;
					trace(err.message + " Cannot Create Unique ID"); 
				}
			}
			
		}
		
		private function addRulesIfDoesntExist( items:ArrayCollection ):void{
			var sqlStatement:SQLStatement = new SQLStatement();
			sqlStatement.sqlConnection = _sqlConnection;
			for each( var item:LeagueRules in items ){
				sqlStatement.text = INSERT_INTO_RULES_IF_NOT_THERE;
				sqlStatement.parameters[0] = item.id;
				sqlStatement.parameters[1] = item.leagueName;
				sqlStatement.parameters[2] = item.leagueManagerEmail;
				sqlStatement.parameters[3] = item.strikesAllowed;
				sqlStatement.parameters[4] = item.foulsAllowed;
				sqlStatement.parameters[5] = item.ballsAllowed;
				sqlStatement.parameters[6] = item.numberOfInnings;
				sqlStatement.parameters[7] = item.allowsTies;
				sqlStatement.parameters[8] = item.foulsAreStrikes;
				sqlStatement.parameters[9] = item.walkOnBalls;
				sqlStatement.parameters[10] = item.timeLimitInMilliseconds;
				
				try{ 
					sqlStatement.execute();
				}catch(err:SQLError){ 
					var error:SQLError = err;
					trace(err.message + " Function: addRules"); 
				}
				sqlStatement = null;
				sqlStatement = new SQLStatement();
				sqlStatement.sqlConnection = _sqlConnection;
				sqlStatement.text = "CREATE UNIQUE INDEX "+item.id+" ON `Rules` (`id` ASC)";
				
				try{ 
					sqlStatement.execute();
				}catch(err:SQLError){ 
					error = err;
					trace(err.message + " Cannot Create Unique ID"); 
				}				
			}
		}
		
		private function closeDatabase():void{
			_sqlConnection.close();
		}		
		
		private function getTeams():ArrayCollection{
			var teamsArray:ArrayCollection = new ArrayCollection();
			createTableIfDoesntExist( TABLE_NAME_TEAMS );
			var sqlStatement:SQLStatement = new SQLStatement();
			sqlStatement.sqlConnection = _sqlConnection;
			sqlStatement.text = GET_TEAMS;
			sqlStatement.execute();
			var result:SQLResult = sqlStatement.getResult();
			if(result.data){
				var numberOfRows:int = result.data.length;
				for( var i:int = 0; i < numberOfRows; i++ ){
					var item:Object 	= result.data[i];
					var team:TeamModel 	= new TeamModel(item.teamName, item.teamColor);
					team.captainEmail 	= item.captainEmail;
					teamsArray.addItem(team);
				}
			}
			return teamsArray;
		}
		
		private function getRules():ArrayCollection{
			var rulesArray:ArrayCollection = new ArrayCollection();
			createTableIfDoesntExist( TABLE_NAME_RULES );
			var sqlStatement:SQLStatement = new SQLStatement();
			sqlStatement.sqlConnection = _sqlConnection;
			sqlStatement.text = GET_RULES
			sqlStatement.execute();
			var result:SQLResult = sqlStatement.getResult();
			if(result.data){
				var numberOfRows:int = result.data.length;
				for( var i:int = 0; i < numberOfRows; i++ ){
					var resultObj:Object 		= result.data[i];
					var item:LeagueRules 		= new LeagueRules();
					item.allowsTies 			= resultObj.allowties;
					item.ballsAllowed 			= resultObj.ballsAllowed;
					item.foulsAllowed 			= resultObj.foulsAllowed;
					item.foulsAreStrikes		= resultObj.foulsAreStrikes;
					item.leagueManagerEmail 	= resultObj.leagueManagerEmail;
					item.leagueName 			= resultObj.leagueName;
					item.numberOfInnings 		= resultObj.numberOfInnings;
					item.strikesAllowed			= resultObj.strikesAllowed;
					item.walkOnBalls 			= resultObj.walkOnBalls;
					item.timeLimitInMilliseconds= resultObj.timeLimitInMilliseconds;
					rulesArray.addItem(item);
				}
			}
			return rulesArray;			
		}
	}
}