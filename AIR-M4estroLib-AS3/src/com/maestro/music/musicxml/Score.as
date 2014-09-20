package com.maestro.music.musicxml 
{
	import com.disney.util.Debug;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Score 
	{
		
		private var __workXML:XML;
		private var __identificationXML:XML;
		private var __defaultsXML:XML;
		private var __creditXML:XMLList;
		private var __partListXMLList:XMLList;
		private var __partsXMLList:XMLList;
		
		private var __partDetails:Array;
		private var __parts:Array;
		private var __durationInSeconds:Number;
		private var __measureCount:int;
		
		
		public function Score() 
		{
			
		}
		
		public function initWithMusicXML(music_xml:XML):void
		{
			//Debug.log("Score: \n" + music_xml, "maestro");
			
			__workXML = music_xml.work[0];
			__identificationXML = music_xml.identification[0];
			__defaultsXML = music_xml.defaults[0];
			__creditXML = music_xml.credit;
			__partListXMLList = music_xml.elements("part-list")[0].children();
			__partsXMLList = music_xml.part;
			
			//Debug.log("Score: __partListXML:\n" + __partListXMLList, "maestro");
			
			__partDetails = new Array();
			
			var part_details_xml:XML;
			var index:int = 0;
			for each (part_details_xml in __partListXMLList)
			{
				var part_details:PartDetails = new PartDetails();
				part_details.initWithXML(part_details_xml);
				part_details.index = index++;
				__partDetails.push(part_details);
			}
			
			__parts = new Array();
			__durationInSeconds = 0;
			__measureCount = 0;
			
			var part_xml:XML;
			index = 0;
			for each (part_xml in __partsXMLList)
			{
				var details:PartDetails = PartDetails(__partDetails[index]);
				var part:Part = new Part(details);
				part.initWithXML(part_xml);
				part.index = index++;
				__durationInSeconds = Math.max(__durationInSeconds, part.durationInSeconds);
				__parts.push(part);
				__measureCount = Math.max(__measureCount, part.measureCount);
			}
		}
		
		public function get parts():Array
		{
			return __parts;
		}
		
		public function get durationInSeconds():Number
		{
			return __durationInSeconds;
		}
		
		public function get measureCount():int
		{
			return __measureCount;
		}
	}
}