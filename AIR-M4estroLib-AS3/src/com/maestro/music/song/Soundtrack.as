package com.maestro.music.song 
{
	import com.m4estro.vc.Debug;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Soundtrack 
	{
		private var __id:String;
		private var __version:String;
		private var __sections:Array;
		private var __curentSectionIndex:int;
		private var __tempo:Number;
		
		public function Soundtrack(soundtrack_xml:XML) 
		{
			__sections = new Array();
			
			__version = soundtrack_xml.@version;
			Debug.log("Soundtrack: version: " + __version, "maestro");
			
			var section:Section = new Section(soundtrack_xml);
			__sections.push(section);
			
			__id = "Soundtrack";
			
			
			/*
			var sectionList:XMLList = soundtrack_xml.children();
			
			var sectionXML:XML;
			var index:int = 0;
			for each (sectionXML in sectionList)
			{
				var section:Section = new Section(sectionXML);
				__sections.push(section);
			}
			*/
		}
		
		public function getSectionWithIndex(index:int):Section
		{
			return __sections[index];
		}
		
		public function get id():String
		{
			return __id;
		}
		
		public function get sections():Array
		{
			return __sections;
		}
		
		public function get xml():XML
		{
			var songXML:XML = <section id={__id} />;
			
			var section:Section;
			var i:int;
			for (i = 0; i < __sections.length; i++)
			{
				section = Section(__sections[i]);
				songXML.appendChild(section.xml);
			}
			
			return songXML;
		}
	}
}