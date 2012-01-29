package
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxControl;
	import org.flixel.plugin.photonstorm.FlxControlHandler;
	
	public class Player extends FlxSprite
	{
		[Embed(source = "../assets/char_walkR.png")] protected var ImgSpaceman:Class;
		[Embed(source = "../assets/Audio_Explosion.mp3")] private var explosionSound:Class;
		[Embed(source = "../assets/Audio_CreatePlatform.mp3")] private var createPlatformSound:Class;
		[Embed(source = "../assets/Audio_CreateTree.mp3")] private var createTreeSound:Class;
		[Embed(source = "../assets/Audio_SpawnIn.mp3")] private var spawnInSound:Class;
		[Embed(source = "../assets/Audio_Footstep_Fixed.mp3")] private var footstepSound:Class;
		
		private var footstep:FlxSound;
		
		protected var _restart:Number;
		protected var _gibs:FlxEmitter;
		protected var _map:FlxTilemap;
		protected var tileSize:Number;
		protected var spawnX:Number;
		protected var spawnY:Number;
		protected var keyboardInputEnabled:Boolean;
		public var treeToClimb:Tree;
		public var canClimb:Boolean;
		protected var spawnSprite:PlayerSpawn;
		protected var spawning:Boolean;
		protected var spawnTimer: Number;
		protected var creation:CreationSprite;
		protected var createX: Number;
		protected var createY:Number;
		
		private var jumpSpeed : Number;
		private var runSpeed : Number;
		
		public static const EMPTY_TILE:Number = 0;
		public static const FLAT_TILE:Number = 1;
		public static const DOUBLE_CURVE:Number = 2;
		public static const LEFT_CURVE:Number = 7;
		public static const RIGHT_CURVE:Number = 8;
		
		public var treesLeft : Number;
		public var explosionsLeft : Number;
		public var platformsLeft : Number;
		public var respawnsLeft : Number;
		
		public var sacrifices : Array;
		public var currentSacrifice : Number;
		
		public var treeClimbSprite:TreeClimbSprite;
		
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
			spawnTimer = 0;
			canClimb = false;
			keyboardInputEnabled = true;
			
			//bounding box tweaks
			width = 30;
			height = 64;
			offset.x = 1;
			offset.y = 1;
			
			//basic player physics
			runSpeed = 160;
			drag.x = runSpeed*15;
			acceleration.y = 2000;
			maxVelocity.x = runSpeed;
			
			treesLeft = 0;
			explosionsLeft = 0;
			platformsLeft = 0;
			
			jumpSpeed = 500;
			//animations
			addAnimation("idle", [6]);
			addAnimation("run", [4, 5, 0, 1, 2, 3], 25);	
			addAnimation("jump", [7]);
			addAnimation("climbTree", [3,4,7,4,3], 25);
			
			sacrifices = new Array();
			sacrifices.push("Platforms");
			sacrifices.push("Explosions");
			sacrifices.push("Trees");
			
			
			currentSacrifice = 0;
			
			FlxG.play(spawnInSound);
			
			footstep = new FlxSound();
			footstep.loadEmbedded(footstepSound, true, true);
			

		/*	if ( FlxG.getPlugin(FlxControl) == null) {
				FlxG.addPlugin(new FlxControl);
			}
			FlxControl.create(this, FlxControlHandler.MOVEMENT_INSTANT, FlxControlHandler.STOPPING_INSTANT, 1, true, true);
			//FlxControl.player1.setJumpButton("UP", FlxControlHandler.KEYMODE_JUST_DOWN, 50000, FlxObject.FLOOR & FlxObject.CEILING, 250, 200);
			
			//FlxControl.player1.setJumpButton("SPACE", FlxControlHandler.KEYMODE_PRESSED, 200, FlxObject.FLOOR, 250, 200);
			FlxControl.player1.setMovementSpeed(400, 0, 100, 400, 400, 0);
			FlxControl.player1.setGravity(0, 40000);
			//FlxControl.player1.setMaximumSpeed(200,400000);*/
		}
		
		
		public function getSacrifice() : String {
			
			return sacrifices[currentSacrifice];
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
			//	spawnTimer = new FlxTimer();
			x = spawnX;
			y = spawnY ;
				
			respawnAnimation();		
			spawnTimer += FlxG.elapsed;
			if(spawnTimer > 1.8)
			{	
				respawnCharacter();		
			}		
		}
		
		public function respawnAnimation():void
		{
			//spawn animation
			if (!spawning)
			{
				spawning = true;
				spawnSprite = new PlayerSpawn(spawnX -48,spawnY-48);
				FlxG.state.add(spawnSprite);
				spawnSprite.play("spawn");
			}
		}
		
		public function respawnCharacter():void
		{
			spawning = false;
			alive = true;
			solid = true;
			exists = true;
			visible = true;
			FlxG.play(spawnInSound);
			velocity.y = -400;
			_restart = 0;
			spawnTimer = 0;
			FlxG.state.remove(spawnSprite);
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
			if(FlxG.keys.justPressed("UP") && canClimb)
			{
				//climb tree
				//climbTree();
				
			}
			else if(FlxG.keys.justPressed("UP") && velocity.y == 0)
			{
				y -= 1;
				velocity.y = -jumpSpeed;
			}
			if(FlxG.keys.justPressed("UP") && velocity.y == 0)
			{
				y -= 1;
				velocity.y = -jumpSpeed;
			}
			/*
			if(FlxG.keys.justPressed("Q"))
			{
				if ( explosionsLeft > 0 ) {
					explosionsLeft--;
					explode(4);
					
					FlxG.camera.shake(0.005,0.35);
					FlxG.camera.flash(0xffd8eba2,0.35);	    
					FlxG.play(explosionSound, 1.0);
					stats.increment("explosions");
				}
			}
			if(FlxG.keys.justPressed("W"))
			{
				if (canCreate())
				{
					if ( platformsLeft > 0 ) {
						platformsLeft --;
						createTiles();
						
						FlxG.camera.shake(0.005,0.35);
						FlxG.camera.flash(0xffd8eba2,0.35);	   
						
						stats.increment("platforms");
					}
					
				}
			}*/
			if(FlxG.keys.justPressed("E"))
			{
				if ( respawnsLeft > 0 ) {
					respawnsLeft--;
					createSpawn();
					
					FlxG.camera.shake(0.005,0.35);
					FlxG.camera.flash(0xffffeba2,0.35);	
					
					stats.increment("spawn_points");
				}
			}
			/*
			if(FlxG.keys.justPressed("R"))
			{
				if ( treesLeft > 0 ) {
					treesLeft--;
					createTree();
					
					FlxG.camera.shake(0.005,0.35);
					FlxG.camera.flash(0x11ff11a2,0.35);	
	
					stats.increment("trees");
				}
			}*/
			
			if ( FlxG.keys.justPressed("SHIFT")  || FlxG.keys.justPressed("TAB")) {
				currentSacrifice ++;
				if ( currentSacrifice > (sacrifices.length-1)) {
					currentSacrifice = 0;
					//tell play state to shift icon

				}
				var playState=FlxG.state as PlayState;
				playState.switchPowerUI(currentSacrifice);
			}
			
			if ( FlxG.keys.justPressed("SPACE")) {
				if ( sacrifices[currentSacrifice] == "Trees" ) {
					if ( treesLeft > 0 ) {
						treesLeft--;
						createTree();
						
						FlxG.camera.shake(0.005,0.35);
						FlxG.camera.flash(0x11ff11a2,0.35);	
						
						FlxG.play(createTreeSound);
						
						stats.increment("trees");
					}
				} else if ( sacrifices[currentSacrifice] == "Explosions") {
					if ( explosionsLeft > 0 ) {
						explosionsLeft--;
						explode(3);
						
						FlxG.camera.shake(0.005,0.35);
						FlxG.camera.flash(0xffd8eba2,0.35);	    
						
						FlxG.play(explosionSound);
						
						stats.increment("explosions");
					}
				} else if ( sacrifices[currentSacrifice] == "Platforms") {
					if (canCreate())
					{
						if ( platformsLeft > 0 ) {
							platformsLeft --;
							createTiles();
							
							FlxG.camera.shake(0.005,0.35);
							FlxG.camera.flash(0xffd8eba2, 0.35);	
							
							FlxG.play(createPlatformSound);
							
							stats.increment("platforms");
						}
						
					}
				} 
			}
			
			if(velocity.y != 0)
			{
				play("jump");
				footstep.stop();
			}
			else if(velocity.x == 0)
			{
				play("idle");
				footstep.stop();
			}
			else
			{
				play("run");
				footstep.play();
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
			var explosion:Explode;
			explosion = new Explode((x-59), (y-43));
			FlxG.state.add(explosion);
			kill();
			explosion.play("grow");
			
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
			// FlxG.camera.flash(0xffd8eba2,0.35);
			if(_gibs != null)
			{
				_gibs.at(this);
				_gibs.start(true,5,0,50);
			}
			(FlxG.state as PlayState).killTrees(x,y);
		}
		
		public function tilesCreated(name:String, frameNo:uint, frameInd:uint):void
		{
			if (frameNo == 14)
			{
				actualCreateTiles();
				FlxG.state.remove(creation);
			}
				
		}
		
		public function actualCreateTiles():void
		{
			
			
			
			FlxG.log("actual create tiles" );
			var platformHeight:int = (createY / tileSize) + 1;
			/*
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
			}*/
			
			//   O
			// XXXXX
			// block of 5 tiles, centred on player
			_map.setTile(createX / tileSize, platformHeight, FLAT_TILE);
			//one to each side
			_map.setTile((createX+tileSize+1) / tileSize, platformHeight, FLAT_TILE);
			_map.setTile((createX-tileSize) / tileSize,  platformHeight, FLAT_TILE);
			//second on each side
			_map.setTile((createX+(tileSize *2)) / tileSize,  platformHeight, FLAT_TILE);
			_map.setTile((createX-(tileSize *2)) / tileSize, platformHeight, FLAT_TILE);
			
			
			
			
			FlxG.camera.shake(0.001,0.35);
			FlxG.camera.flash(0xff0000a2,0.35);
			
		}
		
		public function createTiles():void
		{
			createX = x;
			createY = y;
			creation = new CreationSprite((closestTilePos(x)-64), (closestTilePos(y)-32));
			FlxG.state.add(creation);
			
			creation.addAnimationCallback(tilesCreated);
			creation.play("create");
			kill();
			
			
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
			tree = new Tree(x, y-64);
			(FlxG.state as PlayState).addTree(tree);
			FlxG.state.add(tree);
			kill();
			tree.play("grow");
		}

		public function climbTree(tree:Tree):void
		{
			keyboardInputEnabled = false;
			FlxG.log("playerxa " + x);
			treeToClimb=tree;
			treeClimbSprite=new TreeClimbSprite(0,0);
			treeClimbSprite.x=treeToClimb.x;
			treeClimbSprite.y=treeToClimb.y-64;
			FlxG.log("playerxb " + x);
			FlxG.state.add(treeClimbSprite);
			//treeToClimb.visible=false;
			
			treeClimbSprite.addAnimationCallback(treeAnimationDone);
			
			this.visible=false;
			treeClimbSprite.play("Climb");
			FlxG.log("playerxc " + x);
			
			//Comment out put back in animation is feckered
			//play("climbTree");
			
			//when animation finished teleport to top of tree
			//solid = false;
			//treeToClimb.canopy.solid = false;
			//y = treeToClimb.y - this.height - 20 ;
			//treeToClimb.canopy.solid = true;
			//solid = true;
		//	treeToClimb.y;
			//keyboardInputEnabled = true;
			
		}
		
		function treeAnimationDone(name:String,frameNo:uint,frameIndex:uint):void
		{
				if (frameIndex==7)
				{
					
					//treeToClimb.visible=true;

				
				//	y = treeToClimb.y - this.height - 20 ;
			
					//	treeToClimb.y;
					x = x + 32;
					treeClimbSprite.visible=false;
					this.visible=true;
					FlxG.state.remove(treeClimbSprite);
				}
			
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
			
			var creationLeftX:int = x - 96;
			var creationRightX:int = x + 96;
			
			/*if (this._facing == FlxObject.RIGHT)
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
			*/
			if (spawnX < creationLeftX || spawnX > creationRightX)
			{
				return true;
			}
			else if ((closestTileY + 32) < spawnY - 65 || (closestTileY + 32) > spawnY + 65)
			{
				return true;
			}
			
			return allowCreate;
		}
		
		private function closestTilePos(pos:int):Number
		{
			return Math.floor(pos / tileSize) * tileSize;
		}
	}
}