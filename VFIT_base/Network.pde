int port = 5931;
OscP5 server;

void createServer(){
  if(server == null){
    server = new OscP5(this, port, OscP5.TCP);
    println("Server running at: " + server.ip() + ":" + port);
  }
}

void sendDirection(int direction, boolean animate){
  if(server != null){
    server.send("/direction", new Object[]{ new Integer(direction), new Integer(animate ? 1 : -1) });
  }
}

void sendStop(){
  if(server != null){
    server.send("/stop", new Object[0]);
  }
}

String status(){
  return server != null && server.tcpServer().size() > 0 ? "OK" : "NA";
}
