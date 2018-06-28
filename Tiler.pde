PImage tileImg0, tileImg1;	// two test images, non-generated
PImage mask;				// mask for image generator testing
PImage videoMask;			// mask for vieo output
TileSystem ts1, ts2;		// declare ts as a Tile System
float testScale = 0.05;		// scale for testing tile systems, adjusted with mouse wheel
int history = 24;			// length of tile history (minimum 1)
float strokeW;				// global to hold stroke weight

// ********************************************************************************************************************
void settings() {
	size(1280,720,P3D);
	// fullScreen();
	PJOGL.profile=1;
	smooth(8);
	// noLoop();
	// noSmooth();
	// fullScreen(1);
}

// ********************************************************************************************************************
void setup(){

	// processing sound
	amp = new Amplitude(this);
	in = new AudioIn(this, 0);
	in.start();
	amp.input(in);

	// minim
	minim = new Minim(this);
	myAudioInput = minim.getLineIn(Minim.STEREO,16);
	l = myAudioInput.left.get(0);
	r = myAudioInput.right.get(0);

	noCursor();
	background(0);
	frameRate(24);
	tileImg0 = loadImage("tile-test-2.png"); // tile image for testing
	tileImg1 = loadImage("tile-test-i.png"); // alternate tile image for testing
	mask = loadImage("mask.png"); // test mask
	videoMask = loadImage("VideoMaskBW.png"); // test video mask 
	ts1 = new TileSystem(mask,symmetry12M,tiling12M,6,20);
	ts1.setHistory();
	ts2 = new TileSystem(mask,symmetry12M,tiling12M,6,20);
	ts2.setHistory();

}

// ********************************************************************************************************************
void draw(){
	surface.setTitle( int(frameRate) + " FPS" );

	l = myAudioInput.left.get(0);
	r = myAudioInput.right.get(0);
	strokeW = mapCurve(l,0,1,3,1000,2);
	// strokeW = mapCurve(r,0,1,3,1000,2);
	// strokeW = mapCurve(amp.analyze(),0,1,3,1000,2);
	// strokeW = amp.analyze() * 1000;
	strokeWeight(strokeW);
	println("strokeW: "+strokeW);

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

	pushMatrix();
	translate(width/2, height/2); // work at the center
	scale(0.2);
	rotate(-PI*millis()/60000);
	ts2.display();
	popMatrix();

	// test screen coordinates - make this a function
	// fill(255,24,24);
	// rectMode(CENTER);
	// for (int i = 0; i < ts1.tileArray.length; ++i) { // cycle through all cells
	// 	rect(ts1.tileArray[i].screenX,ts1.tileArray[i].screenY,3,3);
	// }
	blendMode(MULTIPLY);
	image(videoMask,0,0);
}

// ********************************************************************************************************************
// misellaneous functions
float mapCurve (float value, float low1, float high1, float low2, float high2, float power) {
	return(pow(map(value, low1, high1, low2, high2),power));
}

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
  if(testScale<0.05) {testScale = 0.05;};
  // println("Scale: "+testScale);
}

