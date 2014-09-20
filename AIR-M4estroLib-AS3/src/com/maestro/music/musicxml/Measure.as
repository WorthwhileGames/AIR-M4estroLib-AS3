package com.maestro.music.musicxml 
{
	import com.disney.util.Debug;
	import com.maestro.music.MusicEvent;
	import com.maestro.music.MusicEventList;
	/**
	 * ...
	 * @author ...
	 */
	public class Measure
	{
		private var __part:Part;
		private var __number:int;
		private var __attributes:MeasureAttributes;
		private var __direction:MeasureDirection;
		private var __notes:Array;
		private var __notesXMLList:XMLList;
		
		public function Measure(_part:Part) 
		{
			__part = _part;
		}
		
		public function initWithXML(xml:XML):void
		{
			__number = xml.@number;
			
			var attributesXML:XML = xml.attributes[0];
			if (attributesXML.divisions[0])
			{
				__attributes = new MeasureAttributes();
				__attributes.initWithXML(attributesXML);
			}
			else
			{
				__attributes = null;
			}
			
			var directionXML:XML = xml.direction[0];
			if (directionXML && directionXML.sound[0])
			{
				__direction = new MeasureDirection();
				__direction.initWithXML(directionXML);
			}
			else
			{
				__direction = null;
			}
			
			__notes = new Array();
			__notesXMLList = xml.note;
			
			var note_xml:XML;
			var note:Note = null;
			var prevNote:Note = null;
			var startTimeInDivisions:int = 0;
			var chordDurationInDivisions:int = 0;
			var wasChord:Boolean = false;
			
			for each (note_xml in __notesXMLList)
			{
				note = new Note(this);
				note.initWithXML(note_xml);
				
				if (!prevNote)
				{
					note.startTimeInDivisions = startTimeInDivisions;
					startTimeInDivisions += note.duration;
				}
				else if (note.chord)
				{
					chordDurationInDivisions = Math.max(chordDurationInDivisions, note.duration);
					
					if (wasChord)
					{
						//Chord Continue
					}
					else  //chord start
					{
						wasChord = true;
					}
					
					note.startTimeInDivisions = prevNote.startTimeInDivisions;
				}
				else
				{
					if (wasChord)  //chord end
					{
						startTimeInDivisions = prevNote.startTimeInDivisions + chordDurationInDivisions;
						chordDurationInDivisions = note.duration;
						wasChord = false;
					}
					
					note.startTimeInDivisions = startTimeInDivisions;
					startTimeInDivisions += note.duration;
				}

				__notes.push(note);
				prevNote = note;
			}
		}
		
		public function getMusicEventList(tempo_scale:Number, start_time:Number):MusicEventList
		{
			
			var mel:MusicEventList = new MusicEventList();
			var note:Note;
			//var startTimeInDivisions:int = 0;

			var scaledMeasureTime:Number = measureTime / tempo_scale;
			var timePerDivision:Number = scaledMeasureTime / attributes.lengthInDivisions;

			//Debug.log("MusicEvent: measure" + __number + ": " + measureTime + ", " + scaledMeasureTime+ ", " + timePerDivision, "maestro");

			for each(note in __notes)
			{
				var startTimeInSeconds:Number = start_time + (note.startTimeInDivisions * timePerDivision);
				var durationTimeInSeconds:Number = note.duration * timePerDivision;
				
				//Debug.log("MusicEvent: " +  note.MIDINumber + ", " + note.duration + ", " + startTimeInSeconds + ", " + durationTimeInSeconds, "maestro");
				if (!note.rest)
				{
					var musicEvent:MusicEvent = new MusicEvent("note", note.MIDINumber , startTimeInSeconds, durationTimeInSeconds);
					mel.addEvent(musicEvent);
				}

				//startTimeInDivisions += note.duration;
				//TODO implement back-up
			}

			return mel;
		}
		
		public function repositionNotes():void
		{
			//TODO
			Debug.log("repositionNotes", "MEASURE");
		}
		
		public function get part():Part 
		{
			return __part;
		}
		
		public function get notes():Array
		{
			return __notes;
		}
		
		public function get attributes():MeasureAttributes 
		{
			return __attributes;
		}
		
		public function set attributes(a:MeasureAttributes):void
		{
			__attributes = a;
		}
		
		public function get direction():MeasureDirection 
		{
			return __direction;
		}
		
		public function set direction(d:MeasureDirection):void
		{
			__direction = d;
		}
		
		public function get number():int 
		{
			return __number;
		}
		
		public function get measureTime():Number
		{
			var secondsPerBeat:Number = 1 / (direction.soundTempo / 60);
			
			return (attributes.beats * secondsPerBeat);
		}
	}

}