package dao
{
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.collections.ArrayCollection;
	
	public class BedrijfDAO
	{
		public function getItem(id:int):Bedrijf
		{
			var sql:String = "SELECT id, naam, duur, goedkoop, datum, correct FROM bedrijf WHERE id=?";
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sql;
			stmt.parameters[0] = id;
			stmt.execute();
			var result:Array = stmt.getResult().data;
			if (result && result.length == 1)
				return processRow(result[0]);
			else
				return null;
				
		}

		public function findByBedrijf(bedrijfId:int):ArrayCollection
		{
			var sql:String = "SELECT * FROM bedrijf WHERE id=? ORDER BY naam, duur, goedkoop";
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sql;
			stmt.parameters[0] = bedrijfId;
			stmt.execute();
			var result:Array = stmt.getResult().data;
			if (result)
			{
				var list:ArrayCollection = new ArrayCollection();
				for (var i:int=0; i<result.length; i++)
				{
					list.addItem(processRow(result[i]));	
				}
				return list;
			}
			else
			{
				return null;
			}
		}

		public function findByName(searchKey:String):ArrayCollection
		{
			
			
			 var sql:String = "SELECT * FROM bedrijf WHERE naam || ' ' || duur LIKE ? ORDER BY naam, duur";
			 var stmt:SQLStatement = new SQLStatement();
			 stmt.sqlConnection = sqlConnection;
			 stmt.text = sql;
			 stmt.parameters[0] = "%" + searchKey + "%";
			 stmt.execute();
			 
			 var result:Array = stmt.getResult().data;
			 if (result)
			 {
				 var list:ArrayCollection = new ArrayCollection();
				 for (var i:int=0; i<result.length; i++)
				 {
					 list.addItem(processRow(result[i]));	
				 }
				 return list;
			 }
			 else
			 {
				 return null;
			 }
		}

		public function create(bedrijf:Bedrijf):void
		{
			trace(bedrijf.naam);
			var sql:String = 
				"INSERT INTO bedrijf (id, naam, duur, goedkoop, datum, correct) " +
				"VALUES (?,?,?,?,?,?)";
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sql;
			stmt.parameters[0] = bedrijf.id;
			stmt.parameters[1] = bedrijf.naam;
			stmt.parameters[2] = bedrijf.duur;
			stmt.parameters[3] = bedrijf.goedkoop;
			stmt.parameters[4] = bedrijf.datum;
			stmt.parameters[5] = bedrijf.correct ? bedrijf.goedkoop : null;
			stmt.execute();
		}
		
		protected function processRow(o:Object):Bedrijf
		{
			var bedrijf:Bedrijf = new Bedrijf();
			bedrijf.id = o.id;
			bedrijf.naam = o.naam == null ? "" : o.naam;
			bedrijf.duur = o.duur == null ? "" : o.duur;
			bedrijf.goedkoop = o.goedkoop == null ? "" : o.goedkoop;
			bedrijf.datum = o.datum == null ? "" : o.datum;
			
			if (o.goedkoop != null)
			{
				bedrijf.correct = true;
			}
			
			return bedrijf;
		}
		public static var _sqlConnection:SQLConnection;
		
		public function get sqlConnection():SQLConnection
		{
			if (_sqlConnection) return _sqlConnection;
			var file:File = File.documentsDirectory.resolvePath("CallCheap.db");
			var fileExists:Boolean = file.exists;
			_sqlConnection = new SQLConnection();
			_sqlConnection.open(file);trace(fileExists);
			if (!fileExists)
			{
				createDatabase();
				populateDatabase();
			}
			return _sqlConnection;
		}
		
		protected function createDatabase():void
		{
			var sql:String = 
				"CREATE TABLE IF NOT EXISTS bedrijf ( "+
				"id INTEGER PRIMARY KEY AUTOINCREMENT, " +
				"naam VARCHAR(70), " +
				"duur VARCHAR(50), " +
				"goedkoop VARCHAR(50), " +
				"datum VARCHAR(50), " + 
				"correct BOOLEAN)";
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sql;
			stmt.execute();			
		}
		
		protected function populateDatabase():void
		{
			var file:File = File.applicationDirectory.resolvePath("assets/callcheap.xml");
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			var xml:XML = XML(stream.readUTFBytes(stream.bytesAvailable));
			stream.close();
			var bedrijfDAO:BedrijfDAO = new BedrijfDAO();
			for each (var bdr:XML in xml.Bedrijf)
			{
				var bedrijf:Bedrijf = new Bedrijf();
				bedrijf.id = bdr.id;
				bedrijf.naam = bdr.naam;
				bedrijf.duur = bdr.duur;
				bedrijf.goedkoop = bdr.goedkoop;
				bedrijf.datum = bdr.datum;
				bedrijf.correct = false;
				bedrijfDAO.create(bedrijf);
			}
		}

		
	}
}