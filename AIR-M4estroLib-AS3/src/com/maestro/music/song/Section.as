package com.maestro.music.song 
{
	
	/**
	 * ...
	 * @author ...
	 */
	import com.maestro.music.musicxml.Score;
	 
	 
	public class Section 
	{
		private var __index:int;
		private var __id:String;
		private var __score:Score;
		
		
		public function Section(section_xml:XML) 
		{
			
			//Debug.log("Section: \n" + section_xml, "maestro");
			
			__id = "Main Section"; // section_xml.@id;
			__index = 0; // section_xml.@index;
			
			__score = new Score();
			__score.initWithMusicXML(section_xml);
		}
				
		public function get parts():Array
		{
			return __score.parts;
		}
		
		public function get id():String
		{
			return __id;
		}
		
		public function get index():int
		{
			return __index;
		}
		
		public function set index(index:int):void
		{
			__index = index;
		}
		
		public function get score():Score
		{
			return __score;
		}
		
		public function get xml():XML
		{
			
			var sectionXML:XML = <section index={__index} id={__id} />;
			/*
			var track:Track;
			for each (track in __tracks)
			{
				//sectionXML.appendChild(track.xml);
			}
			*/
			
			return sectionXML;
		}
	}
}