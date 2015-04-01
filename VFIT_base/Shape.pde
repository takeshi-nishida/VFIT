PShape[] shapes;
PShape arrow;

void createShapes(float f) {
  shapes = new PShape[4];
  shapes[0] = createShape(ELLIPSE, 0, 0, f, f);
  shapes[1] = createShape(RECT, 0, 0, f, f);
  shapes[2] = createShape(TRIANGLE, f * 0.5, 0, f, f, 0, f);
  shapes[3] = createStar(f * 1.1);  

  arrow = createArrow(f);
}

PShape createStar(float f) {
  PShape s = createShape();
  s.beginShape();
  for (int i = 0; i < 5; i++) {
    float theta = TWO_PI * i * 2 / 5 - HALF_PI;
    s.vertex(cos(theta) * f * 0.5 + f * 0.5, sin(theta) * f * 0.5 + f * 0.5);
  }
  s.endShape();
  return s;
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
