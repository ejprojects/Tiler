// ********************************************************************************************************************
// Tile Class:
// generate and store tile images with various design modes
// functions: generate, display (a given frame offset)


class TileNew {
	PImage mask; //even if it's unmasked, the tile dimensions come from this file
	int tileWidth, tileHeight; //pulled from the mask file
	int mode; // selects generative design options
	PGraphics[] imgList = new PGraphics[30]; // rendering destinations for the generative tile graphics / frames
	int currentFrame; // points to the current frame


	TileNew(PImage mask_, int mode_) {
		mask = mask_;
		mode = mode_;
		tileWidth = mask.width;
		tileHeight = mask.height;
		for (int i = 0; i < imgList.length; ++i) {
			imgList[i] = createGraphics(tileWidth, tileHeight, P3D);
		}
		generateTile(imgList[currentFrame]); // use the generate function below
	}

	void generateTile(PGraphics frame) { // here we draw to the new tile frame

		frame.beginDraw();
		frame.strokeWeight(2);
		frame.stroke(255);
		frame.noFill();
		frame.blendMode(ADD);
		frame.clear();

		// this routine to be replaced by various design functions
		frame.pushMatrix();
		frame.translate(tileWidth/4, tileHeight/3);  // make center of rotation inside tile
		frame.rotate(float(millis())/1000*PI);  // 1/2 rev per second
		frame.ellipse(0, 0, 250, 125); // arbitrary, small...
		frame.popMatrix();
		frame.pushMatrix();
		frame.translate(tileWidth/2, 3*tileHeight/4);  // make center of rotation inside tile
		frame.rotate(float(millis())/1667*PI);  // slower 
		frame.ellipse(0, 0, 250, 125); // arbitrary, small...
		frame.popMatrix();
		
		frame.mask(mask); // maybe alter masking later
		frame.endDraw();
	}

	void updateTile() {
		currentFrame++;
		if (currentFrame >= imgList.length) {
			currentFrame = 0;
		}
		generateTile(imgList[currentFrame]);

	}
	void displayTile(int offset) {
		int offsetFrame = (currentFrame - offset);
		if (offsetFrame < 0) {
			offsetFrame += imgList.length;
		}
		image(imgList[offsetFrame],0,0);
	}


}

// OLD CODE:

// Tile class - holds tiles of a certain deisgn mode, in different states (history or animation frames)
// (30 frames of memory)
// class TileNew {
	// TileGenerator tg; // tile generator belongs to the tile
	// int wd, ht; // derived from PImage

	// TileNew (int wd_, int ht_) {
	// 	wd = wd_;
	// 	ht = ht_;
	// 	for (int i = 0; i < imgList.length; ++i) {
	// 		imgList[i] = createGraphics(wd, ht, P3D);
	// 	}
	// 	tg = new TileGenerator(mask,0);
	// 	currentFrame = 0; // start current frame at 0
	// 	imgList[currentFrame] = tg.generate();
	// }

	// void update() {
	// 	currentFrame++;
	// 	if (currentFrame >= imgList.length) {
	// 		currentFrame = 0;
	// 	}
	// 	imgList[currentFrame] = tg.generate();

	// }

// 	PGraphics choose(int offset) {
// 		int offsetFrame = (currentFrame - offset);
// 		if (offsetFrame < 0) {
// 			offsetFrame += imgList.length;
// 		}
// 		return(imgList[offsetFrame]);
// 	}
// }



