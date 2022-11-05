void mapGen2() {
  resetTiles();
  randomFloatNoiseGrid();
  reverseFloof();
  floof();
  floof();
  floof();
  reverseFloof();
  tiles = floodFilled(tiles);
}

void randomFloatNoiseGrid() {
  float[][] floats = new float[size][size];
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      floats[i][j] = random(0, 1);
    }
  }
  PVector center = new PVector(size/2, size/2);
  float centerP = 0.65;
  for (int r = 2; r < size/2 - 2; r++) {
    for (int i = -r; i < r; i++) {
      for (int j = -r; j < r; j++) {
        int x = (int)center.x + i;
        int y = (int)center.y + j;

        Boolean hasConnectedNeighbor = false;
        for (int k = -1; k <= 1; k++) {
          for (int m = -1; m <= 1; m++) {
            if (tiles[x+k][y+m] && abs(k) + abs(m) != 2) {
              hasConnectedNeighbor = true;
              break;
            }
          }
        }

        if (floats[x][y] <= centerP && hasConnectedNeighbor) {
          tiles[x][y] = true;
        }
      }
    }
  }
}
