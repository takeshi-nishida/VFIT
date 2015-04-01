import netP5.*;
import oscP5.*;

String host = "133.30.244.130";
int port = 5931;
OscP5 client;

PShape arrow;
int direction = 0;
boolean show = false;
boolean animate = false;
long timestamp;

void setup(){
  size(400, 240, P2D);
  client = new OscP5(this, host, port, OscP5.TCP);
  arrow = createArrow(200);
  fill(255);
}

void draw(){
  background(0);
  if(show){
    long ellapsedTime = System.currentTimeMillis() - timestamp;
    float x = width * 0.5, y = height * 0.5;
    if(animate){
      float d = 300 * ellapsedTime / 500 - 150;
      d = direction > 1 ? d : -d;
      x += d * ((direction + 1) % 2);
      y += d * (direction % 2);
      // println(ellapsedTime + "| " + x + "," + y);
    }
    drawArrow(x, y, direction * HALF_PI);
  }
}

void oscEvent(OscMessage m){
  if(m.checkAddrPattern("/direction")){
    show = true;
    direction = ((Integer) m.arguments()[0]).intValue();
    animate = ((Integer) m.arguments()[1]).intValue() > 0;
    timestamp = System.currentTimeMillis();
  }
  if(m.checkAddrPattern("/stop")){
    show = false;
  }
}

PShape createArrow(float f) {
  float hf = f / 2, qf = f / 4, mf = f / 8;
  PShape s = createShape(GROUP);
  PShape head = createShape(TRIANGLE, 0, hf, qf, f - qf, qf, qf);
  PShape body = createShape(RECT, qf, hf - mf, hf, qf);
  s.addChild(head);
  s.addChild(body);
  s.translate(-f/2, -f/2);
  return s;
}

void drawArrow(float x, float y, float angle) {
  pushMatrix();
  translate(x, y);
  rotate(angle);
  shape(arrow);
  popMatrix();
}

