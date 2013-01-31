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
	
	import model.HeadRefModel;
	import model.LeagueRules;
	import model.TeamModel;
	
	import mx.collections.ArrayCollection;
	
	public class SqlConnect extends Sprite{
		
		private var _sqlConnection 	: SQLConnection;
		private var _model 			: HeadRefModel;
		private var _rulesArray 	: ArrayCollection;
		private var _teamsArray 	: ArrayCollection;
		
		public function SqlConnect(){}	
		
		/**
		 * Loads MYSqlLite Database and populates with teams and rules
		 * */
		public function saveModel(pModel:HeadRefModel):void{
			_model = pModel;
			loadDatabase();
			populateDatabase();
			closeDatabase();
		}

		/**
		 * Gets saved rules and teams from database adds to new HeadRef
		 * model and returns.
		 * */
		public function getSavedModel():HeadRefModel{
			_model = new HeadRefModel();
			if(	loadDatabase() ){
				_model.teams = getTeams();
				_model.leagues = getRules();
				closeDatabase();
			}
			return _model;
		}
		
		
		/////////////////////////
		// private methods  ////
		////////////////////////

		private function loadDatabase():Boolean{
			var filePath:String = File.applicationDirectory.resolvePath("refData.db").nativePath;
			var dbFile:File = new File( filePath );
			if( !dbFile.exists ){
				return false
			}else{
				_sqlConnection = new SQLConnection();
				try	{ _sqlConnection.open(dbFile)
				}catch(err:Error){ trace(err.message + "Function: loadDatabase"); }
				return true;
			}
		}
		
		private function populateDatabase():void{
			
			var createTeamsTable:SQLStatement = new SQLStatement();
			createTeamsTable.sqlConnection = _sqlConnection;			
			createTeamsTable.text = "CREATE TABLE IF NOT EXISTS Teams " +
				"(teamName TEXT, " +
				"teamColor TEXT, " +
				"captainEmail TEXT)";
			try { createTeamsTable.execute();
			}catch( err:SQLError ){ trace( err.message );}
			addTeams(_model.teams);

			var createRulesTable:SQLStatement = new SQLStatement();
			createRulesTable.sqlConnection = _sqlConnection;
			createRulesTable.text = "CREATE TABLE IF NOT EXISTS Rules " +
					"(leagueManagerEmail TEXT, " +
					"leagueName TEXT, " +
					"strikesAllowed INTEGER, " +
					"foulsAllowed INTEGER, " +
					"ballsAllowed INTEGER, " +
					"numberOfInnings INTEGER, " +
					"allowsTies BOOL, " +
					"foulsAreStrikes BOOL, " +
					"walkOnBalls BOOL, " +
					"timeLimitInMilliseconds INTEGER)";
			try{ createRulesTable.execute();
			}catch( err:Error ) { trace( err.message ); }
			addRules(_model.leagues);
		}	
		
		private function addTeams( items:ArrayCollection ):void{
			var sqlStatement:SQLStatement = new SQLStatement();
			sqlStatement.sqlConnection = _sqlConnection;
			for each( var team:TeamModel in items ){
				sqlStatement.text = "INSERT INTO Teams (" +
					"teamName, " +
					"teamColor, " +
					"captainEmail) "+
					"VALUES (?, ?, ?)";
				sqlStatement.parameters[0] = team.teamName;
				sqlStatement.parameters[1] = team.teamColor;
				sqlStatement.parameters[2] = team.captainEmail;
				try{ sqlStatement.execute();
				}catch(err:SQLError){ trace(err.message + " Function: addTeams"); }
			}
			sqlStatement = null;
		}
		
		private function addRules( items:ArrayCollection ):void{
			var sqlStatement:SQLStatement = new SQLStatement();
			sqlStatement.sqlConnection = _sqlConnection;
			for each( var item:LeagueRules in items ){
				sqlStatement.text = "INSERT INTO Rules " +
					"(" +
					"leagueManagerEmail, " +
					"leagueName, " +
					"strikesAllowed, " +
					"foulsAllowed, " +
					"ballsAllowed, " +
					"numberOfInnings, " +
					"allowsTies, " +
					"foulsAreStrikes, " +
					"walkOnBalls, " +
					"timeLimitInMilliseconds" +
					") "+
					"VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
				sqlStatement.parameters[0] = item.leagueManagerEmail;
				sqlStatement.parameters[1] = item.leagueName;
				sqlStatement.parameters[2] = item.strikesAllowed;
				sqlStatement.parameters[3] = item.foulsAllowed;
				sqlStatement.parameters[4] = item.ballsAllowed;
				sqlStatement.parameters[5] = item.numberOfInnings;
				sqlStatement.parameters[6] = item.allowsTies;
				sqlStatement.parameters[7] = item.foulsAreStrikes;
				sqlStatement.parameters[8] = item.walkOnBalls;
				sqlStatement.parameters[9] = item.timeLimitInMilliseconds;
				
				try{ sqlStatement.execute();
				}catch(err:Error){ trace(err.message + " Function: addRules"); }
			}
			sqlStatement = null;
		}
		
		private function closeDatabase():void{
			_sqlConnection.close();
		}		
	
		public function doesTableExist(connection:SQLConnection, tableName:String):Boolean{
			connection.loadSchema();
			var schema:SQLSchemaResult = connection.getSchemaResult();
			for each (var table:SQLTableSchema in schema.tables){
				if (table.name.toLowerCase() == tableName.toLowerCase()){
					return true;
				}
			}
			return false;
		}
	
		private function getTeams():ArrayCollection{
			_teamsArray = new ArrayCollection();
			if( doesTableExist( _sqlConnection, "Teams" ) ){
				var sqlStatement:SQLStatement = new SQLStatement();
				sqlStatement.sqlConnection = _sqlConnection;
				sqlStatement.text = "SELECT * FROM Teams";
				sqlStatement.addEventListener(SQLEvent.RESULT, setTeamsArray);
				sqlStatement.execute();
			}
			return _teamsArray;	
		}
		
		private function getRules():ArrayCollection{
			_rulesArray = new ArrayCollection();
			if( doesTableExist( _sqlConnection, "Rules" ) ){
				var sqlStatement:SQLStatement = new SQLStatement();
				sqlStatement.sqlConnection = _sqlConnection;
				sqlStatement.text = "SELECT * FROM Rules";
				sqlStatement.addEventListener(SQLEvent.RESULT, setRulesArray);
				sqlStatement.execute();
			}
			return _rulesArray;			
		}
		
		private function setTeamsArray(event:SQLEvent):void{
			sqlStatement.removeEventListener(SQLEvent.RESULT, setTeamsArray);
			var sqlStatement:SQLStatement = event.target as SQLStatement;
			var result:SQLResult = sqlStatement.getResult();
			if( result == null ) return;
			var numberOfRows:int = result.data.length;
			for( var i:int = 0; i < numberOfRows; i++ ){
				var item:Object 	= result.data[i];
				var team:TeamModel 	= new TeamModel(item.teamName, item.teamColor);
				team.captainEmail 	= item.captainEmail;
				_teamsArray.addItem(team);
			}
		}
		
		private function setRulesArray(event:SQLEvent):void{
			sqlStatement.removeEventListener(SQLEvent.RESULT, setRulesArray);
			var sqlStatement:SQLStatement = event.target as SQLStatement;
			var result:SQLResult = sqlStatement.getResult();
			if( result == null ) return;
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
				_rulesArray.addItem(item);
			}
		}
	
	}
}