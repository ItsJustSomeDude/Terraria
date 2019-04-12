int[][] AddRoughCircle(int[][] arrayToEdit, int xCenter, int yCenter, int radius, int drawWith)
{
	for (int j = 0; j <= radius; j++)
	{
		int intCurrentY = yCenter - radius - j;
		int Temp = int(sqrt(radius * radius - j * j));
		int intLowerX = xCenter - RandInt(Temp - 2, Temp + 2);
		int intUpperX = xCenter + RandInt(Temp - 2, Temp + 2);

		for (int k = intLowerX; k <= intUpperX; k++)
		{
  			if ((intCurrentY >= 0) && (intCurrentY <= arrayToEdit[0].length - 1) && (k >= 0) && (k <= arrayToEdit[0].length - 1))
  			{
				arrayToEdit[intCurrentY][k] = drawWith;
			}
		}
	}
	return arrayToEdit;
}
