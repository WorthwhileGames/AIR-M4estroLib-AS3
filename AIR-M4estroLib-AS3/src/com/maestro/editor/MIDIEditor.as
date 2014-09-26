package com.maestro.editor 
{
	import com.disney.ui.sliders.SliderEvent;
	import com.m4estro.ui.editor.MIDIEditorMC;
	import com.m4estro.ui.sliders.HorizontalSliderNormal;
	import com.m4estro.vc.BaseObject;
	import com.m4estro.vc.Debug;
	import com.maestro.music.MusicManager;
	import com.maestro.music.song.Soundtrack;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MIDIEditor extends BaseObject
	{
		
		public var trackColors:Array;
		
		
		//public var transport:TransportController;
		//public var titleBar:MovieClip;
		//public var menuButton:MovieClip;
		//public var bg:MovieClip;
		//public var btnPlay:PushButton;
		//public var btnRewind:PushButton;
		//public var slTempo:MovieClip;
		//public var slHorizScale:MovieClip;
		//public var slHorizScroll:MovieClip;
		//public var tempoText:TextField;
		//public var fileNameText:TextField;
		
		//public var saveButton:MovieClip;
		//public var loadButton:MovieClip;
		
		
		private var __midiEditorMC:MIDIEditorMC;
		private var __minimized:Boolean;
		private var __minimizedRect:Rectangle;
		private var __maximizedRect:Rectangle;
		
		private var __soundtrack:Soundtrack;
		
		private var __eventGridStartX:Number;
		private var __tempoScale:Number;
		
		private var __eventGrid:EventGrid;
		private var __trackList:TrackList;
		private var __sectionList:SectionList;
		private var __keystrip:Keystrip;
		
		
		public function MIDIEditor(midi_editor_mc:MIDIEditorMC) 
		{
			
			Debug.log("midi_editor_mc: " + midi_editor_mc, "MIDIEditor");
			__midiEditorMC = midi_editor_mc;
			__minimized = false;
			__maximizedRect = new Rectangle(0, 0, __midiEditorMC.width, __midiEditorMC.height);
			__minimizedRect = new Rectangle(0, 0, 151, 26);
			
			
			__midiEditorMC.menuButton.addEventListener(MouseEvent.MOUSE_UP, onMenuButton);
			__midiEditorMC.bg.addEventListener(MouseEvent.MOUSE_DOWN, onBGMouse);
			__midiEditorMC.bg.addEventListener(MouseEvent.MOUSE_UP, onBGMouse);
			__midiEditorMC.titleBar.addEventListener(MouseEvent.MOUSE_DOWN, onBGMouse);
			__midiEditorMC.titleBar.addEventListener(MouseEvent.MOUSE_UP, onBGMouse);
			__midiEditorMC.trackList.bg.addEventListener(MouseEvent.MOUSE_DOWN, onBGMouse);
			__midiEditorMC.trackList.bg.addEventListener(MouseEvent.MOUSE_UP, onBGMouse);
			
			__midiEditorMC.saveButton.labelText = "Save";
			__midiEditorMC.loadButton.labelText = "Load";
			__midiEditorMC.saveButton.addEventListener(MouseEvent.MOUSE_UP, onTintableButton);
			__midiEditorMC.loadButton.addEventListener(MouseEvent.MOUSE_UP, onTintableButton);
			
			__midiEditorMC.btnPlay.addEventListener(MouseEvent.MOUSE_DOWN, onPushButton);
			//__midiEditorMC.slTempo.addEventListener(SliderEvent.ON_CHANGE, onSliderChange);
			//__midiEditorMC.slHorizScale.addEventListener(SliderEvent.ON_CHANGE, onSliderChange);
			//__midiEditorMC.slHorizScroll.addEventListener(SliderEvent.ON_CHANGE, onSliderChange);
			
			
			
			__eventGrid = new EventGrid(__midiEditorMC.eventGrid);
			__trackList = new TrackList(__midiEditorMC.trackList);
			__sectionList = new SectionList(__midiEditorMC.sectionList);
			__keystrip = new Keystrip(__midiEditorMC.keystrip);
			
			__eventGrid.init(this, __sectionList, __trackList);
			__eventGridStartX = __eventGrid.eventGridMC.x;
			
			__trackList.init(this, __eventGrid);
			
			__sectionList.init(this, __eventGrid);
			
			__keystrip.init(this);
			
			
			MusicManager.instance.addEventListener(MusicManager.SONG_LOADED, onSoundtrackLoaded);
			
			Debug.log("bg: " + __midiEditorMC.bg.name, "MIDIEditor");
			
			
			var trackColor1:ColorTransform = new ColorTransform(1, 1, 1, 1, 000, 000, 000, 0);
			var trackColor2:ColorTransform = new ColorTransform(1, 1, 1, 1, 000, 100, 000, 0);
			var trackColor3:ColorTransform = new ColorTransform(1, 1, 1, 1, 000, 000, 100, 0);
			var trackColor4:ColorTransform = new ColorTransform(1, 1, 1, 1, 100, 100, 000, 0);
			var trackColor5:ColorTransform = new ColorTransform(1, 1, 1, 1, 100, 000, 000, 0);
			var trackColor6:ColorTransform = new ColorTransform(1, 1, 1, 1, 100, 000, 100, 0);
			var trackColor7:ColorTransform = new ColorTransform(1, 1, 1, 1, 000, 100, 100, 0);
			
			trackColors = new Array(trackColor1, trackColor2, trackColor3, trackColor4, trackColor5, trackColor6, trackColor7);
			
			__tempoScale = 1;
			//__midiEditorMC.tempoText.text = "" + __tempoScale;
			__eventGrid.tempoScale = 1;
			
		}

		public function onTintableButton(event:Event):void 
		{
			Debug.log("event.target: " + event.target, "MIDIEditor");
			
			var base:DisplayObject = DisplayObject(event.target);
			var button:MovieClip = MovieClip(base.parent.parent);
			var name:String = button.name;
			
			//Debug.log("onTintableButton: " + name, "NoteTris");
			
			switch (name)
			{
				case "saveButton":
					MusicManager.instance.saveSoundtrackFile();
					break;
					
				case "loadButton":
					MusicManager.instance.loadSoundtrackFile();
					break;
			}
		}
		
		public function onPushButton(event:Event):void 
		{
			Debug.log("onPushButton: " + event + ", " + event.target, "MIDIEditor");
			var base:DisplayObject = DisplayObject(event.target);
			var button:MovieClip = MovieClip(base.parent);
			var name:String = button.name;
			
			Debug.log("onPushButton: " + name, "MIDIEditor");
			
			switch (name)
			{
				case "btnPlay":
					if (MusicManager.instance.playing)
					{
						Debug.log("MusicManager is already playing: stopping " + name, "MIDIEditor");
						MusicManager.instance.stopPlayer();
					}
					else
					{
						Debug.log("MusicManager is not playing: starting " + name, "MIDIEditor");
						MusicManager.instance.playSoundtrack(1.0);
						//MusicManager.instance.currentSectionIndex = __sectionList.currentSectionIndex;
						//MusicManager.instance.playSoundtrack(__tempoScale);
					}
					break;
			}
		}
		/*
		public function onSliderChange(event:Event):void
		{
			var slider:HorizontalSliderNormal = HorizontalSliderNormal(event.target);
			//Debug.log("Button: Release: " + button.name, "NoteTris");
			
			switch (slider.name)
			{
				case "slTempo":
					__tempoScale = 1 + (__midiEditorMC.slTempo.value * 1);
					__eventGrid.tempoScale = __tempoScale;
					__midiEditorMC.tempoText.text = "" + __tempoScale;
					break;
					
				case "slHorizScale":
					__eventGrid.gridScaleHoriz = Math.min(8, Math.pow(2, Math.floor(__midiEditorMC.slHorizScale.value * 10)));
					break;
					
				case "slHorizScroll":
					//eventGrid.gridScrollHoriz = slHorizScroll.value;
					var xOffset:Number = -1 * __eventGrid.currentSection.gridScore.widthInPixels * __midiEditorMC.slHorizScroll.value;
					__eventGrid.eventGridMC.x = __eventGridStartX + xOffset;
					break;
			}
		}
		*/
		
		public function onBGMouse(event:Event):void 
		{
			var bg:MovieClip = MovieClip(event.target);
			
			//Debug.log("onBGMouse", "NoteTris");
			
			if (event.type == MouseEvent.MOUSE_DOWN)
			{
				__midiEditorMC.startDrag();
			}
			else if (event.type == MouseEvent.MOUSE_UP)
			{
				__midiEditorMC.stopDrag();
			}
		}
		
		public function onMenuButton(event:Event):void 
		{
			var target:MovieClip = MovieClip(event.target);
			
			toggleMinimized();
		}
		
		private function toggleMinimized():void
		{
			if (!__minimized)
			{
				__minimized = true;
				__midiEditorMC.scrollRect = __minimizedRect;
			}
			else
			{
				__minimized = false;
				__midiEditorMC.scrollRect = __maximizedRect;
			}
		}
		
		public function onSoundtrackLoaded(event:Event):void
		{
			soundtrack = MusicManager.instance.currentSoundtrack;
			Debug.log("onSoundtrackLoaded: " + __soundtrack.id, "MIDIEditor");
		}
		
		
		public function set soundtrack(s:Soundtrack):void
		{
			__soundtrack = s;
			
			__eventGrid.loadSoundtrack(__soundtrack);
		}
		
		public function get soundtrack():Soundtrack
		{
			return __soundtrack;
		}
		
		public function get tempoScale():Number
		{
			return __tempoScale;
		}
		
		public function update(elapsed:int):void
        {
			
			__eventGrid.update(elapsed);
		}

		
	}
}