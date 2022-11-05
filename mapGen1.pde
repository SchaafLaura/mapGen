void mapGen1() {
  resetTiles();
  randomWalk(100000);
  floof();
  floof();
  reverseFloof();
  placeRandomLakes(10);
  reverseFloof();
  reverseFloof();
  floof();
  floof();
  randomWalk(200);
  tiles = floodFilled(tiles);
}
