package
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxControl;
	import org.flixel.plugin.photonstorm.FlxControlHandler;
	
	public class Player extends FlxSprite
	{
		[Embed(source="../assets/char_walkR.png")] protected var ImgSpaceman:Class;
		
		
		protected var _restart:Number;
		protected var _gibs:FlxEmitter;
		protected var _map:FlxTilemap;
		protected var tileSize:Number;
		protected var spawnX:Number;
		protected var spawnY:Number;
		
		private var jumpSpeed : Number;
		private var runSpeed : Number;
		
		public static const EMPTY_TILE:Number = 0;
		public static const FLAT_TILE:Number = 1;
		public static const DOUBLE_CURVE:Number = 2;
		public static const LEFT_CURVE:Number = 7;
		public static const RIGHT_CURVE:Number = 8;
		
		//This is the player object class.  Most of the comments I would put in here
		//would be near duplicates of the Enemy class, so if you're confused at all
		//I'd recommend checking that out for some ideas!
		public function Player(X:int,Y:int)
		{
			super(X, Y);
			tileSize = 32;
			spawnX = closestTilePos(X);
			spawnY = closestTilePos(Y) + 31;
			loadGraphic(ImgSpaceman,true,true,32,64);
			_restart = 0;
			
			//bounding box tweaks
			width = 30;
			height = 64;
			offset.x = 1;
			offset.y = 1;
			
			//basic player physics
		/*	runSpeed = 160;
			drag.x = runSpeed*15;
			acceleration.y = 2000;
			maxVelocity.x = runSpeed;
			jumpSpeed = 500;
		*/	
			//animations
			addAnimation("idle", [0]);
			addAnimation("run", [0, 1, 2, 3,4,5], 12);	
			addAnimation("jump", [2]);
			addAnimation("climbTree", [2,0,2,0,2,0,2,0], 6);
			
			if ( FlxG.getPlugin(FlxControl) == null) {
				FlxG.addPlugin(new FlxControl);
			}
			FlxControl.create(this, FlxControlHandler.MOVEMENT_INSTANT, FlxControlHandler.STOPPING_INSTANT, 1, false, true);
			FlxControl.player1.setJumpButton("Up", FlxControlHandler.KEYMODE_JUST_DOWN, 200, FlxObject.FLOOR, 250, 200);
			
			
			FlxControl.player1.setJumpButton("SPACE", FlxControlHandler.KEYMODE_PRESSED, 200, FlxObject.FLOOR, 250, 200);
			FlxControl.player1.setMovementSpeed(400, 0, 100, 200, 400, 0);
			FlxControl.player1.setGravity(0, 400);
		}
		
		public function setTileMap(collisionMap:FlxTilemap):void
		{
			_map = collisionMap;
		}
		
		public function setGibEmitter(Gibs:FlxEmitter):void
		{
			_gibs = Gibs;
		}
		
		public function respawn():void
		{
			x = spawnX;
			y = spawnY;
			alive = true;
			exists = true;
			visible = true;
			solid = true;
			velocity.y = 0;
			_restart = 0;
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			_gibs = null;
		}
		
		override public function update():void
		{
			var stats : StatsTracker = (FlxG.state as PlayState).statsTracker;
			
			//game restart timer
			if(!alive)
			{
				_restart += FlxG.elapsed;
				if(_restart > 1)
				{
					respawn();
				}
				return;
			}
			if (_map!=null){
				if (this.y>_map.height)
				{
					alive=false;	
				}
			}
			
			//MOVEMENT
			/*
			acceleration.x = 0;
			if(FlxG.keys.LEFT)
			{
				facing = LEFT;
				acceleration.x -= drag.x;
			}
			else if(FlxG.keys.RIGHT)
			{
				facing = RIGHT;
				acceleration.x += drag.x;
			}
			if(FlxG.keys.justPressed("UP") && velocity.y == 0)
			{
				y -= 1;
				velocity.y = -jumpSpeed;
			}*/
			if(FlxG.keys.justPressed("Q"))
			{
				explode(4);
				
				FlxG.camera.shake(0.005,0.35);
				FlxG.camera.flash(0xffd8eba2,0.35);	    
				                
				stats.increment("explosions");

			}
			if(FlxG.keys.justPressed("W"))
			{
				if (canCreate())
				{
					createTiles();
					
					FlxG.camera.shake(0.005,0.35);
					FlxG.camera.flash(0xffd8eba2,0.35);	   
					
					stats.increment("platforms");
				}
			}
			if(FlxG.keys.justPressed("E"))
			{
				createSpawn();
				
				FlxG.camera.shake(0.005,0.35);
				FlxG.camera.flash(0xffffeba2,0.35);	
				
				stats.increment("spawn points");
			}
			if(FlxG.keys.justPressed("R"))
			{
				createTree();
				
				FlxG.camera.shake(0.005,0.35);
				FlxG.camera.flash(0x11ff11a2,0.35);	

				stats.increment("trees");
			}
			
			if(velocity.y != 0)
			{
				play("jump");
			}
			else if(velocity.x == 0)
			{
				play("idle");
			}
			else
			{
				play("run");
			}
		}
		
		override public function hurt(Damage:Number):void
		{
			Damage = 0;
			if(flickering)
				return;
			flicker(1.3);
			if(FlxG.score > 1000) FlxG.score -= 1000;
			if(velocity.x > 0)
				velocity.x = -maxVelocity.x;
			else
				velocity.x = maxVelocity.x;
			super.hurt(Damage);
		}
		
		public function explode(diameter:int):void
		{
			_map.setTile(x / tileSize, (y / tileSize) + 1, EMPTY_TILE);
			
			for (var i:int = 1; i < diameter; i++)
			{
				_map.setTile((x + (tileSize * i)) / tileSize, (y / tileSize) + 1, EMPTY_TILE);
				_map.setTile((x - (tileSize * i)) / tileSize, (y / tileSize) + 1, EMPTY_TILE);
				
				_map.setTile(x / tileSize, ((y + (tileSize * i)) / tileSize) + 1, EMPTY_TILE);
				_map.setTile(x / tileSize, ((y - (tileSize * i)) / tileSize) + 1, EMPTY_TILE);
			}

			//fill in diagonals
			_map.setTile((x+tileSize) / tileSize, ((y+tileSize) / tileSize) + 1, EMPTY_TILE);
			_map.setTile((x-tileSize) / tileSize, ((y+tileSize) / tileSize) + 1, EMPTY_TILE);
			_map.setTile((x+tileSize) / tileSize, ((y-tileSize) / tileSize) + 1, EMPTY_TILE);
			_map.setTile((x-tileSize) / tileSize, ((y-tileSize) / tileSize) + 1, EMPTY_TILE);
			
			_map.setTile((x+(tileSize *2)) / tileSize, ((y+tileSize) / tileSize) + 1, EMPTY_TILE);
			_map.setTile((x-(tileSize *2)) / tileSize, ((y+tileSize) / tileSize) + 1, EMPTY_TILE);
			_map.setTile((x+(tileSize *2)) / tileSize, ((y-tileSize) / tileSize) + 1, EMPTY_TILE);
			_map.setTile((x-(tileSize *2)) / tileSize, ((y-tileSize) / tileSize) + 1, EMPTY_TILE);
			
			_map.setTile((x+tileSize) / tileSize, ((y+(tileSize*2)) / tileSize) + 1, EMPTY_TILE);
			_map.setTile((x+tileSize) / tileSize, ((y-(tileSize*2)) / tileSize) + 1, EMPTY_TILE);
			_map.setTile((x-tileSize) / tileSize, ((y+(tileSize*2)) / tileSize) + 1, EMPTY_TILE);
			_map.setTile((x-tileSize) / tileSize, ((y-(tileSize*2)) / tileSize) + 1, EMPTY_TILE);
			
			kill();
			FlxG.camera.shake(0.005,0.35);
			FlxG.camera.flash(0xffd8eba2,0.35);
			if(_gibs != null)
			{
				_gibs.at(this);
				_gibs.start(true,5,0,50);
			}
			(FlxG.state as PlayState).killTrees(x,y);
		}
		
		public function createTiles():void
		{
			var platformHeight:int = (y / tileSize) + 1;
			
			if (facing == FlxObject.RIGHT)
			{
				_map.setTile(x / tileSize, platformHeight, FLAT_TILE);
				_map.setTile((x + width + 1) / tileSize, platformHeight, FLAT_TILE);
				_map.setTile((x + width * 2) / tileSize, platformHeight, FLAT_TILE);
				_map.setTile((x + width * 3) / tileSize, platformHeight, FLAT_TILE);
			}
			else
			{
				_map.setTile(x / tileSize, platformHeight, FLAT_TILE);
				_map.setTile((x - width) / tileSize, platformHeight, FLAT_TILE);
				_map.setTile((x - (width * 2)) / tileSize, platformHeight, FLAT_TILE);
				_map.setTile((x - (width * 3)) / tileSize, platformHeight, FLAT_TILE);
			}
			
			kill();
			FlxG.camera.shake(0.001,0.35);
			FlxG.camera.flash(0xff0000a2,0.35);
			
		}
		
		public function createSpawn():void
		{
			spawnX = x;
			spawnY = y;
			kill();
		}
		
		public function createTree():void
		{
			var tree:Tree;
			tree = new Tree(x, y-96);
			(FlxG.state as PlayState).addTree(tree);
			FlxG.state.add(tree);
			kill();
		}
		
		override public function kill():void
		{
			if(!alive)
				return;
			super.kill();
			solid = false;
			flicker(0);
			exists = true;
			visible = false;
			
			//velocity.make();
			//acceleration.make();
		}
		
		private function canCreate():Boolean
		{
			var allowCreate:Boolean = false;
			
			var closestTileX:Number = closestTilePos(x);
			var closestTileY:Number = closestTilePos(y) - 32;
			
			var creationLeftX:int = x - 128;
			var creationRightX:int = x + 160;
			
			if (this._facing == FlxObject.RIGHT)
			{
				if (spawnX < closestTileX || spawnX > creationRightX)
				{
					return true;
				}
				else if ((closestTileY + 32) < spawnY - 65 || (closestTileY + 32) > spawnY + 65)
				{
					return true;
				}
			}
			else
			{
				if (spawnX < creationLeftX || spawnX > closestTileX)
				{
					return true;
				}
				else
				{
					if ((closestTileY + 32) < spawnY - 65 || (closestTileY + 32) > spawnY + 65)
					{
						return true;
					}
				}
			}
			
			return allowCreate;
		}
		
		private function closestTilePos(pos:int):Number
		{
			return Math.floor(pos / tileSize) * tileSize;
		}
	}
}