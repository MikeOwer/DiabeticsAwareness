class Progress {
  int maxLevel = 0;
  int healthyLevels = 0;
  DateTime lastLogin = DateTime.now();

  Progress();

  Progress.constructor(int max, int healthy, DateTime date){
    this.maxLevel = max;
    this.healthyLevels = healthy;
    this.lastLogin = date;
  }

  int getMaxLevel(){
    return this.maxLevel!;
  }

  int getHealthyLevels() {
    return this.healthyLevels!;
  }

  DateTime getLastLogin() {
    return this.lastLogin!;
  }

  void increaseMaxLevel(){
    if(this.maxLevel < 3){
      this.maxLevel = this.maxLevel! +1 ;
    }
  }

  void increaseHealthyLevels() {
    if(this.healthyLevels < 3){
      this.healthyLevels = this.healthyLevels! + 1;
    }
  }

  void decreaseHealthyLevels(){
    if(this.healthyLevels > 0){
      this.healthyLevels = this.healthyLevels! - 1;
    }
  }

  void updateLastLogin(){
    this.lastLogin = DateTime.now();
  }


}