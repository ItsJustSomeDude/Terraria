/*
	@pjs
		crisp="true";
		pauseOnBlur="true";
		preload="data/bedrock.png",
				"data/air.png";

*/

// [rows][cols]
int[][] arrWorld = new int[401][800];
PImage[] blockImages = new PImage[100];
int mouseSelectedBlockX = 0;
int mouseSelectedBlockY = 0;

void settings()
{
	// This only runs on PC, Web ignores it.
	size(800, 600);
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

	blockImages[0] = loadImage("data/air.png");
	blockImages[1] = loadImage("data/stone.png");
	blockImages[2] = loadImage("data/grass.png");
	blockImages[3] = loadImage("data/dirt.png");
	blockImages[7] = loadImage("data/bedrock.png");

	IntroMessages();
	GenerateWorld();

	//int[][] arrayTest = new int[100][100];

	//DumpPixelArray(AddRoughCircle(arrayTest, 50, 50, 60, 1, 0));
};

void draw()
{
	mouseSelectedBlockX = mouseX - 299;
	mouseSelectedBlockY = mouseY - 79;

	print(mouseSelectedBlockX + ", ");
	println(mouseSelectedBlockY);

	

	if(keyPressed)
	{
		if( key == '`' || key == '~' )
		{
			SetWebScreenSize();
			IntroMessages();
			DumpPixelArray(arrWorld);
		};
	};
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
}

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
}

void DumpPixelArray(int[][] toDraw)
{
	noSmooth();
	noStroke();
	for(int i = 0; i < toDraw.length; i++)
	{
		for(int j = 0; j < toDraw[0].length; j++)
		{
			if( toDraw[i][j] == 0 )
			{
				stroke(204, 255, 255);
			}
			else if( toDraw[i][j] == 1 )
			{
				stroke(128, 128, 128);
			}
			else if( toDraw[i][j] == 2 )
			{
				stroke(0, 204, 0);
			}
			else if( toDraw[i][j] == 3 )
			{
				stroke(153, 102, 51);
			}
			else if( toDraw[i][j] == 7 )
			{
				stroke(0, 0, 0);
			}
			else if( toDraw[i][j] == 15 )
			{
				stroke(255, 191, 128);
			}
			else if( toDraw[i][j] == 16 )
			{
				stroke(38, 38, 38);
			}
			else if( toDraw[i][j] == 56 )
			{
				stroke(0, 204, 255);
			}
			else if( toDraw[i][j] == 14 )
			{
				stroke(255, 255, 102);
			}
			else if( toDraw[i][j] == 11 )
			{
				stroke(255, 102, 0);
			}
			point(300 + j, 80 + i);
		}
	}
}

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
}

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

	// Add Grass
	for(int i = 0; i < arrWorld[0].length; i++)
	{
		for(int j = 0; j < arrWorld.length; j++)
		{
			if(arrWorld[j][i] == 3)
			{
				arrWorld[j][i + RandInt(0, 1)] = 2;
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
		arrWorld = AddRoughCircle(arrWorld, RandInt(0,arrWorld[0].length), RandInt(200,399), 3, 16, 2);
	}

	// Add Iron
	for(int i = 0; i <= arrWorld[0].length / 4; i++)
	{
		arrWorld = AddRoughCircle(arrWorld, RandInt(0,arrWorld[0].length), RandInt(200,399), 3, 15, 2);
	}

	// Add Diamonds
	for(int i = 0; i <= .25 * arrWorld[0].length / 4; i++)
	{
		arrWorld = AddRoughCircle(arrWorld, RandInt(0,arrWorld[0].length), RandInt(350,400), 2, 56, 2);
	}

	// Add Gold
	for(int i = 0; i <= .3 * arrWorld[0].length / 4; i++)
	{
		arrWorld = AddRoughCircle(arrWorld, RandInt(0,arrWorld[0].length), RandInt(350,400), 2, 14, 2);
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
}

void IntroMessages()
{
	stroke(#000000);
	fill(#000000);
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
}

void DrawSquare(int x, int y, int size, color c )
{
	fill(c);
	noStroke();
	rect(x, y, size, size);
};

// These are Garbage functions that get overwritten by WebCode if on web.
void SetWebScreenSize() {};
void WebSetup() {};
