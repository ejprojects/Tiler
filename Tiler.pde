PImage tileImg0, tileImg1;	// two test images, non-generated
PImage mask;				// mask for image generator testing
TileSystem ts1, ts2;		// declare ts as a Tile System
float testScale = 0.05;		// scale for testing tile systems, adjusted with mouse wheel
int history = 120;			// length of tile history (minimum 1)

// ********************************************************************************************************************
void settings() {
	size(1280,720,P3D);
	PJOGL.profile=1;
	smooth(8);
	// noLoop();
	// noSmooth();
	// fullScreen(1);
}

// ********************************************************************************************************************
void setup(){

	noCursor();
	background(0);
	frameRate(30);
	tileImg0 = loadImage("tile-test-2.png"); // tile image for testing
	tileImg1 = loadImage("tile-test-i.png"); // alternate tile image for testing
	mask = loadImage("mask.png"); // test mask
	ts1 = new TileSystem(mask,symmetry12M,tiling12M,12,40);
	ts1.setHistory();
	// ts2 = new TileSystem(mask,symmetry12M,tiling12M,3,9);
	// ts2.setHistory();

}

// ********************************************************************************************************************
void draw(){
	frame.setTitle(nf(int(frameRate)));

	// clr(); //clear the background
	background(0);
	blendMode(ADD);

	// ts1.tile.displayTile(0,0,0);

	pushMatrix();
	translate(mouseX, mouseY); // work at the mouse location
	scale(testScale);
	rotate(PI*millis()/20000);
	ts1.display();
	popMatrix();

	// pushMatrix();
	// translate(width/2, height/2); // work at the center
	// scale(0.5);
	// ts2.display();
	// popMatrix();

	// test screen coordinates
	// fill(255,24,24);
	// rectMode(CENTER);
	// for (int i = 0; i < ts1.tileArray.length; ++i) { // cycle through all cells
	// 	rect(ts1.tileArray[i].screenX,ts1.tileArray[i].screenY,3,3);
	// }

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

