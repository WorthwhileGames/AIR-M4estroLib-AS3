package com.maestro.music.musicxml 
{
	import com.disney.util.Debug;
	import com.maestro.midi.MIDINoteMap;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Note
	{
		
		private static var stepMap:Array  = new Array("C", "C", "D", "E", "E", "F", "F", "G", "A", "A", "B", "B");
		private static var alterMap:Array = new Array(  0,   1,   0,  -1,   0,   0,   1,   0,  -1,   0,  -1,   0);
		
		private var __measure:Measure;
		private var __pitchStep:String;
		private var __pitchAlter:int;
		private var __pitchOctave:int;
		private var __duration:int;
		private var __voice:int;
		private var __type:String;
		private var __rest:Boolean;
		private var __chord:Boolean;
		private var __startTimeInDivisions:Number;
		
		public function Note(measure:Measure) 
		{
			__measure = measure;
			__rest = false;
			__chord = false;
			__pitchStep = "C";
			__pitchAlter = 0;
			__pitchOctave = 0;
			__duration = 0;
			__voice = 1;
			__type = "na";
			__startTimeInDivisions = 0;
		}
		
		public function initWithXML(xml:XML):void
		{
			//Debug.log("Note: initWithXML: \n" + xml, "maestro");
			
			var pitch:XML;
			var rest:XML;
			var chord:XML;
			
			pitch = xml.pitch[0];
			rest = xml.rest[0];
			chord = xml.chord[0];
			
			if (pitch)
			{
				__pitchStep = pitch.step[0].toString();
				var octave:String = pitch.octave[0].toString();
				__pitchOctave = int(octave);
				if (pitch.alter[0])
				{
					__pitchAlter = int(pitch.alter[0].toString());
				}
				//Debug.log("Note: pitch: " + __pitchStep + __pitchAlter + __pitchOctave, "maestro");
			}
			else if (rest)
			{
				__rest = true;
				//Debug.log("Note: rest: " + __rest, "maestro");
			}
			
			if (chord)
			{
				__chord = true;
				//Debug.log("Note: chord: " + __chord, "maestro");
			}
			var duration:String = xml.duration[0].toString();
			var voice:String = xml.voice[0].toString();
			
			__duration = int(duration);
			__voice = int(voice);
			
			__type = xml.type[0].toString();
			
			//Debug.log("Note: " + __duration + ", " + __pitchStep + __pitchAlter + __pitchOctave, "maestro");
		}
		
		public function get measure():Measure
		{
			return __measure;
		}
		
		public function get MIDINumber():int
		{
			var noteStep:int = MIDINoteMap.getNoteIndexWithName(__pitchStep);
			var MIDINumber:int = ((__pitchOctave + 1) * 12) + noteStep + __pitchAlter;
			
			//Debug.log("get MIDINumber: " + MIDINumber + ": " + noteStep + ", " + __pitchStep + ", " + __pitchAlter + ", " + __pitchOctave, "maestro");
			
			return MIDINumber;
		}
		
		public function set MIDINumber(i:int):void
		{
			var MIDIOctaveCount:int = Math.floor(i / 12.0);
			var noteStep:int = Math.floor(i - (12 * MIDIOctaveCount));
			
			//Debug.log("set MIDINumber: " + i + ", " + MIDIOctaveCount + ", " + noteStep, "maestro");
			
			__pitchStep = Note.stepMap[noteStep];
			__pitchAlter = Note.alterMap[noteStep];
			__pitchOctave = Math.floor(MIDIOctaveCount - 1);
			
			//Debug.log("set MIDINumber: " + __pitchStep + ", " + __pitchAlter + ", " + __pitchOctave, "maestro");
			
		}
		
		public function get duration():int
		{
			return __duration;
		}
		
		/*
		public function set duration(d:int):void
		{
			__duration = d;
			__measure.repositionNotes();
		}
		*/
		
		public function get durationInBeats():Number
		{
			var beatDuration:Number = Number(__measure.attributes.lengthInDivisions) / Number(__measure.attributes.beats);
			return Number(__duration) / beatDuration;
		}
		
		public function get rest():Boolean
		{
			return __rest;
		}
		
		public function get chord():Boolean
		{
			return __chord;
		}
		
		public function set chord(b:Boolean):void
		{
			__chord = b;
		}
		
		public function get type():String
		{
			return __type;
		}
		
		public function get startTimeInDivisions():Number
		{
			return __startTimeInDivisions;
		}
		
		public function set startTimeInDivisions(d:Number):void
		{
			__startTimeInDivisions = d;
		}
	}
}