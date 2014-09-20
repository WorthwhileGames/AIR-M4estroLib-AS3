package com.maestro.editor 
{
	
	//import com.disney.ui.buttons.PushButton;
	//import com.disney.cars.ui.buttons.PushButtonMicroTintable;
	//import com.disney.cars.ui.sliders.HorizontalSliderNormal;
	//import com.disney.cars.ui.sliders.VerticalSliderNormal;
	//import com.disney.ui.buttons.PushButtonEvent;
	//import com.disney.ui.sliders.SliderEvent;
	//import com.disney.util.Debug;
	import com.m4estro.ui.editor.TrackListItemMC;
	import com.m4estro.ui.sliders.HorizontalSliderNormal;
	
	import com.m4estro.vc.BaseObject;
	import com.maestro.music.musicxml.Part;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author ...
	 */
	public class TrackListItem extends BaseObject
	{
		private var __trackListItemMC:TrackListItemMC;
		private var __editor:MIDIEditor;
		private var __trackList:TrackList;
		private var __gridPart:GridPart;
		private var __gridPartVisible:Boolean;
		private var __beingEdited:Boolean;
		
		public var handle:MovieClip;
		public var visibilityToggle:TrackListVisibilityToggle;
		public var editIndicator:MovieClip;
		public var trackName:TextField;
		public var trackInstrument:TextField;
		public var bg:MovieClip;
		public var slVolume:HorizontalSliderNormal;
		public var slPan:HorizontalSliderNormal;
		
		public function TrackListItem(track_list_item_mc:TrackListItemMC) 
		{
			__trackListItemMC = track_list_item_mc;
			__trackListItemMC.editIndicator.visible = false;
			__beingEdited = false;
			__gridPartVisible = true;
		}
		
		public function init(editor:MIDIEditor, track_list:TrackList, grid_part:GridPart):void
		{
			__editor = editor;
			__trackList = track_list;
			gridPart = grid_part;
			
			//Debug.log("TracklistItem:init: " + __gridPart.part.index, "NoteTris");
			__trackListItemMC.handle.transform.colorTransform = __editor.trackColors[__gridPart.part.index];
			__trackListItemMC.visibilityToggle.addEventListener(MouseEvent.MOUSE_UP, onVisibilityToggle);
			__trackListItemMC.handle.addEventListener(MouseEvent.MOUSE_UP, onSelect);
			__trackListItemMC.trackInstrument.addEventListener(TextEvent.TEXT_INPUT, onInstrumentName);
			__trackListItemMC.trackInstrument.addEventListener(FocusEvent.FOCUS_OUT, onInstrumentName);
			
		}
		
		public function onVisibilityToggle(event:Event):void 
		{
			if (__gridPartVisible)
			{
				__gridPartVisible = false;
				__gridPart.hide();
			}
			else 
			{
				__gridPartVisible = true;
				__gridPart.show();
			}
		}
		
		public function onSelect(event:Event):void 
		{
			__trackList.selectTrackWithIndex(__gridPart.part.index);
		}
		
		public function get gridPart():GridPart
		{
			return __gridPart;
		}
		
		public function set gridPart(grid_part:GridPart):void
		{
			__gridPart = grid_part;
			
			var part:Part = Part(__gridPart.part);
			__trackListItemMC.trackName.text = part.id;
			__trackListItemMC.trackInstrument.text = part.instrumentName;
		}
		
		public function onInstrumentName(event:Event):void 
		{
			__gridPart.part.instrumentName = trackInstrument.text;
		}
		
		public function get mc():TrackListItemMC
		{
			return __trackListItemMC;
		}
	}
}