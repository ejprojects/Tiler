// Timer:

int[]			videoLengths = {349000, 271000, 430000, 234000}; // video lengths
// int[]			videoLengths = {10000, 10000, 10000, 10000}; // video lengths
int 			time = 0; // tracks present time
int 			lastTime = 0; // for trigger comparison
int 			startTime = 0; // to be filled with millis when a timer starts

int 			movement = 0; // which video (0-3)

void cycling() {

	// println(lastTime, " ", time, " ", videoLengths[movement]-1000);

	if (timer(3000)) {
		// tileCase[movement]= int(random(3)+1); // obsolete
		// perspCase[movement]= int(random(2)+1); // obsolete
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

// timer functions

boolean timer (int x) {
	time = millis() - startTime;
	if (lastTime < x && time >= x) {
		// println("Trigger ", x, ":", lastTime, " ", time);
		lastTime = time;
		return true;
	}
	else {
		// lastTime = time;
		return false;
	}
}


void resetTimer() {
	startTime = millis();
	lastTime = 0;
}

void movementInc(int v) {
	movement += v;
	if (movement>3) {
		movement=movement%4;
	}
	if (movement<0) {
		movement=0;
	}
	println("movement: "+(movement+1));
}

