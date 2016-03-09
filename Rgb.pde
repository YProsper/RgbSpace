

private RgbSpace space;
private boolean[] colored;
private boolean[] enqueued;
private ArrayList<PVector> toColor;

private PImage image;

public void setup(){
  size(1024, 1024);
  smooth();
  noLoop();
  
  this.space = new RgbSpace();
  this.toColor = new ArrayList<PVector>();
  this.colored = new boolean[width*height];
  this.enqueued = new boolean[width*height];
  
  image = createImage(width, height, RGB);
  image.loadPixels();

  PVector origin = new PVector(width / 3, height / 2);
  int pos = (int) (origin.x + origin.y * width);
  image.pixels[pos] = color(random(0, 255), random(0, 255), random(0, 255));
  this.colored[pos] = true;
  this.enqueueNotColored(origin);
    
  while(toColor.size() > 0){
    PVector next = this.chooseNextPoint();
    int[] target = this.computeAverage(image, next);
    if(target != null){
      int p = (int) (next.x + next.y * width);
      if(this.space.isFree(target[0], target[1], target[2])){
        image.pixels[p] = color(target[0], target[1], target[2]);
        this.space.book(target[0], target[1], target[2]);
      } else {
        int[] newColor = chooseColor(target[0], target[1], target[2]);
        image.pixels[p] = color(newColor[0], newColor[1], newColor[2]);
        this.space.book(newColor[0], newColor[1], newColor[2]);
      }
      
      this.colored[p] = true;
      this.toColor.remove(next);
    }
    
    this.enqueueNotColored(next);
  }
  image.updatePixels();
}

public void draw(){
  
  image(image, 0, 0);
  //save("colors.png");
  println("image done");
  println("nb colors used :" + this.space.getNbBooked());
}

private PVector chooseNextPoint(){
  return this.toColor.get((int)random(this.toColor.size()));
}

private int[] computeAverage(PImage image, PVector center){
  int startX = Math.max((int)center.x-1, 0);
  int stopX = Math.min((int)center.x+1, width-1);
  int startY = Math.max((int)center.y-1, 0);
  int stopY= Math.min((int)center.y+1, height-1);
  
  int nb = 0;
  int r = 0;
  int g = 0;
  int b = 0;
  
  for(int x=startX; x<= stopX; x++){
    for(int y=startY; y<=stopY; y++){
      if(this.colored[x+y*width]){
        int pos = image.pixels[x+y*width];
        r += red(pos);
        g += green(pos);
        b += blue(pos);
        nb++;
      }
    }
  }
  
  return (nb == 0) ? null : new int[] { r/nb, g/nb, b/nb };
}

private void enqueueNotColored(PVector center){
  int startX = Math.max((int)center.x-1, 0);
  int stopX = Math.min((int)center.x+1, width-1);
  int startY = Math.max((int)center.y-1, 0);
  int stopY= Math.min((int)center.y+1, height-1);

  for(int x=startX; x<= stopX; x++){
    for(int y=startY; y<=stopY; y++){
      if(!this.colored[x+y*width] && !this.enqueued[x+y*width]){
        this.toColor.add(new PVector(x, y));
        this.enqueued[x+y*width] = true;
      }
    }
  }
}

private int[] chooseColor(int r, int g, int b){
  int rayon = 1;
  boolean ok = false;
  ArrayList<int[]> colorse = null;
  
  while(!ok){
    colorse = this.space.getColors(r, g, b, rayon);
    if(colorse.size() > 0){
      ok = true;
    } else {
      rayon++;
    }
  }
  
  return colorse.get((int)random(colorse.size())/2);
}