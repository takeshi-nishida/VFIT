State state;

abstract class State {
  long timestamp;
  public State() { timestamp = System.currentTimeMillis(); }
  public long ellapsedTime() { return System.currentTimeMillis() - timestamp; }
  public abstract State processState();
  public State keyPressed() { return this; }
}

class InitialState extends State{
  public State processState(){
    pushStyle();
    textAlign(CENTER, CENTER);
    textSize(48);
    String s = "Press [SPACE] to start the experiment.";
    if(ntrials > 1){
      s += "\nCorrect-go:" + cgo_count;
      s += "\nFalse-go:" + fgo_count;
      s += "\nCorrect answer: " + ca_count + " / " + ntrials;
    }
    text(s, width * 0.5, height * 0.5);
    popStyle();
    return this;
  }
  
  public State keyPressed(){
    if(keyCode == LEFT || keyCode == RIGHT){
      showOnHMD = !showOnHMD;
      if(showOnHMD) createServer();
    }
    if(keyCode == UP || keyCode == DOWN) animate = !animate;
    
    if(key == ' '){
      resetMeasures();
      initLogger();
      return new WaitState();
    }
    
    return this;
  }
}

class WaitState extends State {
  public State processState() {
    float cx = width * 0.5, cy = height * 0.5;
    line(cx - SIZE, cy, cx + SIZE, cy);
    line(cx, cy - SIZE, cx, cy + SIZE);
    return ellapsedTime() > 3000 ? new StimulusState() : this;
  }
}

class StimulusState extends State {
  boolean go;
  int direction; // 0: left, 1: up, 2: right, 3: down
  List<Integer> order;

  public StimulusState() {
    super();
    go = goList.get(ntrials); //random(100) > 50;
    direction = floor(random(4));
    logStimulus(go, direction);
    initOrder();
    if(showOnHMD) sendDirection(direction, animate);
  }

  private void initOrder() {
    List<Integer> l = Arrays.asList(0, 1, 2, 3);
    Collections.shuffle(l);
    if (!go) l.set(0, l.get(1));
    Collections.shuffle(l);
    order = l;
  }

  public State processState() {
    for (int i = 0; i < shapes.length; i++) {
      float theta = TWO_PI * i / shapes.length + QUARTER_PI;
      PShape s = shapes[order.get(i)];
      shape(s, width * 0.5 + cos(theta) * SIZE - SIZE * 0.5, height * 0.5 + sin(theta) * SIZE - SIZE * 0.5);
    }

    if(!showOnHMD){
      float x = width - SIZE, y = SIZE;
      if(animate){
        float d = SIZE * ellapsedTime() / 1000;
        d = direction > 1 ? d : -d;
        x += d * ((direction + 1) % 2);
        y += d * (direction % 2);
      }
      drawArrow(x, y, direction * HALF_PI);
    }
    
    if(ellapsedTime() > STIMULUS_TIME){
      logGo(false);
      return new AnswerState(direction);
    }
    return this;
  }


  public State keyPressed() {
    if(key == GO_KEY){
      if (go) cgo_count++;
      else fgo_count++;
      logGo(true);
      return new AnswerState(direction);
    }
    return this;
  }
}

class AnswerState extends State {
  int direction;

  public AnswerState(int direction){
    super();
    sendStop();
    this.direction = direction;
  }
  
  public State processState() {
    for (int i = 0; i < 4; i++) {
      float theta = TWO_PI * i / 4 + PI;
      drawArrow(width * 0.5 + cos(theta) * SIZE, height * 0.5 + sin(theta) * SIZE, i * HALF_PI);
    }
    
    return this;
  }
  
  public State keyPressed(){
    switch(keyCode){
      case LEFT: return new FeedbackState(direction, 0);
      case UP: return new FeedbackState(direction, 1);
      case RIGHT: return new FeedbackState(direction, 2);
      case DOWN: return new FeedbackState(direction, 3);      
    }
    return this;
  }
}

class FeedbackState extends State {
  int direction, answer;
  
  public FeedbackState(int direction, int answer){
    super();
    this.direction = direction;
    this.answer = answer;
    logAnswer(answer);
    if(direction == answer) ca_count++;
  }
  
  public State processState() {
    float theta = TWO_PI * answer / 4 + PI;
    drawArrow(width * 0.5 + cos(theta) * SIZE, height * 0.5 + sin(theta) * SIZE, answer * HALF_PI);
    
    if(direction != answer && frameCount / 15 % 2 == 0){
      theta = TWO_PI * direction / 4 + PI;
      drawArrow(width * 0.5 + cos(theta) * SIZE, height * 0.5 + sin(theta) * SIZE, direction * HALF_PI);
    }

    if(ellapsedTime() > 2000){
      return ++ntrials >= TOTAL_TRIALS ? new InitialState() : new WaitState();
    }
    return this;
  }
}
