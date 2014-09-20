﻿package com.maestro.world 
{
	import com.disney.base.BaseMovieClip;
	//import com.disney.games.notetris.NoteTris;
	//import com.disney.trumpet3d.pipeline.primitiverenderers.VectorLineRenderer;
	import com.maestro.music.MusicManager;
	import com.maestro.music.musicxml.Measure;
	import com.maestro.music.musicxml.Part;
	import com.maestro.music.song.Section;
	import com.maestro.music.song.Soundtrack;
	import flash.geom.Rectangle;
	
	import com.maestro.managers.InputManager;
	import com.maestro.controller.GameTimer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GameBoard extends BaseMovieClip
	{
		private const NUM_ROWS:int = 10;
		
		public var GAMEBOARD_HEIGHT:int;
		public var GAMEBOARD_WIDTH:int;
		
		//private var __gameController:NoteTris;
		private var blocks:Array;
		private var blocksSettled:Array;
		private var rows:Array;
		private var currentRow:Row;
		private var currentRowIndex:int;
		private var targetRows:Array;
		private var currentTargetRow:TargetRow;
		private var activeBlock:Block;
		private var activeBlockIndex:int;
		private var targetDisplayIndex:int;
		
		private var paused:Boolean = true;
		
		public function GameBoard() 
		{
			
		}
		
		//public function init(gameController:NoteTris): void
		public function init(): void
		{
			//__gameController = gameController;
			
			GAMEBOARD_HEIGHT = this.height;
			GAMEBOARD_WIDTH = this.width;
		}
			
		public function restart():void 
		{
				
			cleanup();
			
			
			rows = new Array();
			var soundtrack:Soundtrack = MusicManager.instance.currentSoundtrack;
			log("restart: " + soundtrack.sections, "NoteTris");
			var part:Part = soundtrack.getSectionWithIndex(0).parts[0];
			var measure:Measure;
			
			//Use measures instead
			
			for each (measure in part.measures)
			{
				log("measure: " + measure, "NoteTris");
				var newRow:Row = new Row();
				newRow.initWithMeasure(measure);
				rows.push(newRow);
			}
			
			
			blocks = new Array();
			blocksSettled = new Array();
			
			targetRows = new Array();
			
			//Implement start screens
			//Move this stuff to NoteTris.as
			
			//Show first row
			currentRowIndex = 0;
			currentRow = rows[currentRowIndex];
			
			targetDisplayIndex = 0;
			createTargetFromRow(currentRow);
			
			//Drop blocks needed by the row
			createBlocksFromRow(currentRow);
			
			activeBlockIndex = 0;
			activeBlock = blocks[activeBlockIndex];
			activeBlock.select();
			
			InputManager.setKeyTimerDuration(InputManager.FORWARD, 200);
			InputManager.setKeyTimerDuration(InputManager.BACK, 200);
			InputManager.setKeyTimerRepeatParameters(InputManager.BACK, false, 0);
			InputManager.setKeyTimerDuration(InputManager.SHOOT, 200);
			InputManager.setKeyTimerRepeatParameters(InputManager.SHOOT, false, 0);
			
			InputManager.setKeyTimerDuration(InputManager.XTRA, 200);
			InputManager.setKeyTimerDuration(InputManager.ROTATE_LEFT, 50);
			InputManager.setKeyTimerRepeatParameters(InputManager.ROTATE_LEFT, true, 4);
			
			InputManager.setKeyTimerDuration(InputManager.ROTATE_RIGHT, 50);
			InputManager.setKeyTimerRepeatParameters(InputManager.ROTATE_RIGHT, true, 4);
			
			this.scrollRect = new Rectangle(0, 0, GAMEBOARD_WIDTH, GAMEBOARD_HEIGHT);
			
			paused = false;
			
		}
		
		public function cleanup():void
		{
			var block:Block;
			var row:Row;
			var target_row:TargetRow;
			
			for each (block in blocks)
			{
				removeChild(block);
				block.cleanup();
			}
			
			for each (block in blocksSettled)
			{
				removeChild(block);
				block.cleanup();
			}
			
			for each (row in rows)
			{
				//removeChild(row);
				row.cleanup();
			}
			
			for each (target_row in targetRows)
			{
				//removeChild(target_row);
				target_row.cleanup();
			}
		}
		
		public function togglePaused():Boolean
		{
			paused = !paused;
			return paused;
		}
		
		public function pause():void
		{
			paused = true;
		}
		
		public function update(elapsed:Number): void
		{
			
			
			handleInput();
			
			if (!paused)
			{
				var blockCount:Number = blocks.length;
				
				if (currentTargetRow.allTargetsMatched)
				{
					MusicManager.instance.playNextPerformer();
					
					log("All Targets Matched: " + blocksSettled, "NoteTris");
					//removeSettledBlocks();
					removeTargetRow(currentTargetRow);
					//paused = true;
					//get next row
					//make new target row
					//make new blocks
					
					currentRowIndex += 1;
					currentRow = rows[currentRowIndex];
			
					createTargetFromRow(currentRow);
			
					//Drop blocks needed by the row
					createBlocksFromRow(currentRow);
					
					activeBlockIndex = 0;
					activeBlock = blocks[activeBlockIndex];
					activeBlock.select();
					
					//__gameController.soundController.queueSound(__gameController.soundDrums, __gameController.beat4th);
					
				}
				
				for (var i:Number = 0; i < blockCount; i++)
				{
					var thisBlock:Block = blocks[i] as Block;
					thisBlock.update(elapsed);
				}

				//Test for successful block drop onto target slots
				if (blocks.length > 0)
				{
					checkBlocksAgainstTargetRow(currentTargetRow);
				}
				
				//reward for successful block drop
				
				//Miss-placed block restarts row

				//Tab to cycle selected block
				
				//Space drops all blocks
			}
		}
		
		private function createTargetFromRow(_row:Row):void 
		{
			var targetRow:TargetRow = new TargetRow();
			targetRow.init(currentRow, this, targetDisplayIndex);
			targetRows.push(targetRow);
			currentTargetRow = targetRow;
			targetDisplayIndex++;
		}
		
		private function createBlocksFromRow(row:Row):void
		{
			log("createBlocksFromRow: row: " + row, "NoteTris");
			log("createBlocksFromRow: row.units(): " + row.units(), "NoteTris");
			
			var units:Array = row.units();
			var unitsCount:int = units.length;
			var nextX:int = 0;
			
			for (var i:int = 0; i < unitsCount; i++)
			{
				var unit:int = units[i];
				var newBlock:Block = new Block();
				
				newBlock.init(unit);
				var durationRange:int = (GAMEBOARD_WIDTH / Block.PIXELS_PER_DURATION_UNIT) - newBlock.duration;
				log("createBlocksFromRow: durationRange: " + durationRange, "NoteTris");
				var randDuration:int = Math.floor( Math.random() * durationRange);
				log("createBlocksFromRow: randDuration: " + randDuration, "NoteTris");
				newBlock.x = randDuration * Block.PIXELS_PER_DURATION_UNIT;
				nextX = nextX + newBlock.width;
				newBlock.y = 0 - (2 * i * Block.PIXELS_PER_VERTICAL_UNIT);
				addChild(newBlock);
				blocks.push(newBlock);
			}
		}
		
		private function checkBlocksAgainstTargetRow(current_target_row:TargetRow): void
		{
			var blockCount:int = blocks.length;
			var targets:Array =  current_target_row.targets;
			var targetCount:int = targets.length;
			var blockSettled:Boolean = false;
			
			for (var i:int = 0; i < blockCount; i++)
			{
				var thisBlock:Block = blocks[i] as Block;
				
					if (current_target_row.isTargetMatched(thisBlock))
					{
						blockSettled = true;
					}
					
					//wrap missed blocks to top of board
					if (thisBlock.y > GAMEBOARD_HEIGHT)
					{
						thisBlock.y = 0 - thisBlock.height;
						thisBlock.fallNormal();
					}
			}
			
			if (blockSettled)
			{
				var newBlocks:Array = new Array();
				
				for (i = 0; i < blockCount; i++)
				{
					thisBlock = blocks[i] as Block;
					thisBlock.unSelect();
					
					if (!thisBlock.settled)
					{
						newBlocks.push(thisBlock);
					}
					else 
					{
						blocksSettled.push(thisBlock);
					}
				}
				
				blocks = newBlocks;
				
				log("blocks: " + blocks, "NoteTris");
				log("blocksSettled: " + blocksSettled, "NoteTris");
				
				activeBlockIndex = 0;
				activeBlock = blocks[activeBlockIndex] as Block;
				if (activeBlock !=null) activeBlock.select();
			}
		}
		
		private function removeTargetRow(target_row:TargetRow): void
		{
			target_row.cleanup();
		}
		
		private function removeSettledBlocks(): void
		{
			var blockCount:int = blocksSettled.length;
			
			for (var i:int = 0; i < blockCount; i++)
			{
				var thisBlock:Block = blocksSettled[i] as Block;
				
				log("Removing: " + thisBlock, "NoteTris");
				removeChild(thisBlock);
				thisBlock.cleanup();
				thisBlock = null;
			}
			
			blocksSettled = [];
		}
				
		public function selectNextBlock(): void
		{
			activeBlock.unSelect();
			
			activeBlockIndex++;
			if (activeBlockIndex >= blocks.length)
			{
				activeBlockIndex = 0;
			}
			
			activeBlock = blocks[activeBlockIndex];
			activeBlock.select();
		}
		
		private function moveBlock(block:Block, dir:int): void
		{

			switch (dir)
			{
				case Direction.LEFT:
					if (((block.x + block.width) - Block.PIXELS_PER_DURATION_UNIT) >= 0)
					{
						block.x -= Block.PIXELS_PER_DURATION_UNIT;
					}
					else
					{
						block.x = GAMEBOARD_WIDTH - Block.PIXELS_PER_DURATION_UNIT; // block.width;
					}
					break;
					
				case Direction.RIGHT:
					if ((block.x + Block.PIXELS_PER_DURATION_UNIT) <= GAMEBOARD_WIDTH)
					{
						block.x += Block.PIXELS_PER_DURATION_UNIT;
					}
					else
					{
						block.x = Block.PIXELS_PER_DURATION_UNIT - block.width;
					}
					break;
			}
		}
		
		
		private function handleInput(): void
		{
			
			if (InputManager.checkInputState(InputManager.QUIT)) {
				//quit
			}
				
			if (InputManager.checkInputState(InputManager.ROTATE_LEFT)) {
				moveBlock(activeBlock, Direction.LEFT);
			}
			
			if (InputManager.checkInputState(InputManager.ROTATE_RIGHT)) {
				moveBlock(activeBlock, Direction.RIGHT);
			}

				
			//if (InputManager.checkInputState(InputManager.XTRA)) {
			//	activeBlock.fallNormal();
			//	selectNextBlock();
			//}
			
			if (InputManager.checkInputState(InputManager.SHOOT)) {
				var blocksLength:int = blocks.length;
				for (var i:int = 0; i < blocksLength; i++)
				{
					blocks[i].drop();
				}
			}

			//if (InputManager.checkInputState(InputManager.SHIELD)) {
			//	paused = !paused;
			//}
			
			if (InputManager.checkInputState(InputManager.FORWARD)) {
				activeBlock.fallSlow();
			}
			
			if (InputManager.checkInputState(InputManager.BACK)) {
				activeBlock.drop();
				selectNextBlock();
			}

			
			if (InputManager.checkInputState(InputManager.USE_POWERUP)) {
				//PowerupManager.deactivatePowerup();
			}
			
		}
	}
}