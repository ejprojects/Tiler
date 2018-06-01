PImage tileImg0, tileImg1;	// two test images, non-generated
PImage mask;				// mas for image generator testing
TileGenerator tg;			// declare tile generator - needs to be part of tile system
TileSystem ts;				// declare ts as a Tile System

// ********************************************************************************************************************
void settings() {
	size(600,600,P3D);
	PJOGL.profile=1;
	smooth();
	// noLoop();
	// noSmooth();
	// fullScreen(1);
}

// ********************************************************************************************************************
void setup(){

	background(48);
	frameRate(30);
	tileImg0 = loadImage("tile-test.png"); // tile image for testing
	tileImg1 = loadImage("tile-test-i.png"); // alternate tile image for testing
	mask = loadImage("mask.png"); // test mask
	tg = new TileGenerator(mask,0); // test mask, test mode
	ts = new TileSystem(mask,symmetry12M,692.6,600,1,1,346.3,600);

}

// ********************************************************************************************************************
void draw(){
	clr(); //clear the background

	image(ts.tile.imgList[0],0,0);

	translate(mouseX, mouseY); // work at the mouse location
	scale(0.25);

	ts.display();

}

// ********************************************************************************************************************
// misellaneous functions
void clr() {
	noStroke();
	fill(48,32);
	rect(0,0,width,height);
}
void mousePressed() {
	// ts.update(); //can i use . syntax to go direct to Tile?
	println("mouse 1");
	println("ts.tile.wd: "+ts.tile.wd+" ts.tile.ht: "+ts.tile.ht);
}
void mouseReleased() {
	// ts.choose(0);
	println("mouse 0");
}

