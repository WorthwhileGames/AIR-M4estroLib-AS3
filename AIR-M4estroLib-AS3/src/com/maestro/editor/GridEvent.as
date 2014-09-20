package com.maestro.editor 
{
	import adobe.utils.CustomActions;
	import com.disney.util.Debug;
	import com.m4estro.ui.editor.GridEventMC;
	import com.noteflight.standingwave3.elements.Sample;
	import com.noteflight.standingwave3.output.AudioPlayer;
	import com.maestro.controller.AudioInstrumentController;
	import com.maestro.music.AudioInstrument;
	import com.maestro.music.AudioNote;
	import com.maestro.music.MusicManager;
	import com.maestro.music.musicxml.Note;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GridEvent
	{
		private var __eventGrid:EventGrid;
		private var __gridMeasure:GridMeasure;
		private var __gridPart:GridPart;
		private var __note:Note;
		private var __eventClipWidth:Number;
		private var __startTimeInDivisions:int;
		
		public var eventClip:GridEventMC;
		
		public function GridEvent(grid:EventGrid, grid_measure:GridMeasure, grid_part:GridPart, note:Note) 
		{
			__eventGrid = grid;
			__gridMeasure = grid_measure;
			__gridPart = grid_part;
			__note = note;
			
			//Debug.log("GridEvent: constructor: " + __note.MIDINumber, "NoteTris");
		}
		
		public function show():void
		{
			if (eventClip == null)
			{
				eventClip = __eventGrid.getGridEventClip(__note);
				
				__eventGrid.eventGridMC.addChild(eventClip);
				
				//eventClip.addEventListener(MouseEvent.MOUSE_UP, onMouse);
				//eventClip.addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
				eventClip.nameText.addEventListener(MouseEvent.MOUSE_UP, onMouse);
				eventClip.nameText.addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
			}
			
			eventClip.visible = true;

			positionClip();
			updateEventWidth();
		}
		
		public function hide():void
		{
			eventClip.visible = false;
		}
		
		public function clear():void
		{
			if (eventClip)
			{
				eventClip.nameText.removeEventListener(MouseEvent.MOUSE_UP, onMouse);
				eventClip.nameText.removeEventListener(MouseEvent.MOUSE_DOWN, onMouse);
				__eventGrid.eventGridMC.removeChild(eventClip);
			}
		}
		
		private function positionClip():void
		{
			var instrumentID:String = __note.measure.part.instrumentName;
			var instrument:AudioInstrument = MusicManager.instance.getAudioInstrumentWithID(instrumentID);
			var note:AudioNote = instrument.getAudioNoteWithID(__note.MIDINumber);
			
			eventClip.noteName = note.noteName;
			
			eventClip.x = (__gridMeasure.startX + (__startTimeInDivisions / __gridMeasure.measure.attributes.lengthInDivisions) * __gridMeasure.widthInPixels) * __eventGrid.gridScaleHoriz;
			
			var yPos:Number = __eventGrid.GRID_UNIT_HEIGHT * 2 - __eventGrid.GRID_NOTE_HEIGTH + __eventGrid.GRID_TOP_BAR_HEIGHT;
			yPos -= ((__note.MIDINumber - 60) * __eventGrid.GRID_NOTE_HEIGTH);
			eventClip.y = yPos;
			//Debug.log("positionClip: " +__note.MIDINumber + ", " + yPos + ", " + eventClip.y, "NoteTris");
		}
		
		private function adjustPitch():void
		{
			var midi_number:Number = 48 + (36 - ((eventClip.y + 5 - __eventGrid.GRID_TOP_BAR_HEIGHT) / Number(__eventGrid.GRID_NOTE_HEIGTH)));
			//var start:int = (eventClip.x + 5) / __eventGrid.GRID_BEAT_WIDTH;
			midi_number = Math.floor(midi_number);
			Debug.log("adjustPitch: " + eventClip.y + ", " + midi_number, "NoteTris");
			
			__note.MIDINumber = midi_number;
			//__note.start = start;
		}
		
		public function onMouse(event:Event):void 
		{
			//var clip:MovieClip = MovieClip(event.target);
			
			if (event.type == MouseEvent.MOUSE_DOWN)
			{
				eventClip.startDrag();
			}
			else if (event.type == MouseEvent.MOUSE_UP)
			{
				eventClip.stopDrag();
				adjustPitch();
				positionClip();
				
				//TODO: make repositionNotes work
				__gridMeasure.measure.repositionNotes();
				
				play();
			}
		}
		
		public function play():void
		{
			var instrumentID:String = __gridPart.part.instrumentName;
			var instrument:AudioInstrument = MusicManager.instance.getAudioInstrumentWithID(instrumentID);
			var note:AudioNote = instrument.getAudioNoteWithID(__note.MIDINumber);
			var noteSample:Sample = note.sample;
			
			eventClip.noteName = note.noteName;
			
			var player:AudioPlayer = new AudioPlayer();
			player.play(noteSample);			
		}
		
		public function updateEventWidth():void
		{
			var instrumentID:String = __gridPart.part.instrumentName;
			var instrument:AudioInstrument = MusicManager.instance.getAudioInstrumentWithID(instrumentID);
			var note:AudioNote = instrument.getAudioNoteWithID(__note.MIDINumber);
			
			//__note.duration = 64; // note.beats;
			__eventClipWidth = (__eventGrid.GRID_BEAT_WIDTH * __note.durationInBeats) * __eventGrid.gridScaleHoriz;
			eventClip.bg.width = __eventClipWidth;
			eventClip.scrollRect = new Rectangle(0, 0, __eventClipWidth, __eventGrid.GRID_UNIT_HEIGHT);
		}
		
		public function get startTimeInDivisions():int
		{
			return __startTimeInDivisions;
		}
		
		public function set startTimeInDivisions(i:int):void
		{
			__startTimeInDivisions = i;
		}
		
		public function get note():Note
		{
			return __note;
		}
	}

}