package com.maestro.music 
{

	import com.m4estro.vc.Debug;
	import com.noteflight.standingwave3.sources.SoundSource;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author ...
	 */
	public class AudioInstrument extends AbstractInstrument
	{
		
		private var __audio:Sound;
		private var __source:SoundSource;
		private var __tempo:Number;
		private var __divisions:Number;
		private var __fileOffset:Number
		private var	__msPerDivision:Number;
		//private var __trackLengthInMilliseconds:int;
		private var __url:String;
		protected var __noteList:XMLList;
		private var __initialized:Boolean;
		
		
		public function AudioInstrument(inst_id:String, audio_tempo:Number, divisions:Number, _file_offsset:Number, url:String, note_list:XMLList)  
		{
			super(inst_id);
			
			__divisions = divisions;
			__fileOffset = _file_offsset * 1000.0;  //convert to milliseconds
			tempo = audio_tempo;
			//__trackLengthInMilliseconds = 0; // divisionsToMilliseconds(length_in_beats);
			
			__url = url;
			__noteList = note_list;
			__initialized = false;
			
			Debug.log("AudioInstrument: __url: " + __url, "NoteTris");	
		}
		
		public function init():void
		{
			trace("AudioInstrument: init: " + __url);
			if (!__initialized)
			{
				__initialized = true;
				__audio = new Sound(new URLRequest(__url));
				__audio.addEventListener(Event.COMPLETE, handleSoundComplete);
			}
		}
		
		public function handleSoundComplete(e:Event):void
		{
			__source = new SoundSource(e.target as Sound);

			//Debug.log("handleSoundComplete: " + id + ": " + e.target + ", " + __source, "NoteTris");
			addNotesFromXMLList(__noteList);
		}

		override public function addNotesFromXMLList(note_list:XMLList):void
		{
			var item:XML;
			var note:AudioNote;
			
			for each (item in note_list)
			{
				var noteID:int = item.@midi;
				var noteName:String = item.@name;
				var offset:Number = divisionsToMilliseconds(item.@offset);
				offset += __fileOffset;
				var lengthInMilliseconds:Number = divisionsToMilliseconds(item.@duration);
				
				//Debug.log("addNotesFromXMLList: offset: " + offset + ": " + lengthInMilliseconds, "NoteTris");
				
				note = new AudioNote(noteID, noteName, offset, lengthInMilliseconds, __source);
				
				addNote(note);
			}
		}
		
		public function getAudioNoteWithID(id:int):AudioNote
		{
			if (notes[id] == null)
			{
				var defaultNote:DefaultAudioNote = new DefaultAudioNote(id, divisionsToMilliseconds(1));
				addNote(defaultNote);
				
				return AudioNote(defaultNote);
			}
			else
			{
				return AudioNote(notes[id]);
			}
		}
		
		public function divisionsToMilliseconds(beats:Number):int 
		{
			return __msPerDivision * beats;
		}
		
		public function set tempo(audio_tempo:Number):void
		{
			
			__tempo = audio_tempo;
			__msPerDivision = (1 / (__tempo / 60)) * 1000 / __divisions;
			
			//Debug.log("Audio Tempo: " + __tempo + ", " + __msPerDivision, "NoteTris");
		}
	}
	
}