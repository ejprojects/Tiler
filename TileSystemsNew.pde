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
	PImage tileMask; 

	Cell[] cellArray; // all the metadata to display tiles in different ways!


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

					xLoc = symmetry[2][s] // cell translation from symmetry data
					+ (hStep/-2)*(clustersWide-1) // plus translation to get us center oriented
					+ (float(x)*hStep)+((y%hOffsetPeriod)*hOffset); // plus tiling step data

					yLoc = symmetry[3][s] // cell translation from symmetry data
					+ (vStep/-2)*(clustersHigh-1) // plus translation to get us center oriented
					+ (float(y)*vStep)+((x%vOffsetPeriod)*vOffset); // plus tiling step data

					cellArray[y*clustersWide*symmetry[0].length+x*symmetry[0].length+s] = new Cell(xLoc, yLoc, angle, flip);
					println("y*clustersWide*symmetry[0].length+x*symmetry[0].length+s: ",(y*clustersWide*symmetry[0].length+x*symmetry[0].length+s));
				}
			}
		}
	}

	void display() {

		pushMatrix();

		for (int i = 0; i < cellArray.length; ++i) { // cycle through all cells
			pushMatrix();
			translate(cellArray[i].xLoc, cellArray[i].yLoc); // translate to xLoc, yLoc
			rotateY(cellArray[i].flip); // rotate on Y axis to accommodate flip
			rotate(cellArray[i].angle); // rotate in plane
			tile.displayTile(cellArray[i].timeShift);
			popMatrix();
		}

		popMatrix();
	}
}


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

