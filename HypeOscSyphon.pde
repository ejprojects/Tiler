// AUDIO / OSC / SYPHON

// ********************************************************************************************************************

// Processing Sound

import processing.sound.*;
Amplitude amp;
AudioIn in;
  


// HYPE

// import hype.*;
// import hype.extended.colorist.HPixelColorist;

// int            myStageW         = 1280;
// int            myStageH         = 720;

// ********************************************************************************************************************

// SYPHON

import codeanticode.syphon.*;
SyphonServer server;

// ********************************************************************************************************************

// OSC
 
import oscP5.*;
import netP5.*;

OscP5 osc;

NetAddress receiver;

// ********************************************************************************************************************

// AUDIO

// import ddf.minim.*;
// import ddf.minim.analysis.*;

// Minim          minim;

// AudioPlayer    myAudioPlayer;
// AudioInput     myAudioInput;
// boolean        myAudioToggle    = false; // true = myAudioPlayer / false = myAudioInput

// FFT            myAudioFFT;

// int            myAudioRange     = 32;	// number of fq bands
// int            myAudioMax       = 100;	//

// // float          myAudioAmp       = 20.0;	// amplification? orig 22
// // float          myAudioIndex     = 0.15; // first band eq amp level? orig .19
// // float          myAudioIndexStep = 0.6; // increase at each step by this. orig .225

// // harwood...  Mic at 50
// float          myAudioAmp       = 0.1;	// amplification? orig 22
// float          myAudioIndex     = -600.0; // first band eq amp level? orig .19
// float          myAudioIndexStep = 800.0; // increase at each step by this. orig .225  3.0

// float          myAudioIndexAmp  = myAudioIndex; // initialize

// float[]        myAudioData      = new float[myAudioRange];
// float[]        myAudioDataMax   = new float[myAudioRange];

// int            fontSize         = 16;
// int            fontSpacing      = 50;

// int            showVisualizerH  = 320;
// boolean        shiftKeyToggle   = false;
// boolean        showVisualizer   = false;

// boolean[]      keys             = {false, false, false, false, false}; // 0=SHIFT, 1=S (PAUSE), 2=P (PLAY), 3=M (MUTE or UNMUTE), 4=R (RESTART AUDIO)
// boolean        myAudioMute      = false;
// boolean        myAudioPaused    = false;

// boolean        useTimeCodes     = true;
// String         timeCodeState;
// int[]          timeCode         = {0, 258623, 417213, 733955};
// int            timeCodeLength   = timeCode.length;
// int            timeCodePosition = 0;
// int            timeCodeFuture   = timeCodePosition+1;

// void myAudioDataSetup() {
// 	myAudioToggle = false;
// 	minim = new Minim(this);
// 	myAudioInput = minim.getLineIn(Minim.MONO);

// 	myAudioFFT = new FFT(myAudioInput.bufferSize(), myAudioInput.sampleRate());
// 	myAudioFFT.linAverages(myAudioRange);
// 	myAudioFFT.window(FFT.GAUSS);
// }

// void myAudioDataSetup(String str, int pos, String state) {
// 	timeCodeState = state;
// 	minim = new Minim(this);
// 	myAudioPlayer = minim.loadFile(str);

// 	if (state == "stop") {
// 		myAudioPlayer.play();
// 		myAudioPlayer.mute();
// 		myAudioPlayer.pause();
// 		myAudioPlayer.unmute();
// 		letsAudioJumpMMS(pos);
// 	} else if (state == "play") {
// 		letsAudioJumpMMS(pos);
// 		myAudioPlayer.play();
// 	} else if (state == "loop") {
// 		letsAudioJumpMMS(pos);
// 		myAudioPlayer.play();
// 	}

// 	myAudioFFT = new FFT(myAudioPlayer.bufferSize(), myAudioPlayer.sampleRate());
// 	myAudioFFT.linAverages(myAudioRange);
// 	// myAudioFFT.window(FFT.GAUSS);
// }

// void myAudioDataUpdate() {
// 	if (myAudioToggle) myAudioFFT.forward(myAudioPlayer.mix); //whcih source
// 	else               myAudioFFT.forward(myAudioInput.mix);	

