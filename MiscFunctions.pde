// //******************************************************************************************

// void createTileArray(float sc) {
// 	float xStep = 3*tileW; // hex are horizontally spaced 3 tile widths apart
// 	float yStep = 2*tileH; // hex are vertically spaced two tile heights apart... 
// 	xSteps = int((float(width)/sc)/xStep)+2; // how many steps across, at scale...
// 	ySteps = int((float(width)/sc)/yStep)+2; // how many steps down, at scale...
// 	float xOffset = -(xSteps-1)*3*tileW/2; // offeset to make it centered on 0,0
// 	float yOffset = -((ySteps)*tileH)+tileH/2;   // ditto
// 	Tiles = new Tile[xSteps * ySteps * 12]; // create array to hold all tiles
// 	for(int x=0; x<xSteps; x++) { 
// 		for (int y=0; y<ySteps; y++) { 
// 			for (int i = 0; i < 12; i++) { // 12 tiles per hex
// 				Tiles[((x*ySteps+y)*12)+i] = new Tile((x*xStep)+xOffset,(y*yStep)+((x%2)*tileH)+yOffset,i);
// 			}
// 		}
// 	}
// }

// void tileRender(int designCase) {
// 	tileGen.beginDraw();
// 	tileGen.background(invert ? fg-washout : washout);
// 	tileGen.endDraw();
// 	for (int i = 0; i < TriArray.length; ++i) {
// 		TriArray[i].render(designCase);
// 	}
// 	tileGen.mask(mask);
// }

// void growStrokes() { // milliseconds for transition
// 	if (strokeIn) {
// 		strokeW = map(cos((float(millis()-growBegin)/growTime)*PI), 1, -1, 0, strokeStable);
// 		if (round(strokeW)==strokeStable) {
// 			strokeW = strokeStable;
// 			strokeIn = false;
// 			justIn = true;
// 			donePrint();
// 		}
// 	}
// 	if (strokeOut) {
// 		strokeW = map(cos((float(millis()-growBegin)/growTime)*PI), 1, -1, strokeStable, strokeLimit);
// 		washout = constrain(map(strokeW/strokeLimit, 0.90, 0.99, 0, 255), 0, 255);
// 		if (round(strokeW)==strokeLimit) {
// 			strokeW = strokeLimit;
// 			strokeOut = false;
// 			justOut = true;
// 			donePrint();
// 		}
// 	}	
// }

// void donePrint () {
// 	println("growStrokes done " , invert ? "NEG" : "POS");

// }

// void movementInc(int v) {
// 	movement += v;
// 	if (movement>3) {
// 		movement=movement%4;
// 	}
// 	if (movement<0) {
// 		movement=0;
// 	}
// 	println("movement: "+(movement+1));
// }

// void togglePlay() {
// 	if (play == 2) {
// 		play = 1;
// 	}
// 	else if (play == 1) {
// 		play = 2;
// 	}
// }

// float mapCurve (float value, float low1, float high1, float low2, float high2, float power) {
// 	return(pow(map(value, low1, high1, low2, high2),power));
// }

// // timer functions

// boolean timer (int x) {
// 	time = millis() - startTime;
// 	if (lastTime < x && time >= x) {
// 		// println("Trigger ", x, ":", lastTime, " ", time);
// 		lastTime = time;
// 		return true;
// 	}
// 	else {
// 		// lastTime = time;
// 		return false;
// 	}
// }


// void resetTimer() {
// 	startTime = millis();
// 	lastTime = 0;
// }