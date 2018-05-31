// ********************************************************************************************************************
// Tile Systems - class to hold the full array of tile clusters based on a certain tile shape, symmetry system, and desired field

class TileSystem {

	Tile tile;
	int tileHeight, tileWidth; // derived from tile
	float[][] symmetry;
	float clusterHeight, clusterWidth; // the minimum rectangle that contains a cluster... how to calculate?
	int clustersWide, clustersHigh; // size of the field
	float hStep, vStep;
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
		//...
	}

	void fill() {
		for (int y = 0; y < clustersHigh; ++y) {		// loop through horizontal rows (step though height)
			for (int x = 0; x < clustersWide; ++x) {		// loop thorough clusters on each row (step through width)
				clusterArray[x][y] = new Cluster(tile,symmetry);
			}
		}
	}

	void display() {
		pushMatrix();
		translate((hStep/-2)*(clustersWide-1), (vStep/-2)*(clustersHigh-1)); // we are center oriented, but starting at the top left of our field
		for (int y = 0; y < clustersHigh; ++y) {		// loop through horizontal rows (step though height)
			for (int x = 0; x < clustersWide; ++x) {		// loop thorough clusters on each row (step through width)
				pushMatrix();
				translate(x*hStep, y*vStep);
				clusterArray[x][y].display();
				popMatrix();
				// println(hStep*clustersWide/-2," ",vStep*clustersHigh/-2," ",x*hStep,"",y*vStep);

			}
		}
		popMatrix();
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
