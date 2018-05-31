// ********************************************************************************************************************
// Tile Systems - class to hold the full array of tile clusters based on a certain tile shape, symmetry system, and desired field

class TileSystem {

	Tile tile;
	int tileHeight, tileWidth; // derived from tile
	float[][] symmetry; // symmetry data
	float clusterWidth, clusterHeight; // the minimum rectangle that contains a cluster... how to calculate?
	int clustersWide, clustersHigh; // size of the field
	float hStep, vStep; // how far to step when tiling the plane
	Cluster[][] clusterArray; // the array, w x h, of the field of tiles


	TileSystem(	Tile tile_, float[][] symmetry_, float clusterWidth_, float clusterHeight_,
		int clustersWide_, int clustersHigh_, float hStep_, float vStep_) {
		tile = tile_;
		tileWidth = tile.wd;
		tileHeight = tile.ht;
		symmetry = symmetry_;
		clusterWidth = clusterWidth_;
		clusterHeight = clusterHeight_;
		clustersWide = clustersWide_;
		clustersHigh = clustersHigh_;
		hStep = hStep_;
		vStep = vStep_;

		clusterArray = new Cluster[clustersWide][clustersHigh];
		for (int y = 0; y < clustersHigh; ++y) { // loop through horizontal rows (step though height)
			for (int x = 0; x < clustersWide; ++x) { // loop thorough clusters on each row (step through width)
				clusterArray[x][y] = new Cluster(tile,symmetry);
			}
		}
	}

	void display() {
		pushMatrix();
		translate((hStep/-2)*(clustersWide-1), (vStep/-2)*(clustersHigh-1)); // we are center oriented, but starting at the top left of our field
		for (int y = 0; y < clustersHigh; ++y) { // loop through horizontal rows (step though height)
			for (int x = 0; x < clustersWide; ++x) { // loop thorough clusters on each row (step through width)
				pushMatrix();
				translate(x*hStep, y*vStep);
				clusterArray[x][y].display();
				popMatrix();
			}
		}
		popMatrix();
	}

	void choose(int tileIndex) {
		for (int y = 0; y < clustersHigh; ++y) { // loop through horizontal rows (step though height)
			for (int x = 0; x < clustersWide; ++x) { // loop thorough clusters on each row (step through width)
				clusterArray[x][y].choose(tileIndex);
			}
		}		
	}
}

// Tile class - holds tiles of a certain form, in different states (history or animation frames)
// NEW version with plain array (30 frames of memory)
class Tile {
	PImage img;
	PImage[] imgList = new PImage[30];
	int wd, ht; // derived from PImage
	int mode; // image generator mode
	int currentFrame; // points to the current frame

	Tile (PImage img_) {
		wd = img_.width;
		ht = img_.height;
		img = img_;
		currentFrame = 0;
		imgList[currentFrame] = tg.generated();
	}

	void udpate() {
		currentFrame++;
		if (currentFrame >= imgList.length) {
			currentFrame = 0;
		}
		imgList[currentFrame] = tg.generated();

	}

}

// Tile class - holds tiles of a certain form, in different states (history or animation frames)
// OLD version with ArrayList
// class Tile {
// 	PImage img;
// 	ArrayList<PImage> imgList = new ArrayList<PImage>();
// 	int wd, ht; // derived from PImage
// 	int mode; // image generator mode

// 	Tile (PImage img_) {
// 		wd = img_.width;
// 		ht = img_.height;
// 		img = img_;
// 		imgList.add(img);
// 	}

// 	void display() { // unused?
// 		image(img,0,0);
// 	}

// 	void display(int i) { // unused?
// 		image(imgList.get(i),0,0);
// 	}

// 	void add(PImage img) {
// 		imgList.add(img);
// 	}

// 	void udpate() {

// 	}

// }

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
			cluster.image(tile.imgList[tileIndex], 0, 0, tile.wd, tile.ht); // place it
			cluster.popMatrix();
		}

		cluster.endDraw();
	}

	void display() { // unused
		image(cluster,-wd/2,-ht/2); // always display from center point
	}
}

// ********************************************************************************************************************
// tile symmetries

float[][] symmetry4 = {	{0,		0,		PI,		PI	},		// rotation
						{0,		PI,		0,		PI	},		// flip, i.e., rotation on y axis
						{0,		0,		0,		0,	},		// x translation
						{0,		0,		0,		0,	}	};	// y translation

float[][] symmetry6 = {	{0,		0,		2*PI/3,	2*PI/3,	4*PI/3,	4*PI/3	},		// rotation
						{0,		PI,		0,		PI,		0,		PI		},		// flip, 180 for mirror
						{0,		0,		0,		0,		0,		0		},		// x translation
						{0,		0,		0,		0,		0,		0		}	};	// y translation


float[][] symmetry12M = {
//0		1		2		3		4		5		6		7		8		9		10		11			*/
{0,		0,		2*PI/6,	2*PI/6,	4*PI/6,	4*PI/6,	6*PI/6, 6*PI/6,	8*PI/6,	8*PI/6,	10*PI/6,10*PI/6},	// rotation
{0,		PI,		0,		PI,		0,		PI,		0,		PI,		0,		PI,		0,		PI},		// flip, PI for mirror
{0,		0,		0,		0,		0,		0,		0,		0,		0,		0,		0,		0},			// x translation
{0,		0,		0,		0,		0,		0,		0,		0,		0,		0,		0,		0}			// y translation
};

float[][] symmetry12 = {
//0		1		2		3		4		5		6		7		8		9		10		11			*/
{0*PI/6,1*PI/6,	2*PI/6,	3*PI/6,	4*PI/6,	5*PI/6,	6*PI/6, 7*PI/6,	8*PI/6,	9*PI/6,	10*PI/6,11*PI/6},	// rotation
{0,		0,		0,		0,		0,		0,		0,		0,		0,		0,		0,		0},		// flip, PI for mirror
{0,		0,		0,		0,		0,		0,		0,		0,		0,		0,		0,		0},			// x translation
{0,		0,		0,		0,		0,		0,		0,		0,		0,		0,		0,		0}			// y translation
};
