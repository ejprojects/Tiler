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

		newTile.beginDraw();
		// newTile.pushMatrix();
		newTile.strokeWeight(2);
		newTile.stroke(255);
		newTile.noFill();
		newTile.blendMode(ADD);
		newTile.clear();

		// this routine to be replaced by various design functions
		newTile.pushMatrix();
		newTile.translate(tileWidth/4, tileHeight/3);  // make center of rotation inside tile
		newTile.rotate(float(millis())/1000*PI);  // 1/2 rev per second
		newTile.ellipse(0, 0, 250, 125); // arbitrary, small...
		newTile.popMatrix();
		newTile.pushMatrix();
		newTile.translate(tileWidth/2, 3*tileHeight/4);  // make center of rotation inside tile
		newTile.rotate(float(millis())/1667*PI);  // slower 
		newTile.ellipse(0, 0, 250, 125); // arbitrary, small...
		newTile.popMatrix();
		
		newTile.mask(mask); // maybe alter masking later
		newTile.endDraw();

		return(newTile);
	}
}


