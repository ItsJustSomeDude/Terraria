/*
	@pjs
		crisp="true";
		pauseOnBlur="false";
		preload="data/mc/air.png",
				"data/mc/dirt.png",
				"data/mc/grass.png",
				"data/mc/stone.png",
				"data/mc/bedrock.png",
				"data/mc/iron_ore.png",
				"data/mc/coal_ore.png",
				"data/mc/gold_ore.png",
				"data/mc/logs.png",
				"data/mc/leaves.png",
				"data/mc/diamond_ore.png",

				"data/mine/air.png",
				"data/mine/dirt.png",
				"data/mine/grass.png",
				"data/mine/stone.png",
				"data/mine/bedrock.png",
				"data/mine/iron_ore.png",
				"data/mine/coal_ore.png",
				"data/mine/gold_ore.png",
				"data/mine/logs.png",
				"data/mine/leaves.png",
				"data/mine/diamond_ore.png";
*/

// [rows][cols]
int[][] arrWorld = new int[401][800];
PImage[] blockImages = new PImage[100];
int mouseSelectedBlockX = 0;
int mouseSelectedBlockY = 0;
int blockSize = 16;
int screenScale = 2;
boolean myTextures = false;
boolean forcePreviewUpdate = false;

// DumpPixelArray runs outside in draw().
// Because of this, I need a bunch of vars to hold things.
// Prefix: dpa
boolean dpaWorking = false;
int[][] dpaToDraw;
int dpaI = 0;

void settings()
{
	// This only runs on PC, Web ignores it.
	size(1200, 600);
	noSmooth();
}

