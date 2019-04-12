/*
int[][] AddRoughCircle(int[][] arrayToEdit, int xCenter, int yCenter, int radius, int drawWith, int randomness)
{
	int numToDraw;
	int numToRand;
	int xCenterTemp;
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
		if( ( yCenter >= 0 ) && ( yCenter < arrayToEdit.length ) && ( ( xCenter + i - radius + 1 ) >=0 ) && ( ( xCenter + i - radius + 1 ) < arrayToEdit[0].length ) )
		{
			arrayToEdit[yCenter][xCenter + i - radius + 1] = drawWith;
		}
	}
	return arrayToEdit;
}
*/

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
