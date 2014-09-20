package com.maestro.editor 
{
	import com.disney.util.Debug;
	import com.maestro.music.musicxml.Measure;
	import com.maestro.music.musicxml.Part;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GridPart 
	{
		
		private var __eventGrid:EventGrid;
		private var __part:Part;
		private var __gridMeasures:Array;
		private var __widthInPixels:Number;
		
		public function GridPart(event_grid:EventGrid, part:Part) 
		{
			__eventGrid = event_grid;
			__part = part;
			
			//Debug.log("GridPart: constructor: " + __part.id + ", " + __part.details.id, "NoteTris");
			
			addGridMeasures();
		}
		
		private function addGridMeasures():void
		{
			__gridMeasures = new Array();
			
			var measure:Measure;
			var startX:Number = 0;
			var width:Number = 0;
			for each (measure in __part.measures)
			{
				var gMeasure:GridMeasure = new GridMeasure(__eventGrid, this, measure);
				width = __eventGrid.GRID_BEAT_WIDTH * measure.attributes.beats;
				gMeasure.widthInPixels = width;
				gMeasure.startX = startX;
				
				__gridMeasures.push(gMeasure);
				
				startX += width;
			}
			
		}
		
		public function addNote(pitch:int, beat:int, duration:Number):void
		{
			//__currentMeasure.addNote(pitch, beat, duration);
			Debug.log("addNote", "GridPart");
		}
		
		public function show():void
		{
			var gMeasure:GridMeasure;
			__widthInPixels = 0;
			
			for each (gMeasure in __gridMeasures)
			{
				gMeasure.show();
				__widthInPixels += gMeasure.widthInPixels;
			}
		}
		
		public function hide():void
		{
			var gMeasure:GridMeasure;
			
			for each (gMeasure in __gridMeasures)
			{
				gMeasure.hide();
			}
		}
		
		public function clearEvents():void
		{
			var gMeasure:GridMeasure;
			
			for each (gMeasure in __gridMeasures)
			{
				gMeasure.clearEvents();
			}
		}
		
		public function get part():Part
		{
			return __part;
		}
		
		public function get widthInPixels():Number
		{
			return __widthInPixels
		}
	}
}