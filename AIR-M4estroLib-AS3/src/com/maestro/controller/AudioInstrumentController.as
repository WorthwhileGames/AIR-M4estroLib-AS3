package com.maestro.controller 
{
	//import com.disney.base.BaseMovieClip;
	import com.disney.geom.Vector2;
	import com.disney.util.Debug;
	import com.m4estro.vc.BaseMovieClip;
	import com.m4estro.ui.KeyboardInstrumentMC;
	import com.maestro.managers.InputManager;
	import com.noteflight.standingwave3.elements.AudioDescriptor;
	import com.noteflight.standingwave3.elements.Sample;
	import com.noteflight.standingwave3.output.AudioPlayer;
	import com.noteflight.standingwave3.performance.AudioPerformer;
	import com.noteflight.standingwave3.performance.ListPerformance;
	import com.maestro.music.AudioInstrument;
	import com.maestro.music.AudioNote;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import __AS3__.vec.Vector;
	
	/**
	 * ...
	 * @author ...
	 */
	public class AudioInstrumentController extends BaseMovieClip
	{
		private var __keys:Array;
		private var __keyCount:int;
		private var __instrument:AudioInstrument;
		private var __performance:ListPerformance;
		private var __player:AudioPlayer;
		
		private var __keyboardMC:KeyboardInstrumentMC;

		private var __waveformWidth:int;
		private var __waveformHeight:int;
		
		private var __minimized:Boolean;
		private var __minimizedRect:Rectangle;
		private var __maximizedRect:Rectangle;
		
		
		public function AudioInstrumentController() 
		{
		}
		
		public function setKeyboardMC(kbd_mc:KeyboardInstrumentMC)
		{
			trace("setKeyboardMC: " + kbd_mc);
			__keyboardMC = kbd_mc;
			__keys = __keyboardMC.keys;
			__keyCount = __keyboardMC.keyCount;
			
			
			trace("setKeyboardMC: assigning event handlers");
			for (var i:int = 0; i < __keyCount; i++)
			{
				//trace(__keys[i] + ", " + __keys[i].name);
				var keyClip:MovieClip = MovieClip(__keys[i]);
				//trace("keyClip: " + keyClip + ", " + keyClip.name);
				keyClip.addEventListener(MouseEvent.MOUSE_DOWN, onInstrumentKeyDown);
				keyClip.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			}
			
			
			__keyboardMC.menuButton.addEventListener(MouseEvent.MOUSE_UP, onMenuButton);
			__keyboardMC.bg.addEventListener(MouseEvent.MOUSE_DOWN, onBGMouse);
			__keyboardMC.bg.addEventListener(MouseEvent.MOUSE_UP, onBGMouse);
			
			__performance = new ListPerformance();
			
			__player = new AudioPlayer();
			__waveformWidth = __keyboardMC.waveform.width;
			__waveformHeight = __keyboardMC.waveform.height;
			
		}
		
		public function init(instrument:AudioInstrument):void
		{
			__instrument = instrument;
			__minimized = false;
			__maximizedRect = new Rectangle(0, 0, width, height);
			__minimizedRect = new Rectangle(0, 0, 100, 20);
			scrollRect = __maximizedRect;
		}
		
		public function onInstrumentKeyDown(event:Event):void 
		{
			trace("onInstrumentKeyDown: " + event);
			trace("onInstrumentKeyDown: target: " + event.target);
			var target:MovieClip = MovieClip(event.target);
			trace("onInstrumentKeyDown: target: " + target);
			var keyClip:MovieClip = MovieClip(target.parent);
			trace("onInstrumentKeyDown: keyClip: " + keyClip);
			var keyName:String = keyClip.name;
			trace("onInstrumentKeyDown: keyName: " + keyName);
			var keyNumber:int = int(keyName.substr(3));
			trace("onInstrumentKeyDown: keyNumber: " + keyNumber);
			
			trace("onInstrumentKeyDown: __instrument: " + __instrument);
			
			var note:AudioNote = __instrument.getAudioNoteWithID(keyNumber);
			trace("onInstrumentKeyDown: note: " + note);
			trace("onInstrumentKeyDown: noteSample: " + noteSample);
			var noteSample:Sample = note.sample;
			
			//__performance.addSource(noteSample);
			trace("onInstrumentKeyDown: __player: " + __player);
			__player.play(noteSample);
			
			if (InputManager.checkInputState(InputManager.CTRL))
			{
				drawAudioData(noteSample);
			}
		}
		
		public function onMouseOver(event:Event):void 
		{
			if (InputManager.checkInputState(InputManager.CTRL))
			{
				var tempPlayer:AudioPlayer = new AudioPlayer();
				var target:MovieClip = MovieClip(event.target);
				var key:MovieClip = MovieClip(target.parent);
				var keyName:String = key.name
				var keyNumber:int = int(keyName.substr(3));
				
				var note:AudioNote = __instrument.getAudioNoteWithID(keyNumber);
				var noteSample:Sample = note.sample;
				
				//__performance.addSource(noteSample);
				tempPlayer.play(noteSample);
			}
		}
		
		public function onMenuButton(event:Event):void 
		{
			var target:MovieClip = MovieClip(event.target);
			
			toggleMinimized();
		}
		
		private function toggleMinimized():void
		{
			if (!__minimized)
			{
				__minimized = true;
				scrollRect = __minimizedRect;
			}
			else
			{
				__minimized = false;
				scrollRect = __maximizedRect;
			}
		}
		
		private function drawAudioData(sample:Sample):void
		{
			
			__keyboardMC.waveform.graphics.beginFill(0x000000);
			__keyboardMC.waveform.graphics.lineStyle(0, 0x000000);
			__keyboardMC.waveform.graphics.drawRect(0, 0, __waveformWidth, __waveformHeight);
			__keyboardMC.waveform.graphics.endFill();
			
			__keyboardMC.waveform.graphics.moveTo(0, __waveformHeight / 2);
			__keyboardMC.waveform.graphics.lineStyle(1, 0xFFFFFF);
			
			var data:Vector.<Number> = sample.channelData[0];
			
			var sampleLength:int = sample.frameCount;
			var widthScale:int = sampleLength / __waveformWidth;
			var max:Number = 0;
			var i:int;
			var j:int = 0;
			for (i = 0; i < sampleLength; i += widthScale)
			{
				max = Math.max(max, Math.abs(data[i]));
			}
			
			var scaleFactor:Number = ((__waveformHeight / 2) - 4) / max;
			
			j = 0;
			for (i = 0; i < sampleLength; i += widthScale)
			{
				j++;
				__keyboardMC.waveform.graphics.lineTo(j, (__waveformHeight / 2) + data[i]*scaleFactor);
			}
			
		}
		
		public function onBGMouse(event:Event):void 
		{
			var bg:MovieClip = MovieClip(event.target);
			
			if (event.type == MouseEvent.MOUSE_DOWN)
			{
				startDrag();
			}
			else if (event.type == MouseEvent.MOUSE_UP)
			{
				stopDrag();
			}
		}
		
		public function update(elapsed:int):void {
			
			if (__instrument)
			{
				for (var i:int = 0; i < __keyCount; i++)
				{
					var key:MovieClip = MovieClip(__keys[i]);
					var note:AudioNote = __instrument.getAudioNoteWithID(i);
					
					if (note)
					{
						if (note.isPlaying())
						{
							key.up.visible = false;
							key.down.visible = true;
						}
						else 
						{
							key.up.visible = true;
							key.down.visible = false;
						}
					}
				}
			}
		}
	}

}