 /*
	@pjs
	crisp="true";
	pauseOnBlur="false";
	font="data/Arial.ttf";
	preload="data/mc/air.png",
			"data/mc/dirt.png",
			"data/mc/grass.png",
			"data/mc/grass-left.png",
			"data/mc/grass-right.png",
			"data/mc/grass-both.png",
			"data/mc/stone.png",
			"data/mc/bedrock.png",
			"data/mc/iron_ore.png",
			"data/mc/coal_ore.png",
			"data/mc/gold_ore.png",
			"data/mc/logs.png",
			"data/mc/leaves.png",
			"data/mc/player1top.png",
			"data/mc/player1bottom.png",
			"data/mc/player2top.png",
			"data/mc/player2bottom.png",
			"data/mc/diamond_ore.png",
			"data/mc/inventory.png",

			"data/select.png",
			"data/basicgui.png",

			"data/mine/air.png",
			"data/mine/dirt.png",
			"data/mine/grass.png",
			"data/mine/grass-left.png",
			"data/mine/grass-right.png",
			"data/mine/grass-both.png",
			"data/mine/stone.png",
			"data/mine/bedrock.png",
			"data/mine/iron_ore.png",
			"data/mine/coal_ore.png",
			"data/mine/gold_ore.png",
			"data/mine/logs.png",
			"data/mine/leaves.png",
			"data/mine/player1top.png",
			"data/mine/player1bottom.png",
			"data/mine/player2top.png",
			"data/mine/player2bottom.png",
			"data/mine/player3top.png",
			"data/mine/player3bottom.png",
			"data/mine/player4top.png",
			"data/mine/player4bottom.png",
			"data/mine/diamond_ore.png",

			"data/mineHiRes/air.png",
			"data/mineHiRes/dirt.png",
			"data/mineHiRes/grass.png",
			"data/mineHiRes/grass-left.png",
			"data/mineHiRes/grass-right.png",
			"data/mineHiRes/grass-both.png",
			"data/mineHiRes/stone.png",
			"data/mineHiRes/bedrock.png",
			"data/mineHiRes/iron_ore.png",
			"data/mineHiRes/coal_ore.png",
			"data/mineHiRes/gold_ore.png",
			"data/mineHiRes/logs.png",
			"data/mineHiRes/leaves.png",
			"data/mineHiRes/player1top.png",
			"data/mineHiRes/player1bottom.png",
			"data/mineHiRes/player2top.png",
			"data/mineHiRes/player2bottom.png",
			"data/mineHiRes/player3top.png",
			"data/mineHiRes/player3bottom.png",
			"data/mineHiRes/player4top.png",
			"data/mineHiRes/player4bottom.png",
			"data/mineHiRes/diamond_ore.png";
*/

// That stuff up there was the directives.  They get ignored by PC, interpreted
// by Web.  They handle image files and all that other beutiful garbage.

boolean printDebug = false;
boolean showFPS = true;

// [rows][cols]
int[][] arrWorld = new int[800][401];
boolean[][] blockFlip = new boolean[800][401];
PImage[] blockImages = new PImage[100];
PImage[] grassBlocks = new PImage[4];
PImage playerTop;
PImage playerBottom;
PImage selectImage;
PImage inventoryImage;
PImage basicGUI;
int mouseSelectedBlockX = 0;
int mouseSelectedBlockY = 0;
int blockSize = 48;
int blockSizeBig = 48;
int screenScale = 4;
boolean bigPreview = true;
boolean myTextures = false;
boolean hiResTextures = true;
boolean forcePreviewUpdate = true;
boolean mouseOverEdge = false;
int drawPixelOffsetX = 0;
int drawPixelOffsetY = 0;
int drawShiftBy = 12;		// Make sure this is divisible by blockSize.

int blockCoveredTop = 0;
int blockCoveredBottom = 0;
int blockInHand = 0;
int reachLength = 6;
int[] backgroundBlocks = {0, 17, 18};
int[] selectorBlacklist = {7, 19};
int[] selectorWhitelist = {0, 19};

int playerX = 400;
int prevPlayerX = 400;
int playerY = 178;
int prevPlayerY = 180;
int currentPlayer = 1;

int selectorX = 0;
int selectorY = 0;

int playerXPrevSelector = 0;
int playerYPrevSelector = 0;

int mouseBlockX = 0;
int mouseBlockY = 0;

boolean facingLeft = false;		// Actualy Backwards????? facingRight ????

int screenCenterX;
int screenCenterY;
int previewWidth;
int previewHeight;

boolean wasdKeys[] = new boolean[4];

// DumpPixelArray runs outside in draw().
// Because of this, I need a bunch of vars to hold things.
// Prefix: dpa
boolean dpaWorking = false;
int[][] dpaToDraw;
int dpaI = 0;

// Color Data
color[] blockColors = new color[100];

// Help screen
int helpWidth = 640;
int helpHeight = 400;
int helpTopLeftX = 50;
int helpTopLeftY = 50;
boolean helpOpen = false;

