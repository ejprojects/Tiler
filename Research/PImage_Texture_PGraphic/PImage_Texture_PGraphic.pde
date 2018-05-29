// tiler using PImage as texture, drawn to PGraphic and posted to screen

void settings() {
  size(400,400,P3D);
  PJOGL.profile=1;
  smooth();
  noLoop();
  // noSmooth();
  // fullScreen(1);
}

// ********************************************************************************************************************
void setup(){

  frameRate(30);
  tileImg = loadImage("tile-test.png"); // this will be replaced with the generated tiles later

}

// ********************************************************************************************************************
void draw(){

  // using the PGraphics tile as a container to render to (trivially for now)
  // tile = createGraphics(100,100);
  // tile.beginDraw();
  // tile.image(tileImg,0,0);
  // tile.endDraw();

  // using the PGraphics tile as a container to render to (trivially for now) via function using texture()
  tileShapeP(tileImg);

  // supertile testing loop
  translate(width/2, height/2); // at center of window
  for (int i = 0; i < symRot.length; ++i) { //cycle through the symmetry data (develop this)
    pushMatrix();
    rotate(symRot[i]); // rotate the prescribed amount
    rotate((symFlip[i] == -1) ? -HALF_PI : 0); // rotate to accommodate flip if necessary (improve)
    scale(symFlip[i],1); // flip if prescribed
    // image(tile,0,0); // draw it from PImgae 
    // tileShape(tileImg); // draw it via shape using PImgae as Texture
    tileShapeP(tileImg); // draw it via shape in fuction
    image(tile,0,0);
    popMatrix();
  }


}

// ********************************************************************************************************************
PImage tileImg; // this loads a tile image

// set up symmetry variable arrays. turn this into a class with a good data structure
float[] symRot = {0, HALF_PI, PI, PI+HALF_PI};
// int[] symFlip = {1, -1, 1, -1};
int[] symFlip = {1, 1, 1, 1};

PGraphics tile; // the container for the individual tiles that will build:
PGraphics superTile; // the supertile, to repeat over the plane

// shape drawing function - direct to screen
void tileShape (PImage img) {
  noStroke();
  textureMode(NORMAL);
  beginShape();
  texture(img);
  vertex(0,0,0,0);
  vertex(99,0,1,0);
  vertex(99,99,1,1);
  vertex(0,99,0,1);
  endShape();

}

// shape drawing function -  to PGraphic 'tile'
void tileShapeP (PImage img) {
  tile = createGraphics(100,100,P3D);
  tile.beginDraw();
  tile.noStroke();
  tile.textureMode(NORMAL);
  tile.beginShape();
  tile.texture(img);
  tile.vertex(0,0,0,0);
  tile.vertex(99,0,1,0);
  tile.vertex(99,99,1,1);
  tile.vertex(0,99,0,1);
  tile.endShape();
  tile.endDraw();

}
