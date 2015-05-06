import netP5.*;
import oscP5.*;
import java.util.*;

// Configuration
int TOTAL_TRIALS  = 20; // Total number of trials
int SIZE          = 100; // Size of the shapes
int WAIT_TIME     = 3000; // Length of wait before each cycle [ms]
int STIMULUS_TIME =  500; // Length of stimilus [ms]
int INPUT_TIME    =  500; // Length of input wait after stimuls [ms]
char GO_KEY = 'z';

// Measures
List<Boolean> goList;
int ntrials; // Current number of trials
int cgo_count; // Number of correct go
int fgo_count; // Number of false go
int ca_count; // Number of correct answer

boolean showOnHMD = false;
boolean animate = false;

boolean sketchFullScreen() { 
  return true;
}

void setup() {
  size(displayWidth, displayHeight);
  initStyle();
  createShapes(SIZE);
  resetMeasures();
  state = new InitialState();
}

void draw() {
  background(0);
  drawStatus();
  state = state.processState();
}

void keyPressed() {
  state = state.keyPressed();
}

void initStyle(){
  fill(255);
  stroke(255);
  strokeWeight(4);
  textSize(18);
}

void drawStatus(){
  String s1 = showOnHMD ? "HMD/" + status() : "DISPLAY";
  String s2 = animate ? "DYNAMIC" : "STATIC";
  String s3 = "Cycle " + ntrials;
  text(s1 + "\n" + s2 + "\n" + s3, 0, textAscent());
}

void resetMeasures(){
  ntrials = 0;
  cgo_count = 0;
  fgo_count = 0;
  ca_count = 0;
  
  int n = (int) (TOTAL_TRIALS * 0.5);
  goList = new ArrayList<Boolean>();
  goList.addAll(Collections.nCopies(n, true));
  goList.addAll(Collections.nCopies(TOTAL_TRIALS - n, false));
  Collections.shuffle(goList);
}
