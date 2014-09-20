﻿package com.maestro.managers 
{
	import com.maestro.controller.GameTimer;
	/**
	 * ...
	 * @author ...
	 */
	public class InputObject
	{
		private var __state:Boolean;
		
		public var timer:GameTimer;
		public var allowRepeat:Boolean;
		public var repeatCount:int;
		public var waitToRepeat:int;
		
		
		public function InputObject() 
		{
			__state = false;
			timer = new GameTimer();
			allowRepeat = true;
			repeatCount = 0;
		}
		
		public function set state(new_state:Boolean): void
		{
			if ((__state == true) && (new_state == false))
			{
				//key has been released
				repeatCount = 0;
			}
			else if ((__state == false) && (new_state == true))
			{
				//key has been pressed
			}
			
			__state = new_state;
		}
		
		public function get state(): Boolean
		{
			var returnState:Boolean = false;
			
			if (__state)
			{
				if (timer.isExpired())
				{
					if (!allowRepeat && (repeatCount > 0))
					{
						returnState = false;
					}
					else if (allowRepeat && ((repeatCount > 0) && (repeatCount < waitToRepeat)))
					{
						returnState = false;
					}
					else 
					{
						returnState = true;
					}
					timer.restartTimer();
					repeatCount++;
				}
				else
				{
					returnState = false;
				}
			}
			else
			{
				returnState = false;
			}

			return returnState;
		}
		
		public function setKeyTimerDuration(dur:int): void
		{
			timer.duration = dur;
		}
		
		public function setKeyTimerRepeatParameters(allow:Boolean, waitCount:int): void
		{
			allowRepeat = allow;
			waitToRepeat = waitCount;
		}
	}
}