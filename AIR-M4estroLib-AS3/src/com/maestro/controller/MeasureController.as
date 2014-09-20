package com.maestro.controller 
{
	import com.disney.base.BaseMovieClip;
	import com.maestro.world.Block;
	import com.maestro.world.GameBoard;
	import com.disney.util.Debug;
	import com.maestro.music.Performer;
	import com.maestro.music.PerformerList;
	import flash.display.MovieClip;
	import com.maestro.music.MusicManager;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MeasureController extends BaseMovieClip
	{
		private var __gameBoard:GameBoard;
		private var __controls:Array;
		private var __performerList:PerformerList;
		
		public function MeasureController() 
		{
			
		}
		
		public function init(game_board:GameBoard):void
		{
			__gameBoard = game_board;
			__controls = new Array();
		}
		
		public function showMeasureControls():void
		{
			var control:Block;
			
			for each (control in __controls)
			{
				removeChild(control);
				control.removeEventListener(MouseEvent.MOUSE_DOWN, onMouse);
			}
			
			__performerList = MusicManager.instance.performerList;
			
			
			//var control:Block;
			
			var i:int = 0;
			var performer:Performer;
			
			for each (performer in __performerList.performers)
			{
				control = new Block();
				control.name = "" + i;
				control.x = i * control.width;
				control.y = 0;
				//control.label = performer.name;
				
				control.addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
				
				addChild(control);
				__controls.push(control);
				i++;
			}
		}
		
		public function onMouse(event:Event):void 
		{
			var clip:MovieClip = MovieClip(event.target);
			Debug.log("onMouse: " + clip.parent.name);
			
			if (event.type == MouseEvent.MOUSE_DOWN)
			{
				var controlIndex:int = int(clip.parent.name);
				var performer:Performer = __performerList.getPerformerWithIndex(controlIndex);
				MusicManager.instance.playPerformer(performer);
			}
			else if (event.type == MouseEvent.MOUSE_UP)
			{

			}
		}
	}
	
}