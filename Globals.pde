// ********************************************************************************************************************

// HYPE

import hype.*;
import hype.extended.colorist.HPixelColorist;

int            myStageW         = 1280;
int            myStageH         = 720;

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

import ddf.minim.*;
import ddf.minim.analysis.*;

Minim          minim;

AudioPlayer    myAudioPlayer;
AudioInput     myAudioInput;
boolean        myAudioToggle    = false; // true = myAudioPlayer / false = myAudioInput

FFT            myAudioFFT;

int            myAudioRange     = 32;	// number of fq bands
int            myAudioMax       = 100;	//

// float          myAudioAmp       = 20.0;	// amplification? orig 22
// float          myAudioIndex     = 0.15; // first band eq amp level? orig .19
// float          myAudioIndexStep = 0.6; // increase at each step by this. orig .225

// harwood...  Mic at 50
float          myAudioAmp       = 0.1;	// amplification? orig 22
float          myAudioIndex     = -600.0; // first band eq amp level? orig .19
float          myAudioIndexStep = 800.0; // increase at each step by this. orig .225  3.0

float          myAudioIndexAmp  = myAudioIndex; // initialize

float[]        myAudioData      = new float[myAudioRange];
float[]        myAudioDataMax   = new float[myAudioRange];

int            fontSize         = 16;
int            fontSpacing      = 50;

int            showVisualizerH  = 320;
boolean        shiftKeyToggle   = false;
boolean        showVisualizer   = false;

boolean[]      keys             = {false, false, false, false, false}; // 0=SHIFT, 1=S (PAUSE), 2=P (PLAY), 3=M (MUTE or UNMUTE), 4=R (RESTART AUDIO)
boolean        myAudioMute      = false;
boolean        myAudioPaused    = false;

boolean        useTimeCodes     = true;
String         timeCodeState;
int[]          timeCode         = {0, 258623, 417213, 733955};
int            timeCodeLength   = timeCode.length;
int            timeCodePosition = 0;
int            timeCodeFuture   = timeCodePosition+1;

// ********************************************************************************************************************// ********************************************************************************************************************
// tile format
float 			ratio = 1.732; 			// tile H = ratio * tile W - only for a half-eqilateral triangle
int 			tileW = 173;			// to hold image tile dimensions
int 			tileH = 300; 			// to hold image tile dimensions
float 			scale = 0.4; 			// overall scale of pattern
PImage 			mask; 					// an equivalent rectangle to the tile, with a diagonal half-mask
PGraphics 		tileGen; 				//	the mutable tile rendering object

// tile genration
Triangle[] 		TriArray;				// array to hold triangles for tile formation
int 			numTri = 4;
float 			strokeW = 0; 			// initial stroke weight
int[]			triScaleRange = {2,4,7,15};	// audio fq ranges for each triangle
int[]			triSpeedRange = {15,7,4,2};	// audio fq ranges for each triangle

// tile array
int 			xSteps, ySteps;			// for placing tiles and calculating field dimensions
Tile[] 			Tiles; 					// declare array to hold tiles

// Timing and animations

float 			speedFactor = 1.0; 		// for increasing tile mutation speeds
float 			strokeFactor = 1.0;		// for varying stroke
float 			washout;				// background tile color for washing out to
float 			strokeStable = 50;		// stroke stabilizes at this thickness
int 			growTime = 5000; 		// stroke growth time in milliseconds
float 			strokeLimit = 100; 		// maximum stroke
float 			strokeThreshold = 2.0;	// smallest stroke, below which opacity fades
int 			growBegin;				// tracks ms for start of stroke growth
boolean 		justOut = true;			// needed for initial run
boolean 		firstRun = true;		// sets to false in first strokein
boolean 		strokeIn, strokeOut, justIn;

int 			paramIndex = 1;			// sets parameter group
int 			play = 2; 				// play (1) or pause (2)
// add more

// for wingren auto play:

int[]			videoLengths = {349000, 271000, 430000, 234000}; // video lengths
// int[]			videoLengths = {10000, 10000, 10000, 10000}; // video lengths
int 			time = 0; // tracks present time
int 			lastTime = 0; // for trigger comparison
int 			startTime = 0; // to be filled with millis when a timer starts

// General

boolean 		invert = false;			// invert?
float  			bg = 0;					// background color
float 			fg = 255;				// foreground color