// inventory stuff
int[][][] arrInventory = new int[9][4][2];
boolean inventoryOpen = false;
int inventoryWidth = 176;
int inventoryHeight = 166;
int inventoryTopLeftX = 50;
int inventoryTopLeftY = 50;
int inventryScale = 2;
int inventoryItemSize = 16;

void settings()
{
	// This only runs on PC, Web ignores it.
	size(1200, 800);
	noSmooth();
}

void setup()
{
	frameRate(60);
	setWebScreenSize();
	textFont(createFont("Arial",32));
	background(#FFFFFF);
	stroke(#000000);
	fill(#000000);
	debugLog("Program Start.");

	loadHiResTextures();
	selectImage = loadImage("data/select.png");
	inventoryImage = loadImage("data/mc/inventory.png");
	basicGUI = loadImage("data/basicgui.png");

	screenCenterX = (int)( blockSize * floor((width / 2) / blockSize));
	screenCenterY = (int)( blockSize * floor((height / 2) / blockSize));
	previewWidth = (int)( floor( width / blockSize ) / 2 );
	previewHeight = (int)( floor( height / blockSize ) / 2 );

	blockColors[0] = color(204, 255, 255);
	blockColors[1] = color(128, 128, 128);
	blockColors[2] = color(0, 204, 0);
	blockColors[3] = color(153, 102, 51);
	blockColors[7] = color(0, 0, 0);
	blockColors[11] = color(255, 102, 0);
	blockColors[14] = color(255, 255, 102);
	blockColors[15] = color(255, 191, 128);
	blockColors[16] = color(38, 38, 38);
	blockColors[17] = color(109, 49, 18);
	blockColors[18] = color(51, 153, 51);
	blockColors[19] = color(255, 0, 0);
	blockColors[56] = color(0, 204, 255);

	generateWorld();
	blockCoveredTop = arrWorld[playerX][playerY];
	blockCoveredBottom = arrWorld[playerX][playerY+1];
	arrWorld[playerX][playerY] = 19;		// Place the player top
	arrWorld[playerX][playerY+1] = 19;		// Place the player bottom
};

void draw()
{
	if(dpaWorking) { dumpPixelArrayWork(); };

	if( ( ( drawPixelOffsetX != 0 ) || ( drawPixelOffsetY != 0 ) ) && bigPreview )
	{
		if(drawPixelOffsetX > 0)
		{
			drawPixelOffsetX -= drawShiftBy;
		}

		if(drawPixelOffsetX < 0)
		{
			drawPixelOffsetX += drawShiftBy;
		}

		if(drawPixelOffsetY > 0)
		{
			drawPixelOffsetY -= drawShiftBy;
		}

		if(drawPixelOffsetY < 0)
		{
			drawPixelOffsetY += drawShiftBy;
		}

		updateBigPreview(playerX, playerY);

		if( ( drawPixelOffsetX == 0 ) && ( drawPixelOffsetY == 0 ) )
		{
			updateSelector();
		}
	}

	prevPlayerX = playerX;
	prevPlayerY = playerY;

	if( mousePressed && !inventoryOpen )
	{
		if( ( mouseButton == LEFT ) && mouseCanInteract() )
		{
			arrWorld[mouseBlockX][mouseBlockY] = 0;
			forcePreviewUpdate = true;
		}

		if( ( mouseButton == CENTER ) && mouseCanInteract() )
		{
			blockInHand = arrWorld[mouseBlockX][mouseBlockY];
		}

		if( ( mouseButton == RIGHT ) && mouseCanInteract() && ( arrWorld[mouseBlockX][mouseBlockY] == 0 ) )
		{
			arrWorld[mouseBlockX][mouseBlockY] = blockInHand;
			forcePreviewUpdate = true;
		}
	}

	if(keyPressed && !inventoryOpen && (drawPixelOffsetX == 0) && ( drawPixelOffsetY == 0 ) )
	{
		if( !bigPreview )
		{
			forcePreviewUpdate = true;
		}

		arrWorld[playerX][playerY] = blockCoveredTop;
		arrWorld[playerX][playerY+1] = blockCoveredBottom;

		if( wasdKeys[0] && (playerY != 0) && ( arrayContains(backgroundBlocks, arrWorld[playerX][max(playerY - 1, 0)]) ) )
		{
			drawPixelOffsetY = -blockSize;
			playerY--;
		}
		if( wasdKeys[1] )
		{
			facingLeft = true;
			//forcePreviewUpdate = true;
			if( (playerX != 0) && arrayContains(backgroundBlocks, arrWorld[max(playerX - 1, 0)][playerY]) && arrayContains(backgroundBlocks, arrWorld[max(playerX - 1, 0)][max(playerY + 1, 0)]) )
			{
				drawPixelOffsetX = -blockSize;
				playerX--;
			}
		}
		if( wasdKeys[2] && (playerY+1 != arrWorld[0].length - 1) && ( arrayContains(backgroundBlocks, arrWorld[playerX][min(playerY + 2, arrWorld[0].length)]) ) )
		{
			drawPixelOffsetY = blockSize;
			playerY++;
		}
		if( wasdKeys[3] )
		{
			facingLeft = false;
			//forcePreviewUpdate = true;
			if( (playerX != arrWorld.length - 1) && arrayContains(backgroundBlocks, arrWorld[min(playerX + 1, arrWorld.length)][playerY]) && arrayContains(backgroundBlocks, arrWorld[min(playerX + 1, arrWorld.length)][min(playerY + 1, arrWorld[0].length)]) )
			{
				drawPixelOffsetX = blockSize;
				playerX++;
			}
		}

		//debugLog(playerX + ", " + playerY);
		blockCoveredTop = arrWorld[playerX][playerY];
		blockCoveredBottom = arrWorld[playerX][playerY+1];
		arrWorld[playerX][playerY] = 19;
		arrWorld[playerX][playerY+1] = 19;
	}

	if( ( ( mouseX != pmouseX ) || ( mouseY != pmouseY ) || (forcePreviewUpdate == true) ) && !bigPreview && !inventoryOpen )
	{
		mouseSelectedBlockX = mouseX - 299;
		mouseSelectedBlockY = mouseY - 79;
		forcePreviewUpdate = false;
		updateLittlePreview(mouseSelectedBlockX, mouseSelectedBlockY);
	}

	if( ( ( mouseX != pmouseX ) || ( mouseY != pmouseY ) ) && bigPreview && !inventoryOpen && ( drawPixelOffsetX == 0 ) && ( drawPixelOffsetY == 0 ) )
	{
		updateSelector();
	}

	if( (forcePreviewUpdate == true) && bigPreview && !inventoryOpen )
	{
		updateBigPreview(playerX, playerY);
		forcePreviewUpdate = false;
	}

	if(showFPS)
	{
		noStroke();
		fill(#FFFFFF);
		rect(0, 0, 45, 15);
		stroke(#000000);
		strokeWeight(1);
		fill(#000000);
		textSize(12);
		text(round(frameRate) + " FPS", 2, 12);
	}
};

void keyReleased()
{
	if( key == '`' || key == '~' )
	{
		setWebScreenSize();
		forcePreviewUpdate = true;
		if( !bigPreview )
		{
			littlePreviewMessages();
			dumpPixelArray(arrWorld);
		}
	};

	if( key == 'r' || key == 'R' )
	{
		blockInHand = arrWorld[mouseBlockX][mouseBlockY];
	};

	if( key == '+' || key == '=' )
	{
		forcePreviewUpdate = true;
		if(myTextures)
		{
			loadMinecraftTextures();
		}
		else
		{
			loadHiResTextures();
		}
	}

	if( key == '-' || key == '_' )
	{
		bigPreview = !bigPreview;
		forcePreviewUpdate = true;
		dpaWorking = false;
		if( !bigPreview )
		{
			blockSize = 16;
			screenScale = 2;
			background(#FFFFFF);
			littlePreviewMessages();

			strokeWeight(1);
			stroke(#000000);
			point(250, 250);

			dumpPixelArray(arrWorld);
		}
		else
		{
			blockSize = blockSizeBig;
			screenScale = 4;
		}
	}

	if( key == 't' || key == 'T' )
	{
		hiResTextures = !hiResTextures;
		if(hiResTextures)
		{
			loadHiResTextures();
		}
		else
		{
			loadMyTextures();
		}
		forcePreviewUpdate = true;
	}

	if( key == 'h' || key == 'H' )
	{
		helpOpen = !helpOpen;
		if(helpOpen)
		{
			drawHelpScreen();
			noLoop();
		}
		else
		{
			loop();
			forcePreviewUpdate = true;
		}
	}

	if( key == '\\' || key == '|' )
	{
		showFPS = !showFPS;
		forcePreviewUpdate = true;
	}

	if( key == 'p' || key == 'P' )
	{
		if(currentPlayer == 4)
		{
			currentPlayer = 1;
		}
		else
		{
			currentPlayer++;
		}

		if(hiResTextures)
		{
			loadHiResTextures();
		}
		else if(myTextures)
		{
			loadMyTextures();
		}
		else
		{
			loadMinecraftTextures();
		}
		forcePreviewUpdate = true;
	}

	if( key == '[' || key == '{' )
	{
		addToInventory(1, 3);
	}

	if( key == ']' || key == '}' )
	{
		addToInventory(2, 5);
	}

	if( key == 'w' || key == 'W' )
	{
		wasdKeys[0] = false;
	}

	if( key == 'a' || key == 'A' )
	{
		wasdKeys[1] = false;
	}

	if( key == 's' || key == 'S' )
	{
		wasdKeys[2] = false;
	}

	if( key == 'd' || key == 'D' )
	{
		wasdKeys[3] = false;
	}

	if( key == 'e' || key == 'E' )
	{
		inventoryOpen = !inventoryOpen;
		if(inventoryOpen)
		{
			image(inventoryImage, inventoryTopLeftX, inventoryTopLeftY, inventoryWidth*inventryScale, inventoryHeight*inventryScale);
			drawInventory();
		}
		else
		{
			forcePreviewUpdate = true;
		}
	}
};

void keyPressed()
{
	if( ( key == 'w' || key == 'W' ) && !wasdKeys[2] )
	{
		wasdKeys[0] = true;
	}

	if( ( key == 'a' || key == 'A' ) && !wasdKeys[3] )
	{
		wasdKeys[1] = true;
	}

	if( ( key == 's' || key == 'S' ) && !wasdKeys[0] )
	{
		wasdKeys[2] = true;
	}

	if( ( key == 'd' || key == 'D' ) && !wasdKeys[1] )
	{
		wasdKeys[3] = true;
	}
};

void drawHelpScreen()
{
	image(basicGUI, helpTopLeftX, helpTopLeftY);
	textSize(15);
	String[] helpText = {"Welcome to the help screen!",
						 "Press H to close it.",
						 "Keyboard Controls:",
						 "Use the W/A/S/D keys to move your player around.",
						 "Press P to change what player you are.",
						 "Mouse Controls:",
						 "Move the mouse to move the selector box.",
						 "Left click to break the block under the selector.",
						 "Push the scroll wheel while on a block to put that block in your hand.",
						 "(If you don't have a mouse with scroll wheel, you can also press R on the keyboard.)",
						 "After you have picked a block with the middle button, place it in an empty space with right click.",
						 "Enjoy the \"game!\""};
	for(int i = 0; i < helpText.length; i++)
	{
		text(helpText[i], helpTopLeftY+5, helpTopLeftX+5+16+(16*i));
	}
};

void addToInventory(int idToAdd, int numberToAdd)
{
	for( int i = 0; i < arrInventory.length; i++ )
	{
		for( int j = 0; j < arrInventory[0].length; j++ )
		{
			if( arrInventory[i][j][0] == idToAdd )
			{
				arrInventory[i][j][1] += numberToAdd;
				return;
			}
		}
	}

	for( int i = 0; i < arrInventory.length; i++ )
	{
		for( int j = 0; j < arrInventory[0].length; j++ )
		{
			if( arrInventory[i][j][0] == 0 )
			{
				arrInventory[i][j][0] = idToAdd;
				arrInventory[i][j][1] += numberToAdd;
				return;
			}
		}
	}
};

void drawInventory()
{
	for(int i = 0; i < 9; i++)
	{
		for(int j = 0; j < 3; j++)
		{
			if( arrInventory[i][j][0] != 0 )
			{
				image(blockImages[arrInventory[i][j][0]], inventoryTopLeftX+22+(36*i+2), inventoryTopLeftY+174+(36*j+2), inventoryItemSize, inventoryItemSize);
				text(arrInventory[i][j][1], inventoryTopLeftX+22+(36*i+2), inventoryTopLeftY+174+(36*j+2));
			}
		}
	}
	for(int i = 0; i < 9; i++)
	{
		if( arrInventory[i][3][0] != 0 )
		{
			image(blockImages[arrInventory[i][3][0]], inventoryTopLeftX+22+(36*i+2), inventoryTopLeftY+181+(36*3+2), inventoryItemSize, inventoryItemSize);
			text(arrInventory[i][3][1], inventoryTopLeftX+22+(36*i+2), inventoryTopLeftY+181+(36*3+2));
		}
	}
};

boolean mouseCanInteract()
{
	if( mouseOverEdge || arrayContains(selectorBlacklist, arrWorld[mouseBlockX][mouseBlockY]) )
	{
		return false;
	}
	else if( ( mouseBlockX >= playerX+reachLength ) || ( mouseBlockX <= playerX-reachLength ) || ( mouseBlockY >= playerY+reachLength ) || ( mouseBlockY <= playerY-reachLength ) )
	{
		return false;
	}
	else if( !arrayContains(selectorWhitelist, arrWorld[mouseBlockX][mouseBlockY]) || !arrayContains(selectorWhitelist, arrWorld[min(mouseBlockX+1, arrWorld.length-1)][mouseBlockY]) || !arrayContains(selectorWhitelist, arrWorld[max(0, mouseBlockX-1)][mouseBlockY]) || !arrayContains(selectorWhitelist, arrWorld[mouseBlockX][min(mouseBlockY+1, arrWorld[0].length-1)]) || !arrayContains(selectorWhitelist, arrWorld[mouseBlockX][max(mouseBlockY-1, 0)]) )
	{
		return true;
	}
	else
	{
		return false;
	}
};

void updateSelector()
{
	if( ( playerX == playerXPrevSelector ) && ( playerY == playerYPrevSelector ) )
	{
		drawBlock(mouseBlockX, mouseBlockY, selectorX, selectorY);
	}

	playerXPrevSelector = playerX;
	playerYPrevSelector = playerY;

	selectorX = blockSize * floor( mouseX / blockSize );
	selectorY = blockSize * floor( mouseY / blockSize );

	mouseOverEdge = false;

	mouseBlockX = playerX - previewWidth + (int)floor(mouseX / blockSize);
	mouseBlockY = playerY - previewHeight + (int)floor(mouseY / blockSize);

	if( ( mouseBlockX < 0 ) || ( mouseBlockY < 0 ) || ( mouseBlockX >= arrWorld.length ) || ( mouseBlockY >= arrWorld[0].length ) )
	{
		mouseOverEdge = true;
		mouseBlockX = max(0, min(arrWorld.length-1, mouseBlockX));
		mouseBlockY = max(0, min(arrWorld[0].length-1, mouseBlockY));
	}

	if( mouseCanInteract() )
	{
		image(selectImage, selectorX, selectorY, blockSize, blockSize);
	}
};

void updateLittlePreview(int centerX, int centerY)
{
	for(int i = playerX-1; i <= playerX+1; i++)
	{
		for(int j = playerY-1; j <= playerY+2; j++)
		{
			dumpPixel(arrWorld, i, j);
		}
	}

	for(int i = -16/screenScale; i <= 16/screenScale; i++)
	{
		for(int j = -16/screenScale; j <= 16/screenScale; j++)
		{
			drawBlock(centerX+j, centerY+i, 145 + blockSize*j, 400 + blockSize*i);
		}
	}
};

void updateBigPreview(int centerX, int centerY)
{
	int playerScreenX = 0;
	int playerScreenY = 0;
	for(int i = -previewHeight; i <= previewHeight+1; i++)
	{
		for(int j = -previewWidth - 1; j <= previewWidth+1; j++)
		{
			if( arrWorld[constrain(centerX+j, 0, arrWorld.length-1)][centerY+i] != 19 )
			{
				drawBlock(centerX+j, centerY+i, screenCenterX + blockSize * j, screenCenterY + blockSize * i);
			}
			else
			{
				playerScreenX = screenCenterX + blockSize * j;
				playerScreenY = screenCenterY + blockSize * i;
			}
		}
	}

	if(drawPixelOffsetY <= 0)
	{
		drawBlock(playerX, playerY+1, playerScreenX, playerScreenY);
		drawBlock(playerX, playerY, playerScreenX, playerScreenY - blockSize);
	}
	else
	{
		drawBlock(playerX, playerY, playerScreenX, playerScreenY - blockSize);
		drawBlock(playerX, playerY+1, playerScreenX, playerScreenY);
	}
};

void drawBlock(int matrixX, int matrixY, int screenX, int screenY)
{
	pushMatrix();
	translate(drawPixelOffsetX, drawPixelOffsetY);

	image(blockImages[0], screenX, screenY, blockSize, blockSize);

	if( ( matrixX >= 0 ) && ( matrixX < arrWorld.length ) && ( matrixY >= 0 ) && ( matrixY < arrWorld[0].length ) )
	{
		if( arrWorld[matrixX][matrixY] == 2 )
		{
			if( arrayContains(selectorWhitelist, arrWorld[max(0, matrixX-1)][matrixY] ) && arrayContains(selectorWhitelist, arrWorld[min(arrWorld.length-1, matrixX+1)][matrixY] ) )
			{
				image(grassBlocks[2], screenX, screenY, blockSize, blockSize);
			}
			else if( arrayContains(selectorWhitelist, arrWorld[max(0, matrixX-1)][matrixY] ) )
			{
				image(grassBlocks[1], screenX, screenY, blockSize, blockSize);
			}
			else if( arrayContains(selectorWhitelist, arrWorld[min(arrWorld.length-1, matrixX+1)][matrixY] ) )
			{
				image(grassBlocks[3], screenX, screenY, blockSize, blockSize);
			}
			else
			{
				image(grassBlocks[0], screenX, screenY, blockSize, blockSize);
			}
		}
		else if( arrWorld[matrixX][matrixY] == 19 )
		{
			pushMatrix();
			if( ( matrixX == playerX ) && ( matrixY == playerY ) )
			{
				if( blockFlip[matrixX][matrixY] )
				{
					translate(screenX, screenY);
				}
				else
				{
					translate(screenX + blockSize, screenY);
					scale(-1, 1);
				}
				image(blockImages[blockCoveredTop], 0, 0, blockSize, blockSize);
			}
			else
			{
				if( blockFlip[matrixX][matrixY] )
				{
					translate(screenX, screenY);
				}
				else
				{
					translate(screenX + blockSize, screenY);
					scale(-1, 1);
				}
				image(blockImages[blockCoveredBottom], 0, 0, blockSize, blockSize);
			}
			popMatrix();

			translate(-drawPixelOffsetX, -drawPixelOffsetY);
			if( !facingLeft )
			{
				//This works flawlessly, drawPixelOffsetX is positive
				translate(screenX, screenY);
			}
			else
			{
				// This does not.  drawPixelOffsetX is negative.
				translate(screenX + blockSize, screenY);
				scale(-1, 1);    // Flip the block
			}

			if( ( matrixX == playerX ) && ( matrixY == playerY ) )
			{
				image(playerTop, 0, 0, blockSize, blockSize);
			}
			else
			{
				image(playerBottom, 0, 0, blockSize, blockSize);
			}
		}
		else
		{
			if( blockFlip[matrixX][matrixY] )
			{
				translate(screenX, screenY);
			}
			else
			{
				translate(screenX + blockSize, screenY);
				scale(-1, 1);
			}
			image(blockImages[arrWorld[matrixX][matrixY]], 0, 0, blockSize, blockSize);
		}
	}
	popMatrix();
};

void shiftHorizontal(int shiftBy)
{
	loadPixels();

	color[][] newPixels = new color[width][height];
	color[][] newPixels2 = new color[width][height];

	int k = 0;
	for(int i = 0; i < width; i++)
	{
		for(int j = 0; j < height; j++)
		{
			newPixels[i][j] = pixels[k];
			k++;
		}
	}

	for (int row = 0; row < newPixels.length; row++)
	{
    	for (int col = 0; col < newPixels[row].length; col++)
		{
        	newPixels2[row][col] = newPixels[row][(col + shiftBy) % newPixels[row].length]
    	}
	}

	k = 0;
	for(int i = 0; i < width; i++)
	{
		for(int j = 0; j < height; j++)
		{
			pixels[k] = newPixels[i][j];
			k++;
		}
	}

	updatePixels();
}

void shiftVertical(int shiftBy)
{
	loadPixels();


}

void loadMinecraftTextures()
{
	hiResTextures = false;
	myTextures = false;
	blockImages[0] = loadImage("data/mc/air.png");
	blockImages[1] = loadImage("data/mc/stone.png");
	blockImages[2] = loadImage("data/mc/grass.png");
	blockImages[3] = loadImage("data/mc/dirt.png");
	blockImages[7] = loadImage("data/mc/bedrock.png");

	blockImages[14] = loadImage("data/mc/gold_ore.png");
	blockImages[15] = loadImage("data/mc/iron_ore.png");
	blockImages[16] = loadImage("data/mc/coal_ore.png");
	blockImages[17] = loadImage("data/mc/logs.png");
	blockImages[18] = loadImage("data/mc/leaves.png");

	blockImages[56] = loadImage("data/mc/diamond_ore.png");

	grassBlocks[0] = loadImage("data/mc/grass.png");
	grassBlocks[1] = loadImage("data/mc/grass-left.png");
	grassBlocks[2] = loadImage("data/mc/grass-both.png");
	grassBlocks[3] = loadImage("data/mc/grass-right.png");

	if( ( currentPlayer == 1 ) || ( currentPlayer == 3 ) )
	{
		playerTop = loadImage("data/mc/player1top.png");
		playerBottom = loadImage("data/mc/player1bottom.png");
	}
	else if( ( currentPlayer == 2 ) || ( currentPlayer == 4 ) )
	{
		playerTop = loadImage("data/mc/player2top.png");
		playerBottom = loadImage("data/mc/player2bottom.png");
	}
	else
	{
		println("Unknown Player Image: " + currentPlayer);
	}
};

void loadMyTextures()
{
	hiResTextures = false;
	myTextures = true;
	blockImages[0] = loadImage("data/mine/air.png");
	blockImages[1] = loadImage("data/mine/stone.png");
	blockImages[2] = loadImage("data/mine/grass.png");
	blockImages[3] = loadImage("data/mine/dirt.png");
	blockImages[7] = loadImage("data/mine/bedrock.png");

	blockImages[14] = loadImage("data/mine/gold_ore.png");
	blockImages[15] = loadImage("data/mine/iron_ore.png");
	blockImages[16] = loadImage("data/mine/coal_ore.png");
	blockImages[17] = loadImage("data/mine/logs.png");
	blockImages[18] = loadImage("data/mine/leaves.png");
	blockImages[56] = loadImage("data/mine/diamond_ore.png");

	grassBlocks[0] = loadImage("data/mine/grass.png");
	grassBlocks[1] = loadImage("data/mine/grass-left.png");
	grassBlocks[2] = loadImage("data/mine/grass-both.png");
	grassBlocks[3] = loadImage("data/mine/grass-right.png");

	if( currentPlayer == 1 )
	{
		playerTop = loadImage("data/mine/player1top.png");
		playerBottom = loadImage("data/mine/player1bottom.png");
	}
	else if( currentPlayer == 2 )
	{
		playerTop = loadImage("data/mine/player2top.png");
		playerBottom = loadImage("data/mine/player2bottom.png");
	}
	else if( currentPlayer == 3 )
	{
		playerTop = loadImage("data/mine/player3top.png");
		playerBottom = loadImage("data/mine/player3bottom.png");
	}
	else if( currentPlayer == 4 )
	{
		playerTop = loadImage("data/mine/player4top.png");
		playerBottom = loadImage("data/mine/player4bottom.png");
	}
	else
	{
		println("Unknown Player Image: " + currentPlayer);
	}
};

void loadHiResTextures()
{
	hiResTextures = true;
	myTextures = true;
	blockImages[0] = loadImage("data/mineHiRes/air.png");
	blockImages[1] = loadImage("data/mineHiRes/stone.png");
	blockImages[2] = loadImage("data/mineHiRes/grass.png");
	blockImages[3] = loadImage("data/mineHiRes/dirt.png");
	blockImages[7] = loadImage("data/mineHiRes/bedrock.png");

	blockImages[14] = loadImage("data/mineHiRes/gold_ore.png");
	blockImages[15] = loadImage("data/mineHiRes/iron_ore.png");
	blockImages[16] = loadImage("data/mineHiRes/coal_ore.png");
	blockImages[17] = loadImage("data/mineHiRes/logs.png");
	blockImages[18] = loadImage("data/mineHiRes/leaves.png");
	blockImages[56] = loadImage("data/mineHiRes/diamond_ore.png");

	grassBlocks[0] = loadImage("data/mineHiRes/grass.png");
	grassBlocks[1] = loadImage("data/mineHiRes/grass-left.png");
	grassBlocks[2] = loadImage("data/mineHiRes/grass-both.png");
	grassBlocks[3] = loadImage("data/mineHiRes/grass-right.png");

	if( currentPlayer == 1 )
	{
		playerTop = loadImage("data/mineHiRes/player1top.png");
		playerBottom = loadImage("data/mineHiRes/player1bottom.png");
	}
	else if( currentPlayer == 2 )
	{
		playerTop = loadImage("data/mineHiRes/player2top.png");
		playerBottom = loadImage("data/mineHiRes/player2bottom.png");
	}
	else if( currentPlayer == 3 )
	{
		playerTop = loadImage("data/mineHiRes/player3top.png");
		playerBottom = loadImage("data/mineHiRes/player3bottom.png");
	}
	else if( currentPlayer == 4 )
	{
		playerTop = loadImage("data/mineHiRes/player4top.png");
		playerBottom = loadImage("data/mineHiRes/player4bottom.png");
	}
	else
	{
		println("Unknown Player Image: " + currentPlayer);
	}
};

boolean arrayContains(int[] arrayToSearch, int contains)
{
	for(int i = 0; i < arrayToSearch.length; i++)
	{
		if(arrayToSearch[i] == contains)
		{
			return true;
		}
	}
	return false;
}

int countInArray(int[][] toRead, int toFind)
{
	int count = 0;
	for(int i = 0; i < toRead.length; i++)
	{
		for(int j = 0; j < toRead[0].length; j++)
		{
			if( toRead[i][j] == toFind )
			{
				count++;
			}
		}
	}
	return count;
};

int[][] addRoughCircle(int[][] arrayToEdit, int xCenter, int yCenter, int radius, int drawWith, int randomness)
{
	for (int j = 0; j <= radius; j++)
	{
		int intCurrentY = yCenter - radius - j;
		int Temp = int(sqrt(radius * radius - j * j));

		//int intLowerX = xCenter - Temp;
		//int intUpperX = xCenter + Temp;

		int intLowerX = xCenter - randInt(Temp - randomness, Temp + randomness);
		int intUpperX = xCenter + randInt(Temp - randomness, Temp + randomness);

		for (int k = intLowerX; k <= intUpperX; k++)
		{
			if ((intCurrentY >= 0) && (intCurrentY <= arrayToEdit[0].length - 1) && (k >= 0) && (k <= arrayToEdit.length - 1))
			{
				arrayToEdit[k][intCurrentY] = drawWith;
			}
		}
	}

	for (int j = 0; j <= radius; j++)
	{
		int intCurrentY = yCenter - radius + j;
		int Temp = int(sqrt(radius * radius - j * j));

		//int intLowerX = xCenter - Temp;
		//int intUpperX = xCenter + Temp;

		int intLowerX = xCenter - randInt(Temp - randomness, Temp + randomness);
		int intUpperX = xCenter + randInt(Temp - randomness, Temp + randomness);

		for (int k = intLowerX; k <= intUpperX; k++)
		{
			if ((intCurrentY >= 0) && (intCurrentY <= arrayToEdit[0].length - 1) && (k >= 0) && (k <= arrayToEdit.length - 1))
			{
				arrayToEdit[k][intCurrentY] = drawWith;
			}
		}
	}
	return arrayToEdit;
};

void dumpPixelArrayWork()
{
	for(int j = 0; j < dpaToDraw.length; j++)
	{
		stroke(blockColors[dpaToDraw[j][dpaI]]);
		point(300 + j, 80 + dpaI);
	}

	if( dpaI == dpaToDraw[0].length - 1 )
	{
		dpaWorking = false;
	}
	else
	{
		dpaI++;
	}
}

void dumpPixelArray(int[][] toDraw)
{
	dpaWorking = true;
	dpaToDraw = toDraw;
	dpaI = 0;
};

void dumpPixel(int[][] toDraw, int xToDraw, int yToDraw)
{
	if( ( xToDraw >= 0 ) && ( yToDraw >= 0 ) && ( xToDraw < arrWorld.length ) && ( yToDraw < arrWorld[0].length ) )
	{
		stroke(blockColors[toDraw[xToDraw][yToDraw]]);
		point(300 + xToDraw, 80 + yToDraw);
	}
};

void logArray(int[][] toDraw)
{
	String row = "";
	for(int i = 0; i < toDraw.length; i++)
	{
		row = "";
		for(int j = 0; j < toDraw[0].length; j++)
		{
			row += toDraw[i][j];
		}
		debugLog(row);
	}
};

void generateWorld()
{
	// Add Base World
	// Row  0         =  Bedrock:   7
	// Rows 10 - 49   =  Stone:     1
	// Rows 9 - 6     =  Dirt:      3
	// Rows 5         =  Grass:     2

	// Stone
	for(int i = 0; i < arrWorld.length; i++)
	{
		for(int j = 200; j <= 399; j++)
		{
			arrWorld[i][j] = 1;
		};
	};

	// Dirt
	for(int i = 0; i < arrWorld.length; i++)
	{
		for(int j = 190; j <= 199; j++)
		{
			arrWorld[i][j] = 3;
		};
	};

	// Add Surface Randomness
	for(int i = 0; i <= arrWorld.length; i++)
	{
		arrWorld = addRoughCircle(arrWorld, randInt(0, arrWorld.length), randInt(195,200), randInt(2,8), 3, 0);
	}

	// Add Grass and Tress
	for(int i = 0; i < arrWorld.length; i++)
	{
		for(int j = 0; j < arrWorld[0].length; j++)
		{
			if(arrWorld[i][j] == 3)
			{
				arrWorld[i][j] = 2;
				if( randInt(0,9) == 0 )
				{
					// Add a tree
					arrWorld[i][j] = 3;
					int treeHeight = randInt(4,8);
					int leafRadius = randInt(3,5);
					//debugLog("Adding tree.  Height: " + treeHeight + ", Leaves: " + leafRadius);

					arrWorld = addRoughCircle(arrWorld, i, j - treeHeight + leafRadius - 1, leafRadius, 18, 1);

					for(int k = j - 1; k >= j - treeHeight; k--)
					{
						arrWorld[i][k] = 17;
					}
				}
				break;
			}
		}
	}

	// Add Sub-Surface Randomness
	for(int i = 0; i <= arrWorld.length; i++)
	{
		arrWorld = addRoughCircle(arrWorld, randInt(0,arrWorld.length), randInt(204,201), randInt(1,6), 1, 2);
	}

	// Add Coal
	for(int i = 0; i <= arrWorld.length / 4; i++)
	{
		arrWorld = addRoughCircle(arrWorld, randInt(0,arrWorld.length), randInt(200,399), 3, 16, 1);
	}

	// Add Iron
	for(int i = 0; i <= arrWorld.length / 4; i++)
	{
		arrWorld = addRoughCircle(arrWorld, randInt(0,arrWorld.length), randInt(200,399), 2, 15, 1);
	}

	// Add Diamonds
	for(int i = 0; i <= .25 * arrWorld.length / 4; i++)
	{
		arrWorld = addRoughCircle(arrWorld, randInt(0,arrWorld.length), randInt(350,400), 1, 56, 1);
	}

	// Add Gold
	for(int i = 0; i <= .3 * arrWorld.length / 4; i++)
	{
		arrWorld = addRoughCircle(arrWorld, randInt(0,arrWorld.length), randInt(350,400), 1, 14, 1);
	}

	// Bedrock
	for(int i = 0; i < arrWorld.length; i++)
	{
		arrWorld[i][400] = 7;
	};

	debugLog("Iron: " + countInArray(arrWorld, 15));
	debugLog("Coal: " + countInArray(arrWorld, 16));
	debugLog("Diamonds: " + countInArray(arrWorld, 56));
	debugLog("Gold: " + countInArray(arrWorld, 14));

	for(int i = 0; i < blockFlip.length; i++)
	{
		for(int j = 0; j < blockFlip[0].length; j++)
		{
			blockFlip[i][j] = randBool();
		}
	}
};

int randInt(int min, int max)
{
	return round(random(min,max));
};

boolean randBool()
{
	if( round(random(1, 2)) == 1 )
	{
		return false;
	}
	else
	{
		return true;
	}
};

void debugLog(String toPrint)
{
	if(printDebug)
	{
		println(toPrint);
	}
};

void littlePreviewMessages()
{
	stroke(#000000);
	fill(#000000);
	textSize(12);
	text("This view is really just for debugging world generation.  But it is also still here because I don't want to delete Smiley :)", 20, 25);
	text("Here is a smiley face image for testing purposes.", 20, 40);
	text("Here is the Generated World:", 300, 70);
	drawSmiley();
};

void drawSmiley()
{
	fill(233, 224, 71);
	strokeWeight(7/2);
	ellipse(250/2, 250/2, 300/2, 300/2);
	fill(0);
	ellipse(200/2, 210/2, 30/2, 70/2);
	ellipse(300/2, 210/2, 30/2, 70/2);
	fill(255);
	bezier(150/2, 295/2, 200/2, 370/2, 300/2, 370/2, 350/2, 295/2);
	line(150/2, 295/2, 350/2, 295/2);
	line(160/2, 180/2, 210/2, 135/2);
	line(340/2, 180/2, 290/2, 135/2);

	strokeWeight(1);		// This caused so many problems.  Bad Smiley. :(  ):
};

// These are Garbage functions that get overwritten by WebCode if on web.
void setWebScreenSize() {};
