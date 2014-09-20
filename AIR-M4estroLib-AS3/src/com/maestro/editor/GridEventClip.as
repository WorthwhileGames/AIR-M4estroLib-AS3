package com.maestro.editor 
{
	import com.disney.base.BaseMovieClip;
	import flash.display.MovieClip;
	import flash.text.TextField;
	/**
	 * ...
	 * @author ...
	 */
	public class GridEventClip extends BaseMovieClip
	{
		public var nameText:TextField;
		public var bg:MovieClip;
		
		private var __noteName:String;
		
		public function GridEventClip() 
		{
			
		}
		
		public function set noteName(name:String):void
		{
			__noteName = name;
			nameText.text = __noteName;
		}
		
	}

}