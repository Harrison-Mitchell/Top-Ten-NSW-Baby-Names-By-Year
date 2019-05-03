String[] lines;
int lineNo = 0;
int[] starts;
int[] startWidths;
int[] ends;
int[] endWidths;

void setup () {
  size(500,1000);
  lines = reverse(loadStrings("namesG.csv")); // Goes from new to old, so flip
  textAlign(LEFT,CENTER);
  strokeWeight(1);
  stroke(0);
}

void draw () {
  if (frameCount > 59 && frameCount % 60 == 0) { // After the first second to avoid / 0
    ends = new int[0]; // Flush arrays
    starts = new int[0];
    startWidths = new int[0];
    endWidths = new int[0];
    
    for (int x=1; x<21; x+=2) { // For each name in the next year
      boolean found = false;
      String[] next = split(lines[lineNo+1],","); // Get next year data
      String[] search = split(lines[lineNo],","); // Get cur year data
      for (int k=1; k<21; k+=2) { // For each cur name
        if (next[x].equals(search[k])) { // If name is common between this and next year
          found = true;
          starts = append(starts, ((k-1)/2)*100+10); // Save current y
          startWidths = append(startWidths, int(float(search[k+1])/int(search[2])*500));
          // Save current width, future y and future width
          ends = append(ends, ((x-1)/2)*100+10);
          endWidths = append(endWidths, int(float(next[x+1])/int(next[2])*500));
        }
      }
      
      if (!found) { // Name isn't common between years
        starts = append(starts, 1000); // Transision it in from the bottom
        startWidths = append(startWidths, int(float(next[x+1])/int(next[2])*500));
        ends = append(ends, ((x-1)/2)*100+10);
        endWidths = append(endWidths, int(float(next[x+1])/int(next[2])*500));
      }
    }
    lineNo++;
  }
  
  if (frameCount > 59 && frameCount % 60 <= 20) { // Use the first 1/3 of the second for transition
    background(0);
    float prog = frameCount % 60 / 2.0 / 10; // Get 20 points between 0 and 1.
    for (int i=0; i < 10; i++) { // For our 10 names
      fill(255);
      // BG rect
      rect(0, starts[i]+(ends[i]-starts[i])*prog, startWidths[i]+(endWidths[i]-startWidths[i])*prog, 80);
      fill(252,45,238);
      textSize(40);
      // Name
      text(split(lines[lineNo],",")[1+i*2], 10, starts[i]+(ends[i]-starts[i])*prog+30);
      textSize(14);
      // Number
      text(split(lines[lineNo],",")[2+i*2], 10, starts[i]+(ends[i]-starts[i])*prog+60);
    }
  }
}
