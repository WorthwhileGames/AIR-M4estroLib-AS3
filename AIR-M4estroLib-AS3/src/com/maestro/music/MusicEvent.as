package com.maestro.music 
{
	
	/**
	 * ...
	 * @author ...
	 */
	public class MusicEvent 
	{
		
		private var __type:String;
		private var __pitch:int;
		private var __startTime:Number;
		private var __duration:Number;
		
		
		public function MusicEvent(event_type:String, pitch:int, start:Number, dur:Number) 
		{
			__type = event_type;
			__pitch = pitch;
			__startTime = start;
			__duration = dur;
		}
		
		public function get type():String
		{
			return __type;
		}
		
		public function get pitch():int
		{
			return __pitch;
		}
		
		public function get startTime():Number
		{
			return __startTime;
		}
		
		public function get duration():Number
		{
			return __duration;
		}
	}
	
}