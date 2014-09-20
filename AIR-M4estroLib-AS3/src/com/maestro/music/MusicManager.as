package com.maestro.music 
{
	import com.disney.base.BaseEventDispatcher;
	import com.disney.loaders.*;
	//import com.disney.trumpet3d.objects.skeletal.SkeletalAnimation;
	import com.disney.util.Debug;
	//import com.noteflight.standingwave3.performance.QueuePerformance;
	import com.maestro.midi.MIDINoteMap;
	import com.maestro.music.musicxml.Measure;
	import com.maestro.music.musicxml.Part;
	import flash.display.Loader;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	
	import flash.events.Event;
	
	import com.noteflight.standingwave3.elements.AudioDescriptor;
	import com.noteflight.standingwave3.elements.IAudioSource;
	import com.noteflight.standingwave3.output.AudioPlayer;
	import com.noteflight.standingwave3.performance.AudioPerformer;
	import com.noteflight.standingwave3.performance.ListPerformance;
	import com.noteflight.standingwave3.sources.SoundSource;
	
	import com.maestro.controller.AudioInstrumentController;
	import com.maestro.music.AudioInstrument;
	import com.maestro.music.DefaultAudioInstrument;
	import com.maestro.music.InstrumentGroup;
	import com.maestro.music.MusicEvent;
	import com.maestro.music.MusicEventList;
	import com.maestro.music.song.Soundtrack;
	import com.maestro.music.song.Section;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MusicManager extends BaseEventDispatcher
	{
		
		public static const INSTRUMENT_CONFIG_LOADED:String = "INSTRUMENT_CONFIG_LOADED";
		public static const SONG_LOADED:String = "SONG_LOADED";
		public static const noteNameArray:Array = new Array("C", "C#", "D", "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B");
		
		private static const defaultInstrumentDependency:Class = DefaultAudioInstrument;
		
		private static var __instance:MusicManager;
		
		private var __assetPath:String;
		private var __instrumentGroup:InstrumentGroup;
		//private var __performance:ListPerformance;
		private var __queue:ListPerformance;
		private var __playing:Boolean;
		
		private var __currentSoundtrack:Soundtrack;
		private var __currentSectionIndex:int;
		
		private var __performers:Array;
		private var __currentPerformerIndex:int;
		private var __performerList:PerformerList;
		
		private var __listPerformer:AudioPerformer;
		private var __queuePerformer:AudioPerformer;
		private var __player:AudioPlayer;
		private var __playerStartTime:Number;
		
		private var __fileRef:FileReference= new FileReference();
		
		public function MusicManager()
		{
			MIDINoteMap.init();
		}
		
		public static function scientificNameWithIndex(index:int):String
		{
			var nameIndex:int = index % 12;
			var nameOctave:int = (index / 12) - 1;
			
			return String(noteNameArray[nameIndex]) + nameOctave;
		}
		
		public static function MIDINameWithIndex(index:int):String
		{
			var nameIndex:int = index % 12;
			var nameOctave:int = (index / 12) - 2;
			
			return String(noteNameArray[nameIndex]) + nameOctave;
		}
		
		public static function get instance():MusicManager
		{
			if (__instance == null)
			{
				__instance = new MusicManager();
			}
			
			return __instance;
		}
		
		public function init(assetPath:String):void 
		{
			__assetPath = assetPath;
		}
		
		public function loadInstruments(instrumentConfigURL:String):void
		{
			trace("MusicManager:loadInstruments: " + instrumentConfigURL);
			XMLLoader.instance.load(instrumentConfigURL, onInstrumentConfigLoaded);
		}
		
		public function loadSoundtrack(soundtrackURL:String):void
		{
			trace("MusicManager:loadSoundtrack: " + soundtrackURL);
			XMLLoader.instance.load(soundtrackURL, onSoundtrackLoaded);
		}
		
		public function get playing():Boolean
		{
			return __playing
		}
		
		private function onInstrumentConfigLoaded(xml:XML):void
        {
			trace("MusicManager:onInstrumentConfigLoaded: ");

			//trace("xml.@id: " + xml.@id);
			__instrumentGroup = new InstrumentGroup(xml.@id);

			var instruments:XMLList = xml.instruments.children();
			
			var item:XML;
			var instrument:AudioInstrument;
			
            for each(item in instruments) {
                
				var id:String = item.@id;
				var tempo:Number = item.@tempo;
				var divisions:Number = item.@divisions;
				var file_offset:Number = item.@file_offset;
				var soundFileName:String = item.@soundFileName;
				var instrumentClass:Class = getDefinitionByName(item.@instrumentClass) as Class;
				var url:String = __assetPath + "instruments/" + soundFileName;
				var notes:XMLList = item.children();

				//trace(item.@id + ", " + item.@soundFileName + ", " + item.@instrumentClass + ", " + url); 
				instrument = new instrumentClass(id, tempo, divisions, file_offset, url, notes);
				instrument.init();

				__instrumentGroup.addInstrument(instrument);
            }
			
			dispatchEvent(new Event(MusicManager.INSTRUMENT_CONFIG_LOADED));
		}
		
		public function initializeInstrumentController(controller:AudioInstrumentController, instrumentID:String):void
		{
			controller.init(__instrumentGroup.getInstrumentWithID(instrumentID));
		}
		
		private function onSoundtrackLoaded(xml:XML):void
        {
			var soundtrack:Soundtrack = new Soundtrack(xml);
			
			__currentSoundtrack = soundtrack;
			
			Debug.log("onSoundtrackLoaded: " + soundtrack.id, "MusicManager");

			dispatchEvent(new Event(MusicManager.SONG_LOADED));
		}
		
		public function saveSoundtrackFile():void
		{
			__fileRef.save(__currentSoundtrack.xml, __currentSoundtrack.id + ".xml");
		}
		
		public function loadSoundtrackFile():void
		{
			__fileRef.browse([new FileFilter("Soundtracks", "*.xml")]);
			__fileRef.addEventListener(Event.SELECT, onFileSelected);
		}
		
		public function onFileSelected(evt:Event):void{
			__fileRef.addEventListener(Event.COMPLETE, onFileLoaded);
			__fileRef.load();
			__fileRef.removeEventListener(Event.SELECT, onFileSelected);
		}
		
		public function onFileLoaded(evt:Event):void {
			
			//var loader:Loader = new Loader();
			//loader.loadBytes(evt.target.data);
			Debug.log("onFileLoaded: ", "MusicManager");
			onSoundtrackLoaded(XML(evt.target.data));
			__fileRef.removeEventListener(Event.COMPLETE, onFileLoaded);
		}

		public function playSoundtrack(tempo_scale:Number):void
		{
			trace("playSoundtrack", "NoteTris");
			
			var section:Section = __currentSoundtrack.getSectionWithIndex(__currentSectionIndex);
			var parts:Array = section.parts;
			var part:Part;
			var listPerformance:ListPerformance = new ListPerformance();
			
			for each (part in parts)
			{
				var measure:Measure;
				
				var measureStartTime:Number = 0;
				for each (measure in part.measures)
				{
					//trace("InstrumentName: " + part.instrumentName, "maestro");
					__instrumentGroup.addEventsToPerformanceWithInstrument(measure.getMusicEventList(tempo_scale, measureStartTime), listPerformance, AudioInstrument(__instrumentGroup.getInstrumentWithID(part.instrumentName)));
					measureStartTime += (measure.measureTime / tempo_scale);
				}
			}
						
			__player = new AudioPlayer();
			__listPerformer = new AudioPerformer(listPerformance, new AudioDescriptor(44100, 2));
			
			__player.play(__listPerformer);
			__player.addEventListener(Event.COMPLETE, playerDone);
			__playing = true;
			__playerStartTime = getTimer();
		}
		
		public function queueSoundtrackMeasures(tempo_scale:Number):void
		{
			trace("playSoundtrack", "NoteTris");
		
			var section:Section = __currentSoundtrack.getSectionWithIndex(__currentSectionIndex);
			var parts:Array = section.score.parts;
			var part:Part;
			var measureCount:int = section.score.measureCount;
			
			__performerList = new PerformerList();

			var i:int;
			for (i = 0; i < measureCount; i++)
			{
				var listPerformance:ListPerformance = new ListPerformance();
				
				for each (part in parts)
				{
					var measure:Measure = part.measures[i];
					
					var measureStartTime:Number = 0;
					//for each (measure in part.measures)
					//{
						
						
						__instrumentGroup.addEventsToPerformanceWithInstrument(measure.getMusicEventList(tempo_scale, measureStartTime), listPerformance, AudioInstrument(__instrumentGroup.getInstrumentWithID(part.instrumentName)), true);
						//measureStartTime += (measure.measureTime / tempo_scale);
					//}
				}
				var performer:Performer = new Performer(new AudioPerformer(listPerformance, new AudioDescriptor(44100, 2)), section, section.score, measureCount);
				__performerList.addPerformer(performer);
			}
						
			__player = new AudioPlayer();
			//var listPerformer:AudioPerformer = AudioPerformer(__performers[__currentPerformerIndex]);
			
			__queue = new ListPerformance();
			__queue.addSourceAt(__queue.frameCount, __performerList.currentPerformer.audioPerformer);
			__queuePerformer = new AudioPerformer(__queue, new AudioDescriptor(44100, 2));
			
			__player.play(__queuePerformer);
			//__player.play(listPerformer);
			__player.addEventListener(Event.COMPLETE, playerDone);
			__playing = true;
			__playerStartTime = getTimer();
		}
		
		public function playNextPerformer():void
		{
			__queue.addSourceAt(__queue.frameCount, __performerList.nextPerformer.audioPerformer);
			
		}
		
		public function playPerformer(performer:Performer):void
		{
			__queue.addSourceAt(__queue.frameCount, performer.audioPerformer);
		}
		
		public function playPerformerWithIndex(i:int):void
		{
			__queue.addSourceAt(__queue.frameCount, __performerList.getPerformerWithIndex(i).audioPerformer);
		}
		
		public function get performerList():PerformerList
		{
			return __performerList;
		}
		
		public function stopPlayer():void 
		{
			__player.stop();
			__playing = false;
		}
		
		public function playerDone(e:Event):void
		{
			trace("playerDone: looping", "NoteTris");
			__playing = false;
		}
		
		public function set currentSectionIndex(index:int):void
		{
			__currentSectionIndex = index;
		}
		
		public function get currentSoundtrack():Soundtrack
		{
			return __currentSoundtrack;
		}
		
		public function getAudioInstrumentWithID(id:String):AudioInstrument
		{
			return AudioInstrument(__instrumentGroup.getInstrumentWithID(id))
		}
		
		public function get player():AudioPlayer
		{
			return __player;
		}
		
		public function get playerStartTime():Number
		{
			return __playerStartTime;
		}
		
		public function get listPerformer():AudioPerformer
		{
			return __listPerformer;
		}
	}
}