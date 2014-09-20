package com.maestro.editor 
{
	import com.m4estro.ui.editor.EventGridUnitMC;
	import com.m4estro.vc.BaseObject;

	/**
	 * ...
	 * @author ...
	 */
	public class EventGridUnit extends BaseObject
	{
		public var eventGridUnitMC:EventGridUnitMC;
		
		public function EventGridUnit(event_grid_unit_mc:EventGridUnitMC) 
		{
			eventGridUnitMC = event_grid_unit_mc;
		}
		
		public function get width():int
		{
			return eventGridUnitMC.width;
		}
		
		public function get height():int
		{
			return eventGridUnitMC.height;
		}
		
	}

}