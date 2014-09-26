package com.maestro.music 
{

	
	
	/**
	 * ...
	 * @author ...
	 */
	public class DefaultAudioInstrument extends AudioInstrument
	{		
		public function DefaultAudioInstrument(inst_id:String, audio_tempo:Number, divisions:Number, file_offset:Number, url:String, note_list:XMLList)  
		{
			super(inst_id, audio_tempo, divisions, file_offset, url, note_list);	
		}
		
		override public function init():void
		{
			addNotesFromXMLList(__noteList);
		}

		override public function addNotesFromXMLList(note_list:XMLList):void
		{
			var item:XML;
			var note:DefaultAudioNote;
			
			for each (item in note_list)
			{
				var noteID:int = item.@id;
				var noteName:String = item.@name;
				var offset:Number = divisionsToMilliseconds(item.@offset);
				var lengthInMilliseconds:Number = divisionsToMilliseconds(item.@duration);
				
				note = new DefaultAudioNote(noteID, lengthInMilliseconds);
				
				addNote(note);
			}
		}
	}
}