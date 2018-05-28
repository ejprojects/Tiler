class Tile {
	float x, y; // coordinates of center point - acute corner
	float a; 	// angle in radians for adjacent edge, calculated from aIndex
	int aIndex;	// 0 - 11 for 12 places
	boolean r; 	// reflected? calculated from aIndex
	float centerX, centerY, screenX, screenY; // for finding center of tile on screen

	Tile(float x_, float y_, int a_) { // a_ is an index of position - 12 places
		x = x_;
		y = y_;
		aIndex = a_;
		a = (a_/2) * (TWO_PI/6); // angle for the adjacent edge
		if (a_%2 == 1) {
			r = true; // if it's odd, reflect!
		}
		centerX = tileW / 3;
		centerY = tileH * 2 / 3;
	}

	void display() {
		pushMatrix();
		scale(scale);
		translate(x,y);
		rotate(a); // rotate to the angle
		if(r) {
			scale(-1, 1); //reflect on the x axis
		}
		scale(1.001,1); // adjjust width
		image(tileGen,0,0);
		screenX = modelX(centerX, centerY, 0); // record screen coordinates of tile center
		screenY = modelY(centerX, centerY, 0);
		popMatrix();
	}
}