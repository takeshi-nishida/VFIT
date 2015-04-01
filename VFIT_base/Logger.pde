PrintWriter logger;

void initLogger(){
  if(logger != null){
    logger.close();
  }
  logger = createWriter(nf(month(),2) + "" + nf(day(),2) + "-" + nf(hour(),2) + "" + nf(minute(),2) + ".txt");
}

void logStimulus(boolean go, int direction){
  logger.print(ntrials + "," + go + "," + direction + ",");
}

void logGo(boolean go){
  logger.print(go + ",");
}

void logAnswer(int input){
  logger.println(input);
  logger.flush();
}
