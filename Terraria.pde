/*
	@pjs crisp="true";
		 pauseOnBlur="true";
*/

// [rows][cols]
int[][] arrWorld = new int[401][800];

setup = function()
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

LogArray = function(toPrint)
{
	string currentLine;
	for(int i = 0; i < toPrint.length; i++)
	{
		currentLine = "";
		for(int j = 0; j < toPrint[0].length; j++)
		{
			currentLine += toPrint[i][j];
		}
		console.log(currentLine);
	}
}

CountInArray = function(toRead, toFind)
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

DumpPixelArray = function(toDraw)
{
	noSmooth();
	for(int i = 0; i < toDraw.length; i++)
	{
		for(int j = 0; j < toDraw[0].length; j++)
		{
			if( toDraw[i][j] == 0 )
			{
				stroke(179, 240, 255);
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
			point(300 + j, 80 + i);
		}
	}
}

GenerateWorld = function()
{
	// Add Base World
	// Row  0         =  Bedrock:   7
	// Rows 10 - 49   =  Stone:     1
	// Rows 9 - 6     =  Dirt:      3
	// Rows 5         =  Grass:     2

	// Bedrock
	for(int i = 0; i < arrWorld[0].length; i++)
	{
		arrWorld[400][i] = 7;
	};

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

	// Grass
	for(int i = 0; i < arrWorld[0].length; i++)
	{
		arrWorld[189][i] = 2;
	};

	// Add Coal
	for(int i = 0; i <= arrWorld[0].length; i++)
	{
		arrWorld[RandInt(200,399)][RandInt(1,arrWorld[0].length)] = 16;
	}

	// Add Iron
	for(int i = 0; i <= arrWorld[0].length; i++)
	{
		arrWorld[RandInt(200,399)][RandInt(1,arrWorld[0].length)] = 15;
	}

	console.log("Iron: " + CountInArray(arrWorld, 15));
	console.log("Coal: " + CountInArray(arrWorld, 16));
	DumpPixelArray(arrWorld);
	console.log(arrWorld);
};

RandInt = function(min, max)
{
	return int(random(min,max));
}

IntroMessages = function()
{
	stroke(#000000);
	fill(#000000);
	text("Click on the canvas to focus sketch.  If the screen gets resized, press the ~ key to repaint. ", 20, 20);
	text("Here is a smiley face image for testing purposes.", 20, 40);
	text("Here is the Generated World:", 300, 70);
	DrawTestImage();
};

draw = function()
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

DrawTestImage = function()
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

PaintScreen = function()
{


}


DrawSquare = function(int x, int y, int size, color c )
{
	fill(c);
	noStroke();
	rect(x, y, size, size);
};
