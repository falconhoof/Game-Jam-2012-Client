//NOTE TO SELF: Need to add an empty tile at start(0) of tilesets
//NOTE TO SELF: Some Issues with tileset need to sort
package
{
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		[Embed(source="../assets/charAnim.png")] protected var ImgSpaceman:Class;
		
		
		protected var _restart:Number;
		protected var _gibs:FlxEmitter;
		protected var _map:FlxTilemap;
		protected var tileSize:Number;
		protected var spawnX:Number;
		protected var spawnY:Number;
		
		public static const FLAT_TILE:Number=6;
		
		//This is the player object class.  Most of the comments I would put in here
		//would be near duplicates of the Enemy class, so if you're confused at all
		//I'd recommend checking that out for some ideas!
		public function Player(X:int,Y:int)
		{
			super(X,Y);
			spawnX = X;
			spawnY = Y-50;
			loadGraphic(ImgSpaceman,true,true,32);
			_restart = 0;
			
			//bounding box tweaks
			width = 30;
			height = 32;
			offset.x = 1;
			offset.y = 1;
			
			//basic player physics
			var runSpeed:uint = 80;
			drag.x = runSpeed*8;
			acceleration.y = 420;
			maxVelocity.x = runSpeed;
			
			
			//animations
			addAnimation("idle", [0]);
			addAnimation("run", [0, 1, 2, 3,4,5,6], 12);	
			addAnimation("jump", [2]);
			
		}
		
		public function setTileMap(collisionMap:FlxTilemap):void
		{
			_map = collisionMap;
			tileSize = 32;
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
			acceleration.y = 420;
			maxVelocity.x = 80;
			_restart = 0;
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			_gibs = null;
		}
		
		override public function update():void
		{
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
			
			if (this.y>_map.height)
			{
				alive=false;	
			}
			
			//MOVEMENT
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
				velocity.y = -200;
			}
			if(FlxG.keys.justPressed("Q"))
			{
				explode();
				
				FlxG.camera.shake(0.005,0.35);
				FlxG.camera.flash(0xffd8eba2,0.35);	
			}
			if(FlxG.keys.justPressed("W"))
			{
				createTiles();
				
				FlxG.camera.shake(0.005,0.35);
				FlxG.camera.flash(0xffd8eba2,0.35);	
			}
			if(FlxG.keys.justPressed("E"))
			{
				createSpawn();
				
				FlxG.camera.shake(0.005,0.35);
				FlxG.camera.flash(0xffffeba2,0.35);	
			}
			
			
			
			//ANIMATION
			//ANIMATION
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
		
		public function explode():void
		{
			_map.setTile(x / tileSize, y / tileSize, 0);
			//one to each side
			_map.setTile((x+width+1) / tileSize, y / tileSize, 0);
			_map.setTile((x-width) / tileSize, y / tileSize, 0);
			//one up one down
			_map.setTile(x / tileSize, (y+height) / tileSize, 0);
			_map.setTile(x / tileSize, (y-height) / tileSize, 0);
			//second on each side
			_map.setTile((x+(width *2)) / tileSize, y / tileSize, 0);
			_map.setTile((x-(width *2)) / tileSize, y / tileSize, 0);
			//second up and down
			_map.setTile(x / tileSize, (y+(height*2)) / tileSize, 0);
			_map.setTile(x / tileSize, (y-(height*2)) / tileSize, 0);
			//fill in diagonals
			_map.setTile((x+width+1) / tileSize, (y+height) / tileSize, 0);
			_map.setTile((x-width) / tileSize, (y+height) / tileSize, 0);
			_map.setTile((x+width+1) / tileSize, (y-height) / tileSize, 0);
			_map.setTile((x-width) / tileSize, (y-height) / tileSize, 0);
			
			_map.setTile((x+(width *2)) / tileSize, (y+height) / tileSize, 0);
			_map.setTile((x-(width *2)) / tileSize, (y+height) / tileSize, 0);
			_map.setTile((x+(width *2)) / tileSize, (y-height) / tileSize, 0);
			_map.setTile((x-(width *2)) / tileSize, (y-height) / tileSize, 0);
			
			_map.setTile((x+width+1) / tileSize, (y+(height*2)) / tileSize, 0);
			_map.setTile((x+width+1) / tileSize, (y-(height*2)) / tileSize, 0);
			_map.setTile((x-width+1) / tileSize, (y+(height*2)) / tileSize, 0);
			_map.setTile((x-width+1) / tileSize, (y-(height*2)) / tileSize, 0);
			
			
			//third on each side
			_map.setTile((x+(width *3)) / tileSize, y / tileSize, 0);
			_map.setTile((x-(width *3)) / tileSize, y / tileSize, 0);
			//third up and down
			_map.setTile(x / tileSize, (y+(height*3)) / tileSize, 0);
			_map.setTile(x / tileSize, (y-(height*3)) / tileSize, 0);
			kill();
			FlxG.camera.shake(0.005,0.35);
			FlxG.camera.flash(0xffd8eba2,0.35);
			if(_gibs != null)
			{
				_gibs.at(this);
				_gibs.start(true,5,0,50);
			}
		}
		
		public function createTiles():void
		{
			if (this._facing == FlxObject.RIGHT)
			{
				_map.setTile(x / tileSize, y / tileSize, FLAT_TILE);
				_map.setTile((x + width + 1) / tileSize, y / tileSize, FLAT_TILE);
				_map.setTile((x + width * 2) / tileSize, y / tileSize, FLAT_TILE);
				_map.setTile((x + width * 3) / tileSize, y / tileSize, FLAT_TILE);
			}
			else
			{
				_map.setTile(x / tileSize, y / tileSize, FLAT_TILE);
				_map.setTile((x - width) / tileSize, y / tileSize, FLAT_TILE);
				_map.setTile((x - (width * 2)) / tileSize, y / tileSize, FLAT_TILE);
				_map.setTile((x - (width * 3)) / tileSize, y / tileSize, FLAT_TILE);
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
		
		override public function kill():void
		{
			if(!alive)
				return;
			super.kill();
			solid = false;
			flicker(0);
			exists = true;
			visible = false;
			velocity.make();
			acceleration.make();
			
		}
	}
}