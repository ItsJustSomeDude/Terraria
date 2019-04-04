/*
	@pjs crisp="true";
		 pauseOnBlur="true";
*/

// [rows][cols]
int[][] arrWorld = new int[401][800];

void setup()
{
	size(window.innerWidth, window.innerHeight);
	console.clear();
	background(#FFFFFF);
	stroke(#000000);
	fill(#000000);
	textFont(loadFont("FFScala.ttf"));
	console.log("I have landed!");

	IntroMessages();
	GenerateWorld();
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
	int numToDraw;
	int numToRand;
	int yCenterTemp;
	int randTmp;
	for(int i = 0 - radius; i < radius; i++)
	{
		numToDraw = i + ( i - 1 );
		numToRand = numToDraw + ( 2 * RandInt(0 - randomness, randomness) );
		xCenterTemp = xCenter + RandInt(0 - randomness, randomness);
		for(int j = 0; j < numToRand; j++)
		{
			if( ( ( yCenter + i - radius ) >= 0 ) && ( ( yCenter + i - radius ) < arrayToEdit.length ) && ( ( xCenterTemp + j - int(numToRand / 2 ) ) >= 0 ) && ( ( xCenterTemp + j - int(numToRand / 2 ) ) < arrayToEdit[0].length ) )
			{
				arrayToEdit[yCenter + i - radius][xCenterTemp + j - int(numToRand / 2 )] = drawWith;
			}
		}
		numToRand = numToDraw + ( 2 * RandInt(0 - randomness, randomness) );
		for(int j = 0; j < numToRand; j++)
		{
			if( ( ( yCenter - i + radius ) >= 0 ) && ( ( yCenter - i + radius ) < arrayToEdit.length ) && ( ( xCenterTemp + j - int(numToRand / 2 ) ) >=0 ) && ( ( xCenterTemp + j - int(numToRand / 2 ) ) < arrayToEdit[0].length ) )
			{
				arrayToEdit[yCenter - i + radius][xCenterTemp + j - int(numToRand / 2 )] = drawWith;
			}
		}
	}

	for(int i = 0; i < 2 * radius - 1; i++)
	{
		arrayToEdit[yCenter][xCenter + i - radius + 1] = drawWith;
	}
	return arrayToEdit;
}

void DumpPixelArray(toDraw)
{
	noSmooth();
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

void LogArray(toDraw)
{
	String row = "";
	for(int i = 0; i < toDraw.length; i++)
	{
		row = "";
		for(int j = 0; j < toDraw[0].length; j++)
		{
			row += toDraw[i][j];
		}
		console.log(row);
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
		arrWorld = AddRoughCircle(arrWorld, RandInt(0,arrWorld[0].length), RandInt(189,191), RandInt(1,8), 3, 0);
	}

	for(int i = 0; i < arrWorld[0].length; i++)
	{
		for(int j = 0; j < arrWorld.length; j++)
		{
			if(arrWorld[j][i] == 3)
			{
				arrWorld[j][i + RandInt(0, 1)] = 2;
				break
			}
		}
	}

	// Add Sub-Surface Randomness
	for(int i = 0; i <= arrWorld[0].length; i++)
	{
		arrWorld = AddRoughCircle(arrWorld, RandInt(0,arrWorld[0].length), RandInt(201,199), RandInt(1,6), 1, 2);
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

	// This needs some serious work.
	/*

	// Add Lava
	int lavaX;
	int lavaY;
	for(int i = 0; i <= .1 * arrWorld[0].length; i++)
	{
		lavaX = RandInt(320,399);
		lavaY = RandInt(2,arrWorld[0].length);
		arrWorld[lavaX][lavaY] = 11;
		arrWorld[lavaX+1][lavaY] = 11;
		arrWorld[lavaX-1][lavaY] = 0;
		arrWorld[lavaX-1][lavaY-2] = 0;
		arrWorld[lavaX-1][lavaY+2] = 0;


		arrWorld[lavaX][lavaY-1] = 11;
		//arrWorld[lavaX+1][lavaY-1] = 11;
		arrWorld[lavaX-1][lavaY-1] = 0;

		arrWorld[lavaX][lavaY+1] = 11;
		//arrWorld[lavaX+1][lavaY+1] = 11;
		arrWorld[lavaX-1][lavaY+1] = 0;
	}

	*/


	// Bedrock
	for(int i = 0; i < arrWorld[0].length; i++)
	{
		arrWorld[400][i] = 7;
	};

	console.log("Iron: " + CountInArray(arrWorld, 15));
	console.log("Coal: " + CountInArray(arrWorld, 16));
	console.log("Diamonds: " + CountInArray(arrWorld, 56));
	DumpPixelArray(arrWorld);
	console.log(arrWorld);
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

void draw()
{
	PaintScreen();

	if(keyPressed)
	{
		if( key == '`' || key == '~' )
		{
			console.log("Changing Size");
			size(window.innerWidth, window.innerHeight);
			IntroMessages();
			DumpPixelArray(arrWorld);
		};

		if( key == '' || key == '' )
		{

		};
	};
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

void PaintScreen()
{


}

void DrawSquare(int x, int y, int size, color c )
{
	fill(c);
	noStroke();
	rect(x, y, size, size);
};
