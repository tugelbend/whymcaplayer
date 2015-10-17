/**
 *  Plays tracks according to a playlist
 *  
 *  The Playlist has been tailored specificly for the performance
 *  this player has been used for:
 *  1) First Part: It starts with the first track, if the play button 
 *  is pressed again within 10 seconds, it will again play the first track.
 *  
 *  2) Middle Part: If the play button is pressed after ten seconds but 
 *  within 180 seconds, the second, third fourth and the first track 
 *  are played one time. Still within 180 seconds tracks are played 
 *  in random order afterwards.
 *  
 *  3) Final Part: The fith track is played.
 *
 *
 **/
class PlayList {
  PlayTimer pt;
  AudioPlayer[] players;
  AudioMetaData currentTrackInfo;
  int[] middlePartPlaytimes = new int[4];
  
  void init(AudioPlayer[] players){
    this.players = players;
    this.pt = new PlayTimer(); 
    middlePartPlaytimes[0] = 0;
    middlePartPlaytimes[1] = 0;
    middlePartPlaytimes[2] = 0;
    middlePartPlaytimes[3] = 0;
  }
 
 /**
  * Start playback
  */ 
 void startPlayback() {
    println("Timer: " + str(this.pt.getSeconds()));
    this.stopPlayback();
    if(!this.pt.hasStarted()){
      this.pt.start();
    }
    this.players[this.getCurrentTrack()].play();
 }
 
 void stop() {
    this.players[0].close();
    minim.stop();
 }
 
 /**
  * Stop playback 
  */
 void stopPlayback(){
   for(int i=0; i < this.players.length; i++){
      if(this.players[i].isPlaying()){
        this.players[i].pause();
      }
      this.players[i].rewind();
    } 
 }
 
 /**
  * Reset timer and playlist
  */
 void reset(){
   this.pt.reset();
   for(int i=0; i < this.middlePartPlaytimes.length; i++){
     middlePartPlaytimes[i] = 0;
   }
 }
 
 /**
  * Return timer for output
  */
 String getTimerOutput(){
   return str(pt.getSeconds()) + " Seconds";
 }

 /**
  * Return the player status for output
  */
 String getPlayerStatus(){
  for(int i=0; i < this.players.length; i++){
    if(this.players[i].isPlaying()){
        currentTrackInfo = players[i].getMetaData();
        return "Playing " + currentTrackInfo.fileName();
      }
    } 
    return "Not playing";  
 }
 
 /**
  * Returns the id of the track that should be played
  */
 int getCurrentTrack(){
   //First part
   if(this.pt.getSeconds() < 10){
     return 0;
   }
   //Middle part
   if(this.pt.getSeconds() >=10 && this.pt.getSeconds() < 180){
     int currentTrack = -1;
     for(int i=0; i < this.middlePartPlaytimes.length; i++) {
       currentTrack = this.getMiddlePart(i);
       if(currentTrack != -1) {
         return currentTrack;
       }
     }
     return floor(random(0,4));
   }
   //Final part
   if(this.pt.getSeconds() >= 180) {
     return 4;
   }
   //Should never be reached
   return -1;
 }
 
 /**
  * Returns the track id of the track that should be played 
  * once in the middle part.
  *
  * Note: When a psmove button is pressed more then one press
  * event is registered. To avoid that the tracks are skipped 
  * in that case, I made sure that a song is played no matter 
  * how many button press events within a second are registered. 
  */
 int getMiddlePart(int middlePart) {
   if(this.middlePartPlaytimes[middlePart] == 0 || ((this.middlePartPlaytimes[middlePart] + 1000) > millis())){
     if(this.middlePartPlaytimes[middlePart] == 0){
       this.middlePartPlaytimes[middlePart] = millis();
     }
     if(middlePart == this.middlePartPlaytimes.length -1) {
       return 0;
     }
     return middlePart+1;
   }
   return -1;
 }
};
