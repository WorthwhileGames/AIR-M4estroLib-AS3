package com.maestro.music 
{
	import com.disney.util.Debug;
	import com.noteflight.standingwave3.elements.AudioDescriptor;
	import com.noteflight.standingwave3.elements.IAudioSource;
	import com.noteflight.standingwave3.elements.IRandomAccessSource;
	import com.noteflight.standingwave3.elements.Sample;
	import com.noteflight.standingwave3.filters.CacheFilter;
	import com.noteflight.standingwave3.sources.SineSource;
	import com.noteflight.standingwave3.sources.SoundSource;
	import flash.media.Sound;
	
	/**
	 * ...
	 * @author ...
	 */
	public class DefaultAudioNote extends AudioNote
	{
		private var __sineSource:CacheFilter;
		
		public function DefaultAudioNote(midi:int, _milliseconds:Number) 
		{
			super(midi, MusicManager.scientificNameWithIndex(midi), 0, _milliseconds, null);
			
			var toOffset:Number = millisecondsToSample(_milliseconds);
			var power:Number = ((midi - 69) / 12.0)
			var freq:Number = 440 * Math.pow(2, power);
			var s:SineSource = new SineSource(new AudioDescriptor(), 1, freq);
			__sineSource = new CacheFilter(s);
			
			sample = __sineSource.getSampleRange(0, toOffset);
			
			//Debug.log("DefaultAudioNote: " + id + ", " + freq + ", " + power, "NoteTris");
		}
		
		override public function millisecondsToSample(ms:Number):Number
		{
			var sampleOffset:Number = Math.floor((ms / 1000.0) * AudioDescriptor.RATE_44100);
			
			return sampleOffset;
		}
		
	}
}