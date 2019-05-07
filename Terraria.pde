/*
	@pjs
	crisp="true";
	pauseOnBlur="false";
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
			"data/mc/player.png",
			"data/mc/diamond_ore.png",

			"data/mine/select.png",
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
			"data/mine/player.png",
			"data/mine/diamond_ore.png";
*/

// That stuff up there was the directives.  They get ignored by PC, interpreted
// by Web.  They handle image files and all that other beutiful garbage.

boolean printDebug = false;

// [rows][cols]
int[][] arrWorld = new int[800][401];
boolean[][] blockFlip = new boolean[800][401];
PImage[] blockImages = new PImage[100];
PImage[] grassBlocks = new PImage[4];
PImage selectImage;
int mouseSelectedBlockX = 0;
int mouseSelectedBlockY = 0;
int blockSize = 32;
int screenScale = 4;
boolean bigPreview = true;
boolean myTextures = false;
boolean forcePreviewUpdate = true;
boolean mouseOverEdge = false;

int blockCovered = 0;
int blockInHand = 0;
int[] backgroundBlocks = {0, 17, 18};
int[] selectorBlacklist = {7, 19};
int[] selectorWhitelist = {0, 19};

int playerX = 400;
int prevPlayerX = 400;
int playerY = 178;
int prevPlayerY = 180;

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

void settings()
{
	// This only runs on PC, Web ignores it.
	size(800, 600);
	noSmooth();
}

