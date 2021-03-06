package model{
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	import mx.collections.ArrayCollection;
	
	public class HeadRefModel{
		
		[Bindable]
		public var teams:ArrayCollection = new ArrayCollection();
		[Bindable]
		public var leagues:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		public var gameModel:GameModel = new GameModel();
		
		public var teamSelectedForEditing	: String = "";
		public var rulesSelectedForEditing	: String = "";
		public var homeOrAwayAdded			: String = "";
		
		public var undoStack:Array = new Array();		
		
		public function HeadRefModel(){}
	
		
		
	}
}