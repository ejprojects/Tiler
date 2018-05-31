PImage tileImg; // this loads a tile image
Tile t; //declare t as a member of the Tile class
Cluster c; //declate my cluster
TileSystem ts;

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
	tileImg = loadImage("tile-test.png"); // this will be replaced with the generated tiles later
	t = new Tile(tileImg);
	c = new Cluster(t,symmetry4);
	ts = new TileSystem(t,symmetry4,200,200,3,3,200,200);

}

// ********************************************************************************************************************
void draw(){
	clr(); //clear the background

	translate(mouseX, mouseY); // work at the mouse location

	// c.display();

	ts.fill();

	ts.display();

}

// ********************************************************************************************************************
// classes

// set up symmetry variable arrays. turn this into a class with a good data structure
float[] symRot = {0, HALF_PI, PI, PI+HALF_PI};
// int[] symFlip = {1, -1, 1, -1};
int[] symFlip = {1, 1, 1, 1};

// symmetry class - data structure to hold symmetry information for various tile systems


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

	Cluster (Tile tile, float[][] symmetry) {
		wd = tile.wd*3; //arbitraily se width and height (calculate exactly based on tile and symmetry later)
		ht = tile.ht*3;
		cluster = createGraphics(wd,ht,P3D); // create the PGraphics
		cluster.beginDraw();
		cluster.translate(wd/2, ht/2); // translate to the center

		for (int i = 0; i < symmetry[0].length; ++i) { //cycle through the symmetry data (develop this)
			cluster.hint(DISABLE_DEPTH_TEST);
			cluster.pushMatrix();
			cluster.translate(symmetry[2][i], symmetry[3][i]); // translate for placement
			cluster.rotateY(symmetry[1][i]); // rotate on Y axis to accommodate flip
			cluster.rotate(symmetry[0][i]); // rotate the prescribed amount
			cluster.image(tile.img, 0, 0, tile.wd, tile.ht); // place it
			cluster.popMatrix();
		}

		cluster.endDraw();

	}

	void display() {
		image(cluster,-wd/2,-ht/2); // always display from center point
	}
	// void display2() {
	// 	image(cluster,0,0); 
	// }
}

// ********************************************************************************************************************
// misellaneous functions
void clr() {
	noStroke();
	fill(48,32);
	rect(0,0,width,height);
}


