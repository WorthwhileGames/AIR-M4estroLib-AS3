﻿package com.maestro.world 
{
	
	
	/**
	 * ...
	 * @author ...
	 */
	public class Target extends Block
	{
		public var matched:Boolean;
		
		
		public function Target() 
		{
			super();
			matched = false;
		}
		
		override public function init(dur:Number): void
		{
			duration = dur / 16;  //16 divisions per 16th note when 256 divisions per measure
		}
				
		override public function update(elapsed:Number): void
		{

		}
		
		public function match(): void
		{
			matched = true;
		}
		
		override public function toString():String
		{
			return "Target: " + x + ", " + matched;
		}
	}
}