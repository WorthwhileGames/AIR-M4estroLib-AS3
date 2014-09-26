package com.maestro.editor 
{
	import com.m4estro.vc.BaseMovieClip;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * ...
	 * @author ...
	 */
	public class PlayHead extends BaseMovieClip
	{
		public var up:MovieClip;
		
		private var __eventGrid:EventGrid;
		private var __line:MovieClip;
		private var __dragRect:Rectangle;
		
		
		public function PlayHead() 
		{
			addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
			addEventListener(MouseEvent.MOUSE_UP, onMouse);
		}
		
		public function init(_eventGrid:EventGrid):void
		{
			__eventGrid = _eventGrid;

			__dragRect = new Rectangle(0, __eventGrid.GRID_TOP_BAR_HEIGHT, __eventGrid.eventGridMC.width, __eventGrid.GRID_TOP_BAR_HEIGHT+1);
			
			if (__line == null)
			{
				__line = new MovieClip();
				addChild(__line);
				__line.x = 0;
				__line.graphics.moveTo(0, 0);
				__line.graphics.lineStyle(2, 0x668866);
				__line.graphics.lineTo(0, __eventGrid.eventGridMC.height);
			}
		}
		
		public function onMouse(event:Event):void 
		{
			if (event.type == MouseEvent.MOUSE_DOWN)
			{
				startDrag(true, __dragRect);
			}
			else if (event.type == MouseEvent.MOUSE_UP)
			{
				stopDrag();
				x = __eventGrid.GRID_TOP_BAR_HEIGHT;
			}
		}
		
	}

}