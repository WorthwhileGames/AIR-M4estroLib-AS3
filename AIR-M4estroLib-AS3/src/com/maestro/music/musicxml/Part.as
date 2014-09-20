package com.maestro.music.musicxml 
{
	import com.disney.util.Debug;
	import com.maestro.music.MusicEventList;
	/**
	 * ...
	 * @author ...
	 */
	public class Part
	{
		private var __id:String;
		private var __index:int;
		private var __details:PartDetails;
		private var __measures:Array;
		private var __measuresXMLList:XMLList;
		private var __measureCount:int;
		private var __durationInSeconds:Number;
		
		public function Part(_details:PartDetails) 
		{
			__details = _details;
			__index = 0;
			__measureCount = 0;
		}
		
		public function initWithXML(xml:XML):void
		{
			//Debug.log("Part: details: " + __details.name, "maestro");
			
			__id = xml.@id;
			__measures = new Array();
			__measuresXMLList = xml.measure;
			__durationInSeconds = 0;
			
			var measure_xml:XML;
			var currentAttributes:MeasureAttributes = new MeasureAttributes();
			var currentDirection:MeasureDirection = new MeasureDirection();
			
			for each (measure_xml in __measuresXMLList)
			{
				var measure:Measure = new Measure(this);
				measure.initWithXML(measure_xml);
				
				if (measure.attributes != null)
				{
					currentAttributes = measure.attributes;
				}
				else
				{
					measure.attributes = currentAttributes;
				}
				
				if (measure.direction != null)
				{
					currentDirection = measure.direction;
				}
				else
				{
					measure.direction = currentDirection;
				}
				__durationInSeconds += measure.measureTime;
				
				__measures.push(measure);
				__measureCount++;
			}
		}
		
		public function addNote(pitch:int, beat:int, duration:Number):void
		{
			//TODO
		}
		
		public function get id():String
		{
			return __id;
		}
		
		public function get index():int
		{
			return __index;
		}
		
		public function set index(i:int):void
		{
			__index = i;
		}
		
		public function get details():PartDetails 
		{
			return  __details;
		}
		
		public function get partName():String 
		{
			return  __details.name;
		}
		
		public function get instrumentName():String 
		{
			return  __details.instrumentName;
		}
		
		public function set instrumentName(name:String):void 
		{
			__details.instrumentName = name;
		}
		
		public function get measures():Array
		{
			return __measures;
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