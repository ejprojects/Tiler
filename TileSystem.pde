// ********************************************************************************************************************
// Tile System - class to hold one Tile (with its history) and manage metadata for everything else.
// using a separate Tile class to allow for more tiles in one system in the future.

class TileSystem {

	int tileHeight, tileWidth; // to be derived from tile mask, via the Tile class
	Tile tile; // a tile object, to be filled with generated graphics
	float[][] symmetry; // symmetry data for creating clusters
	int tileCount; // how many tiles per cluster, pulled from symmetry array
	float[][] tiling; // transformation data for tiling out clusters
	float clusterWidth, clusterHeight; // the minimum rectangle that contains a cluster... how to calculate?
	int clustersWide, clustersHigh; // size of the field
	float 	hStep, vStep, hOffset, vOffset,
			hOffsetPeriod, vOffsetPeriod;
	PVector centroid, centroidMod; // 	// PImage tileMask; 
	TileData[] tileArray; // all the metadata to display tiles in different ways!

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

		tileArray = new TileData[tileCount*clustersHigh*clustersWide]; // total number of cells

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


					tileArray[y*clustersWide*tileCount+x*symmetry[0].length+s] = new TileData(xLoc, yLoc, angle, flip);
				}
			}
		}
	}

	void display() {

		tile.updateTile();

		pushMatrix();

		for (int i = 0; i < tileArray.length; ++i) { // cycle through all cells
			pushMatrix();
			translate(tileArray[i].xLoc, tileArray[i].yLoc); // translate to xLoc, yLoc
			rotate(tileArray[i].angle); // rotate in plane
			rotateY(tileArray[i].flip); // rotate on Y axis to accommodate flip

			getScreenXY(tileArray[i]); // at the farthest tranbsformation, store the screen x,y
			setIsOnScreen(tileArray[i], int(200 * testScale)); // set the isOnScrren flag with margin

			if(tileArray[i].isOnScreen) {
				tile.displayTile(tileArray[i].timeShift, -centroid.x, -centroid.y); // draw tile from center
			}
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
		for (int i = 0; i < tileArray.length; ++i) {
			if(abs(tileArray[i].xLoc)>maxX) {
				maxX = abs(tileArray[i].xLoc);
			}
			if(abs(tileArray[i].yLoc)>maxY) {
				maxY = abs(tileArray[i].yLoc);
			}	
		}
		
		maxDist = new PVector(maxX,maxY);

		for (int i = 0; i < tileArray.length; ++i) {
			PVector iDist = new PVector(tileArray[i].xLoc,tileArray[i].yLoc);
			tileArray[i].timeShift=int(map(iDist.mag()/maxDist.mag(),0,1,0,history-1));
			
		}
	}
	// get the screen x,y of the prevailing transormation

	void getScreenXY(TileData td) {
		td.screenX = modelX(0,0,0);
		td.screenY = modelY(0,0,0);
	}

	// test whether tiles will be visible
	void setIsOnScreen(TileData td, int margin) {
		td.isOnScreen = 	(td.screenX<0-margin ||
							td.screenX>width+margin ||
							td.screenY<0-margin ||
							td.screenY>height+margin) ?
		false : true ;
	}
}


class TileData {
	float xLoc,yLoc,angle,flip; // cell center origin x, y and rotation a, flip f
	float screenX, screenY; // cell center screen coordinates
	boolean isOnScreen; // flag cells that could be visible
	int timeShift; // how many frames back are we looking?
	// later add scale, transparency or mask,

	TileData (float xLoc_, float yLoc_, float angle_, float flip_) {
		xLoc = xLoc_;
		yLoc = yLoc_;
		angle = angle_;
		flip = flip_;
		// timeShift = 0; // redundantly

	}

}


