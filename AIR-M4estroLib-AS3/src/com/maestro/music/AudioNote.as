package com.maestro.music 
{
	import com.noteflight.standingwave3.elements.AudioDescriptor;
	import com.noteflight.standingwave3.elements.Sample;
	import com.noteflight.standingwave3.sources.SoundSource;
	
	/**
	 * ...
	 * @author ...
	 */
	public class AudioNote extends AbstractNote
	{
		private var __noteName:String;
		private var __offset:Number;
		private var __lengthInMilliseconds:Number;
		//private var __beats:Number;
		private var __instrumentSource:SoundSource;
		private var __noteSample:Sample;
		private var __clones:Array;
		
		public function AudioNote(note_id:int, note_name:String, offset:Number, _lengthInMilliseconds:Number, source:SoundSource) 
		{
			super(note_id);

			__noteName = note_name;
			__offset = offset;
			__lengthInMilliseconds = _lengthInMilliseconds;
			//__beats = _beats
			__instrumentSource = source;
			
			var fromOffset:Number = millisecondsToSample(__offset);
			var toOffset:Number = fromOffset + millisecondsToSample(__lengthInMilliseconds);
			
			
			if (__instrumentSource != null)
			{
				__noteSample = __instrumentSource.getSampleRange(fromOffset, toOffset);
			}
			__clones = new Array();
			
			//Debug.log("AudioNote: " + id + ", " + fromOffset + ", " + toOffset, "NoteTris");
		}
		
		public function millisecondsToSample(ms:Number):Number
		{
			var sampleOffset:Number = Math.floor((ms / 1000.0) * __instrumentSource.descriptor.rate);
			
			return sampleOffset;
		}
		
		public function get sample():Sample
		{
			var clone:Sample = Sample(__noteSample.clone());
			//__clones.push(clone);
			return clone;
		}
		
		public function getSampleRange(durationInSeconds:Number):Sample
		{
			var range:Sample = Sample(__noteSample.getSampleRange(0, durationInSeconds * AudioDescriptor.RATE_44100));
			//__clones.push(range);
			return range;
		}
		
		public function set sample(s:Sample):void
		{
			__noteSample = s;
		}
		
		public function isPlaying():Boolean
		{
			var is_playing:Boolean = false;
			var i:int;
			var clone_count:int = __clones.length;
			for (i = 0; i < __clones.length; i++)
			{
				var clone:Sample = Sample(__clones[i]);
				if ((clone.position > 0) && (clone.position < clone.frameCount))
				{
					is_playing = true;
					break;
				}
			}
			
			return is_playing;
		}
		
		public function get noteName():String
		{
			return __noteName;
		}
		
		public function get lengthInMilliseconds():Number
		{
			return __lengthInMilliseconds;
		}
		
		//public function get beats():Number
		//{
		//	return __beats;
		//}
	}
}