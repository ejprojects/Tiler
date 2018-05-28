// User Input

void sendOSC(String addr, int msg) {
  /* send an OSC message to NetAddress addr */
  osc.send( receiver , addr , msg);
  println("sent OSC: ", addr, " ",msg);
}

void keyPressed() {
	if (key == CODED) {
		switch (keyCode) {

			case UP:
			sendOSC("/Play", 1);
			sendOSC("/Fade", 1);
			break;

			case DOWN:
			sendOSC("/Fade", 2);
    if (justIn) {
      strokeOut = true;
      growBegin = millis();
      print ("out", ": ", strokeOut, "... ");
      justIn = false;
    }
			break;

			case RIGHT:
			movementInc(1);
			sendOSC("/Play", 2);
			sendOSC("/Set", movement+1);
			break;

			case LEFT:
			movementInc(-1);
			sendOSC("/Play", 2);
			sendOSC("/Set", movement+1);
			break;

			default:
			break;
		}
	}
	switch (key) {

		case ' ':
		if (play == 2) {
			play = 1;
		}
		sendOSC("/Play", play);
		break;

		case BACKSPACE:
		if (play == 2) {
			play = 1;
		}
		sendOSC("/Reset", 1);
		break;

		case 'v':
		if (showVisualizer) showVisualizer = false;
		else                showVisualizer = true;
		break;

		case 'i':
		if(justOut) {
			invert = firstRun ? false : !invert;
			firstRun = false;
			justOut = false;
			strokeIn = true;
			washout = 0;
			growBegin = millis();
			print ("in", ": ", strokeIn, "... ");
		}
		break;

		case 'o':
		if (justIn) {
			strokeOut = true;
			growBegin = millis();
			print ("out", ": ", strokeOut, "... ");
			justIn = false;
		}
		break;

		default:
		break;
	}

	if (myAudioToggle) {
		if(keyCode == SHIFT) keys[0]=true;
		if(key=='S')         keys[1]=true; // STOP / PAUSE
		if(key=='P')         keys[2]=true; // PLAY
		if(key=='M')         keys[3]=true; // MUTE or UNMUTE
		if(key=='R')         keys[4]=true; // RESTART

		if (keys[0] && keys[1]) {
			myAudioPaused = true;
			myAudioPlayer.pause();
		}

		if (keys[0] && keys[2]) {
			myAudioPaused = false;
			myAudioPlayer.play();
		}

		if (keys[0] && keys[3]) {
			if (myAudioMute) {
				myAudioPlayer.unmute();
				myAudioMute = false;
			} else {
				myAudioPlayer.mute();
				myAudioMute = true;
			}
		}

		if (keys[0] && keys[4]) {
			timeCodePosition = 0;
			timeCodeFuture   = timeCodePosition+1;
			letsAudioJumpMMS(0);
		}
	}
}

void keyReleased() {
	if (myAudioToggle) {
		if(keyCode == SHIFT)     keys[0]=false;
		if(key=='s' || key=='S') keys[1]=false;
		if(key=='p' || key=='P') keys[2]=false;
		if(key=='m' || key=='M') keys[3]=false;
		if(key=='r' || key=='R') keys[4]=false;
	}
}

void cycling() {

	// println(lastTime, " ", time, " ", videoLengths[movement]-1000);

	if (timer(3000)) {
		tileCase[movement]= int(random(3)+1);
		perspCase[movement]= int(random(2)+1);
		sendOSC("/Set", movement+1);
		sendOSC("/Play", 1);
		sendOSC("/Fade", 1);
		}
	
	

	if (timer(videoLengths[movement] + 2000)) {
		sendOSC("/Fade", 2);
		}

	

	if (timer(videoLengths[movement]+3000)) {
		sendOSC("/Play", 2);
		movementInc (int(random(3))+1);
		resetTimer();
	}

}


	// 	if (key == CODED) {
	// 	switch (keyCode) {

	// 		case UP:
	// 		sendOSC("/Play", 1);
	// 		sendOSC("/Fade", 1);
	// 		break;

	// 		case DOWN:
	// 		sendOSC("/Fade", 2);
 //    if (justIn) {
 //      strokeOut = true;
 //      growBegin = millis();
 //      print ("out", ": ", strokeOut, "... ");
 //      justIn = false;
 //    }
	// 		break;

	// 		case RIGHT:
	// 		movementInc(1);
	// 		sendOSC("/Play", 2);
	// 		sendOSC("/Set", movement+1);
	// 		break;

	// 		case LEFT:
	// 		movementInc(-1);
	// 		sendOSC("/Play", 2);
	// 		sendOSC("/Set", movement+1);
	// 		break;

	// 		default:
	// 		break;
	// 	}
	// }
	// switch (key) {

	// 	case ' ':
	// 	if (play == 2) {
	// 		play = 1;
	// 	}
	// 	sendOSC("/Play", play);
	// 	break;

	// 	case BACKSPACE:
	// 	if (play == 2) {
	// 		play = 1;
	// 	}
	// 	sendOSC("/Reset", 1);
	// 	break;

	// 	case 'v':
	// 	if (showVisualizer) showVisualizer = false;
	// 	else                showVisualizer = true;
	// 	break;

	// 	case 'i':
	// 	if(justOut) {
	// 		invert = firstRun ? false : !invert;
	// 		firstRun = false;
	// 		justOut = false;
	// 		strokeIn = true;
	// 		washout = 0;
	// 		growBegin = millis();
	// 		print ("in", ": ", strokeIn, "... ");
	// 	}
	// 	break;

	// 	case 'o':
	// 	if (justIn) {
	// 		strokeOut = true;
	// 		growBegin = millis();
	// 		print ("out", ": ", strokeOut, "... ");
	// 		justIn = false;
	// 	}
	// 	break;

	// 	default:
	// 	break;
	// }

// ********************************************************************************************************************

void mousePressed() {
	if (myAudioToggle && keys[0]) {
		int position = int( map( mouseX, 0, width, 0, myAudioPlayer.length() ) );
		myAudioPlayer.cue( position );

		for (int i = 0; i < timeCodeLength; ++i) {
			if (position<timeCode[i]) {
				timeCodePosition = i-1;
				timeCodeFuture   = i;
				break;
			}
		}
	}
}

// ********************************************************************************************************************

// mousewheel control...

void mouseWheel(MouseEvent event) {
	float e = event.getAmount();
	myAudioAmp += e/100;
	if(myAudioAmp<0.1) {
		myAudioAmp = 0.1;
	}
	if(myAudioAmp>0.25) {
		myAudioAmp = 0.25;
	}
	println("myAudioAmp: "+myAudioAmp);
}