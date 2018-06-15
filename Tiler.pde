PImage tileImg0, tileImg1;	// two test images, non-generated
PImage mask;				// mask for image generator testing
// TileGenerator tg;			// declare tile generator - needs to be part of tile system
TileSystem ts1, ts2;				// declare ts as a Tile System
float testScale = 0.25;		// scale for testing tile systems, adjusted with mouse wheel

// ********************************************************************************************************************
void settings() {
	size(1000,1000,P3D);
	PJOGL.profile=1;
	smooth(8);
	// noLoop();
	// noSmooth();
	// fullScreen(1);
}

// ********************************************************************************************************************
void setup(){

	background(0);
	frameRate(30);
	tileImg0 = loadImage("tile-test.png"); // tile image for testing
	tileImg1 = loadImage("tile-test-i.png"); // alternate tile image for testing
	mask = loadImage("mask.png"); // test mask
	ts1 = new TileSystem(mask,symmetry12M,tiling12M,3,9);
	ts2 = new TileSystem(mask,symmetry12M,tiling12M,3,9);

}

// ********************************************************************************************************************
void draw(){

	// clr(); //clear the background
	background(0);
	blendMode(ADD);

	// image(ts.tile.imgList[0],0,0);

	pushMatrix();
	translate(mouseX, mouseY); // work at the mouse location
	scale(testScale);
	ts1.display();
	popMatrix();

	pushMatrix();
	translate(width/2, height/2); // work at the center
	scale(0.5);
	rotate(PI*millis()/10000);
	ts2.display();
	popMatrix();



}

// ********************************************************************************************************************
// misellaneous functions
void clr() {
	noStroke();
	fill(48,32);
	rect(0,0,width,height);
}
void mousePressed() {
	println("mouse 1");
	println("ts1.tile.tileWidth: "+ts1.tile.tileWidth+" ts1.tile.tileHeight: "+ts1.tile.tileHeight);
}
void mouseReleased() {
	// ts.choose(0);
	println("mouse 0");
}

void mouseWheel(MouseEvent event) {
  testScale += float(event.getCount())/100;
  if(testScale<0.1) {testScale = 0.1;};
  // println("Scale: "+testScale);
}

