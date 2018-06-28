/**
  * This sketch demonstrates how to monitor the currently active audio input 
  * of the computer using an AudioInput. What you will actually 
  * be monitoring depends on the current settings of the machine the sketch is running on. 
  * Typically, you will be monitoring the built-in microphone, but if running on a desktop
  * it's feasible that the user may have the actual audio output of the computer 
  * as the active audio input, or something else entirely.
  * <p>
  * Press 'm' to toggle monitoring on and off.
  * <p>
  * When you run your sketch as an applet you will need to sign it in order to get an input.
  * <p>
  * For more information about Minim and additional features, 
  * visit http://code.compartmental.net/minim/ 
  */

import ddf.minim.*;
import processing.sound.*;
AudioIn inS;
Amplitude ampS;

Minim minim;
AudioInput inM;

void setup()
{
  size(512, 200, P3D);

  minim = new Minim(this);
  
  // use the getLineIn method of the Minim object to get an AudioInput
  inM = minim.getLineIn();
  
  ampS = new Amplitude(this);
  inS = new AudioIn(this, 0);
  inS.start();
  ampS.input(inS);
}

void draw()
{
  background(0);
  stroke(255);
  
  // draw the waveforms so we can see what we are monitoring
  for(int i = 0; i < inM.bufferSize() - 1; i++)
  {
    line( i, 50 + inM.left.get(i)*50, i+1, 50 + inM.left.get(i+1)*50 );
    line( i, 150 + inM.right.get(i)*50, i+1, 150 + inM.right.get(i+1)*50 );
  }
  
  String monitoringState = inM.isMonitoring() ? "enabled" : "disabled";
  text( "Input monitoring is currently " + monitoringState + ".", 5, 15 );
  
  println(ampS.analyze());
}

void keyPressed()
{
  if ( key == 'm' || key == 'M' )
  {
    if ( inM.isMonitoring() )
    {
      inM.disableMonitoring();
    }
    else
    {
      inM.enableMonitoring();
    }
  }
}
