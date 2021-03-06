package
{
	import flash.display.BlendMode;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	
	import org.flixel.*;
	//import org.osmf.layout.AbsoluteLayoutFacet;
	
	public class PlayState extends FlxState
	{
		// Tileset that works with AUTO mode (best for thin walls)
		[Embed(source = '../assets/auto_tiles.png')]private static var auto_tiles:Class;
		
		// Tileset that works with ALT mode (best for thicker walls)
		[Embed(source = '../assets/alt_tiles.png')]private static var alt_tiles:Class;
		
		// Tileset that works with OFF mode (do what you want mode)
		[Embed(source = '../assets/empty_tiles.png')]private static var empty_tiles:Class;
		
		// Default tilemaps. Embedding text files is a little weird.
		[Embed(source = '../assets/default_auto.txt', mimeType = 'application/octet-stream')]private static var default_auto:Class;
		[Embed(source = '../assets/default_alt.txt', mimeType = 'application/octet-stream')]private static var default_alt:Class;
		[Embed(source = '../assets/default_empty.txt', mimeType = 'application/octet-stream')]private static var default_empty:Class;
		
		[Embed(source="../assets/spaceman.png")] private static var ImgSpaceman:Class;
		[Embed(source="../assets/gib.png")] private static var ImgGibs:Class;
		
		
		// graphics
		[Embed(source="../assets/bg_gradientA.png")] private var BgGradientA:Class;
		[Embed(source="../assets/fg_InverseVignette.png")] private static var FgInverseVignetteClass:Class;

		[Embed(source="../assets/fg_SunlightGradient.png")] private static var FgSunlightGradientClass:Class;
		[Embed(source = "../assets/fg_letterbox.png")] private static var FgLetterboxClass:Class;
		
		[Embed(source = "../assets/Audio_Ambience.mp3")] private var ambientSound:Class;
		[Embed(source = "../assets/Audio_Pickup.mp3")] private var pickUpSound:Class;
		private var ambientPlayback:FlxSound;

		[Embed(source="../assets/fg_mistFX.png")] private static var FgMistClass:Class;
		
		//Power UI Assets
		[Embed(source="../assets/ui_explodeIcon.png")] private static var explodeIconClass:Class;
		[Embed(source="../assets/ui_platformIcon.png")] private static var platformIconClass:Class;
		[Embed(source="../assets/ui_treeIcon.png")] private static var treeIcon:Class;
		
		// graphics classes
		private var fgInverseVignette : FlxSprite;
		private var fgMist : FlxSprite;
		private var fgLetterbox : FlxSprite;
		private var gradientA : FlxSprite;
		
		// movieclip
		private var mcLoader:Loader = new Loader();
		private var movieEffects : MovieClip;
		
		// stats tracking
		public var statsTracker : StatsTracker;
		private var loadJSONData : JSONLoad;
		
		//Button for restart

		
		// Some static constants for the size of the tilemap tiles
		private const TILE_WIDTH:uint = 16;
		private const TILE_HEIGHT:uint = 16;
		
		// The FlxTilemap we're using
		private var collisionMap:FlxTilemap;
		
		//This is the current map
		private var map:MapBase;
		
		// We need to know which level it is for logic
		private var levelId : Number;
		
		// Box to show the user where they're placing stuff
		private var highlightBox:FlxObject;
		
		// Player modified from "Mode" demo
		private var player:Player;
		
		private var exit:Exit;
		private var exitTransition:Boolean;
		protected var trees:FlxGroup;
		public var canopies:FlxGroup;
		protected var explosions:FlxGroup;
		protected var pickups:FlxGroup;
		protected var pickupScoreDisplay:FlxGroup;
		protected var iconDisplay:FlxGroup;

		// Some interface buttons and text
		private var autoAltBtn:FlxButton;
		private var resetBtn:FlxButton;
		private var quitBtn:FlxButton;
		private var helperTxt:FlxText;
		private var lastSacrifice:Number=0;
		
		
		private var sacrificeText:FlxText;
		
		protected var _littleGibs:FlxEmitter;
		
		public var tutorialTriggers : Array;
		public var levels:Array;
		
		public var endLevel:Boolean=false;
		
		public function PlayState(level:Number)
		{
			levelId=level;
		}
		
		//Callback function to retrieve sprites from map
		protected function onMapAddCallback(spr:FlxSprite):void
		{
			if(spr is Player) {
				player = spr as Player;
			}
			else if (spr is Exit)
			{
				exit=spr as Exit;
			}
			else if(spr is TutorialTrigger)
			{
				tutorialTriggers.push(spr as TutorialTrigger);
				//create text element and add
				//it to the 
			}
			else if (spr is Tree)
			{
				trees.add(spr as Tree);
				(spr as Tree).play("idle");
			}
			else if (spr is Pickup)
			{
				pickups.add(spr as Pickup);
			}
		}
		
		public function OnStartLevel():void
		{

			if (player!=null){
				player.active=false;
			}
			if (collisionMap!=null){
				collisionMap.active=false;
			}
			if (exit!=null){
				exit.active=false;
			}
			

			for each(var t:TutorialTrigger in tutorialTriggers)
			{
				remove(t);
			}
			for each(var tree:Tree in trees)
			{
				tree.kill();
				remove(tree);
			}
			remove(collisionMap);
			remove(player);
			remove(exit);
			remove(trees);
			
			tutorialTriggers = new Array(); 
			trees = new FlxGroup();

			canopies = new FlxGroup();
			explosions = new FlxGroup();

			pickups=new FlxGroup();
			
			

			map=levels[levelId];
			map.decorateBackground(levelId);
			
			//for ( var i : Number = 0; i < map.backgroundSprites.length; i++) {
				//var bgSprite : FlxSprite = map.backgroundSprites[i];
				//add(bgSprite);
			//}
			map.addSpritesToLayerMainGame(onMapAddCallback);
			
			//stop trees by falling by initialising group before map creation
			
			add(map.layerMainGame);
			collisionMap=map.layerMainGame;		
			
			
			setupPlayer();	
			player.treesLeft = map.treesAllowed;
			player.platformsLeft = map.platformsAllowed;
			player.respawnsLeft = map.respawnsAllowed;
			player.explosionsLeft = map.explosionsAllowed;
			//endLevel=false;
			ambientPlayback.loadEmbedded(ambientSound, true);
			ambientPlayback.play();
			FlxG.flash(0xFFFFFF,1);

		}
		
		public function OnRestartButtonClick():void
		{
			
			FlxG.camera.fade(0xFF000000,1,OnResetFadeDone,true);
		}
		
		public function OnResetFadeDone():void
		{
			FlxG.flash();
			FlxG.switchState(new PlayState(levelId));
		}
		
		public function OnEndLevel():void
		{
			//check to see if we have levels left
			//if not go to exit screen(currently start screen)
			//endLevel=true;
			ambientPlayback.stop();
			
			levelId++;
			statsTracker.submitStats();

			if (levelId>levels.length-1)
			{
				//fade for second before End screen
				FlxG.fade(0xFFFFFFFF,1,OnEndGame);
			}
			else
			{
				//set flag to prevent exit collision being detected multiple times when fading
				exitTransition = true;
				//fade for second before summary screen
				FlxG.fade(0xFFFFFFFF,1,switchToSummary);	
			}
		}

		public function switchToSummary():void
		{
			
			FlxG.switchState(new SummaryState(levelId, statsTracker));
		}
		
		public function OnEndLevelFade():void
		{
			FlxG.camera.fade(0xFFFFFFFF,1,OnStartFadeDone,true);
		}
		
		
		public function OnStartFadeDone():void
		{
			OnStartLevel();
		}
		
		public function OnEndGame():void
		{
			FlxG.switchState(new EndGameState(statsTracker));
			//FlxG.switchState(new MenuState());	
		}
		
		override public function create():void
		{
			
			levels=new Array();
			tutorialTriggers = new Array(); 
			trees = new FlxGroup();
			pickups=new FlxGroup();
			
			//We only need to hide/show these
			pickupScoreDisplay=new FlxGroup();
			
			ambientPlayback = new FlxSound();
			
			/*mcLoader = new Loader(); 
			var url : URLRequest = new URLRequest("../assets/fg_ParticleVideo.swf");
			mcLoader.load(url);
			FlxG.stage.addChild(mcLoader);
			mcLoader.y = 100;	
			mcLoader.blendMode = "screen";
			mcLoader.scaleX = mcLoader.scaleY = 2;*/
			
			FlxG.framerate = 50;
			FlxG.flashFramerate = 50;
			
			_littleGibs = new FlxEmitter();
			_littleGibs.setXSpeed(-150,150);
			_littleGibs.setYSpeed(-200,0);
			_littleGibs.setRotation(-720,-720);
			_littleGibs.gravity = 350;
			_littleGibs.bounce = 0.5;
			_littleGibs.makeParticles(ImgGibs,100,10,true,0.5);
			
			// removing the gibs from the explosion because it sucks
			// add(_littleGibs);  
			
			// add background gradient
			gradientA = new FlxSprite(0,0, BgGradientA);
			gradientA.solid = false;
			gradientA.moves = false;
		//	gradientA.alpha = 1;
		//	gradientA.blend = "multiply";
			add(gradientA);
			
		
			map = new MapLevelZero();
			levels.push(map);
			
			map = new MapLevelOne();
			levels.push(map);
			
			map = new MapLevelTwo();
			levels.push(map);
			
			map = new MapLevelSeven();
			levels.push(map);
			
			map = new MapLevelThree();
			levels.push(map);
			
			map = new MapLevelFour();
			levels.push(map);
			
			map = new MapLevelFive();
			levels.push(map);
			
			map = new MapLevelSix();
			levels.push(map);
			
		
			

			
			OnStartLevel();
			
			
			
			
			
			
			explosions = new FlxGroup();
			// Creates a new tilemap with no arguments
			//collisionMap = new FlxTilemap();
			
			/*
			* FlxTilemaps are created using strings of comma seperated values (csv)
			* This string ends up looking something like this:
			*
			* 0,0,0,0,0,0,0,0,0,0,
			* 0,0,0,0,0,0,0,0,0,0,
			* 0,0,0,0,0,0,1,1,1,0,
			* 0,0,1,1,1,0,0,0,0,0,
			* ...
			*
			* Each '0' stands for an empty tile, and each '1' stands for
			* a solid tile
			*
			* When using the auto map generation, the '1's are converted into the corresponding frame
			* in the tileset.
			*/
			
			// Initializes the map using the generated string, the tile images, and the tile size
			/*
			collisionMap.loadMap(new default_auto(), auto_tiles, TILE_WIDTH, TILE_HEIGHT, FlxTilemap.AUTO);
			add(collisionMap);
			
			highlightBox = new FlxObject(0, 0, TILE_WIDTH, TILE_HEIGHT);
			*/
			
			fgMist = new FlxSprite(0, 0, FgMistClass);
			fgMist.blend = "screen";
			 add(fgMist);
			fgMist.x = 100;
			fgMist.y = -150;
			fgMist.alpha = 0.5;
			fgMist.angularVelocity = 10;
			
			/* add foreground stuff */
			fgInverseVignette = new FlxSprite(0, 0, FgInverseVignetteClass);
			fgInverseVignette.blend = "screen";
			fgInverseVignette.alpha = 1;
			add(fgInverseVignette);
			
		
			
			
			// fgLetterbox = new FlxSprite(0, 0, FgLetterboxClass);
			// add(fgLetterbox);
			
			
			/*
			// When switching between modes here, the map is reloaded with it's own data, so the positions of tiles are kept the same
			// Notice that different tilesets are used when the auto mode is switched
			autoAltBtn = new FlxButton(4, FlxG.height - 24, "AUTO", function():void
			{
			switch(collisionMap.auto)
			{
			case FlxTilemap.AUTO:
			collisionMap.loadMap(FlxTilemap.arrayToCSV(collisionMap.getData(true), collisionMap.widthInTiles),
			alt_tiles, TILE_WIDTH, TILE_HEIGHT, FlxTilemap.ALT);
			autoAltBtn.label.text = "ALT";
			break;
			
			case FlxTilemap.ALT:
			collisionMap.loadMap(FlxTilemap.arrayToCSV(collisionMap.getData(true), collisionMap.widthInTiles),
			empty_tiles, TILE_WIDTH, TILE_HEIGHT, FlxTilemap.OFF);
			autoAltBtn.label.text = "OFF";
			break;
			
			case FlxTilemap.OFF:
			collisionMap.loadMap(FlxTilemap.arrayToCSV(collisionMap.getData(true), collisionMap.widthInTiles),
			auto_tiles, TILE_WIDTH, TILE_HEIGHT, FlxTilemap.AUTO);
			autoAltBtn.label.text = "AUTO";
			break;
			}
			
			});
			add(autoAltBtn);
			
			//TEST
			resetBtn = new FlxButton(8 + autoAltBtn.width, FlxG.height - 24, "Reset", function():void
			{
			switch(collisionMap.auto)
			{
			case FlxTilemap.AUTO:
			collisionMap.loadMap(new default_auto(), auto_tiles, TILE_WIDTH, TILE_HEIGHT, FlxTilemap.AUTO);
			player.x = 64;
			player.y = 220;
			break;
			
			case FlxTilemap.ALT:
			collisionMap.loadMap(new default_alt(), alt_tiles, TILE_WIDTH, TILE_HEIGHT, FlxTilemap.ALT);
			player.x = 64;
			player.y = 128;
			break;
			
			case FlxTilemap.OFF:
			collisionMap.loadMap(new default_empty(), empty_tiles, TILE_WIDTH, TILE_HEIGHT, FlxTilemap.OFF);
			player.x = 64;
			player.y = 64;
			break;
			}
			});
			add(resetBtn);
			
			quitBtn = new FlxButton(FlxG.width - resetBtn.width - 4, FlxG.height - 24, "Quit",
			function():void { FlxG.fade(0xff000000, 0.22, function():void { FlxG.switchState(new MenuState()); } ); } );
			add(quitBtn);
			
			helperTxt = new FlxText(12 + autoAltBtn.width*2, FlxG.height - 30, 150, "Click to place tiles\nShift-Click to remove tiles\nArrow keys to move");
			add(helperTxt);*/
			
			// camera tint
			
			//var cam:FlxCamera = new FlxCamera(0,0, FlxG.width, FlxG.height); // we put the first one in the top left corner
			// this sets the limits of where the camera goes so that it doesn't show what's outside of the tilemap
			//cam.setBounds(0,0,FlxG.width, FlxG.height);
			//FlxG.addCamera(cam);
			
			
			// initialise stats
			statsTracker  = new StatsTracker();
			statsTracker.trackItem("explosions");
			statsTracker.trackItem("platforms");
			statsTracker.trackItem("spawn_points");
			statsTracker.trackItem("trees");
			statsTracker.trackItem("levelId");
			statsTracker.trackItem("pickups");
			statsTracker.setValue("levelId", levelId);

			
			startEffects();
			//create button
			resetBtn=new FlxButton(FlxG.width-100,FlxG.height- 150,"Restart",OnRestartButtonClick);
			add(resetBtn);
			
			
			iconDisplay=new FlxGroup();
			var pUISprite:PowerUISprite=new PowerUISprite(32,FlxG.height- 260);
			pUISprite.loadGraphic(platformIconClass,true,false,128,128,false);
			pUISprite.play("Idle");
			iconDisplay.add(pUISprite);
			
			
			
			pUISprite=new PowerUISprite(32,FlxG.height- 260);
			pUISprite.loadGraphic(explodeIconClass,true,false,128,128,false);
			pUISprite.play("Idle");
			pUISprite.visible=false;
			iconDisplay.add(pUISprite);
			
			pUISprite=new PowerUISprite(32,FlxG.height- 260);
			pUISprite.loadGraphic(treeIcon,true,false,128,128,false);
			pUISprite.play("Idle");
			pUISprite.visible=false;
			iconDisplay.add(pUISprite);
		
			add(iconDisplay);
			
			FlxG.mouse.show();
			
			
		}
		
		// Jon's function!
		private function startEffects() : void {
			// FlxG.camera.color = 0xecfbff; // add a light red tint to the camera to differentiate it from the other
			
			var whitePixel:FlxParticle;
			
			//Here we actually initialize out emitter
			//The parameters are        X   Y                Size (Maximum number of particles the emitter can store)
			var theEmitter : FlxEmitter = new FlxEmitter(FlxG.width/2, -500 , 400);
			
			//Now by default the emitter is going to have some properties set on it and can be used immediately
			//but we're going to change a few things.
			
			//First this emitter is on the side of the screen, and we want to show off the movement of the particles
			//so lets make them launch to the right.
			theEmitter.setXSpeed(-100, 100);
			
			//and lets funnel it a tad
			theEmitter.setYSpeed( -400, 400);
			
			//Let's also make our pixels rebound off surfaces
			theEmitter.bounce = .8;
			
			//Now let's add the emitter to the state.
			add(theEmitter);
			
			//Now it's almost ready to use, but first we need to give it some pixels to spit out!
			//Lets fill the emitter with some white pixels
			for (var i:int = 0; i < theEmitter.maxSize/2; i++) {
				whitePixel = new FlxParticle();
				whitePixel.makeGraphic(3, 3, 0xFFd9e2e5);
				whitePixel.visible = false; //Make sure the particle doesn't show up at (0, 0)
				theEmitter.add(whitePixel);
				whitePixel = new FlxParticle();
				whitePixel.makeGraphic(2, 2, 0xFFFFFFFF);
				whitePixel.visible = false;
				theEmitter.add(whitePixel);
			}
			
			//Now lets set our emitter free.
			//Params:        Explode, Particle Lifespan, Emit rate(in seconds)
			theEmitter.start(false, 5, .01);

			fgLetterbox = new FlxSprite(0, 0, FgLetterboxClass);
			add(fgLetterbox);
			
			sacrificeText = new FlxText(170,FlxG.height- 204,800,"0");
			sacrificeText.size = 16;
			sacrificeText.alignment = "left";
			sacrificeText.color=0xFF000000;
			add(sacrificeText);
			
		}
		
		public function switchPowerUI(current:Number):void
		{
			var uiElement:PowerUISprite=iconDisplay.members[lastSacrifice];
			uiElement.visible=false;
			lastSacrifice=current;
			uiElement=iconDisplay.members[current];
			uiElement.Play();
		}
		
		override public function update():void
		{
			// Tilemaps can be collided just like any other FlxObject, and flixel
			// automatically collides each individual tile with the object.
			//if (!endLevel){
				FlxG.collide(player, collisionMap);
				FlxG.overlap(player, trees, climbTree);
		 		FlxG.collide(player, trees);
				FlxG.collide(trees, collisionMap, plantTreeFirmly);
			
				for each(var t:TutorialTrigger in tutorialTriggers)
				{
					if (player.overlaps(t))
					{
						t.ShowMessage();					
					}
					else
					{
						t.HideMessage();
					}
				}
			
				FlxG.overlap(player, trees, climbTree);
				FlxG.collide(player, trees);
				
				FlxG.overlap(player,pickups,HandlePickUps);
				FlxG.collide(player, pickups);
			
				//If we have hit the exit
				if(player.overlaps(exit) && !exitTransition)
				{
					//FlxG.switchState(new MenuState());
					OnEndLevel();
				}
			//}
			
			/*
			//TODO: For Create block to get tile location when you die!!!
			//Change mouse to player position, move this into player
			highlightBox.x = Math.floor(FlxG.mouse.x / TILE_WIDTH) * TILE_WIDTH;
			highlightBox.y = Math.floor(FlxG.mouse.y / TILE_HEIGHT) * TILE_HEIGHT;
			
			if (FlxG.mouse.pressed())
			{
			// FlxTilemaps can be manually edited at runtime as well.
			// Setting a tile to 0 removes it, and setting it to anything else will place a tile.
			// If auto map is on, the map will automatically update all surrounding tiles.
			collisionMap.setTile(FlxG.mouse.x / TILE_WIDTH, FlxG.mouse.y / TILE_HEIGHT, FlxG.keys.SHIFT?0:1);
			}*/
			
			super.update();
		}
		
		public function HandlePickUps(p:Player, pUp:Pickup):void
		{
			FlxG.play(pickUpSound);
			
			pUp.kill();
			
			statsTracker.increment("pickups");
			//TODO: Handle pickup logic, give some kind of metric
		}
		
		public function climbTree(p:Player, treeToClimb:Tree):void
		{
			
			player.play("climbTree");
			if (player.y > treeToClimb.y -5)
			{
				FlxG.log("this is updating y");
				player.y = treeToClimb.y-64;
				FlxG.log("this is updating before " + player.x);
				player.x = treeToClimb.x+32;
				FlxG.log("this is updating after" + player.x);
				player.climbTree(treeToClimb);
			}
			//player.canClimb = true;
			//player.treeToClimb = treeToClimb;
			
			
		}

		public function plantTreeFirmly(tree:Tree, m:FlxTilemap):void
		{
			tree.immovable = true;
			tree.acceleration.y = 0;
		
		}
		
		public function killTrees(X:Number, Y:Number):void
		{
			var exp:Explosion;
			
			exp = new Explosion(X-75,Y-75);
			explosions.add(exp);
			FlxG.overlap(explosions, trees, killThisTree);
		}

		
		public function killThisTree(Exp:Explosion, dieTree:Tree):void
		{
			dieTree.kill();
		}
		
		public override function draw():void
		{
			var sacrificeLeft : String = "";
			
			if ( player.getSacrifice() == "Trees") {
				sacrificeLeft = ""+player.treesLeft;
			} else if ( player.getSacrifice() == "Explosions") {
				sacrificeLeft = ""+player.explosionsLeft;
			} if ( player.getSacrifice() == "Platforms") {
				sacrificeLeft = ""+player.platformsLeft;
			} 
			
			sacrificeText.text = "x " + sacrificeLeft;
			
			super.draw();
			
		}
		
		private function setupPlayer():void
		{
			//player = new Player(64, 220);
			player.setTileMap(collisionMap);
			player.setGibEmitter(_littleGibs);
			//add(player);
		}
		
		public function addTree(tree:Tree):void
		{
			trees.add(tree);
		}
		
		private function wrap(obj:FlxObject):void
		{
			obj.x = (obj.x + obj.width / 2 + FlxG.width) % FlxG.width - obj.width / 2;
			obj.y = (obj.y + obj.height / 2) % FlxG.height - obj.height / 2;
		}
	}
}

