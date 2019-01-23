/*
   pjs crisp="true";
*/

setup = function()
{
	console.clear();
	noLoop();
	size( window.innerWidth, window.innerHeight );
	background(#FFFFFF);
	font = loadFont("FFScala.ttf");
	textFont(font);
	console.log("I have landed!");
	stroke(#000000);
};

draw = function()
{
	stroke(#000000);
	fill(#000000);
	text("There is no game here right now.  However, this text is being draw on the canvas that the game will be put on.", 20, 20);
	text("Also, here is a smiley face image for testing purposes.", 20, 40);

	fill(233, 224 , 71);
	strokeWeight(7);
	ellipse(250, 250, 300 ,300);
	fill(0);
	ellipse(200, 210 , 30, 70);
	fill(0);
	ellipse(300, 210 , 30, 70);
	fill (255);
	bezier(150, 295, 200, 370, 300, 370, 350, 295);
	line(150, 295, 350, 295);
	line(160, 180, 210, 135);
	line(340, 180, 290, 135);

	noLoop();
};

square = function(int x, int y, int size, color c )
{
	fill(c);
	noStroke();
	rect(x, y, size, size);
}
