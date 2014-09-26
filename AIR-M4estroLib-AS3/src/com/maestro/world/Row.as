package com.maestro.world 
{
	import com.m4estro.vc.BaseMovieClip;
	import com.maestro.music.musicxml.Measure;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Row extends BaseMovieClip
	{
		private var meter:Number;
		private var tempo:Number;
		private var notationPattern:NotationPattern;
		
		
		public function Row() 
		{
			notationPattern = new NotationPattern();
		}
		
		public function initWithMeasure(measure:Measure):void
		{
			notationPattern.initWithMeasure(measure);
		}
		
		public function units():Array 
		{
			return notationPattern.patternUnits;
		}
		
		public function cleanup():void
		{
			notationPattern.cleanup();
			notationPattern = null;
		}
	}
	
}