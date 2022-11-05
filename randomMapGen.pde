import java.util.ArrayDeque;
Boolean[][] tiles;
int size = 200;
int numberOfRectangles = 20;
float scale;
void setup() {
  size(1000, 1000);
  scale = width / size;
  background(0);
  tiles = new Boolean[size][size];
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      tiles[i][j] = false;
    }
  }
  tiles[size/2][size/2] = true;
}
Boolean doStuff = false;
void draw() {
  frameRate(0.5);
  gen();
  showTiles();
  //
}


void randomWalk(int iters) {
  pos = new PVector(size/2, size/2);
  for (int i = 0; i < iters; i++) {
    int x = random(0, 1) > 0.5 ? (random(0, 1) > 0.5 ? -1 : 1) : 0;
    int y = random(0, 1) > 0.5 ? (random(0, 1) > 0.5 ? -1 : 1) : 0;
    if (abs(x) + abs(y) != 2 && pos.x + x > 0 && pos.x + x < size - 1 && pos.y + y > 0 && pos.y + y < size - 1) {
      pos.x += x;
      pos.y += y;
      tiles[(int)pos.x][(int)pos.y] = true;
    }
  }
}


PVector pos = new PVector(size/2, size/2);
void mousePressed() {
  doStuff = !doStuff;
}
void keyPressed() {
  if (key == 'f') {
    floof();
  }
  if (key == 'l') {
    placeRandomLakes(1);
  }
  if (key == 'r') {
    reverseFloof();
  }
  if (key == 'z') {
    tiles = floodFilled(tiles);
  }
  if (keyCode == ENTER) {
    gen();
  }
}

void gen() {
  int r = (int) random(0, 3);
  switch(r) {
  case 0:
    mapGen1();
    break;
  case 1:
    mapGen2();
    break;
  case 2:
    mapGen3();
    break;
  }


  if (countPassable() < (size/3) * (size/3)) {
    gen();
  }
}


int countPassable() {
  int n = 0;
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      n += tiles[i][j] ? 1 : 0;
    }
  }
  return n;
}





void resetTiles() {
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      tiles[i][j] = false;
    }
  }
  tiles[size/2][size/2] = true;
}

void placeRandomReverseLakes(int num) {
  for (int i = 0; i < num; i++) {
    PVector p = randomWallPoint();
    int r = 0;
    while (circleIsEmpty(p, r)) {
      r = r + 1;
    }
    if (r > 6)
      carveReverseCircle(p, r);
  }
}


void placeRandomLakes(int num) {
  for (int i = 0; i < num; i++) {
    PVector p = randomPassablePoint();
    int r = 0;
    while (circleIsFilled(p, r)) {
      r = r + 1;
    }
    if (r > 6)
      carveCircle(p, r - 3);
  }
}

void carveCircle(PVector pos, int r) {
  for (int i = (int)pos.x - r; i < pos.x + r; i++) {
    for (int j = (int) pos.y - r; j < pos.y + r; j++) {
      if ( (i-pos.x) * (i-pos.x) + (j-pos.y) * (j-pos.y) < r * r) {
        tiles[i][j] = false;
      }
    }
  }
}

void carveReverseCircle(PVector pos, int r) {
  for (int i = (int)pos.x - r; i < pos.x + r; i++) {
    for (int j = (int) pos.y - r; j < pos.y + r; j++) {
      if ( (i-pos.x) * (i-pos.x) + (j-pos.y) * (j-pos.y) < r * r) {
        tiles[i][j] = true;
      }
    }
  }
}


boolean circleIsEmpty(PVector pos, int r) {
  if (pos.x + r > size - 1 || pos.x - r <= 0 || pos.y + r > size - 1 || pos.y - r <= 0)
    return false;

  for (int i = (int)pos.x - r; i < pos.x + r; i++) {
    for (int j = (int) pos.y - r; j < pos.y + r; j++) {
      if ( (i-pos.x) * (i-pos.x) + (j-pos.y) * (j-pos.y) < r * r) {
        if (tiles[i][j])
          return false;
      }
    }
  }
  return true;
}

