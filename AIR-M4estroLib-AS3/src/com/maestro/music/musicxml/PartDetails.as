package com.maestro.music.musicxml 
{
	import com.disney.util.Debug;
	/**
	 * ...
	 * @author ...
	 */
	public class PartDetails
	{
		private var __id:String;
		private var __index:int;
		private var __name:String;
		private var __abbreviation:String;
		private var __instrumentId:String;
		private var __instrumentName:String;
		private var __midiInstrumentID:String;
		private var __midiChannel:int;
		private var __midiProgram:int;
		
		public function PartDetails() 
		{

		}
		
		public function initWithXML(xml:XML):void
		{
			//Debug.log("Part: initWithXML: \n" + xml, "maestro");
			
			__id = xml.@id;
			__name = xml.elements("part-name")[0].toString();
			__abbreviation = xml.elements("part-abbreviation")[0].toString();
			
			var score_instrument:XML = xml.elements("score-instrument")[0];
			__instrumentId = score_instrument.@id;
			__instrumentName = score_instrument.elements("instrument-name")[0].toString();
			
			var midi_instrument:XML = xml.elements("midi-instrument")[0];
			__midiInstrumentID = midi_instrument.@id;
			__midiChannel = int(midi_instrument.elements("midi-channel")[0].toString());
			__midiProgram = int(midi_instrument.elements("midi-program")[0].toString());

		}
		
		public function get index():int
		{
			return __index;
		}
		
		public function set index(i:int):void
		{
			__index = i;
		}
		
		public function get id():String
		{
			return __id;
		}
		
		public function get name():String
		{
			return __name;
		}
		
		public function get instrumentName():String
		{
			return __instrumentName;
		}
		
		public function set instrumentName(name:String):void 
		{
			__instrumentName = name;
		}
	}

}