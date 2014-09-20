package com.maestro.music 
{
	
	/**
	 * ...
	 * @author ...
	 */
	
	import com.disney.util.Debug;
	import com.noteflight.standingwave3.elements.Sample;
	import com.noteflight.standingwave3.performance.IPerformance;
	import com.noteflight.standingwave3.performance.ListPerformance;
	import com.noteflight.standingwave3.performance.PerformableAudioSource;
	 
	public class InstrumentGroup 
	{
		
		private var __id:String;
		private var __instruments:Object;

		public function InstrumentGroup(id:String) 
		{
			__id = id;
			__instruments = new Object();
		}
		
		public function addInstrument(instrument:AudioInstrument):void
		{
			__instruments[instrument.id] = instrument;
		}
		
		public function getInstrumentWithID(id:String):AudioInstrument
		{
			return AudioInstrument(__instruments[id]);
		}
		
		public function addEventsToPerformanceWithInstrument(list:MusicEventList, performance:ListPerformance, instrument:AudioInstrument, enforceNoteLength:Boolean = false):void
		{
			var event:MusicEvent;
			
			for each (event in list.events)
			{
				if (event.type == "note")
				{
					var note:AudioNote = instrument.getAudioNoteWithID(event.pitch);
					var noteSample:Sample;
					if (enforceNoteLength)
					{
						noteSample = note.getSampleRange(event.duration);
					}
					else
					{
						noteSample = note.sample;
					}
					
					var e:PerformableAudioSource = new PerformableAudioSource(event.startTime, noteSample);
					performance.addElement(e);
				}
			}
		}
	}
}