class Progress {
  int maxLevel = 0;
  int healthyLevels = 0;
  DateTime lastLogin = DateTime.now();

  Progress();

  Progress.constructor(int max, int healthy, DateTime date){
    maxLevel = max;
    healthyLevels = healthy;
    lastLogin = date;
  }

  int getMaxLevel(){
    return maxLevel;
  }

  int getHealthyLevels() {
    return healthyLevels;
  }

  DateTime getLastLogin() {
    return lastLogin;
  }

  void increaseMaxLevel(){
    if(maxLevel < 3){
      maxLevel = maxLevel +1 ;
    }
  }

  void increaseHealthyLevels() {
    if(healthyLevels < 3){
      healthyLevels = healthyLevels + 1;
    }
  }

  void decreaseHealthyLevels(){
    if(healthyLevels > 0){
      healthyLevels = healthyLevels - 1;
    }
  }

  void updateLastLogin(){
    lastLogin = DateTime.now();
  }


}