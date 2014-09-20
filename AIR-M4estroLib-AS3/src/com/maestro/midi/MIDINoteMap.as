package com.maestro.midi 
{
	import com.disney.util.Debug;
	import com.noteflight.standingwave3.output.AudioSampleHandler;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MIDINoteMap 
	{
		public static const NOTE_COUNT:int = 128;
		public static const SCALE_STEPS:int = 12;
		public static const NOTE_NAMES:Array = new Array("C", "C#", "D", "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B");
		public static const MIDI_OCTAVE_START:int = -2;  //Pro Tools and DP use A3 as note 69
		public static const STEP_MAP:Array = new Array(0, 0, 2, 4, 5, 7, 9, 11, 12, 14, 16, 17, 19, 21, 22, 23);  //1-indexed

		
		public static var notes:Array;
		public static var noteHash:Object;
		
		public static function init():void
		{
			var i:int;
			var name_index:int;
			var octave:int;
			
			var note_array:Array = new Array();
			
			for (i = 0; i < NOTE_COUNT; i++)
			{
				name_index = i % 12;
				octave = Math.floor(i / 12) + MIDI_OCTAVE_START;
				
				note_array[i] = String(NOTE_NAMES[name_index]) + octave;
			}
			
			notes = note_array;
			
			noteHash = new Object();
			
			for (i = 0; i < NOTE_COUNT; i++)
			{
				noteHash[String(NOTE_NAMES[i])] = i;
			}
			
			//for (i = 0; i < NOTE_COUNT; i++)
			//{
			//	Debug.log(i + ": " + notes[i], "DataTool");
			//}
		}
		
		public static function getNoteNameWithIndex(index:int):String
		{
			return notes[index];
		}
		
		public static function getNoteIndexWithName(name:String):int
		{
			return noteHash[name];
		}
	}
}