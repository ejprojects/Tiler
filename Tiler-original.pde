
void settings() {
	size(myStageW,myStageH,P3D);
	PJOGL.profile=1;
	smooth(4);
	// noSmooth();
	// fullScreen(1);
}

// ********************************************************************************************************************
void setup(){

	frameRate(30);
	hint(DISABLE_DEPTH_TEST);
	noStroke();
	noFill();

	// OSC
	/* create a new instance of OscP5, the second parameter indicates the listening port */
	osc = new OscP5( this , 12000 ); 
	/* create a NetAddress which requires the receiver's IP address and port number */
	receiver = new NetAddress( "127.0.0.1" , 12000 );

	// Syphon
	server = new SyphonServer(this, "Processing Syphon");

	// Set Up Tile Graphic
	mask = loadImage("mask.png");
	tileGen = createGraphics(tileW,tileH,P3D);
	TriArray = new Triangle[numTri];
	for (int i = 0; i<TriArray.length; i++) {
		TriArray[i] = new Triangle 
		(random(tileW), random(tileH), 1, 30000);
		//	x pos		y pos		scale	mspr speed int(random(6666, 20000))
	}

	createTileArray(scale);

	if(myAudioToggle) {
	myAudioDataSetup("Au Dela Du Temps.mp3", 0, "loop"); // AudioPlayer / audio file, start position in Milliseconds, state = stop / play / loop	
}
else {
		myAudioDataSetup(); //line in!
	}
	sendOSC("/Set", 1); // unnecessarily initialize vuo, just to send a message
}

// ********************************************************************************************************************
void draw(){
	cycling();							//cycle automatically 

	pushMatrix(); 
	translate(width/2,height/2); 		//centering
	background(invert ? fg : bg); 		//inversion
	// growStrokes(); 						// for growing in and growing out
	strokeW = strokeStable;				//skip stroke growth

	switch (fftACase[movement]) {
		case 1:
		for (int i = 0; i < numTri; ++i) {
			float fftA1 = mapCurve(myAudioData[triScaleRange[i]], 0, myAudioMax, 0.2, 1.0, 1.2);
			TriArray[i].scaleF = fftA1;
			// print(fftA1, " ");
			float fftA2 = map(myAudioData[triSpeedRange[i]], 0, myAudioMax, 1.0, 10.0);
			TriArray[i].speedF = fftA2;
		}
		break;

		case 2:
		for (int i = 0; i < numTri; ++i) {
			float fftA1 = mapCurve(myAudioData[triScaleRange[i]], 0, myAudioMax, 0.09, 1.0, 1.3);
			TriArray[i].scaleF = fftA1;
			float fftA2 = map(myAudioData[triSpeedRange[i]], 0, myAudioMax, 1.0, 30.0);
			TriArray[i].speedF = fftA2;
		}
		break;

		case 3:
		for (int i = 0; i < numTri; ++i) {
			float fftA1 = mapCurve(myAudioData[triScaleRange[i]], 0, myAudioMax, 0.09, 1.0, 1.2);
			TriArray[i].scaleF = fftA1;
			float fftA2 = map(myAudioData[triSpeedRange[i]], 0, myAudioMax, 1.0, 8.0);
			TriArray[i].speedF = fftA2;
		}
		break;

		case 4:
		for (int i = 0; i < numTri; ++i) {
			float fftA1 = mapCurve(myAudioData[triScaleRange[i]], 0, myAudioMax, 0.15, 1.0, 1.6);
			TriArray[i].scaleF = fftA1;
			float fftA2 = map(myAudioData[triSpeedRange[i]], 0, myAudioMax, 1.0, 15.0);
			TriArray[i].speedF = fftA2;
		}
		break;

		default:
		println("fftACase broken");
		break;
}

	tileRender(tileCase[movement]); // draw all the tiles to their PGraphics

	pushMatrix();
	switch (perspCase[movement]) {				// changing tile grid orientation & perspecitve
		case 1: // do nothing
		break;

		case 2: // looming sky
		translate(0,350);
		rotateX(-.6);
		break;

		case 3: // looming sky
		translate(0,-350);
		rotateX(.6);
		break;

		default:
		println("perspCase broken");
		break;
	}

	if (showTiles[movement]) {					// diplay the tiles, unless they're turned off
		for (int i = 0; i<Tiles.length; i++) { // display the tiles
			Tiles[i].display();
		}
	}

	popMatrix();
	popMatrix();

	myAudioDataUpdate();

	if (showVisualizer) myAudioDataWidget();
	// saveFrame("../frames/#########.tif"); if (frameCount == 900) exit();
	surface.setTitle( int(frameRate) + " FPS" );

	server.sendScreen();
}

// ********************************************************************************************************************