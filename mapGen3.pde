void mapGen3() {
  resetTiles();
  Boolean[][] initialWalk = floatWalk(new PVector(size/2, size/2), 100000);
  addToTiles(initialWalk);
  additiveFloatWalks(30, 10000);
  placeRandomReverseLakes(100);
  floof();
  reverseFloof();
  tiles = floodFilled(tiles);
  placeRandomLakes(1000);
}

void additiveFloatWalks(int iters, int walksteps) {
  for (int i = 0; i < iters; i++) {
    Boolean[][] walk = floatWalk(new PVector(random(2, size - 2), random(2, size - 2)), walksteps);
    addToTiles(walk);
  }
}

void addToTiles(Boolean[][] toAdd) {
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      if (tiles[i][j] || toAdd[i][j]) {
        tiles[i][j] = true;
      }
    }
  }
}

Boolean[][] floatWalk(PVector start, int steps) {
  float[][] floatGrid = new float[size][size];
  Boolean[][] visited = new Boolean[size][size];
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      floatGrid[i][j] = random(0, 1);
      visited[i][j] = false;
    }
  }
  pos = start;
  for (int k = 0; k < steps; k++) {
    if (pos.x > size - 2 || pos.x < 2 || pos.y > size - 2 || pos.y < 2) {
      break;
    }
    visited[(int) pos.x][(int) pos.y] = true;
    float record = 2;
    Boolean t = false;
    Boolean b = false;
    Boolean l = false;
    Boolean r = false;
    if (!visited[(int)pos.x - 1][(int)pos.y] && floatGrid[(int)pos.x - 1][(int)pos.y] < record) {
      record = floatGrid[(int)pos.x - 1][(int)pos.y];
      l = true;
    }
    if (!visited[(int)pos.x + 1][(int)pos.y] && floatGrid[(int)pos.x + 1][(int)pos.y] < record) {
      record = floatGrid[(int)pos.x - 1][(int)pos.y];
      l = false;
      r = true;
    }
    if (!visited[(int)pos.x][(int)pos.y - 1] && floatGrid[(int)pos.x][(int)pos.y - 1] < record) {
      record = floatGrid[(int)pos.x][(int)pos.y - 1];
      l = false;
      r = false;
      t = true;
    }
    if (!visited[(int)pos.x][(int)pos.y + 1] && floatGrid[(int)pos.x][(int)pos.y + 1] < record) {
      record = floatGrid[(int)pos.x][(int)pos.y + 1];
      l = false;
      r = false;
      t = false;
      b = true;
    }
    if (l) {
      pos.x -= 1;
    } else if (r) {
      pos.x += 1;
    } else if (t) {
      pos.y -= 1;
    } else if (b) {
      pos.y += 1;
    } else if (!l && !r && !t && !b) {
      record = 0;
      if (visited[(int)pos.x - 1][(int)pos.y] && floatGrid[(int)pos.x - 1][(int)pos.y] > record) {
        record = floatGrid[(int)pos.x - 1][(int)pos.y];
        l = true;
      }
      if (visited[(int)pos.x + 1][(int)pos.y] && floatGrid[(int)pos.x + 1][(int)pos.y] > record) {
        record = floatGrid[(int)pos.x - 1][(int)pos.y];
        l = false;
        r = true;
      }
      if (visited[(int)pos.x][(int)pos.y - 1] && floatGrid[(int)pos.x][(int)pos.y - 1] > record) {
        record = floatGrid[(int)pos.x][(int)pos.y - 1];
        l = false;
        r = false;
        t = true;
      }
      if (visited[(int)pos.x][(int)pos.y + 1] && floatGrid[(int)pos.x][(int)pos.y + 1] > record) {
        record = floatGrid[(int)pos.x][(int)pos.y + 1];
        l = false;
        r = false;
        t = false;
        b = true;
      }

      if (l) {
        pos.x -= 1;
      } else if (r) {
        pos.x += 1;
      } else if (t) {
        pos.y -= 1;
      } else if (b) {
        pos.y += 1;
      }
    }
  }
  return visited;
}
