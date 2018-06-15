// ********************************************************************************************************************
// New Tile Systems - class to hold one Tile (with its history) and manage metadata for everything else.
// retaining the Tile class to allow for more tiles in one system in the future.

class TileSystemNew {

	int tileHeight, tileWidth; // derived from tile mask, via the Tile class
	TileNew tile; // a tile object, to be filled with generated graphics
	float[][] symmetry; // symmetry data for creating clusters
	float[][] tiling; // transformation data for tiling out clusters
	float clusterWidth, clusterHeight; // the minimum rectangle that contains a cluster... how to calculate?
	int clustersWide, clustersHigh; // size of the field
	float hStep, vStep, hOffset, vOffset, hOffsetPeriod, vOffsetPeriod; // transformations needed to fill field, pulled from tiling[][]

	// adding:
	Cell[] cellArray; // all the metadata to display tiles in different ways!

	//to be deleted:
	// Cluster[][] clusterArray; 
	PImage tileMask; 

	TileSystemNew(PImage tileMask_, float[][] symmetry_, float[][] tiling_,
		int clustersWide_, int clustersHigh_) {

		tileMask = tileMask_;
		tileWidth = tileMask.width;
		tileHeight = tileMask.height;
		tile = new TileNew(tileMask,0);
		clustersWide = clustersWide_;
		clustersHigh = clustersHigh_;

		symmetry = symmetry_;
		tiling = tiling_;

		clusterWidth = tiling[0][0];
		clusterHeight = tiling[1][0];
		hStep = tiling[0][1] * clusterWidth;
		vStep = tiling[1][1] * clusterHeight;
		hOffset = tiling[0][2] * clusterWidth;
		hOffsetPeriod = tiling[0][3];
		vOffset = tiling[1][2] * clusterHeight;
		vOffsetPeriod = tiling[1][3];

		cellArray = new Cell[symmetry[0].length*clustersHigh*clustersWide]; // total number of cells

		// initial fill of the cell array:
		for (int y = 0; y < clustersHigh; ++y) { // loop through horizontal rows (step though height)
			for (int x = 0; x < clustersWide; ++x) { // loop thorough symmetry clusters on each row (step through width)
				for (int s = 0; s < symmetry[0].length; ++s) { // loop through symmetry count

					float xLoc, yLoc, angle, flip; // read and calculate cell attributes
					angle = symmetry[0][s]; // read from symmetry data
					flip = symmetry[1][s]; // read from symmetry data
					xLoc = symmetry[2][s] + (hStep/-2)*(clustersWide-1); //... ??? calculating translation
					yLoc = symmetry[3][s] + (vStep/-2)*(clustersHigh-1); //... ??? to tile out the field, 0 center

					cellArray[y+x+s] = new Cell(xLoc, yLoc, angle, flip);
				}
			}
		}
	}

	void display() {
		// println("tile.choose(0): "+tile.choose(0));

		pushMatrix();
		translate((hStep/-2)*(clustersWide-1), (vStep/-2)*(clustersHigh-1)); // we are center oriented, but starting at the top left of our field

		// clusterArray[0][0].update();

		for (int y = 0; y < clustersHigh; ++y) { // loop through horizontal rows (step though height)
			for (int x = 0; x < clustersWide; ++x) { // loop thorough clusters on each row (step through width)
				pushMatrix();
				translate((float(x)*hStep)+((y%hOffsetPeriod)*hOffset), (float(y)*vStep)+((x%vOffsetPeriod)*vOffset));
				// clusterArray[x][y].update(); // don't update each cluster each time?
				// clusterArray[0][0].display();
				popMatrix();
			}
		}
		popMatrix();
	}

	void choose(int tileIndex) {
		for (int y = 0; y < clustersHigh; ++y) { // loop through horizontal rows (step though height)
			for (int x = 0; x < clustersWide; ++x) { // loop thorough clusters on each row (step through width)
				// clusterArray[x][y].choose(tileIndex);
			}
		}		
	}
}

// cluster class - to hold repeatable tiling units
// class ClusterNew {
// 	PGraphics cluster;
// 	float wd, ht;
// 	Tile tile;
// 	float[][] symmetry;

// 	ClusterNew (Tile tile_, float[][] symmetry_, float clusterWidth_, float clusterHeight_) {
// 		tile = tile_;
// 		symmetry = symmetry_;
// 		wd = clusterWidth_; 
// 		ht = clusterHeight_;
// 		cluster = createGraphics(round(wd),round(ht),P3D); // create the PGraphics

// 		choose(0); // constructor makes use of 'choose' function below to initialize.

// 	}

// 	void update() {
// 		tile.update();

// 		cluster.beginDraw();
// 		cluster.clear(); // makes the backroud transparent
// 		cluster.blendMode(ADD); // allow for overlap, if any
// 		cluster.translate(wd/2, ht/2); // translate to the center

// 		for (int i = 0; i < symmetry[0].length; ++i) { //cycle through the symmetry data (develop this)
// 			cluster.hint(DISABLE_DEPTH_TEST);
// 			cluster.pushMatrix();
// 			cluster.translate(symmetry[2][i], symmetry[3][i]); // translate for placement
// 			cluster.rotateY(symmetry[1][i]); // rotate on Y axis to accommodate flip
// 			cluster.rotate(symmetry[0][i]); // rotate the prescribed amount
// 			cluster.image(tile.imgList[tile.currentFrame], 0, 0, tile.wd, tile.ht); // place it
// 			cluster.popMatrix();
// 		}

// 		cluster.endDraw();
// 	}

// 	void choose(int tileIndex) {

// 		cluster.beginDraw();
// 		// cluster.blendMode(ADD);
// 		cluster.translate(wd/2, ht/2); // translate to the center

// 		for (int i = 0; i < symmetry[0].length; ++i) { //cycle through the symmetry data (develop this)
// 			cluster.hint(DISABLE_DEPTH_TEST);
// 			cluster.pushMatrix();
// 			cluster.translate(symmetry[2][i], symmetry[3][i]); // translate for placement
// 			cluster.rotateY(symmetry[1][i]); // rotate on Y axis to accommodate flip
// 			cluster.rotate(symmetry[0][i]); // rotate the prescribed amount
// 			cluster.image(tile.imgList[tileIndex], 0, 0, tile.wd, tile.ht); // place it
// 			cluster.popMatrix();
// 		}

// 		cluster.endDraw();
// 	}

// 	void display() { // unused
// 		image(cluster,-wd/2,-ht/2); // always display from center point
// 	}
// }

class Cell {
	float xLoc,yLoc,angle,flip; // cell origin x, y and rotation a, flip f
	int timeShift; // how many frames back are we looking?
	// later add scale, transparency or mask,
	// and a screen x-y location

	Cell(float xLoc_, float yLoc_, float angle_, float flip_) {
		xLoc = xLoc_;
		yLoc = yLoc_;
		angle = angle_;
		flip = flip_;
		timeShift = 0; // redundantly

	}

}
