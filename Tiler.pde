PImage tileImg0, tileImg1;	// two test images, non-generated
PImage mask;				// mas for image generator testing
TileGenerator tg;			// declare tile generator
// Tile t;						// declare t as a member of the Tile class
// Cluster c;					// declare my cluster
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
	// t = new Tile(tileImg0);
	// t.add(tileImg1); // obsolete
	ts = new TileSystem(mask,symmetry12,200,200,6,6,200,200);

}

// ********************************************************************************************************************
void draw(){
	clr(); //clear the background

	translate(mouseX, mouseY); // work at the mouse location

	// ts.display();

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
}
void mouseReleased() {
	// ts.choose(0);
	println("mouse 0");
}

