package com.maestro.editor 
{
	import com.disney.base.BaseMovieClip;
	import com.m4estro.ui.editor.TrackListItemMC;
	import com.m4estro.ui.editor.TrackListMC;
	import com.m4estro.vc.BaseObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author ...
	 */
	public class TrackList extends BaseObject
	{
		
		public var baseTrackListItemMC:TrackListItemMC;
		public var bgMC:MovieClip;
		public var expanderMC:MovieClip;
		
		private var __trackListMC:TrackListMC;
		
		private var __editor:MIDIEditor;
		private var __eventGrid:EventGrid;
		private var __trackListHeight:Number;
		private var __trackListMinWidth:Number;
		private var __trackListMaxWidth:Number;
		private var __expanderWidth:Number;
		private var __maxScrollRect:Rectangle;
		private var __minScrollRect:Rectangle;
		private var __minimized:Boolean;
		private var __trackListItems:Array;
		private var __currentTrack:GridPart;
		private var __currentTrackIndex:int;
		private var __gridParts:Array;
		
		public function TrackList(track_list_mc:TrackListMC) 
		{
			__trackListMC = track_list_mc;
			
			baseTrackListItemMC = __trackListMC["baseTrackListItem"];
			bgMC = __trackListMC["bg"];
			expanderMC = __trackListMC["expander"];
			
			__minimized = false;
			__trackListHeight = __trackListMC.height;
			__trackListMinWidth = 160;
			__trackListMaxWidth = __trackListMC.width;
			
			__expanderWidth = expanderMC.width;			
			
			__maxScrollRect = new Rectangle(0, 0, __trackListMaxWidth, __trackListHeight);
			__minScrollRect = new Rectangle(0, 0, __trackListMinWidth, __trackListHeight);
			__trackListMC.scrollRect = __minScrollRect;
			
			expanderMC.addEventListener(MouseEvent.MOUSE_UP, onExpander);
			
			toggleTracklistWidth();
			
			baseTrackListItemMC.visible = false;
		}
		
		public function init(editor:MIDIEditor, event_grid:EventGrid):void
		{
			__editor = editor;
			__eventGrid = event_grid;
		}
		
		public function get currentTrack():GridPart
		{
			return __currentTrack;
		}
		
		public function selectTrackWithIndex(index:int):void
		{
			__currentTrackIndex = index;
			__currentTrack = __gridParts[index];
			__eventGrid.selectPartWithIndex(__currentTrackIndex);
			
			var trackListItem:TrackListItem;
			for each (trackListItem in __trackListItems)
			{
				if (trackListItem.gridPart.part.index == __currentTrackIndex)
				{
					trackListItem.mc.editIndicator.visible = true;
				}
				else
				{
					trackListItem.mc.editIndicator.visible = false;
				}
			}
		}
		
		public function toggleTracklistWidth():void
		{
			if (__minimized)
			{
				__minimized = false;
				__trackListMC.scrollRect = __maxScrollRect;
				expanderMC.x = __trackListMaxWidth - __trackListMC.expander.width + 2;
			}
			else
			{
				__minimized = true;
				__trackListMC.scrollRect = __minScrollRect;
				expanderMC.x = __trackListMinWidth - expanderMC.width + 2;
			}
		}
		
		public function onExpander(event:Event):void
		{
			toggleTracklistWidth();
		}
		
		public function set tracks(grid_part_list:Array):void
		{
			__gridParts = grid_part_list;
			
			//clear tracks
			var item:TrackListItem;
			for each (item in __trackListItems)
			{
				__trackListMC.removeChild(item.mc);
			}
			
			__trackListItems = new Array();
			__currentTrackIndex = 0;
			
			var i:int;
			var gridPart:GridPart;
			var trackListItem:TrackListItem;
			var count:int = __gridParts.length;
			var startX:int = baseTrackListItemMC.x;
			var startY:int = baseTrackListItemMC.y;
			var nextItemY:int = startY;
			
			for (i = 0; i < count; i++)
			{
				gridPart = GridPart(__gridParts[i]);
				trackListItem = new TrackListItem(new TrackListItemMC());
				trackListItem.init(__editor, this,  gridPart);
				trackListItem.mc.x = startX;
				trackListItem.mc.y = nextItemY;
				nextItemY += (baseTrackListItemMC.height + 3);
				__trackListMC.addChild(trackListItem.mc);
				__trackListItems.push(trackListItem);
			}
			
			selectTrackWithIndex(__currentTrackIndex);  
			
			__trackListMC.swapChildren(expanderMC, trackListItem.mc);
		}
	}
	
}