boolean circleIsFilled(PVector pos, int r) {
  if (pos.x + r > size - 1 || pos.x - r <= 0 || pos.y + r > size - 1 || pos.y - r <= 0)
    return false;

  for (int i = (int)pos.x - r; i < pos.x + r; i++) {
    for (int j = (int) pos.y - r; j < pos.y + r; j++) {
      if ( (i-pos.x) * (i-pos.x) + (j-pos.y) * (j-pos.y) < r * r) {
        if (!tiles[i][j])
          return false;
      }
    }
  }
  return true;
}

void floof() {
  Boolean[][] buffer = new Boolean[size][size];

  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      buffer[i][j] = false;
    }
  }
  for (int i = 1; i < size - 1; i++) {
    for (int j = 1; j < size - 1; j++) {
      buffer[i][j] = false;
      int n = 0;
      n += tiles[i + 1][j + 0] ? 1 : 0;
      n += tiles[i - 1][j + 0] ? 1 : 0;
      n += tiles[i + 0][j + 1] ? 1 : 0;
      n += tiles[i + 0][j - 1] ? 1 : 0;
      if (tiles[i][j]) {
        buffer[i][j] = n >= 1;
      } else {
        buffer[i][j] = n != 0;
      }
    }
  }
  tiles = buffer;
}

void reverseFloof() {
  Boolean[][] buffer = new Boolean[size][size];

  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      buffer[i][j] = false;
    }
  }
  for (int i = 1; i < size - 1; i++) {
    for (int j = 1; j < size - 1; j++) {
      int n = 0;
      n += !tiles[i + 1][j + 0] ? 1 : 0;
      n += !tiles[i - 1][j + 0] ? 1 : 0;
      n += !tiles[i + 0][j + 1] ? 1 : 0;
      n += !tiles[i + 0][j - 1] ? 1 : 0;
      if (!tiles[i][j]) {
        buffer[i][j] = tiles[i][j];
      } else {
        buffer[i][j] = n > 0 ? false : true;
      }
    }
  }
  tiles = buffer;
}

PVector randomPassablePoint() {
  int x = (int)random (2, size - 2);
  int y = (int) random(2, size - 2);
  while (!tiles[x][y]) {
    x = (int)random (2, size - 2);
    y = (int) random(2, size - 2);
  }
  return new PVector(x, y);
}

PVector randomWallPoint() {
  int x = (int)random (2, size - 2);
  int y = (int) random(2, size - 2);
  while (tiles[x][y]) {
    x = (int)random (2, size - 2);
    y = (int) random(2, size - 2);
  }
  return new PVector(x, y);
}


void showTiles() {
  noStroke();
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      fill(tiles[i][j] ? 255 : 0);
      square(i * scale, j * scale, scale);
    }
  }
}

Boolean[][] floodFilled(Boolean[][] input) {
  ArrayDeque<PVector> q = new ArrayDeque<PVector>();
  ArrayList<PVector> list = new ArrayList<PVector>();

  PVector start = new PVector(size/2, size/2);
  q.add(start);
  list.add(start);
  while (!q.isEmpty()) {
    PVector curr = q.removeFirst();
    for (int x = -1; x <= 1; x++) {
      for (int y = -1; y <= 1; y++) {
        if (
          abs(x) + abs(y) != 2 &&
          !(x == 0 && y == 0)
          && input[(int)curr.x + x][(int)curr.y + y]) {

          q.add(new PVector((int)curr.x + x, (int)curr.y + y));
          list.add(new PVector((int)curr.x + x, (int)curr.y + y));
          tiles[(int)curr.x + x][(int)curr.y + y] = false;
        }
      }
    }
  }

  Boolean[][] ret = new Boolean[size][size];
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      ret[i][j] = false;
    }
  }

  for (int i = 0; i < list.size(); i++) {
    PVector p = list.get(i);
    ret[(int)p.x][(int)p.y] = true;
  }
  return ret;
}
