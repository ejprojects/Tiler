// ********************************************************************************************************************
// Generate tile images
//
// plan: make a function to generate and update the images in Tile objects
// so that their arrays contain some number of frames of continuous animation

class TileGenerator {
	PImage mask; //even if it's unmasked, the tile dimensions come from this file
	int tileWidth, tileHeight; //pulled from the mask file
	int mode; // selects generative design options
	PGraphics newTile; // rendering destination for the generative tile graphics

	TileGenerator(PImage mask_, int mode_) {
		mask = mask_;
		mode = mode_;
		tileWidth = mask.width;
		tileHeight = mask.height;
		newTile = createGraphics(tileWidth, tileHeight, P3D);

	}

	PGraphics generate() { // here we draw to the new tile

		println("tg generate(pg) start");

		newTile.beginDraw();
		newTile.pushMatrix();
		newTile.strokeWeight(2);
		newTile.stroke(255);
		newTile.noFill();
		newTile.background(0);

		newTile.translate(tileWidth/3, tileHeight/2);  // make center of rotation inside tile
		newTile.rotate(float(millis())/1000*TWO_PI);  // one rev per second
		newTile.ellipse(0, 0, 100, 50); // arbitrary, small...

		newTile.popMatrix();
		newTile.endDraw();
		newTile.mask(mask);

		println("tg generate(pg) finish");

		return(newTile);
	}
}


