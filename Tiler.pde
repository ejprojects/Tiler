
void settings() {
	size(400,400,P3D);
	PJOGL.profile=1;
	smooth();
	noLoop();
	// noSmooth();
	// fullScreen(1);
}

// ********************************************************************************************************************
void setup(){

	frameRate(30);
	tileImg = loadImage("tile-test.png"); // this will be replaced with the generated tiles later

}

// ********************************************************************************************************************
void draw(){

	// using the PGraphics tile as a container to render to (trivially for now)
	tile = createGraphics(100,100);
	tile.beginDraw();
	tile.image(tileImg,0,0);
	tile.endDraw();

	// supertile testing loop
	translate(width/2, height/2); // at center of window
	for (int i = 0; i < symRot.length; ++i) { //cycle through the symmetry data (develop this)
		pushMatrix();
		rotate(symRot[i]); // rotate the prescribed amount
		rotate((symFlip[i] == -1) ? -HALF_PI : 0); // rotate to accommodate flip if necessary (improve)
		scale(symFlip[i],1); // flip if prescribed
		image(tile,0,0); // draw it
		popMatrix();
	}


}

// ********************************************************************************************************************
PImage tileImg; // this loads a tile image

// set up symmetry variable arrays. turn this into a class with a good data structure
float[] symRot = {0, HALF_PI, PI, PI+HALF_PI};
// int[] symFlip = {1, -1, 1, -1};
int[] symFlip = {1, 1, 1, 1};

PGraphics tile; // the container for the individual tiles that will build:
PGraphics superTile; // the supertile, to repeat over the plane
