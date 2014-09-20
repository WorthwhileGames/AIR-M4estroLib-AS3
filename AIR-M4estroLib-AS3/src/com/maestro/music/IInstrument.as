package com.maestro.music 
{
	import com.noteflight.standingwave3.elements.IAudioFilter;
	import com.noteflight.standingwave3.elements.IAudioSource;
	
	/**
	 * ...
	 * @author ...
	 */
	public interface IInstrument 
	{
		
		function addNotesFromXMLList(note_list:XMLList):void;
		
		function addNote(note:AbstractNote):void;
		
		function get id():String;
		
		function getSourceForNote(id:int, duration:Number, filtered:Boolean):IAudioSource;
		
		function setNoteFilter(filter:IAudioFilter):void;

	}
}