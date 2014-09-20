package com.maestro.editor 
{
	import com.disney.util.Debug;
	import com.maestro.music.musicxml.Score;
	import com.maestro.music.song.Section;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GridSection 
	{
		private var __eventGrid:EventGrid;
		private var __songSection:Section;
		private var __sectionIndex:int;
		
		private var __gridScore:GridScore;
		
		public function GridSection(grid:EventGrid, section:Section) 
		{
			__eventGrid = grid;
			__songSection = section;
			__sectionIndex = section.index;
			
			Debug.log("GridSection: constructor: __songSection.id: " + __songSection.id, "GridSection");
		
			__gridScore = new GridScore(__eventGrid, __songSection);
		}
		
		public function selectPartWithIndex(index:int):void
		{
			__gridScore.selectPartWithIndex(index);
		}
		
		public function get sectionIndex():int
		{
			return __sectionIndex;
		}
		
		public function set sectionIndex(index:int):void
		{
			__sectionIndex = index;
		}
	
		public function get gridScore():GridScore
		{
			return __gridScore;
		}
	}
}