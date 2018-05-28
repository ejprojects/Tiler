class Triangle {
	float xPos, yPos, scale, scaleF, speedF;
	int mspr;
	int lastMillis; // holds time of last render
	float angle;
	float [] sFactorHistory; // hold some number of previous values for averaging
	float sFactorAvg;
	int historyPointer;
	float modStrokeW; // in case stroke is very small, keep it at a setpoint. will modify opacity instead.
	float modStrokeWAlpha;

	Triangle(float x_, float y_, float sc_, int mspr_) {
		xPos = x_;
		yPos = y_;
		scale = sc_;
		mspr = mspr_;
		lastMillis = millis();
		scaleF = 0.0;
		speedF = 1.0;
		sFactorHistory = new float[6];
	}

	void render(int designCase) {
		
		//maintain average
		sFactorHistory[historyPointer] = scaleF;
		historyPointer++;
		if (historyPointer == sFactorHistory.length) {historyPointer = 0;}
		sFactorAvg = 0;
		for (int i = 0; i < sFactorHistory.length; ++i) {
			sFactorAvg += sFactorHistory[i];
		}
		sFactorAvg /= sFactorHistory.length;

		//Avoid strokes less than 2.0 (at screen scale); taper opacity instead
		// this doesn't really work
		modStrokeW = (strokeW * sFactorAvg);
		if (modStrokeW > strokeThreshold / scale) {
			modStrokeWAlpha = 255;
		}
		else {
			modStrokeWAlpha = map(modStrokeW, 0, strokeThreshold / scale, 0, 255);
			modStrokeW = strokeThreshold / scale;
		}
			// println("modStrokeW: "+modStrokeW, " modStrokeWAlpha:"+modStrokeWAlpha);

		//rotate
		angle += TWO_PI*(float((millis()-lastMillis))/mspr)*speedF;
		lastMillis = millis();

		//draw
		tileGen.beginDraw();
		tileGen.pushMatrix();
		tileGen.translate(xPos, yPos);
		tileGen.rotate(angle);
		tileGen.strokeWeight(modStrokeW);
		tileGen.stroke(invert ? bg : fg, modStrokeWAlpha);
		tileGen.noFill();

		switch (designCase) {
			case 1:
			design1();
			break;

			case 2:
			design2();
			break;

			case 3:
			design3();
			break;

			default:	
			println("triangle design case broken");
			break;
		}

		tileGen.popMatrix();
		tileGen.endDraw();
	}

	void design1 () { // tile-shaped triangles
		tileGen.beginShape();
		tileGen.vertex(-58*scale,-200*scale);
		tileGen.vertex(114*scale,100*scale);
		tileGen.vertex(-58*scale,100*scale);
		tileGen.endShape(CLOSE);
	}

	void design2 () { // circles
		tileGen.ellipse(80, 20, 200*scale, 200*scale);
	}

	void design3 () { // ellipses
		tileGen.ellipse(100, 30, 300*scale, 100*scale);
	}

}