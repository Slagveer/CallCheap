package dao
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class Bedrijf
	{
		public var loaded:Boolean = false;
		
		public var id:int;
		public var naam:String;
		public var duur:String;
		public var goedkoop:String;
		public var datum:String;
		public var correct:Boolean;
		
		private var _bedrijf:Bedrijf;
		
		// Lazy loading of manager
		[Bindable(event="bedrijfChanged")]
		public function get bedrijf():Bedrijf
		{
			if (_bedrijf && !_bedrijf.loaded && _bedrijf.id > 0)
			{
				var bedrijfSrv:BedrijfDAO = new BedrijfDAO();
				_bedrijf = bedrijfSrv.getItem(_bedrijf.id);
			}
			return _bedrijf;
		}
		
		public function set bedrijf(__bedrijf:Bedrijf):void
		{
			_bedrijf = __bedrijf;
			dispatchEvent(new Event("bedrijfChanged"));
		}
		
		private var _directReports:ArrayCollection;
		private var directReportsLoaded:Boolean = false;
		
		// Lazy loading of the list of contacts
		[Bindable(event="bedrijvenChanged")]
		public function get directReports():ArrayCollection
		{
			if (!directReportsLoaded && id > 0)
			{
				var bedrijfSrv:BedrijfDAO = new BedrijfDAO();
				_directReports = bedrijfSrv.findByBedrijf(id);
				directReportsLoaded = true;
			}
			return _directReports;
		}
		
	}
}