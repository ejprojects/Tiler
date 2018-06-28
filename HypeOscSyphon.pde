// AUDIO / OSC / SYPHON

// ********************************************************************************************************************

// Processing Sound

import processing.sound.*;
Amplitude amp;
AudioIn in;
  
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

void sendOSC(String addr, int msg) {
  /* send an OSC message to NetAddress addr */
  osc.send( receiver , addr , msg);
  println("sent OSC: ", addr, " ",msg);
}

// ********************************************************************************************************************
// ********************************************************************************************************************

// AUDIO

import ddf.minim.*;

Minim          minim;
AudioInput     myAudioInput;
float			l,r;
