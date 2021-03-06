class yarnRenderFBO {

  yarnStitchFBO[] myYarn;
  int stitchSize;
  int widthYarn;
  int yarnthickness;
  PImage img;

  yarnRenderFBO() {
    stitchSize = 7;
    yarnthickness = 2;
  }

  void setStitchSize(int _stitchSize) {
    stitchSize = _stitchSize;
    render();
  }
  
  void render(){
    loadPattern(img);
  }

  void loadPattern(PImage _img) {
    noLoop(); 
    img = _img;
    img.loadPixels();
    int totalStitch = img.height*img.width;
    
    widthYarn = img.width;
    myYarn = new yarnStitchFBO[totalStitch];
    for (int i=0; i<myYarn.length;i++) {
      myYarn[i] = new yarnStitchFBO(stitchSize, yarnthickness);
    }

    fbo = createGraphics(img.width*stitchSize*2, (img.height+1)*stitchSize*2);
    //pdf = (PGraphicsPDF) createGraphics(width, height, PDF, "pause-resume.pdf");
    draw();
    loop(); 
  }

  void exportImage(String fileName) {
    if(!exportTransparentPattern){
      PGraphics fbo2 = createGraphics(fbo.width, fbo.height);
      fbo2.beginDraw();
      fbo2.background(cp.getColorValue());
      fbo2.image(fbo,0,0);
      fbo2.save( fileName);
    }else{
      fbo.save( fileName);
    }
  }

  void draw() {
    fbo.beginDraw();
    img.loadPixels();
    for (int y = 0; y < img.height; y++) {
      for (int x = 0; x < img.width; x++) {
        int loc = x + y*img.width;

        // posicion in garment
        Boolean lastRow = false;
        Boolean firstRow = false;
        if ((loc/widthYarn)==0) firstRow = true;
        if (ceil(loc/widthYarn)==ceil((myYarn.length-1)/widthYarn)) lastRow = true;

        // The functions red(), green(), and blue() pull out the 3 color components from a pixel.
        color c1 = img.pixels[loc];
        
        color c2 = color(0,0,0);
        
        if (!lastRow) {
          c2 = img.pixels[loc+widthYarn];
        }
        if (firstRow) {
          myYarn[loc].drawPieceModelUnit(loc%widthYarn, loc/widthYarn, c1, c1, true, lastRow);
          myYarn[loc].drawPieceModelUnit((loc%widthYarn), (loc/widthYarn)+1, c1, c2, false, lastRow);
        }
        else {
          myYarn[loc].drawPieceModelUnit((loc%widthYarn), (loc/widthYarn)+1, c1, c2, firstRow, lastRow);
        }
      }
    }
    fbo.endDraw();
  }
}

class yarnRenderPDF {

  yarnStitchPDF[] myYarn;
  int stitchSize;
  int widthYarn;
  int yarnthickness;
  PImage img;

  yarnRenderPDF() {
    stitchSize = 7;
    yarnthickness = 2;
  }

  void loadPatternAndExport(PImage _img, String exportFileName) {
    noLoop(); 
    img = _img;
    img.loadPixels();
    int totalStitch = img.height*img.width;
    
    widthYarn = img.width;
    myYarn = new yarnStitchPDF[totalStitch];
    for (int i=0; i<myYarn.length;i++) {
      myYarn[i] = new yarnStitchPDF(stitchSize, yarnthickness);
    }

    pdf = (PGraphicsPDF) createGraphics(img.width*stitchSize*2, (img.height+1)*stitchSize*2, PDF, exportFileName);
    draw();
    loop(); 
  }

  void draw() {
    pdf.beginDraw();
    if(!exportTransparentPattern){
      pdf.fill(cp.getColorValue());
      pdf.rect(0,0,img.width*stitchSize*2, (img.height+1)*stitchSize*2);
    }
    img.loadPixels();
    for (int y = 0; y < img.height; y++) {
      for (int x = 0; x < img.width; x++) {
        int loc = x + y*img.width;

        // posicion in garment
        Boolean lastRow = false;
        Boolean firstRow = false;
        if ((loc/widthYarn)==0) firstRow = true;
        if (ceil(loc/widthYarn)==ceil((myYarn.length-1)/widthYarn)) lastRow = true;

        // The functions red(), green(), and blue() pull out the 3 color components from a pixel.
        color c1 = img.pixels[loc];
        
        color c2 = color(0,0,0);
        
        if (!lastRow) {
          c2 = img.pixels[loc+widthYarn];
        }
        if (firstRow) {
          myYarn[loc].drawPieceModelUnit(loc%widthYarn, loc/widthYarn, c1, c1, true, lastRow);
          myYarn[loc].drawPieceModelUnit((loc%widthYarn), (loc/widthYarn)+1, c1, c2, false, lastRow);
        }
        else {
          myYarn[loc].drawPieceModelUnit((loc%widthYarn), (loc/widthYarn)+1, c1, c2, firstRow, lastRow);
        }
      }
    }
    pdf.dispose();
    pdf.endDraw();
  }
}
