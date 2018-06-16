// ********************************************************************************************************************
// Tile System - class to hold one Tile (with its history) and manage metadata for everything else.
// using a separate Tile class to allow for more tiles in one system in the future.

class TileSystem {

	int tileHeight, tileWidth; // to be derived from tile mask, via the Tile class
	Tile tile; // a tile object, to be filled with generated graphics
	float[][] symmetry; // symmetry data for creating clusters
	int tileCount; // how many tiles per cluster
	float[][] tiling; // transformation data for tiling out clusters
	float clusterWidth, clusterHeight; // the minimum rectangle that contains a cluster... how to calculate?
	int clustersWide, clustersHigh; // size of the field
	float 	hStep, vStep, hOffset, vOffset,
			hOffsetPeriod, vOffsetPeriod;
	PVector centroid, centroidMod; // 
	PImage tileMask; 

	Cell[] cellArray; // all the metadata to display tiles in different ways!


	TileSystem(PImage tileMask_, float[][] symmetry_, float[][] tiling_,
		int clustersWide_, int clustersHigh_) {

		tile = new Tile(tileMask_,0);
		tileWidth = tile.tileWidth;
		tileHeight = tile.tileHeight;
		clustersWide = clustersWide_;
		clustersHigh = clustersHigh_;

		symmetry = symmetry_;
		tiling = tiling_;

		tileCount = symmetry[0].length;
		clusterWidth = tiling[0][0];
		clusterHeight = tiling[1][0];
		hStep = tiling[0][1] * clusterWidth;
		vStep = tiling[1][1] * clusterHeight;
		hOffset = tiling[0][2] * clusterWidth;
		hOffsetPeriod = tiling[0][3];
		vOffset = tiling[1][2] * clusterHeight;
		vOffsetPeriod = tiling[1][3];
		centroid = new PVector(tiling[0][4],tiling[1][4]);
		centroidMod = new PVector(0,0);

		cellArray = new Cell[tileCount*clustersHigh*clustersWide]; // total number of cells

		// initial fill of the cell array:
		float xLoc, yLoc, angle, flip; // for storage and calculation of cell attributes
		for (int y = 0; y < clustersHigh; ++y) { // loop through horizontal rows (step though height)
			for (int x = 0; x < clustersWide; ++x) { // loop thorough symmetry clusters on each row (step through width)
				for (int s = 0; s < tileCount; ++s) { // loop through symmetry count

					angle = symmetry[0][s]; // read from symmetry data
					flip = symmetry[1][s]; // read from symmetry data

					centroidMod.set(centroid.x*cos(flip),centroid.y);
					centroidMod.rotate(angle);
					// println("centroid: "+centroid+" -- centroidMod: "+centroidMod);

					xLoc = symmetry[2][s]; // cell translation from symmetry data
					xLoc += centroidMod.x; // offset to draw tile from its center 
					xLoc += (hStep/-2)*(clustersWide-1); // plus translation to get us center oriented
					xLoc += (float(x)*hStep)+((y%hOffsetPeriod)*hOffset); // plus tiling step data

					if (hOffsetPeriod>1) { // account for tiling offset in centering the field
						xLoc += min(clustersHigh-1,hOffsetPeriod-1)*hOffset/-2;
					}

					yLoc = symmetry[3][s]; // cell translation from symmetry data
					yLoc += centroidMod.y; // offset to draw tile from its center 
					yLoc += (vStep/-2)*(clustersHigh-1); // plus translation to get us center oriented
					yLoc += (float(y)*vStep)+((x%vOffsetPeriod)*vOffset); // plus tiling step data

					if (vOffsetPeriod>1) { // account for tiling offset in centering the field
						yLoc += min(clustersWide-1,vOffsetPeriod-1)*vOffset/-2;
					}


					cellArray[y*clustersWide*tileCount+x*symmetry[0].length+s] = new Cell(xLoc, yLoc, angle, flip);
				}
			}
		}
	}

	void display() {

		tile.updateTile();

		pushMatrix();

		for (int i = 0; i < cellArray.length; ++i) { // cycle through all cells
			pushMatrix();
			translate(cellArray[i].xLoc, cellArray[i].yLoc); // translate to xLoc, yLoc
			rotate(cellArray[i].angle); // rotate in plane
			rotateY(cellArray[i].flip); // rotate on Y axis to accommodate flip
			// tile.displayTileTest(cellArray[i].timeShift, -centroid.x, -centroid.y); // draw tile from center
			tile.displayTile(cellArray[i].timeShift, -centroid.x, -centroid.y); // draw tile from center
			popMatrix();
		}

		popMatrix();
	}

	// Radial History- set the tiles' timeShift to maximize with distance from center
	void setHistory() {
		float maxX = 0;
		float maxY = 0;
		PVector maxDist;

		//find the maximum xLoc and Yloc values (better to use center of tile.. Later)
		//also better to use vecor magnitude... also Later
		for (int i = 0; i < cellArray.length; ++i) {
			if(abs(cellArray[i].xLoc)>maxX) {
				maxX = abs(cellArray[i].xLoc);
			}
			if(abs(cellArray[i].yLoc)>maxY) {
				maxY = abs(cellArray[i].yLoc);
			}	
		}
		
		maxDist = new PVector(maxX,maxY);

		for (int i = 0; i < cellArray.length; ++i) {
			PVector iDist = new PVector(cellArray[i].xLoc,cellArray[i].yLoc);
			cellArray[i].timeShift=int(map(iDist.mag()/maxDist.mag(),0,1,0,history-1));
			
		}
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

