/*
	@pjs crisp="true";
		 pauseOnBlur="true";
*/

setup = function()
{
	size(window.innerWidth, window.innerHeight);
	console.clear();
	background(#FFFFFF);
	stroke(#000000);
	fill(#000000);
	textFont(loadFont("FFScala.ttf"));
	console.log("I have landed!");

	int arrWorld;

	text("There is no game here right now.  However, this text is being draw on the canvas that the game will be put on.", 20, 20);
	text("Also, here is a smiley face image for testing purposes.", 20, 40);
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
			DrawTestImage();
		}

		if( key == '' || key == '' )
		{

		}
	}
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
