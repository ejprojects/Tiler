// ********************************************************************************************************************
// New Tile Systems - class to hold one Tile (with its history) and manage metadata for everything else

class TileSystemNew {

	PImage tileMask; // fill with mask
	int tileHeight, tileWidth; // derived from tile mask
	TileGenerator tg; // we have to have a tile generator
	Tile tile; // a tile object, to be filled with generated graphics
	float[][] symmetry; // symmetry data for creating clusters
	float[][] tiling; // transformation data for tiling out clusters
	float clusterWidth, clusterHeight; // the minimum rectangle that contains a cluster... how to calculate?
	int clustersWide, clustersHigh; // size of the field
	float hStep, vStep, hOffset, vOffset, hOffsetPeriod, vOffsetPeriod; // how far to step when tiling the plane
	Cluster[][] clusterArray; // the array, w x h, of the field of tiles


	TileSystemNew(PImage tileMask_, float[][] symmetry_, float[][] tiling_,
		int clustersWide_, int clustersHigh_) {
		tileMask = tileMask_;
		tileWidth = tileMask.width;
		tileHeight = tileMask.height;
		tile = new Tile(tileWidth,tileHeight);
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


		clusterArray = new Cluster[clustersWide][clustersHigh];
		for (int y = 0; y < clustersHigh; ++y) { // loop through horizontal rows (step though height)
			for (int x = 0; x < clustersWide; ++x) { // loop thorough clusters on each row (step through width)
				clusterArray[x][y] = new Cluster(tile,symmetry,clusterWidth,clusterHeight);
			}
		}
	}

	void display() {
		// println("tile.choose(0): "+tile.choose(0));

		pushMatrix();
		translate((hStep/-2)*(clustersWide-1), (vStep/-2)*(clustersHigh-1)); // we are center oriented, but starting at the top left of our field

		clusterArray[0][0].update();

		for (int y = 0; y < clustersHigh; ++y) { // loop through horizontal rows (step though height)
			for (int x = 0; x < clustersWide; ++x) { // loop thorough clusters on each row (step through width)
				pushMatrix();
				translate((float(x)*hStep)+((y%hOffsetPeriod)*hOffset), (float(y)*vStep)+((x%vOffsetPeriod)*vOffset));
				// clusterArray[x][y].update(); // don't update each cluster each time?
				clusterArray[0][0].display();
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
class ClusterNew {
	PGraphics cluster;
	float wd, ht;
	Tile tile;
	float[][] symmetry;

	ClusterNew (Tile tile_, float[][] symmetry_, float clusterWidth_, float clusterHeight_) {
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
		cluster.clear(); // makes the backroud transparent
		cluster.blendMode(ADD); // allow for overlap, if any
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
		// cluster.blendMode(ADD);
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
class TileNew {
	TileGenerator tg; // tile generator belongs to the tile
	PGraphics[] imgList;
	int wd, ht; // derived from PImage
	int mode; // image generator mode
	int currentFrame; // points to the current frame

	TileNew (int wd_, int ht_) {
		wd = wd_;
		ht = ht_;
		imgList = new PGraphics[30];
		for (int i = 0; i < imgList.length; ++i) {
			imgList[i] = createGraphics(wd, ht, P3D);
		}
		tg = new TileGenerator(mask,0);
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

	PGraphics choose(int offset) {
		int offsetFrame = (currentFrame - offset);
		if (offsetFrame < 0) {
			offsetFrame += imgList.length;
		}
		return(imgList[offsetFrame]);
	}
}
