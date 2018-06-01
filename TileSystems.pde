// ********************************************************************************************************************
// Tile Systems - class to hold the full array of tile clusters based on a certain tile shape, symmetry system, and desired field

class TileSystem {

	PImage tileMask; // fill with mask
	int tileHeight, tileWidth; // derived from tile mask
	TileGenerator tg; // we have to have a tile generator
	Tile tile; // a tile object, to be filled with generated graphics
	float[][] symmetry; // symmetry data for creating clusters
	float clusterWidth, clusterHeight; // the minimum rectangle that contains a cluster... how to calculate?
	int clustersWide, clustersHigh; // size of the field
	float hStep, vStep; // how far to step when tiling the plane
	Cluster[][] clusterArray; // the array, w x h, of the field of tiles


	TileSystem(PImage tileMask_, float[][] symmetry_, float clusterWidth_, float clusterHeight_,
		int clustersWide_, int clustersHigh_, float hStep_, float vStep_) {
		tileMask = tileMask_;
		tileWidth = tileMask.width;
		tileHeight = tileMask.height;
		tile = new Tile(tileWidth,tileHeight);
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
				clusterArray[x][y] = new Cluster(tile,symmetry,clusterWidth,clusterHeight);
			}
		}
	}

	void display() {
		println("tile.choose(0): "+tile.choose(0));

		pushMatrix();
		translate((hStep/-2)*(clustersWide-1), (vStep/-2)*(clustersHigh-1)); // we are center oriented, but starting at the top left of our field
		for (int y = 0; y < clustersHigh; ++y) { // loop through horizontal rows (step though height)
			for (int x = 0; x < clustersWide; ++x) { // loop thorough clusters on each row (step through width)
				pushMatrix();
				translate(x*hStep, y*vStep);
				clusterArray[x][y].update();
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

// cluster class - to hold repeatable tiling units
class Cluster {
	PGraphics cluster;
	float wd, ht;
	Tile tile;
	float[][] symmetry;

	Cluster (Tile tile_, float[][] symmetry_, float clusterWidth_, float clusterHeight_) {
		tile = tile_;
		symmetry = symmetry_;
		wd = clusterWidth_; 
		ht = clusterHeight_;
		cluster = createGraphics(round(wd),round(ht),P3D); // create the PGraphics

		choose(0); // constructor makes use of 'choose' function below to initialize.

	}

	void update() {
		tile.update();

		cluster.beginDraw();
		cluster.translate(wd/2, ht/2); // translate to the center

		for (int i = 0; i < symmetry[0].length; ++i) { //cycle through the symmetry data (develop this)
			cluster.hint(DISABLE_DEPTH_TEST);
			cluster.pushMatrix();
			cluster.translate(symmetry[2][i], symmetry[3][i]); // translate for placement
			cluster.rotateY(symmetry[1][i]); // rotate on Y axis to accommodate flip
			cluster.rotate(symmetry[0][i]); // rotate the prescribed amount
			cluster.image(tile.imgList[tile.currentFrame], 0, 0, tile.wd, tile.ht); // place it
			cluster.popMatrix();
		}

		cluster.endDraw();
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

// Tile class - holds tiles of a certain form, in different states (history or animation frames)
// NEW version with plain array (30 frames of memory)
class Tile {
	PImage[] imgList;
	int wd, ht; // derived from PImage
	int mode; // image generator mode
	int currentFrame; // points to the current frame

	Tile (int wd_, int ht_) {
		wd = wd_;
		ht = ht_;
		imgList = new PImage[30];
		currentFrame = 0; // start current frame at 0
		imgList[currentFrame] = tg.generate();
	}

	void update() {
		currentFrame++;
		if (currentFrame >= imgList.length) {
			currentFrame = 0;
		}
		imgList[currentFrame] = tg.generate();

	}

	PImage choose(int offset) {
		int offsetFrame = (currentFrame - offset);
		if (offsetFrame < 0) {
			offsetFrame += imgList.length;
		}
		return(imgList[offsetFrame]);
	}

}

// ********************************************************************************************************************
// tile symmetries



float[][] symmetry1 = {	{0},		// rotation
						{0},		// flip, i.e., rotation on y axis
						{0},		// x translation
						{0}	};		// y translation

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
