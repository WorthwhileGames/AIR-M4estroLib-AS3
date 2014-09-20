package com.maestro.music 
{
	import com.noteflight.standingwave3.elements.IAudioSource;
	import flash.media.Sound;
	
	/**
	 * ...
	 * @author ...
	 */
	public class AbstractNote 
	{
		private var __id:int;
		
		
		public function AbstractNote(id:int) 
		{
			__id = id;
		}
		
		public function get id():int
		{
			return __id;
		}
	}
}