void setup()
{
	frameRate(30);

	SetWebScreenSize();
	WebSetup();
	background(#FFFFFF);
	stroke(#000000);
	fill(#000000);
	debugLog("Program Start.");

	loadMyTextures();

	screenCenterX = blockSize * floor((width / 2) / blockSize);
	screenCenterY = blockSize * floor((height / 2) / blockSize);
	previewWidth = ( floor( width / blockSize ) / 2 );
	previewHeight = ( floor( height / blockSize ) / 2 );

	selectImage = loadImage("data/mine/select.png");

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

	GenerateWorld();
	blockCovered = arrWorld[playerX][playerY];
	arrWorld[playerX][playerY] = 19;		// Place the player
};

void draw()
{
	if(dpaWorking) { DumpPixelArrayWork(); };

	prevPlayerX = playerX;
	prevPlayerY = playerY;

	if(mousePressed)
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

		if( ( mouseButton == RIGHT ) && mouseCanInteract() )
		{
			arrWorld[mouseBlockX][mouseBlockY] = blockInHand;
			forcePreviewUpdate = true;
		}
	}

	if(keyPressed)
	{
		if( !bigPreview )
		{
			forcePreviewUpdate = true;
		}

		arrWorld[playerX][playerY] = blockCovered;

		if( ( wasdKeys[0] ) && (playerY != 0) && ( arrayContains(backgroundBlocks, arrWorld[playerX][max(playerY - 1, 0)]) ) )
		{
			playerY--;
		}
		if( ( wasdKeys[1] ) && (playerX != 0) && ( arrayContains(backgroundBlocks, arrWorld[max(playerX - 1, 0)][playerY]) ) )
		{
			facingLeft = true;
			playerX--;
		}
		if( ( wasdKeys[2] ) && (playerY != arrWorld[0].length - 1) && ( arrayContains(backgroundBlocks, arrWorld[playerX][min(playerY + 1, arrWorld[0].length)]) ) )
		{
			playerY++;
		}
		if( ( wasdKeys[3] ) && (playerX != arrWorld.length - 1) && ( arrayContains(backgroundBlocks, arrWorld[min(playerX + 1, arrWorld.length)][playerY]) ) )
		{
			facingLeft = false;
			playerX++;
		}
		//debugLog(playerX + ", " + playerY);
		blockCovered = arrWorld[playerX][playerY];
		arrWorld[playerX][playerY] = 19;
	}

	if( ( ( mouseX != pmouseX ) || ( mouseY != pmouseY ) || (forcePreviewUpdate == true) ) && (!bigPreview) )
	{
		mouseSelectedBlockX = mouseX - 299;
		mouseSelectedBlockY = mouseY - 79;
		forcePreviewUpdate = false;
		updateLittlePreview(mouseSelectedBlockX, mouseSelectedBlockY);
	}

	if( ( ( mouseX != pmouseX ) || ( mouseY != pmouseY ) ) && (bigPreview) )
	{
		updateSelector();
	}

	if( ( ( playerX != prevPlayerX ) || ( playerY != prevPlayerY ) || (forcePreviewUpdate == true) ) && (bigPreview) )
	{
		forcePreviewUpdate = false;
		updateBigPreview(playerX, playerY);
		updateSelector();
		//debugLog("Drew Big Preview.");
	}
};

void keyReleased()
{
	if( key == '`' || key == '~' )
	{
		SetWebScreenSize();
		forcePreviewUpdate = true;
		if( !bigPreview )
		{
			IntroMessages();
			DumpPixelArray(arrWorld);
		}
	};

	if( key == '+' || key == '=' )
	{
		forcePreviewUpdate = true;
		if( myTextures )
		{
			loadMinecraftTextures();
		}
		else
		{
			loadMyTextures();
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
			IntroMessages();

			strokeWeight(1);
			stroke(#000000);
			point(250, 250);

			DumpPixelArray(arrWorld);
		}
		else
		{
			blockSize = 32;
			screenScale = 4;
		}
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
};

void keyPressed()
{
	if( key == 'w' || key == 'W' )
	{
		wasdKeys[0] = true;
	}

	if( key == 'a' || key == 'A' )
	{
		wasdKeys[1] = true;
	}

	if( key == 's' || key == 'S' )
	{
		wasdKeys[2] = true;
	}

	if( key == 'd' || key == 'D' )
	{
		wasdKeys[3] = true;
	}
}

boolean mouseCanInteract()
{
	if( mouseOverEdge || arrayContains(selectorBlacklist, arrWorld[mouseBlockX][mouseBlockY]) )
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
	if( ( playerX == playerXPrevSelector ) && ( playerY == playerYPrevSelector ) && mouseCanInteract() )
	{
		drawBlock(mouseBlockX, mouseBlockY, selectorX, selectorY);
		/*
		pushMatrix();
		if( blockFlip[mouseBlockX][mouseBlockY] )
		{
			translate(selectorX, selectorY);
		}
		else
		{
			translate(selectorX + blockSize, selectorY);
			scale(-1, 1);
		}

		if( mouseCanInteract() )
		{
			image(blockImages[0], 0, 0, blockSize, blockSize);
			image(blockImages[arrWorld[mouseBlockX][mouseBlockY]], 0, 0, blockSize, blockSize);
		}
		popMatrix();
		*/
	}

	playerXPrevSelector = playerX;
	playerYPrevSelector = playerY;

	selectorX = blockSize * floor( mouseX / blockSize );
	selectorY = blockSize * floor( mouseY / blockSize );

	mouseOverEdge = false;

	mouseBlockX = playerX - previewWidth + floor(mouseX / blockSize);
	mouseBlockY = playerY - previewHeight + floor(mouseY / blockSize);

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
		for(int j = playerY-1; j <= playerY+1; j++)
		{
			DumpPixel(arrWorld, i, j);
		}
	}

	for(int i = -16/screenScale; i <= 16/screenScale; i++)
	{
		for(int j = -16/screenScale; j <= 16/screenScale; j++)
		{
			/*
			image(blockImages[0], 145 + blockSize*j, 400 + blockSize*i, blockSize, blockSize);
			if( ( centerY+i >= 0 ) && ( centerX+j >= 0 ) && ( centerY+i < arrWorld[0].length ) && ( centerX+j < arrWorld.length ) )
			{
				if( arrWorld[centerX+j][centerY+i] == 19 )
				{
					pushMatrix();
					image(blockImages[blockCovered], 145 + blockSize * j, 400 + blockSize * i, blockSize, blockSize);
					if( !facingLeft )
					{
						translate(145 + blockSize * j, 400 + blockSize * i);
					}
					else
					{
						translate(145 + blockSize + blockSize * j, 400 + blockSize * i);
						scale(-1, 1);
					}
					image(blockImages[19], 0, 0, blockSize, blockSize);
					popMatrix();
				}
				else
				{
					image(blockImages[arrWorld[centerX+j][centerY+i]], 145 + blockSize * j, 400 + blockSize * i, blockSize, blockSize);
				}
			}
			*/
			drawBlock(centerX+j, centerY+i, 145 + blockSize*j, 400 + blockSize*i);
		}
	}
};

void updateBigPreview(int centerX, int centerY)
{
	/*
	for(int i = -previewHeight; i <= previewHeight; i++)
	{
		for(int j = -previewWidth; j <= previewWidth; j++)
		{
			image(blockImages[0], screenCenterX + blockSize*j, screenCenterY + blockSize*i, blockSize, blockSize);

			if( ( centerX+j >= 0 ) && ( centerX+j < arrWorld.length ) && ( centerY+i >= 0 ) && ( centerY+i < arrWorld[0].length ) )
			{
				if( arrWorld[centerX+j][centerY+i] == 19 )
				{
					pushMatrix();
					image(blockImages[blockCovered], screenCenterX + blockSize * j, screenCenterY + blockSize * i, blockSize, blockSize);
					if( !facingLeft )
					{
						translate(screenCenterX + blockSize * j, screenCenterY + blockSize * i);
					}
					else
					{
						translate(screenCenterX + blockSize + blockSize * j, screenCenterY + blockSize * i);
						scale(-1, 1);
					}
					image(blockImages[19], 0, 0, blockSize, blockSize);
					popMatrix();
				}
				else
				{
					pushMatrix();
					if( blockFlip[centerX+j][centerY+i] )
					{
						translate(screenCenterX + blockSize * j, screenCenterY + blockSize * i);
					}
					else
					{
						translate(screenCenterX + blockSize + blockSize * j, screenCenterY + blockSize * i);
						scale(-1, 1);
					}
					image(blockImages[arrWorld[centerX+j][centerY+i]], 0, 0, blockSize, blockSize);
					popMatrix();
				}
			}
		}
	}
	*/

	for(int i = -previewHeight; i <= previewHeight; i++)
	{
		for(int j = -previewWidth; j <= previewWidth; j++)
		{
			drawBlock(centerX+j, centerY+i, screenCenterX + blockSize * j, screenCenterY + blockSize * i);
		}
	}
};

void drawBlock(int matrixX, int matrixY, int screenX, int screenY)
{
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
			image(blockImages[blockCovered], screenX, screenY, blockSize, blockSize);
			if( !facingLeft )
			{
				translate(screenX, screenY);
			}
			else
			{
				translate(screenX + blockSize, screenY);
				scale(-1, 1);
			}
			image(blockImages[19], 0, 0, blockSize, blockSize);
			popMatrix();
		}
		else
		{
			pushMatrix();
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
			popMatrix();
		}
	}
};

void loadMinecraftTextures()
{
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
	blockImages[19] = loadImage("data/mc/player.png");

	blockImages[56] = loadImage("data/mc/diamond_ore.png");

	grassBlocks[0] = loadImage("data/mc/grass.png");
	grassBlocks[1] = loadImage("data/mc/grass-left.png");
	grassBlocks[2] = loadImage("data/mc/grass-both.png");
	grassBlocks[3] = loadImage("data/mc/grass-right.png");
};

void loadMyTextures()
{
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
	blockImages[19] = loadImage("data/mine/player.png");

	blockImages[56] = loadImage("data/mine/diamond_ore.png");

	grassBlocks[0] = loadImage("data/mine/grass.png");
	grassBlocks[1] = loadImage("data/mine/grass-left.png");
	grassBlocks[2] = loadImage("data/mine/grass-both.png");
	grassBlocks[3] = loadImage("data/mine/grass-right.png");
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

int CountInArray(int[][] toRead, int toFind)
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

int[][] AddRoughCircle(int[][] arrayToEdit, int xCenter, int yCenter, int radius, int drawWith, int randomness)
{
	for (int j = 0; j <= radius; j++)
	{
		int intCurrentY = yCenter - radius - j;
		int Temp = int(sqrt(radius * radius - j * j));

		//int intLowerX = xCenter - Temp;
		//int intUpperX = xCenter + Temp;

		int intLowerX = xCenter - RandInt(Temp - randomness, Temp + randomness);
		int intUpperX = xCenter + RandInt(Temp - randomness, Temp + randomness);

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

		int intLowerX = xCenter - RandInt(Temp - randomness, Temp + randomness);
		int intUpperX = xCenter + RandInt(Temp - randomness, Temp + randomness);

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

void DumpPixelArrayWork()
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

void DumpPixelArray(int[][] toDraw)
{
	dpaWorking = true;
	dpaToDraw = toDraw;
	dpaI = 0;
};

void DumpPixel(int[][] toDraw, int xToDraw, int yToDraw)
{
	stroke(blockColors[toDraw[xToDraw][yToDraw]]);
	point(300 + xToDraw, 80 + yToDraw);
};

void LogArray(int[][] toDraw)
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

void GenerateWorld()
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
		arrWorld = AddRoughCircle(arrWorld, RandInt(0, arrWorld.length), RandInt(195,200), RandInt(2,8), 3, 0);
	}

	// Add Grass and Tress
	for(int i = 0; i < arrWorld.length; i++)
	{
		for(int j = 0; j < arrWorld[0].length; j++)
		{
			if(arrWorld[i][j] == 3)
			{
				arrWorld[i][j] = 2;
				if( RandInt(0,9) == 0 )
				{
					// Add a tree
					arrWorld[i][j] = 3;
					int treeHeight = RandInt(4,8);
					int leafRadius = RandInt(3,5);
					//debugLog("Adding tree.  Height: " + treeHeight + ", Leaves: " + leafRadius);

					AddRoughCircle(arrWorld, i, j - treeHeight + leafRadius - 1, leafRadius, 18, 1);

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
		arrWorld = AddRoughCircle(arrWorld, RandInt(0,arrWorld.length), RandInt(204,201), RandInt(1,6), 1, 2);
	}

	// Add Coal
	for(int i = 0; i <= arrWorld.length / 4; i++)
	{
		arrWorld = AddRoughCircle(arrWorld, RandInt(0,arrWorld.length), RandInt(200,399), 3, 16, 1);
	}

	// Add Iron
	for(int i = 0; i <= arrWorld.length / 4; i++)
	{
		arrWorld = AddRoughCircle(arrWorld, RandInt(0,arrWorld.length), RandInt(200,399), 2, 15, 1);
	}

	// Add Diamonds
	for(int i = 0; i <= .25 * arrWorld.length / 4; i++)
	{
		arrWorld = AddRoughCircle(arrWorld, RandInt(0,arrWorld.length), RandInt(350,400), 1, 56, 1);
	}

	// Add Gold
	for(int i = 0; i <= .3 * arrWorld.length / 4; i++)
	{
		arrWorld = AddRoughCircle(arrWorld, RandInt(0,arrWorld.length), RandInt(350,400), 1, 14, 1);
	}

	// Bedrock
	for(int i = 0; i < arrWorld.length; i++)
	{
		arrWorld[i][400] = 7;
	};

	debugLog("Iron: " + CountInArray(arrWorld, 15));
	debugLog("Coal: " + CountInArray(arrWorld, 16));
	debugLog("Diamonds: " + CountInArray(arrWorld, 56));
	debugLog("Gold: " + CountInArray(arrWorld, 14));

	for(int i = 0; i < blockFlip.length; i++)
	{
		for(int j = 0; j < blockFlip[0].length; j++)
		{
			blockFlip[i][j] = RandBool();
		}
	}
};

int RandInt(int min, int max)
{
	return round(random(min,max));
};

boolean RandBool()
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

void IntroMessages()
{
	stroke(#000000);
	fill(#000000);
	textSize(12);
	text("Click on the canvas to focus sketch.  If the screen gets resized, press the ~ key to repaint. ", 20, 20);
	text("Here is a smiley face image for testing purposes.", 20, 40);
	text("Here is the Generated World:", 300, 70);
	DrawTestImage();
};

void DrawTestImage()
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

	strokeWeight(1);		// This caused so many problems.  Bad Smiley.  -|==>  :(  <==|-
	};

	// These are Garbage functions that get overwritten by WebCode if on web.
	void SetWebScreenSize() {};
	void WebSetup() {};
