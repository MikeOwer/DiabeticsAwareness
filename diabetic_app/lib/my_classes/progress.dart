class Progress {
  int maxLevel = 0;
  int healthyLevels = 0;
  int currentQuestion = 0;
  DateTime lastLogin = DateTime.now();

  Progress();

  Progress.constructor(int max, int healthy, int currentQ, DateTime date) {
    this.maxLevel = max;
    this.healthyLevels = healthy;
    this.currentQuestion = currentQ;
    this.lastLogin = date;
  }

  int getMaxLevel() {
    return this.maxLevel!;
  }

  int getHealthyLevels() {
    return healthyLevels;
  }

  int getCurrentQuestion() {
    return this.currentQuestion;
  }

  DateTime getLastLogin() {
    return lastLogin;
  }

  void increaseMaxLevel() {
    if (this.maxLevel < 3) {
      this.maxLevel = this.maxLevel! + 1;
    }
  }

  //Los iba a tomar como contadores para el reseteo de los niveles
  //en caso de que no entre el usuario
  void increaseHealthyLevels() {
    if (this.healthyLevels < 3) {
      this.healthyLevels = this.healthyLevels! + 1;
    }
  }

  void increaseCurrentQuestion() {
    //Se aumenta el número de pregunta actual
    if (this.maxLevel < 3) {
      if (this.currentQuestion < 5) {
        this.currentQuestion += 1;
      }
    } else {
      this.currentQuestion += 1;
    }
  }

  void decreaseLevels() {
    if (this.maxLevel > 0) {
      this.maxLevel = this.maxLevel - 1;
    }
  }

  void decreaseHealthyLevels() {
    if (this.healthyLevels > 0) {
      this.healthyLevels = this.healthyLevels! - 1;
    }
  }

  void updateLastLogin() {
    this.lastLogin = DateTime.now();
  }
}
