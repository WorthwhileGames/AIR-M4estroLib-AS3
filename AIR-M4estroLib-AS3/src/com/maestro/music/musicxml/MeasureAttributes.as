package com.maestro.music.musicxml 
{
	
	/**
	 * ...
	 * @author ...
	 */
	public class MeasureAttributes
	{
		private var __divisions:int;
		private var __keyFifths:int;
		private var __keyMode:String;

		private var __timeBeats:int;
		private var __timeBeatType:int;

		private var __clefNumber:Number;
		private var __clefSign:String;
		private var __clefLine:Number;

		public function MeasureAttributes() 
		{
				__divisions = 0;
				__keyFifths = 0;
				__keyMode = "na";

				__timeBeats = 0;
				__timeBeatType = 0;

				__clefNumber = 0;
				__clefSign = "na";
				__clefLine = 0;
		}
		
		public function initWithXML(xml:XML):void
		{
			//Debug.log("MeasureAttributes: \n" + xml, "maestro");
			
			if (xml.divisions[0])
			{
				var divisions:String = xml.divisions[0].toString();
				__divisions = int(divisions);
				var fifths:String = xml.key[0].fifths[0].toString();
				__keyFifths = int(fifths);
				
				__keyMode = xml.key[0].mode[0].toString();

				var time:XML = xml.time[0];
				var beat_type:XML = time.elements("beat-type")[0];
				var beats:String = time.beats[0].toString();
				__timeBeats = int(beats);
				__timeBeatType = int(beat_type.toString());

				__clefNumber = xml.clef[0].@number;
				__clefSign = xml.clef[0].sign[0].toString();
				var clef_line:String = xml.clef[0].line[0].toString();
				__clefLine = int(clef_line);
				//Debug.log("MeasureAttributes: divisions: " + __divisions, "maestro");
			}
		}
		
		public function get beats():int
		{
			return __timeBeats;
		}
		
		public function get beatType():int
		{
			return __timeBeatType;
		}
		
		public function get lengthInDivisions():int
		{
			return __divisions * __timeBeats * (4.0 / __timeBeatType);
		}
	}
}