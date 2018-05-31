PImage tileImg0, tileImg1; 
Tile t;			// declare t as a member of the Tile class
Cluster c;		// declare my cluster
TileSystem ts;	// declare ts as a Tile System

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
	tileImg0 = loadImage("tile-test.png"); // tile image
	tileImg1 = loadImage("tile-test-i.png"); // alternate tile image
	t = new Tile(tileImg0);
	t.add(tileImg1);
	ts = new TileSystem(t,symmetry12,200,200,6,6,200,200);

}

// ********************************************************************************************************************
void draw(){
	clr(); //clear the background

	translate(mouseX, mouseY); // work at the mouse location

	ts.display();

}

void mousePressed() {
	ts.choose(1); //can i use . syntax to go direct to Tile?
	println("mouse 1");

}
void mouseReleased() {
	ts.choose(0);
	println("mouse 0");

}

// ********************************************************************************************************************
// classes


// Tile class - holds tiles of a certain form, in different states (history or animation frames)
class Tile {
	PImage img;
	ArrayList<PImage> imgList = new ArrayList<PImage>();
	int wd, ht;

	Tile (PImage img_) {
		wd = img_.width;
		ht = img_.height;
		img = img_;
		imgList.add(img);
	}

	void display() { // unused?
		image(img,0,0);
	}

	void display(int i) { // unused?
		image(imgList.get(i),0,0);
	}

	void add(PImage img) {
		imgList.add(img);
	}

}

// cluster class - to hold repeatable tiling units
class Cluster {
	PGraphics cluster;
	int wd, ht;
	Tile tile;
	float[][] symmetry;

	Cluster (Tile tile_, float[][] symmetry_) {
		tile = tile_;
		symmetry = symmetry_;
		wd = tile.wd*3; //arbitraily set width and height (calculate exactly based on tile and symmetry later)
		ht = tile.ht*3;
		cluster = createGraphics(wd,ht,P3D); // create the PGraphics

		choose(0); // constructor makes use of 'choose' function below to initialize.

	}

	void choose(int tileIndex) {

		cluster.beginDraw();
		cluster.translate(wd/2, ht/2); // translate to the center

		for (int i = 0; i < symmetry[0].length; ++i) { //cycle through the symmetry data (develop this)
			cluster.hint(DISABLE_DEPTH_TEST);
			cluster.pushMatrix();
			cluster.translate(symmetry[2][i], symmetry[3][i]); // translate for placement
			cluster.rotateY(symmetry[1][i]); // rotate on Y axis to accommodate flip
			cluster.rotate(symmetry[0][i]); // rotate the prescribed amount
			cluster.image(tile.imgList.get(tileIndex), 0, 0, tile.wd, tile.ht); // place it
			cluster.popMatrix();
		}

		cluster.endDraw();
	}

	void display() { // unused
		image(cluster,-wd/2,-ht/2); // always display from center point
	}
}

// ********************************************************************************************************************
// misellaneous functions
void clr() {
	noStroke();
	fill(48,32);
	rect(0,0,width,height);
}


