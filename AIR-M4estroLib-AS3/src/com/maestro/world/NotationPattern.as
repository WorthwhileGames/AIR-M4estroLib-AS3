﻿package com.maestro.world 
{
	import com.m4estro.vc.BaseMovieClip;
	import com.maestro.music.musicxml.Measure;
	import com.maestro.music.musicxml.Note;
	
	/**
	 * ...
	 * @author ...
	 */
	public class NotationPattern extends BaseMovieClip
	{
		private var patternImage:String;
		private var patternAudio:String;
		
		public var patternUnits:Array;
		
		public function NotationPattern() 
		{
			/*
			patternUnits = new Array();
			
			var totalBeats:int = 0
			while (totalBeats < 16)
			{
				
				var beatCount:int = Math.random() * 16  + 1;
				
				if ((totalBeats + beatCount) <= 16)
				{
					totalBeats += beatCount;
					patternUnits.push(beatCount);
				}
			}
			
			log("NotationPattern: patternUnits: " + patternUnits.toString(), "NoteTris");
			*/
		}
		
		public function initWithMeasure(measure:Measure):void
		{
			log("initWithMeasure: " + measure.number, "NoteTris");
			patternUnits = new Array();
			
			var divisionCount:int = 0;
			var totalDivisions:int = 0
			var prev_note:Note = null;
			var note:Note;
			
			for each (note in measure.notes)
			{
				log("note: start: " + note.duration, "NoteTris");
				//if (prev_event != null)
				//{
					//divisionCount = event.startTimeInBeats() - prev_event.startTimeInBeats();
					//Debug.log("beatCount: " + beatCount, "NoteTris");
					divisionCount += note.duration;
					patternUnits.push(note.duration);
				//}
				//prev_event = event;
			}
			
			if (divisionCount < 256)
			{
				patternUnits.push(256 - divisionCount);
			}
		}
		
		public function cleanup():void
		{
			patternUnits = null;
		}
	}
	
}