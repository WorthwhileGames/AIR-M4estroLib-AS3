package com.maestro.editor 
{
	import com.m4estro.ui.editor.SectionListItemMC;
	import com.m4estro.ui.editor.SectionListMC;
	import com.m4estro.vc.BaseMovieClip;
	import com.m4estro.vc.Debug;
	
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SectionList extends BaseMovieClip
	{
		
		public var baseSectionListItemMC:SectionListItemMC;
		public var bgMC:MovieClip;
		//public var expanderMC:MovieClip;
		
		private var __sectionListMC:SectionListMC;
		
		private var __editor:MIDIEditor;
		private var __eventGrid:EventGrid;
		
		private var __sectionListItems:Array;
		private var __gridSections:Array;
		private var __currentGridSection:GridSection;
		private var __currentGridSectionIndex:int;
		
		public function SectionList(section_list_mc:SectionListMC) 
		{
			__sectionListMC = section_list_mc;
			
			baseSectionListItemMC = __sectionListMC.baseSectionListItem;
			bgMC = __sectionListMC.bg;
			
			baseSectionListItemMC.visible = false;
		}
		
		public function init(editor:MIDIEditor, event_grid:EventGrid):void
		{
			__editor = editor;
			__eventGrid = event_grid;
		}
		
		public function get currentSection():GridSection
		{
			return __currentGridSection;
		}
		
		public function get currentSectionIndex():int
		{
			return __currentGridSectionIndex;
		}
		
		public function selectSectionWithIndex(index:int):void
		{
			__currentGridSectionIndex = index;
			__currentGridSection = __gridSections[__currentGridSectionIndex];
			__eventGrid.selectSectionWithIndex(__currentGridSectionIndex);
			
			var sectionListItem:SectionListItem;
			for each (sectionListItem in __sectionListItems)
			{
				if (sectionListItem.gridSection.sectionIndex == __currentGridSectionIndex)
				{
					sectionListItem.mc.editIndicator.visible = true;
				}
				else
				{
					sectionListItem.mc.editIndicator.visible = false;
				}
			}
		}
		
		public function set sections(section_list:Array):void
		{
			__gridSections = section_list;
			Debug.log("set sections: " + __gridSections + ", " + __gridSections.length, "SectionList");
			
			//clear sections
			var item:SectionListItem;
			for each (item in __sectionListItems)
			{
				__sectionListMC.removeChild(item.mc);
			}
			__sectionListItems = new Array();
			__currentGridSectionIndex = 0;
			
			var i:int;
			var section:GridSection;
			var sectionListItem:SectionListItem;
			var count:int = __gridSections.length;
			var startX:int = baseSectionListItemMC.x;
			var startY:int = baseSectionListItemMC.y;
			var nextItemY:int = startY;
			
			for (i = 0; i < count; i++)
			{
				section = GridSection(__gridSections[i]);
				sectionListItem = new SectionListItem(new SectionListItemMC());
				sectionListItem.init(__editor, this, section);
				sectionListItem.mc.x = startX;
				sectionListItem.mc.y = nextItemY;
				nextItemY += (baseSectionListItemMC.height + 3);
				__sectionListMC.addChild(sectionListItem.mc);
				__sectionListItems.push(sectionListItem);
			}
			
			selectSectionWithIndex(__currentGridSectionIndex);
		}
	}
}