import java.util.ArrayList;

public class RgbSpace {
  private int nbBooked = 0;
  private boolean[][][] space;
  
  public RgbSpace(){
    this.initSpace();
  }
  
  public void book(int r, int g, int b) {
    /* TODO remove commentary 
      if(r < 0 || r > 255) throw new IllegalArgumentException("r not in [0-255]");
      if(g < 0 || g > 255) throw new IllegalArgumentException("g not in [0-255]");
      if(b < 0 || b > 255) throw new IllegalArgumentException("b not in [0-255]");
     */
    
    this.space[r][g][b] = true;
    this.nbBooked++;
  }
  
  public void free(int r, int g, int b){
    /* TODO remove commentary
      if(r < 0 || r > 255) throw new IllegalArgumentException("r not in [0-255]");
      if(g < 0 || g > 255) throw new IllegalArgumentException("g not in [0-255]");
      if(b < 0 || b > 255) throw new IllegalArgumentException("b not in [0-255]");
     */
    
    this.space[r][g][b] = false;
  }
  
  public boolean isFree(int r, int g, int b){
    return !this.space[r][g][b];
  }
  
  public int getNbBooked(){
    return this.nbBooked;
  }
  
  public ArrayList<int[]> getColors(int r, int g, int b, int rayon){
    ArrayList<int[]> result = new ArrayList<int[]>();
    
    int rLowLimit = Math.max(0, r-rayon);
    int gLowLimit = Math.max(0, g-rayon);
    int bLowLimit = Math.max(0, b-rayon);
    int rHighLimit = Math.min(255, r+rayon);
    int gHighLimit = Math.min(255, g+rayon);
    int bHighLimit = Math.min(255, b+rayon);
    
    for(int r2 = rLowLimit; r2<= rHighLimit; r2++){
      for(int g2 = gLowLimit; g2<= gHighLimit; g2++){
        for(int b2 = bLowLimit; b2<= bHighLimit; b2++){
          if(!this.space[r2][g2][b2]){
            result.add(new int[] { r2, g2, b2 });
          }
        }
      }
    }
    
    return result;
  }
  
  private void initSpace(){
    this.space = new boolean[256][256][256];
    for(int r=0; r<256; r++){
      for(int g=0; g<256; g++){
        for(int b=0; b<256; b++){
          this.space[r][g][b] = false;
        }
      }
    }
  }
}