PImage tileImg; // this loads a tile image
Tile t; //declare t as a member of the Tile class
Cluster c; //declate my cluster

void settings() {
	size(400,400,P3D);
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
	tileImg = loadImage("tile-test.png"); // this will be replaced with the generated tiles later
	t = new Tile(tileImg);
	c = new Cluster(t);

}

// ********************************************************************************************************************
void draw(){
	clr(); //clear the background
	pushMatrix();
	translate(mouseX, mouseY); // work at the mouse location

	
	c.display();


	popMatrix();
}

// ********************************************************************************************************************
// set up symmetry variable arrays. turn this into a class with a good data structure
float[] symRot = {0, HALF_PI, PI, PI+HALF_PI};
// int[] symFlip = {1, -1, 1, -1};
int[] symFlip = {1, 1, 1, 1};


void clr() {
	noStroke();
	fill(48,32);
	rect(0,0,width,height);
}
// build a tile class - very simple, to be complicated by time variable later
class Tile {
	PImage img;
	int wd, ht;

	Tile (PImage img_) {
		wd = img_.width;
		ht = img_.height;
		img = img_;
	}

	void display() {
		image(img,0,0);
	}
}

// build a cluster class - to hold repeatable tiling units
class Cluster {
	PGraphics cluster;
	int wd, ht;

	Cluster (Tile tile) {
		wd = tile.wd*2; //arbitraily se width and height (calculate exactly based on tile and symmetry later)
		ht = tile.ht*2;
		cluster = createGraphics(wd,ht,P3D); // create the PGraphics
		cluster.beginDraw();
		cluster.translate(wd/2, ht/2); // translate to the center

		for (int i = 0; i < symRot.length; ++i) { //cycle through the symmetry data (develop this)
			cluster.pushMatrix();
			cluster.rotate(symRot[i]); // rotate the prescribed amount
			cluster.rotate((symFlip[i] == -1) ? -HALF_PI : 0); // rotate to accommodate flip if necessary (improve)
			cluster.scale(symFlip[i],1); // flip if prescribed
			cluster.image(tile.img, 0, 0, tile.wd, tile.ht); // place it
		}

		cluster.endDraw();

	}

	void display() {
		image(cluster,-wd/2,-ht/2); // always display from center point
	}
}


