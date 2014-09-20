package com.maestro.editor 
{
	import com.disney.input.Keys;
	import com.m4estro.ui.editor.KeystripMC;
	import com.m4estro.ui.editor.KeystripUnitMC;
	import com.m4estro.vc.BaseObject;
	/**
	 * ...
	 * @author ...
	 */
	public class Keystrip extends BaseObject
	{
		private var __keystripMC:KeystripMC;
		private var __baseUnitMC:KeystripUnitMC;
		
		public var KEYBOARD_UNIT_WIDTH:int;
		public var KEYBOARD_UNIT_HEIGHT:int;
		public var KEYBOARD_NOTE_HEIGTH:int;
		
		private var __editor:MIDIEditor;
		
		public function Keystrip(keystrip_mc:KeystripMC) 
		{
			__keystripMC = keystrip_mc;
			__baseUnitMC = __keystripMC.baseUnit;
			
			KEYBOARD_UNIT_WIDTH = __baseUnitMC.width;
			KEYBOARD_UNIT_HEIGHT = __baseUnitMC.height;
			KEYBOARD_NOTE_HEIGTH = (KEYBOARD_UNIT_HEIGHT - 1) / 12;  //12 half steps starting at C	
			
			addKeyboarUnits();
		}
		
		public function init(midi_editor:MIDIEditor):void
		{
			__editor = midi_editor;
		}
		
		
		
		private function addKeyboarUnits():void
		{
			var unitCount:int = 3; // should be based on onte range of track
			
			for (var i:int = 0; i < unitCount; i++)
			{
				var unitMC:KeystripUnitMC = new KeystripUnitMC();
				unitMC.y = i * KEYBOARD_UNIT_HEIGHT;
				__keystripMC.addChild(unitMC);
			}
		}
	}
}