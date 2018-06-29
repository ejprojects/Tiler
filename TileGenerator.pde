// ********************************************************************************************************************
// Tile Class:
// generate and store tile images with various design modes
// functions: generate, display (a given frame offset)

class Tile {
	PImage mask; //even if it's unmasked, the tile dimensions come from this file
	int tileWidth, tileHeight; //pulled from the mask file
	int design; // selects generative design options
	PGraphics[] imgList = new PGraphics[history]; // rendering destinations for the generative tile graphics / frames
	int currentFrame; // points to the current frame
	float scale = 1.0; // needed to make old code run, not used, yet??

	Tile (PImage mask_, int design_) {
		mask = mask_;
		design = design_;
		tileWidth = mask.width;
		tileHeight = mask.height;
		for (int i = 0; i < imgList.length; ++i) {
			imgList[i] = createGraphics(tileWidth, tileHeight, P3D);
		}
		generateTile(imgList[currentFrame]); // use the generate function below
	}

	void generateTile(PGraphics frame) { // here we draw to the new tile frame

		// println("design: "+design);

		frame.beginDraw();
		frame.strokeWeight(strokeW);
		frame.stroke(255);
		frame.noFill();
		frame.blendMode(ADD);
		frame.clear();

		switch (design) {
			case 0 :
			design0(frame);
			break;
			case 1 :
			design1(frame);
			break;
			case 2 :
			design2(frame);
			break;
			case 3 :
			design3(frame);
			break;
			default :
			println("tile design mode broken: "+design);
			break;
		}
		
		frame.mask(mask); // maybe alter masking later
		frame.endDraw();
	}

	void design0(PGraphics frame) {
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
	}

	void design1 (PGraphics frame) { // tile-shaped triangles
		frame.pushMatrix();
		frame.rotate(float(millis())/1667*PI);  // slower
		frame.beginShape();
		scale = 1.5;
		frame.vertex(-58*scale,-200*scale);
		frame.vertex(114*scale,100*scale);
		frame.vertex(-58*scale,100*scale);
		frame.endShape(CLOSE);
		frame.popMatrix();
		scale = 2.0;
		frame.pushMatrix();
		frame.rotate(float(millis())/-1233*PI);  // slower
		frame.beginShape();
		frame.vertex(-58*scale,-200*scale);
		frame.vertex(114*scale,100*scale);
		frame.vertex(-58*scale,100*scale);
		frame.endShape(CLOSE);
		frame.popMatrix();
		scale = 2.5;
		frame.pushMatrix();
		frame.translate(tileWidth*1.2, tileHeight*1.1);
		frame.rotate(float(millis())/-1233*PI);  // slower
		frame.beginShape();
		frame.vertex(-58*scale,-200*scale);
		frame.vertex(114*scale,100*scale);
		frame.vertex(-58*scale,100*scale);
		frame.endShape(CLOSE);
		frame.popMatrix();
	}

	void design2 (PGraphics frame) { // circles
		frame.pushMatrix();
		frame.rotate(float(millis())/1991*PI);  // slower
		scale = 1.5;
		frame.ellipse(80, 20, 200*scale, 200*scale);
		frame.popMatrix();
		scale = 2.0;
		frame.pushMatrix();
		frame.rotate(float(millis())/-1233*PI);  // slower
		frame.ellipse(25, 150, 200*scale, 200*scale);
		frame.popMatrix();
		scale = 2.5;
		frame.pushMatrix();
		frame.rotate(float(millis())/2523*PI);  // slower
		frame.ellipse(250, 100, 200*scale, 200*scale);
		frame.popMatrix();

	}

	void design3 (PGraphics frame) { // ellipses
		frame.pushMatrix();
		frame.rotate(float(millis())/-1834*PI);  // slower
		scale = 1.5;
		frame.ellipse(80, 20, 200*scale, 200*scale);
		frame.popMatrix();
		scale = 2.0;
		frame.pushMatrix();
		frame.rotate(float(millis())/1533*PI);  // slower
		frame.ellipse(25, 150, 200*scale, 200*scale);
		frame.popMatrix();
		scale = 2.5;
		frame.pushMatrix();
		frame.rotate(float(millis())/2207*PI);  // slower
		frame.ellipse(200, 100, 125*scale, 125*scale);
		frame.popMatrix();
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


