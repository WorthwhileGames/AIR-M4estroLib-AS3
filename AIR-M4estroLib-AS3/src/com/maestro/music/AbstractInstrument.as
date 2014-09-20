package com.maestro.music 
{

	import com.noteflight.standingwave3.elements.IAudioFilter;
	import com.noteflight.standingwave3.elements.IAudioSource;
	import flash.media.Sound;
	
	/**
	 * ...
	 * @author ...
	 */
	public class AbstractInstrument implements IInstrument
	{
		private var __id:String;
		private var __notes:Object;
		private var __filter:IAudioFilter;

		private var __controller:AbstractInstrumentController;
		
		
		public function AbstractInstrument(inst_id:String) 
		{
			__id = inst_id;
			__notes = new Object();
		}
		
		public function addNotesFromXMLList(note_list:XMLList):void
		{
			
			throw new Error("addNotesFromXMLList() not overridden");
		}
		
		public function addNote(note:AbstractNote):void
		{
			__notes[note.id] = note;
		}
	

		public function getSourceForNote(id:int, duration:Number, filtered:Boolean):IAudioSource
		{
			throw new Error("getSourceForNote() not overridden");
		}
		
		public function setNoteFilter(filter:IAudioFilter):void
		{
			__filter = filter;
		}
		
		public function get id():String
		{
			return __id;
		}
		
		public function get notes():Object
		{
			return __notes;
		}
	}
	
}