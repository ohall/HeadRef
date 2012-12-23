package model{
	import mx.collections.ArrayCollection;

	public class HeadRefModel{
		
		[Bindable]
		public var teams:ArrayCollection = new ArrayCollection();
		[Bindable]
		public var leagues:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		public var gameModel:GameModel = new GameModel();
		
		
	
		
		public function HeadRefModel(){}
	
	}
}