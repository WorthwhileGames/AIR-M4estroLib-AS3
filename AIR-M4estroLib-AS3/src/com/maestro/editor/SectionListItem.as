package com.maestro.editor 
{
	//import com.disney.base.BaseMovieClip;
	//import com.disney.ui.buttons.PushButton;
	//import com.disney.cars.ui.buttons.PushButtonMicroTintable;
	//import com.disney.cars.ui.sliders.HorizontalSliderNormal;
	//import com.disney.cars.ui.sliders.VerticalSliderNormal;
	//import com.disney.ui.buttons.PushButtonEvent;
	//import com.disney.ui.sliders.SliderEvent;
	//import com.disney.util.Debug;
	import com.m4estro.ui.editor.SectionListItemMC;
	import com.m4estro.vc.BaseObject;
	import com.maestro.music.song.Section;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SectionListItem extends BaseObject
	{
		private var __sectionListItemMC:SectionListItemMC;
		
		private var __editor:MIDIEditor;
		private var __sectionList:SectionList;
		
		private var __visible:Boolean;
		private var __beingEdited:Boolean;
		private var __gridSection:GridSection;

		//public var editIndicator:MovieClip;
		//public var sectionName:TextField;
		//public var bg:MovieClip;
		
		public function SectionListItem(section_list_item_mc:SectionListItemMC) 
		{
			__sectionListItemMC = section_list_item_mc;
			
			__sectionListItemMC.editIndicator.visible = false;
			__beingEdited = false;
			__visible = true;
			
			__sectionListItemMC.bg.addEventListener(MouseEvent.MOUSE_UP, onSelect);
		}
		
		public function init(editor:MIDIEditor, section_list:SectionList, grid_section:GridSection):void
		{
			__editor = editor;
			__sectionList = section_list;
			
			gridSection = grid_section;
		}
		
		public function onSelect(event:Event):void 
		{
			__sectionList.selectSectionWithIndex(__gridSection.sectionIndex);
		}
		
		public function get gridSection():GridSection
		{
			return __gridSection;
		}
		
		public function set gridSection(grid_section:GridSection):void
		{
			__gridSection = grid_section;
			var songSection:Section = Section(__gridSection.gridScore.songSection);
			__sectionListItemMC.sectionName.text = songSection.id;
		}
		
		public function get mc():SectionListItemMC
		{
			return __sectionListItemMC;
		}
	}
}