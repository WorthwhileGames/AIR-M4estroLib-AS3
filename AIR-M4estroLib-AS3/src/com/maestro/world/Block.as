﻿package com.maestro.world 
{
	import com.m4estro.vc.BaseMovieClip;
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Block extends BaseMovieClip
	{
		public static var PIXELS_PER_DURATION_UNIT:Number;  //set in FLA by sizing Block
		public static var PIXELS_PER_VERTICAL_UNIT:Number;  //set in FLA by sizing Block
		
		private var __duration:Number;
		private var __yVelocity:Number;
		private static var activeBlockFilters:Array;
				
		
		public var fg:MovieClip;
		public var bg:MovieClip;
		public var settled:Boolean;
		
		
		public function Block() 
		{
			PIXELS_PER_DURATION_UNIT = this.width;
			PIXELS_PER_VERTICAL_UNIT = this.height;
			
			__duration = 0;
			__yVelocity = 0;
			settled = false;
			
			this.y = 0;
			
			if (activeBlockFilters == null)
			{
				activeBlockFilters = [new GlowFilter(0x000000)];
			}
		}
		
		public function init(dur:Number): void
		{
			
			duration = dur / 16;  //16 divisions per 16th note when 256 divisions per measure
			fallNormal();
		}
		
		public function set duration(d:Number): void
		{
			__duration = d;
			this.bg.width = d * PIXELS_PER_DURATION_UNIT;
			this.fg.width = (d * PIXELS_PER_DURATION_UNIT) - 4;
			
		}
		
		public function get duration(): Number
		{
			return __duration;
		}
		
		public function set velocity(v:Number): void
		{
			__yVelocity = v;
		}
		
		public function get velocity(): Number
		{
			return __yVelocity;
		}
		
		public function updateVelocity(d:Number): void
		{
			__yVelocity += d;
		}
		
		public function update(elapsed:Number): void
		{
			//log("Block:update: elapsed: " + elapsed + ", " + (__yVelocity * elapsed) + ", " + this.y, "NoteTris");
			
			if (!settled)
			{
				this.y += (__yVelocity * elapsed);
			}
		}
		
		public function fallNormal(): void
		{
			var randVel:Number = 20 + (20 * Math.random());
			__yVelocity = 20; // randVel;
		}
		
		public function fallSlow(): void
		{
			var randVel:Number = 10 + (10 * Math.random());
			__yVelocity = 10; // randVel;
		}
		
		public function drop(): void
		{
			var randVel:Number = 400;
			__yVelocity = 400; // randVel;
		}
		
		public function doNotFall(): void
		{
			__yVelocity = 0;
		}
		
		public function settle(): void
		{
			settled = true;
		}
		
		public function unSettle(): void
		{
			settled = false;
		}
		
		public function select(): void
		{
			this.filters = activeBlockFilters;
		}
		
		public function unSelect(): void
		{
			this.filters = [];
		}
		
		override public function toString():String
		{
			
			return "Block: " + x + ", " + settled;
		}
		
		public function cleanup(): void
		{
			activeBlockFilters = null;
			fg = null;
			bg = null;
			destroy();
		}
	}
	
}