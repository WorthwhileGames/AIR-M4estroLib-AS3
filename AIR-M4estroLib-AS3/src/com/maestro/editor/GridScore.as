package com.maestro.editor 
{
	import com.m4estro.vc.Debug;
	import com.maestro.music.musicxml.Part;
	import com.maestro.music.song.Section;

	/**
	 * ...
	 * @author ...
	 */
	public class GridScore
	{
		private var __eventGrid:EventGrid;
		private var __songSection:Section;
		private var __parts:Array;
		private var __currentPart:GridPart;
		private var __currentPartIndex:int;
		private var __widthInPixels:Number;
		private var __durationInSeconds:Number;
		
		public function GridScore(grid:EventGrid, section:Section) 
		{
			__eventGrid = grid;
			__songSection = section;
			
			__parts = new Array();
			
			Debug.log("GridScore: constructor: " + __songSection.id, "GridScore");
			
			addGridParts(__songSection);
			
		}
		
		public function addNote(pitch:int, beat:int, duration:Number):void
		{
			__currentPart.addNote(pitch, beat, duration);
		}
		
		public function selectPart(part:GridPart):void
		{
			__currentPart = part;
		}
		
		public function selectPartWithIndex(index:int):void
		{
			__currentPartIndex = index;
			var part:GridPart = GridPart(__parts[index]);
			selectPart(part);
		}
		
		public function clearParts():void
		{
			if (__parts.length > 0)
			{
				var grid_part:GridPart;
				for each (grid_part in __parts)
				{
					grid_part.clearEvents();
				}
			}
			
			__parts = new Array();;
		}
		
		private function addGridParts(section:Section):void
		{
			var part:Part;
			
			for each(part in section.parts)
			{
				var gPart:GridPart = new GridPart(__eventGrid, part);
				
				__parts.push(gPart);
			}
		}
		
		public function show():void
		{
			__widthInPixels = 0;
			for (var i:int = 0; i < __parts.length; i++)
			{
				var part:GridPart = showPartWithIndex(i);
				__widthInPixels = Math.max(__widthInPixels, part.widthInPixels);
			}
		}
		
		public function hide():void
		{
			for (var i:int = 0; i < __parts.length; i++)
			{
				hidePartWithIndex(i);
			}
		}
		
		public function showPart(part:GridPart):void
		{
			//Debug.log("GridScore: showPart: " + part.part.id, "NoteTris");
			part.show();
		}
		
		public function showPartWithIndex(index:int):GridPart
		{
			var part:GridPart = GridPart(__parts[index]);
			showPart(part);
			return part;
		}
		
		public function hidePart(part:GridPart):void
		{
			part.hide();
		}
		
		public function hidePartWithIndex(index:int):void
		{
			var part:GridPart = GridPart(__parts[index]);
			hidePart(part);
		}
		
		public function get partCount():int
		{
			return __parts.length;
		}
		
		public function get parts():Array
		{
			return __parts;
		}
		
		public function get songSection():Section
		{
			return __songSection;
		}
		
		public function get widthInPixels():Number
		{
			return __widthInPixels;
		}
		
		public function get durationInSeconds():Number
		{
			return __songSection.score.durationInSeconds;
		}
	}
}