/**
 *  Simple timer
 */
class PlayTimer {

  int millis;
  /**
   * Start timer
   */
  void start(){
    this.millis = millis();
  }
  
  /**
   * Returns true if timer has been 
   * started, false otherwise
   */
  boolean hasStarted(){
    if(this.millis == 0){
      return false;
    }
    return true;
  }
  
  /**
   * Get the seconds that have past 
   * since timer start
   */
  int getSeconds(){
    if(!this.hasStarted()){
      return 0;
    }
    int millisPassed = millis() - this.millis;
    return millisPassed / 1000;
  }
  
  /**
   * Get the minutes that have past 
   * since timer start
   */
  int getMinutes(){
    return this.getSeconds() / 60;
  }
  
  /**
   * Reset the timer
   */
  void reset(){
    println("Timer reset.");
    this.millis = 0;
  }
};
