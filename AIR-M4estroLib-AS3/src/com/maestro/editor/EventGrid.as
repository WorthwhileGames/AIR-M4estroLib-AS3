package com.maestro.editor 
{
	import com.m4estro.ui.editor.EventGridMC;
	import com.m4estro.ui.editor.EventGridUnitMC;
	import com.m4estro.ui.editor.GridEventMC;
	import com.m4estro.vc.BaseObject;
	import com.m4estro.vc.Debug;
	import com.maestro.music.MusicManager;
	import com.maestro.music.musicxml.Note;
	import com.maestro.music.song.Section;
	import com.maestro.music.song.Soundtrack;
	import com.noteflight.standingwave3.performance.AudioPerformer;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundChannel;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class EventGrid extends BaseObject
	{
		
		public var GRID_UNIT_WIDTH:int;
		public var GRID_UNIT_HEIGHT:int;
		public var GRID_UNIT_COUNT_HORIZONTAL:int = 64;
		public var GRID_UNIT_COUNT_VERTICAL:int = 3;
		public var GRID_BEAT_WIDTH:int;
		public var GRID_NOTE_HEIGTH:int;
		public var GRID_TOP_BAR_HEIGHT:Number;
		
		public var eventGridMC:EventGridMC;
		
		private var __baseUnit:EventGridUnit;
		
		private var __editor:MIDIEditor;
		private var __sectionList:SectionList;
		private var __trackList:TrackList;
		
		private var __soundtrack:Soundtrack;
		private var __sections:Array;
		private var __currentGridSection:GridSection;
		
		private var __gridScaleHoriz:Number;
		private var __gridScaleVert:Number;
		private var __gridScrollHoriz:Number;
		private var __gridScrollVert:Number;
		private var __tempoScale:Number;
		private var __playHead:PlayHead;
		
		private var __topBarClip:MovieClip;
		
		public function EventGrid(event_grid_mc:EventGridMC) 
		{
			Debug.log("EventGridMC: " + event_grid_mc, "EventGrid");
			eventGridMC = event_grid_mc;
			__baseUnit = new EventGridUnit(eventGridMC.baseUnit);

			GRID_UNIT_WIDTH = __baseUnit.width;
			GRID_UNIT_HEIGHT = __baseUnit.height;
			GRID_BEAT_WIDTH = GRID_UNIT_WIDTH / 4;
			GRID_NOTE_HEIGTH = (GRID_UNIT_HEIGHT - 1) / 12;  //12 half steps starting at C
			GRID_TOP_BAR_HEIGHT = 30;
			
			__gridScaleHoriz = 1;
			__gridScaleVert = 1;
			__gridScrollHoriz = 1;
			__gridScrollVert = 1;
			
			eventGridMC.scrollRect = new Rectangle(0, 0, GRID_UNIT_WIDTH * GRID_UNIT_COUNT_HORIZONTAL, GRID_UNIT_HEIGHT * GRID_UNIT_COUNT_VERTICAL + GRID_TOP_BAR_HEIGHT);
			
			eventGridMC.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			addGridUnits();
			
			__topBarClip = new MovieClip();
			
			__topBarClip.graphics.beginFill(0x555555);
			__topBarClip.graphics.lineStyle(0, 0x555555);
			__topBarClip.graphics.drawRect(0, 0, eventGridMC.width, GRID_TOP_BAR_HEIGHT);
			__topBarClip.graphics.endFill();
			
			eventGridMC.addChild(__topBarClip);
			
			__playHead = new PlayHead();
			__playHead.init(this);
			__playHead.x = 0;
			__playHead.y = GRID_TOP_BAR_HEIGHT;
			eventGridMC.addChild(__playHead);
			
		}
		
		public function init(editor:MIDIEditor, section_list:SectionList, track_list:TrackList):void
		{
			__editor = editor;
			__sectionList = section_list;
			__trackList = track_list;
			__sections = new Array();
		}
		
		public function onMouseUp(event:Event):void
		{
			
			/*
			if (InputManager.checkInputState(InputManager.CTRL)) {
				var pitch:int = getPitchFromGridY(mouseY);
				var beat:int = getBeatFromGridX(mouseX)
				Debug.log("onMouseUp + CTRL: " + pitch + ", " + beat, "NoteTris");
				
				__currentGridSection.gridScore.addNote(pitch, beat, 1);
			}
			else
			{
				Debug.log("onMouseUp", "NoteTris");
			}
			*/
		}
		
		public function getPitchFromGridY(y:int):int
		{
			var pitch:int =  (GRID_UNIT_HEIGHT * 2 - y - GRID_TOP_BAR_HEIGHT) / GRID_NOTE_HEIGTH;
			Debug.log("pitch: " + pitch, "EventGrid");
			return pitch;
		}
		
		public function getBeatFromGridX(x:int):int
		{
			var beat:int =  x / GRID_BEAT_WIDTH;
			Debug.log("beat: " + beat, "EventGrid");
			return beat;
		}
		
		public function loadSoundtrack(soundtrack:Soundtrack):void
		{
			Debug.log("loadSoundtrack: " + soundtrack.id, "EventGrid");
			clearSections();
			addGridSections(soundtrack);
			__sectionList.sections = __sections;
		}
		
		/******
		public function showSection(index:int):void
		{
			__currentGridSection = GridSection(__sections[index]);
			
			var i:int;
			for (i = 0; i < __currentGridSection.gridScore.partCount; i++)
			{
				__currentGridSection.gridScore.showPartWithIndex(index);
			}
		}
		******/
		
		private function clearSections():void
		{
			Debug.log("clearSections: " + __sections, "EventGrid");
			var section:GridSection;
			for each (section in __sections)
			{
				section.gridScore.clearParts();
			}
			__sections = new Array();
		}
		
		private function addGridSections(soundtrack:Soundtrack):void
		{
			Debug.log("addGridSections: " + soundtrack.id, "EventGrid");
			var section:Section;
			
			for each(section in soundtrack.sections)
			{
				var gSection:GridSection = new GridSection(this, section);
				
				__sections.push(gSection);
			}
		}
		
		private function addGridUnits():void
		{
			var unitCount:int = GRID_UNIT_COUNT_HORIZONTAL; // __currentGridSection.length / 4; // 4 beats per runit
			var unitRows:int = GRID_UNIT_COUNT_VERTICAL;
			
			//Debug.log("addGridUnits: " + unitCount, "NoteTris");
			
			for (var i:int = 0; i < unitCount; i++)
			{
				for (var j:int = 0; j < unitRows; j++)
				{
					var eguMC:EventGridUnitMC = new EventGridUnitMC();
					var unit:EventGridUnit = new EventGridUnit(eguMC);
					unit.eventGridUnitMC.x = i * GRID_UNIT_WIDTH;
					unit.eventGridUnitMC.y = j * GRID_UNIT_HEIGHT + GRID_TOP_BAR_HEIGHT;
					eventGridMC.addChild(unit.eventGridUnitMC);
				}
			}
		}
		
		public function getGridEventClip(note:Note):GridEventMC
		{
			var clip:GridEventMC = new GridEventMC();
			//Debug.log("Colors: " + __editor.trackColors + ", " + __editor.trackColors[trackEvent.trackIndex], "NoteTris");
			var part_index:int = note.measure.part.index;
			clip.bg.transform.colorTransform = __editor.trackColors[part_index];
			
			
			return clip;
		}
		
		public function get currentSection():GridSection
		{
			return __currentGridSection;
		}
		
		public function selectSection(section:GridSection):void
		{
			if (__currentGridSection) __currentGridSection.gridScore.hide();
			__currentGridSection = section;
			__currentGridSection.gridScore.show();
			
			__trackList.tracks = __currentGridSection.gridScore.parts;
		}
		
		public function selectSectionWithIndex(index:int):void
		{
			var section:GridSection = GridSection(__sections[index]);
			selectSection(section);
		}
		
		public function selectPartWithIndex(index:int):void
		{
			__currentGridSection.selectPartWithIndex(index);
		}
		
		public function get sections():Array
		{
			return __sections;
		}
		
		public function set gridScaleHoriz(h_scale:Number):void
		{
			__gridScaleHoriz = h_scale;
			__currentGridSection.gridScore.show();
		}
		
		public function get gridScaleHoriz():Number
		{
			return __gridScaleHoriz;
		}
		
		public function set gridScaleVert(v_scale:Number):void
		{
			__gridScaleVert = v_scale;
		}
		
		public function get gridScaleVert():Number
		{
			return __gridScaleVert;
		}

		public function set gridScrollHoriz(h_scale:Number):void
		{
			__gridScrollHoriz = h_scale;
		}

		public function set gridScrollVert(v_scale:Number):void
		{
			__gridScrollVert = v_scale;
		}
		
		public function set tempoScale(t_scale:Number):void
		{
			__tempoScale = t_scale;
		}
		
		public function update(elapsed:int):void
        {
			
			if (MusicManager.instance.playing)
			{
				var ap:AudioPerformer;
				var playHeadX:Number;
				var channel:SoundChannel = MusicManager.instance.player.channel;
				var latency:Number = MusicManager.instance.player.latency;
				var position:Number;
				
				ap = MusicManager.instance.listPerformer;
				//position = ap.position / AudioDescriptor.RATE_44100 - latency;
				position = (getTimer() - MusicManager.instance.playerStartTime) / 1000;
				//playHeadX = (ap.position / ap.frameCount) * __currentGridSection.gridScore.widthInPixels;
				playHeadX = (position / __currentGridSection.gridScore.durationInSeconds) * __currentGridSection.gridScore.widthInPixels * __gridScaleHoriz * __tempoScale;
				
				//Debug.log("update: playhead: " + position + ", " + __currentGridSection.gridScore.durationInSeconds, "maestro");
				
				__playHead.x = playHeadX;
			}
		}

	}
	
}