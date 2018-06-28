import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import processing.sound.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class SoundVsMinim extends PApplet {

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



AudioIn inS;
Amplitude ampS;

Minim minim;
AudioInput inM;

public void setup()
{
  

  minim = new Minim(this);
  
  // use the getLineIn method of the Minim object to get an AudioInput
  inM = minim.getLineIn();
  
  ampS = new Amplitude(this);
  inS = new AudioIn(this, 0);
  inS.start();
  ampS.input(inS);
}

public void draw()
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

public void keyPressed()
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
  public void settings() {  size(512, 200, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "SoundVsMinim" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
