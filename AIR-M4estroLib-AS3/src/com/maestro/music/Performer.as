package com.maestro.music 
{
	import com.maestro.music.musicxml.Measure;
	import com.maestro.music.musicxml.Part;
	import com.maestro.music.musicxml.Score;
	import com.maestro.music.song.Section;
	import com.noteflight.standingwave3.performance.AudioPerformer;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Performer 
	{
		private var __audioPerformer:AudioPerformer;
		private var __section:Section;
		private var __score:Score;
		private var __part:Part;
		private var __measureNum:int;
		
		private var __icon:BitmapData;
		
		
		public function Performer(_audioPerformer:AudioPerformer, _section:Section, _score:Score, _measureNum:int) 
		{
			__audioPerformer = _audioPerformer;
			__section = _section;
			__score = _score;
			//__part = _part;
			__measureNum = _measureNum;
		}
		
		public function get name():String
		{
			return "M" + __measureNum;
		}
		
		public function get audioPerformer():AudioPerformer
		{
			return __audioPerformer;
		}
	}
}