void setup()
{
	SetWebScreenSize();
	WebSetup();
	background(#FFFFFF);
	stroke(#000000);
	fill(#000000);
	println("Program Start.");

	loadMyTextures();

	IntroMessages();
	GenerateWorld();

	//int[][] arrayTest = new int[100][100];

	//DumpPixelArray(AddRoughCircle(arrayTest, 50, 50, 60, 1, 0));
};

void draw()
{
	if(!focused)
	{
		fill(0, 0, 0);
		textSize(20);
		text("Click to Focus", 700, 50);
	}
	else
	{
		fill(255, 255, 255);
		textSize(20);
		text("Click to Focus", 700, 50);
	}

	if(dpaWorking) { DumpPixelArrayWork(); };

	mouseSelectedBlockX = mouseX - 299;
	mouseSelectedBlockY = mouseY - 79;

	//print(mouseSelectedBlockX + ", ");
	//println(mouseSelectedBlockY);

	if( ( mouseX != pmouseX ) || ( mouseY != pmouseY ) || (forcePreviewUpdate == true) )
	{
		forcePreviewUpdate = false;
		for(int i = -16/screenScale; i <= 16/screenScale; i++)
		{
			for(int j = -16/screenScale; j <= 16/screenScale; j++)
			{
				image(blockImages[0], 145 + blockSize*j, 400 + blockSize*i, blockSize, blockSize);
				if( ( mouseSelectedBlockY+i >= 0 ) && ( mouseSelectedBlockX+j >= 0 ) && ( mouseSelectedBlockY+i < arrWorld.length ) && ( mouseSelectedBlockX+j < arrWorld[0].length ) )
				{
					image(blockImages[arrWorld[mouseSelectedBlockY+i][mouseSelectedBlockX+j]], 145 + blockSize*j, 400 + blockSize*i, blockSize, blockSize);
				}
			}
		}
	}
};

void keyReleased()
{
	if( key == '`' || key == '~' )
	{
		SetWebScreenSize();
		IntroMessages();
		DumpPixelArray(arrWorld);
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

	blockImages[56] = loadImage("data/mc/diamond_ore.png");
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

	blockImages[56] = loadImage("data/mine/diamond_ore.png");
};

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
			if ((intCurrentY >= 0) && (intCurrentY <= arrayToEdit[0].length - 1) && (k >= 0) && (k <= arrayToEdit[0].length - 1))
			{
				arrayToEdit[intCurrentY][k] = drawWith;
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
			if ((intCurrentY >= 0) && (intCurrentY <= arrayToEdit.length - 1) && (k >= 0) && (k <= arrayToEdit[0].length - 1))
			{
				arrayToEdit[intCurrentY][k] = drawWith;
			}
		}
	}
	return arrayToEdit;
};

void DumpPixelArrayWork()
{
	int tmp = 0;
	for(int j = 0; j < dpaToDraw[0].length; j++)
	{
		tmp = dpaToDraw[dpaI][j];
		if( tmp == 0 )
		{
			stroke(204, 255, 255);
		}
		else if( tmp == 1 )
		{
			stroke(128, 128, 128);
		}
		else if( tmp == 2 )
		{
			stroke(0, 204, 0);
		}
		else if( tmp == 3 )
		{
			stroke(153, 102, 51);
		}
		else if( tmp == 7 )
		{
			stroke(0, 0, 0);
		}
		else if( tmp == 15 )
		{
			stroke(255, 191, 128);
		}
		else if( tmp == 16 )
		{
			stroke(38, 38, 38);
		}
		else if( tmp == 17 )
		{
			stroke(109, 49, 18);
		}
		else if( tmp == 18 )
		{
			stroke(51, 153, 51);
		}
		else if( tmp == 56 )
		{
			stroke(0, 204, 255);
		}
		else if( tmp == 14 )
		{
			stroke(255, 255, 102);
		}
		else if( tmp == 11 )
		{
			stroke(255, 102, 0);
		}
		point(300 + j, 80 + dpaI);
	}

	if( dpaI == dpaToDraw.length - 1 )
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
		println(row);
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
	for(int i = 200; i <= 399; i++)
	{
		for(int j = 0; j < arrWorld[0].length; j++)
		{
			arrWorld[i][j] = 1;
		};
	};

	// Dirt
	for(int i = 190; i <= 199; i++)
	{
		for(int j = 0; j < arrWorld[0].length; j++)
		{
			arrWorld[i][j] = 3;
		};
	};

	// Add Surface Randomness
	for(int i = 0; i <= arrWorld[0].length; i++)
	{
		arrWorld = AddRoughCircle(arrWorld, RandInt(0,arrWorld[0].length), RandInt(195,200), RandInt(2,8), 3, 0);
	}

	// Add Grass and Tress
	for(int i = 0; i < arrWorld[0].length; i++)
	{
		for(int j = 0; j < arrWorld.length; j++)
		{
			if(arrWorld[j][i] == 3)
			{
				arrWorld[j][i] = 2;
				if( RandInt(0,9) == 0 )
				{
					// Add a tree
					arrWorld[j][i] = 3;
					int treeHeight = RandInt(4,8);

					int leafRadius = RandInt(3,5);
					//println("Adding tree.  Height: " + treeHeight + ", Leaves: " + leafRadius);

					AddRoughCircle(arrWorld, i, j - treeHeight + leafRadius - 1, leafRadius, 18, 1);

					for(int k = j - 1; k >= j - treeHeight; k--)
					{
						arrWorld[k][i] = 17;
					}
				}
				break;
			}
		}
	}

	/*
	for(int i = 0; i < arrWorld[0].length; i++)
	{

	};
	*/

	// Add Sub-Surface Randomness
	for(int i = 0; i <= arrWorld[0].length; i++)
	{
		arrWorld = AddRoughCircle(arrWorld, RandInt(0,arrWorld[0].length), RandInt(204,201), RandInt(1,6), 1, 2);
	}

	// Add Coal
	for(int i = 0; i <= arrWorld[0].length / 4; i++)
	{
		arrWorld = AddRoughCircle(arrWorld, RandInt(0,arrWorld[0].length), RandInt(200,399), 3, 16, 1);
	}

	// Add Iron
	for(int i = 0; i <= arrWorld[0].length / 4; i++)
	{
		arrWorld = AddRoughCircle(arrWorld, RandInt(0,arrWorld[0].length), RandInt(200,399), 2, 15, 1);
	}

	// Add Diamonds
	for(int i = 0; i <= .25 * arrWorld[0].length / 4; i++)
	{
		arrWorld = AddRoughCircle(arrWorld, RandInt(0,arrWorld[0].length), RandInt(350,400), 1, 56, 1);
	}

	// Add Gold
	for(int i = 0; i <= .3 * arrWorld[0].length / 4; i++)
	{
		arrWorld = AddRoughCircle(arrWorld, RandInt(0,arrWorld[0].length), RandInt(350,400), 1, 14, 1);
	}

	// Bedrock
	for(int i = 0; i < arrWorld[0].length; i++)
	{
		arrWorld[400][i] = 7;
	};

	println("Iron: " + CountInArray(arrWorld, 15));
	println("Coal: " + CountInArray(arrWorld, 16));
	println("Diamonds: " + CountInArray(arrWorld, 56));
	DumpPixelArray(arrWorld);
};

int RandInt(int min, int max)
{
	return int(random(min,max));
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
};

void DrawSquare(int x, int y, int size, color c )
{
	fill(c);
	noStroke();
	rect(x, y, size, size);
};

// These are Garbage functions that get overwritten by WebCode if on web.
void SetWebScreenSize() {};
void WebSetup() {};
