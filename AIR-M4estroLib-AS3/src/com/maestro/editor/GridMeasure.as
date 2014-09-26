package com.maestro.editor 
{
	import com.maestro.music.musicxml.Measure;
	import com.maestro.music.musicxml.Note;
	
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author ...
	 */
	public class GridMeasure
	{
		private var __partIndex:int;
		private var __eventGrid:EventGrid;
		private var __gridPart:GridPart;
		private var __measure:Measure;
		private var __events:Array;
		private var __widthInPixels:Number;
		private var __startX:Number;
		private var __measureLineClip:MovieClip;
		
		public function GridMeasure(grid:EventGrid, grid_part:GridPart, _measure:Measure) 
		{
			__eventGrid = grid;
			__gridPart = grid_part;
			__measure = _measure;
			__partIndex = __measure.part.index;
			
			//Debug.log("GridMeasure: constructor: " + __measure.part.partName + ":" + __measure.number, "NoteTris");
			
			__events = new Array();
			
			addGridEvents();
		}
		
		private function addGridEvents():void
		{
			var note:Note;
			var prevNote:Note = null;
			var startTimeInDivisions:int = 0;
			var chordDurationInDivisions:int = 0;
			var wasChord:Boolean = false;
			
			for each(note in __measure.notes)
			{
				/*
				if (note.chord)
				{
					chordDurationInDivisions = Math.max(chordDurationInDivisions, note.duration);
					
					if (wasChord)
					{
						//Chord Continue
					}
					else
					{
						Debug.log("ChordStart: " + startTimeInDivisions, "Maestro");
						wasChord = true;
					}
				}
				else
				{
					if (wasChord)
					{
						Debug.log("ChordEnd: " + startTimeInDivisions, "Maestro");
						startTimeInDivisions += chordDurationInDivisions;
						chordDurationInDivisions = note.duration;
						wasChord = false;
					}
					startTimeInDivisions += note.duration;
				}
				
				if (note.chord)
				{
					Debug.log("Chord: " + note.type + ", " + note.duration + ", " + note.rest, "Maestro");
				}
				else
				{
					Debug.log("Solo: " + note.type + ", " + note.duration + ", " + note.rest, "Maestro");
				}
				*/
				
				var gEvent:GridEvent = new GridEvent(__eventGrid, this, __gridPart, note);
				gEvent.startTimeInDivisions = note.startTimeInDivisions;
				
				__events.push(gEvent);
				prevNote = note;
			}
		}
		
		public function clearEvents():void
		{
			if (__events.length > 0)
			{
				var event:GridEvent;
				for each (event in __events)
				{
					event.clear();
				}
			}
			
			__events = new Array();
		}
		
		public function addNote(pitch:int, beat:int, duration:Number):void
		{
			//TODO
			/*
			//add TrackEvent to Song
			var noteXML:XML = <event type={"note"} start={beat} pitch={pitch} duration={duration} />;
			var event:TrackEvent = new TrackEvent(noteXML);
			event.trackIndex = __partIndex;
			__part.addTrackEvent(event);
			//add GridEvent to GridTrack
			var gEvent:GridEvent = new GridEvent(__eventGrid, this, event);
			gEvent.show();
			gEvent.play();
			__events.push(gEvent);
			*/
		}
		
		public function show():void
		{
			
			if (__measureLineClip == null)
			{
				__measureLineClip = new MovieClip();
				__eventGrid.eventGridMC.addChild(__measureLineClip);
				__measureLineClip.x = __startX;
				__measureLineClip.graphics.moveTo(0, __eventGrid.GRID_TOP_BAR_HEIGHT);
				__measureLineClip.graphics.lineStyle(1, 0x666688);
				__measureLineClip.graphics.lineTo(0, __eventGrid.eventGridMC.height);
			}
			
			__measureLineClip.visible = true;
			__measureLineClip.x = __startX * __eventGrid.gridScaleHoriz;
			
			var event:GridEvent;
			
			for each(event in __events)
			{
				if (!event.note.rest)
				{
					event.show();
				}
			}
		}
		
		public function hide():void
		{
			if (__measureLineClip != null)
			{
				__measureLineClip.visible = false;
			}
			
			var event:GridEvent;
			
			for each(event in __events)
			{
				if (!event.note.rest)
				{
					event.hide();
				}
			}
		}
		
		public function get partIndex():int
		{
			return __partIndex;
		}
		
		public function get measure():Measure
		{
			return __measure;
		}
		
		public function get instrumentID():String
		{
			return __measure.part.instrumentName;
		}
		
		public function get startX():Number
		{
			return __startX;
		}
		
		public function set startX(n:Number):void
		{
			__startX = n;
		}
		
		public function get widthInPixels():Number
		{
			return __widthInPixels;
		}
		
		public function set widthInPixels(n:Number):void
		{
			__widthInPixels = n;
		}
	}
}