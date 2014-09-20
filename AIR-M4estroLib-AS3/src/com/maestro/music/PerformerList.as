package com.maestro.music 
{
	
	/**
	 * ...
	 * @author ...
	 */
	public class PerformerList 
	{
		private var __performers:Array;
		private var __currentPerformerIndex:int;
		
		public function PerformerList() 
		{
			__performers = new Array();
			__currentPerformerIndex = 0;
		}
		
		public function addPerformer(performer:Performer):void
		{
			
			__performers.push(performer);
		}
		
		public function get performers():Array
		{
			return __performers;
		}
		
		public function get currentPerformer():Performer 
		{
			return __performers[__currentPerformerIndex];
		}
		
		public function getPerformerWithIndex(i:int):Performer
		{
			if ((i >= 0) && (i < __performers.length))
			{
				__currentPerformerIndex = i;	
			}
			return __performers[__currentPerformerIndex];
		}
		
		public function get nextPerformer():Performer
		{
			return getPerformerWithIndex(__currentPerformerIndex + 1);
		}
		
		public function get prevPerformer():Performer
		{
			return getPerformerWithIndex(__currentPerformerIndex - 1);
		}
	}
}