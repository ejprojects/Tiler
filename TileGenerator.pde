// ********************************************************************************************************************
// Tile Class:
// generate and store tile images with various design modes
// functions: generate, display (a given frame offset)


class Tile {
	PImage mask; //even if it's unmasked, the tile dimensions come from this file
	int tileWidth, tileHeight; //pulled from the mask file
	int mode; // selects generative design options
	PGraphics[] imgList = new PGraphics[history]; // rendering destinations for the generative tile graphics / frames
	int currentFrame; // points to the current frame


	Tile (PImage mask_, int mode_) {
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
		frame.strokeWeight(10);
		frame.stroke(255);
		frame.noFill();
		frame.blendMode(ADD);
		frame.clear();

		// this routine to be replaced by various design functions
		frame.pushMatrix();
		frame.translate(tileWidth/4, tileHeight/3);  // make center of rotation inside tile
		frame.rotate(float(millis())/1000*PI);  // 1/2 rev per second
		frame.ellipse(0, 0, 400, 250); // arbitrary, small...
		frame.popMatrix();
		frame.pushMatrix();
		frame.translate(tileWidth/2, 3*tileHeight/4);  // make center of rotation inside tile
		frame.rotate(float(millis())/1667*PI);  // slower 
		frame.ellipse(0, 0, 350, 225); // arbitrary, small...
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
	void displayTile(int offset, float x, float y) {
		int offsetFrame = (currentFrame - offset);
		if (offsetFrame < 0) {
			offsetFrame += imgList.length;
		}
		image(imgList[offsetFrame],x,y);
	}
	void displayTileTest(int offset, float x, float y) {
		int offsetFrame = (currentFrame - offset);
		if (offsetFrame < 0) {
			offsetFrame += imgList.length;
		}
		image(tileImg0,x,y);
	}


}