// 	for (int i = 0; i < myAudioRange; ++i) { // in each band...
// 		// gets the minim-average, amplified by the overall amp, then by 'myAudioIndexAmp'
// 		float tempIndexAvg = (myAudioFFT.getAvg(i) * myAudioAmp) * myAudioIndexAmp;
// 		// then constrain it to 'myAudioMax'
// 		float tempIndexCon = constrain(tempIndexAvg, 0, myAudioMax);
// 		myAudioData[i]     = tempIndexCon; // this is the output for this band
// 		myAudioIndexAmp+=myAudioIndexStep; // this ups the amplification!!
// 	}

// 	myAudioIndexAmp = myAudioIndex; // reset

// 	if (myAudioToggle) {
// 		// timecodes
// 		if( myAudioPlayer.position()>timeCode[timeCodeFuture] && timeCodeFuture!=0 ) {
// 			timeCodePosition = timeCodeFuture;
// 			timeCodeFuture   = ++timeCodeFuture%timeCodeLength;
// 		}

// 		// loop
// 		if (timeCodeState=="loop" && !myAudioPaused && !myAudioPlayer.isPlaying()) {
// 			timeCodePosition = 0;
// 			timeCodeFuture   = timeCodePosition+1;
// 			letsAudioJumpMMS(0);
// 			myAudioPlayer.play();
// 		}
// 	}
// }

// void myAudioDataWidget() {

// 	//setup
// 	perspective(PI/3.0, (float)width/height, 0.1, 1000000);
// 	noLights();
// 	// hint(DISABLE_DEPTH_TEST);
// 	resetShader();

// 	//main viewer rectangle shaded
// 	noStroke();
// 	fill(0,200);
// 	rect(0, height-showVisualizerH, width, (showVisualizerH-10));

// 	//player position marker
// 	strokeWeight(0.5);
// 	stroke(255,50); 
// 	noFill();
// 	line(185, height-61, width, height-61);
// 	stroke(255,100); 
// 	line(0, height-(showVisualizerH-16), width, height-(showVisualizerH-16));
// 	if (myAudioToggle) {
// 		fill(#CCCCCC);
// 		int position = (int)map( myAudioPlayer.position(), 0, myAudioPlayer.length(), 0, width );
// 		rect(position, height-(showVisualizerH-6), 1, 20);
// 	}

// 	//timecode markers
// 	if (myAudioToggle && useTimeCodes) {
// 		for (int i = 0; i < timeCodeLength; ++i) {
// 			if (i==timeCodePosition) { stroke(#CC6600); fill(#CC6600); }
// 			else                     { stroke(#00CC00); fill(#00CC00); }
// 			int timeCodePos = (int)map(timeCode[i], 0, myAudioPlayer.length(), 0, width);
// 			rect(timeCodePos, height-(showVisualizerH-6), 1, 20);
// 		}
// 	}

// 	noFill();
// 	stroke(#FF0000); line(10, height-31,  169, height-31);
// 	stroke(#FF3300); line(10, height-51,  169, height-51);
// 	stroke(#FF6600); line(10, height-71,  169, height-71);
// 	stroke(#FF9900); line(10, height-91,  169, height-91);
// 	stroke(#FFCC00); line(10, height-111, 169, height-111);
// 	strokeWeight(1.0);

// 	pushMatrix();
// 	scale((float)width/1920,1);

// 	noStroke();
// 	for (int i = 0; i < myAudioRange; ++i) {
// 		fill(#ECECEC);
// 		rect(10 + (i*5), (height-myAudioData[i])-11, 3.3, myAudioData[i]);
// 	}

// 	textAlign(CENTER);

// 	int rectY      = 107;
// 	int textY      = 80;
// 	int yOffset    = 0;
// 	int yOffsetAmp = 45;
// 	int yThreshold;

// 	for (int j = 0; j < myAudioRange; ++j) {
// 		// 20 % 
// 		yThreshold = 20; yOffset = yOffsetAmp*0;
// 		if (myAudioData[j]>=yThreshold) { fill(#FF0000); myAudioDataMax[j] = yThreshold; }
// 		else                            { fill(#181818); myAudioDataMax[j] = 0; }
// 		rect(185 + (j*fontSpacing), height-(rectY+yOffset), 44, 40);
// 		if (myAudioData[j]>=yThreshold) fill(0);
// 		else                            fill(#4D4D4D);
// 		text(str(j), 207 + (j*fontSpacing), height-(textY+yOffset));

