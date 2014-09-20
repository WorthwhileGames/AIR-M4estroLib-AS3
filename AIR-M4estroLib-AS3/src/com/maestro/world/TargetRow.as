﻿package com.maestro.world 
{
	import com.disney.base.BaseMovieClip;
	
	/**
	 * ...
	 * @author ...
	 */
	public class TargetRow extends BaseMovieClip
	{
		private var gameBoard:GameBoard;
		private var row:Row;
		
		public var targets:Array;
		public var allTargetsMatched:Boolean;
		public var displayIndex:int;
		
		
		public function TargetRow() 
		{
			
		}
		
		public function init(_row:Row, game_board:GameBoard, index:int): void
		{
			log("TargetRow.init: row: " + _row + ", game_board: " + game_board, "NoteTris");
			log("TargetRow.init: row.units(): " + _row.units(), "NoteTris");
			
			row = _row;
			gameBoard = game_board;
			displayIndex = index;
			targets = new Array();
			allTargetsMatched = false;
			
			var units:Array = row.units();
			var unitsCount:int = units.length;
			var nextX:int = 0;
			
			for (var i:int = 0; i < unitsCount; i++)
			{
				var unit:int = units[i];
				var newTarget:Target = new Target();

				newTarget.init(unit);
				newTarget.x = nextX;
				nextX = nextX + newTarget.width;
				newTarget.y = gameBoard.GAMEBOARD_HEIGHT - (newTarget.height + newTarget.height * displayIndex);
				
				newTarget.alpha = .5;
				
				gameBoard.addChild(newTarget);
				targets.push(newTarget);
			}			
		
		}
		
		public function isTargetMatched(block:Block): Boolean
		{
			var targetCount:int = targets.length;
			var targetMatched:Boolean = false;
			
			allTargetsMatched = true;
			
			for (var j:int = 0; j < targetCount; j++)
			{
				var thisTarget:Target = targets[j] as Target;
				
				if (!thisTarget.matched && (block.x == thisTarget.x) && (block.duration == thisTarget.duration))
				{
					if (block.y >= (thisTarget.y - 5))
					{
						block.y = thisTarget.y;
						block.settle();
						thisTarget.match();
						thisTarget.select();
						targetMatched = true;
					}
				}
				if (!thisTarget.matched)
				{
					allTargetsMatched = false;
				}
			}
			
			return targetMatched;
		}
		
		public function cleanup(): void
		{
			if (targets)
			{
				var targetCount:int = targets.length;
				
				log("targets: " +targets, "NoteTris");
				
				for (var j:int = 0; j < targetCount; j++)
				{
					var thisTarget:Target = targets[j] as Target;
					
					gameBoard.removeChild(thisTarget);
					thisTarget.destroy();
				}
			}
			
			targets = null;
			gameBoard = null;
			destroy();
		}
	}
	
}