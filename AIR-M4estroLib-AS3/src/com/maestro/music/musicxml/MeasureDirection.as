package com.maestro.music.musicxml 
{
	import com.disney.util.Debug;
	/**
	 * ...
	 * @author ...
	 */
	public class MeasureDirection
	{
		private var __placement:String;
		private var __directionType:String;
		private var __metronomeBeatUnit:String;
		private var __metronomePerMinute:int;
		private var __soundTempo:Number;

		public function MeasureDirection() 
		{
			__placement = "na";
			__directionType = "na";
			__metronomeBeatUnit = "na";
			__metronomePerMinute = 120.0;
			__soundTempo = 120.0;
		}
		
		public function initWithXML(xml:XML):void
		{
			if (xml)
			{
				__placement = xml.@placement;
				
				var metronomeXML:XML = xml.elements("direction-type")[0].metronome[0];
				if (metronomeXML)
				{
					__directionType = "metronome";
					__metronomeBeatUnit = metronomeXML.elements("beat-unit")[0].toString;
					__metronomePerMinute = Number(metronomeXML.elements("per-minute")[0].toString);
				}

				__soundTempo = xml.sound.@tempo;
				Debug.log("MeasureDirection: __soundTempo: " + __soundTempo, "maestro");
			}
		}
		
		public function get soundTempo():Number
		{
			return __soundTempo;
		}
	}

}