// 		// 40 % 
// 		yThreshold = 40; yOffset = yOffsetAmp*1;
// 		if (myAudioData[j]>=yThreshold) { fill(#FF3300); myAudioDataMax[j] = yThreshold; }
// 		else                            { fill(#181818); }
// 		rect(185 + (j*fontSpacing), height-(rectY+yOffset), 44, 40);
// 		if (myAudioData[j]>=yThreshold) fill(0);
// 		else                            fill(#4D4D4D);
// 		text(str(j), 207 + (j*fontSpacing), height-(textY+yOffset));

// 		// 60 % 
// 		yThreshold = 60; yOffset = yOffsetAmp*2;
// 		if (myAudioData[j]>=yThreshold) { fill(#FF6600); myAudioDataMax[j] = yThreshold; }
// 		else                            { fill(#181818); }
// 		rect(185 + (j*fontSpacing), height-(rectY+yOffset), 44, 40);
// 		if (myAudioData[j]>=yThreshold) fill(0);
// 		else                            fill(#4D4D4D);
// 		text(str(j), 207 + (j*fontSpacing), height-(textY+yOffset));

// 		// 80 % 
// 		yThreshold = 80; yOffset = yOffsetAmp*3;
// 		if (myAudioData[j]>=yThreshold) { fill(#FF9900); myAudioDataMax[j] = yThreshold; }
// 		else                            { fill(#181818); }
// 		rect(185 + (j*fontSpacing), height-(rectY+yOffset), 44, 40);
// 		if (myAudioData[j]>=yThreshold) fill(0);
// 		else                            fill(#4D4D4D);
// 		text(str(j), 207 + (j*fontSpacing), height-(textY+yOffset));

// 		// 100 % 
// 		yThreshold = 100; yOffset = yOffsetAmp*4;
// 		if (myAudioData[j]>=yThreshold) { fill(#FFCC00); myAudioDataMax[j] = yThreshold; }
// 		else                            { fill(#181818); }
// 		rect(185 + (j*fontSpacing), height-(rectY+yOffset), 44, 40);
// 		if (myAudioData[j]>=yThreshold) fill(0);
// 		else                            fill(#4D4D4D);
// 		text(str(j), 207 + (j*fontSpacing), height-(textY+yOffset));

// 		int tempInt   = (int)myAudioDataMax[j];
// 		int tempAlpha = (int)map(tempInt, 0, 100, 55, 255);
// 		fill(#ECECEC, tempAlpha);
// 		text(str(tempInt), 207 + (j*fontSpacing), height-30);
// 	}

// 	popMatrix();

// 	fill(#999999);
// 	textAlign(RIGHT);
// 	text("20 %",  width-25, height-(textY+(yOffsetAmp*0)));
// 	text("40 %",  width-25, height-(textY+(yOffsetAmp*1)));
// 	text("60 %",  width-25, height-(textY+(yOffsetAmp*2)));
// 	text("80 %",  width-25, height-(textY+(yOffsetAmp*3)));
// 	text("100 %", width-25, height-(textY+(yOffsetAmp*4)));

// 	pushMatrix();
// 	scale((float)width/1920,1);

// 	if (myAudioToggle) {
// 		if (useTimeCodes) {
// 			fill(#CC6600);
// 			String curPos = "timeCodePosition = " + str(timeCodePosition);
// 			text(curPos, 170, height-215);
// 		}
// 		String curTime = str(myAudioPlayer.position()/60000) + " : " + str((myAudioPlayer.position()/1000)%60) ;
// 		fill(#00616f);
// 		text(curTime, 170, height-170);
// 		fill(#0095A8);
// 		text(str(myAudioPlayer.position()), 170, height-125);
// 	}

// 	// hint(ENABLE_DEPTH_TEST);

// 	popMatrix();
// }

// void letsAudioJump(int _m, int _s) { if (myAudioToggle) myAudioPlayer.cue( (_m*60000)+(_s*1000) ); }
// void letsAudioJumpMMS(int _time) {   if (myAudioToggle) myAudioPlayer.cue( _time ); }

// void stop() {
// 	if (myAudioToggle) myAudioPlayer.close();
// 	else               myAudioInput.close();
	
// 	minim.stop();  
// 	super.stop();
// }
