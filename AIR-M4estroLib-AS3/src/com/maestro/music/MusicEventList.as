package com.maestro.music 
{
	
	/**
	 * ...
	 * @author ...
	 */
	public class MusicEventList 
	{
		private var __list:Array;
		
		public function MusicEventList() 
		{
			__list = new Array();
		}
		
		public function addEvent(event:MusicEvent):void
		{
			__list.push(event);
		}
		
		public function get events():Array
		{
			return __list;
		}
		
	}
	
}