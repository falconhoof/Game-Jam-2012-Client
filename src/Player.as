
package
{
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		[Embed(source="../assets/charAnim.png")] protected var ImgSpaceman:Class;
		
		
		protected var _restart:Number;
		protected var _gibs:FlxEmitter;
		protected var _map:FlxTilemap;
		
		//This is the player object class.  Most of the comments I would put in here
		//would be near duplicates of the Enemy class, so if you're confused at all
		//I'd recommend checking that out for some ideas!
		public function Player(X:int,Y:int)
		{
			super(X,Y);
			loadGraphic(ImgSpaceman,true,true,32);
			_restart = 0;
			
			//bounding box tweaks
			width = 32;
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
		}
		
		public function setGibEmitter(Gibs:FlxEmitter):void
		{
			_gibs = Gibs;
		}
			
		public function respawn():void
		{
			x = 64;
			y = 64;
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
				if(_restart > 3)
				{
					respawn();
				}
				return;
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
			if(FlxG.keys.justPressed("SPACE"))
			{
				explode();
				
				FlxG.camera.shake(0.005,0.35);
				FlxG.camera.flash(0xffd8eba2,0.35);
				
				
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
			_map.setTile(x / 16, y / 16, 0);
			_map.setTile((x+width+1) / 16, y / 16, 0);
			_map.setTile((x-width) / 16, y / 16, 0);
			_map.setTile(x / 16, (y+height) / 16, 0);
			_map.setTile(x / 16, (y-height) / 16, 0);
			_map.setTile((x+(width *2)) / 16, y / 16, 0);
			_map.setTile((x-(width *2)) / 16, y / 16, 0);
			_map.setTile(x / 16, (y+(height*2)) / 16, 0);
			_map.setTile(x / 16, (y-(height*2)) / 16, 0);
			_map.setTile((x+(width *3)) / 16, y / 16, 0);
			_map.setTile((x-(width *3)) / 16, y / 16, 0);
			_map.setTile(x / 16, (y+(height*3)) / 16, 0);
			_map.setTile(x / 16, (y-(height*3)) / 16, 0);
			kill();
			FlxG.camera.shake(0.005,0.35);
			FlxG.camera.flash(0xffd8eba2,0.35);
			
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
			FlxG.camera.shake(0.005,0.35);
			FlxG.camera.flash(0xffd8eba2,0.35);
			if(_gibs != null)
			{
				_gibs.at(this);
				_gibs.start(true,5,0,50);
			}
		}
	}
}