import io.thp.psmove.*;
import ddf.minim.*;

//Move controller
PSMove move;
int triggerValue;
boolean isSquarePressed;
moveButton[] moveButtons = new moveButton[9];  // The move controller has 9 buttons

//Audioplayer
Minim minim;
PlayList pl;
AudioPlayer[] players = new AudioPlayer[5];

//Screen
PFont f;
String sOutput = "Why MCA?";
String sTimer = "0";       

void setup() {
  //init info screen
  size(1000,800);
  background(0);
  f = createFont("Arial",16,true);
  fill(255);
  
  //init move controller
  move = new PSMove();    // We need one controller
  moveInit();             // Create the buttons
  
  //init audioplayer  
  minim = new Minim(this);
  players[0] = minim.loadFile("YMCA.mp3", 1024);
  players[1] = minim.loadFile("ymca_disco.mp3", 1024);
  players[2] = minim.loadFile("ymca_lederhose.mp3", 1024);
  players[3] = minim.loadFile("ymca_ost.mp3", 1024);
  players[4] = minim.loadFile("ymca_metal.mp3", 1024);
  pl = new PlayList(); 
  pl.init(players);
}

void draw() {
  //draw infor screen
  background(0);
  textFont(f,64);
  fill(255,0,0); 
  textAlign(CENTER);
  text("Why MCA?!",width/2,height/2-70);
  fill(255);
  text(pl.getPlayerStatus(),width/2,height/2);
  text(pl.getTimerOutput(),width/2,height/2+70);
 
  //read psmove buttons
  moveUpdate();
}

void moveInit() {
   for (int i=0; i<moveButtons.length; i++) {
    moveButtons[i] = new moveButton();
  } 
}

/**
 * Read psmove buttons 
 */
void moveUpdate() {
   // Read buttons  
  while (move.poll () != 0) {
    int trigger = move.get_trigger();
    moveButtons[0].setValue(trigger);

    int buttons = move.get_buttons();

    if ((buttons & Button.Btn_SQUARE.swigValue()) != 0) {
      moveButtons[2].press();
      pl.startPlayback();
    } else {
      moveButtons[2].release();
    }
  }
  
  // Store the values in conveniently named variables
  triggerValue = moveButtons[0].value;
  isSquarePressed = moveButtons[2].getPressed();
}

/**
 *  Keyboard controls for testing or if no psmove 
 *  available
 */
void keyPressed() {
  //start playback  
  if (key == 'p') {
      pl.startPlayback();
    }
    //reset timer
    if (key == 'r') {
      pl.reset();
    }
    //stop playback
    if (key == 's') {
      pl.stopPlayback();
    }
}
 
void stop(){
  pl.stop();
  super.stop();
}

