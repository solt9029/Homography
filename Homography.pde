import org.apache.commons.math3.linear.*; // 線形代数ライブラリ

void setup() {
  size(500, 400);

  PImage inputImg = loadImage("test.jpg");

  double [][] inputXY = {
    {141, 109}, 
    {407, 32}, 
    {53, 304}, 
    {452, 352}, 
    {217, 157}
  };

  double[][] outputUV = {
    {0, 0}, 
    {500, 0}, 
    {0, 400}, 
    {500, 400}, 
    {231, 168}
  };

  double[][] AArray = {
    {inputXY[0][0], inputXY[0][1], 1, 0, 0, 0, -inputXY[0][0] * outputUV[0][0], -inputXY[0][1] * outputUV[0][0]}, 
    {0, 0, 0, inputXY[0][0], inputXY[0][1], 1, -inputXY[0][0] * outputUV[0][1], -inputXY[0][1] * outputUV[0][1]}, 

    {inputXY[1][0], inputXY[1][1], 1, 0, 0, 0, -inputXY[1][0] * outputUV[1][0], -inputXY[1][1] * outputUV[1][0]}, 
    {0, 0, 0, inputXY[1][0], inputXY[1][1], 1, -inputXY[1][0] * outputUV[1][1], -inputXY[1][1] * outputUV[1][1]}, 

    {inputXY[2][0], inputXY[2][1], 1, 0, 0, 0, -inputXY[2][0] * outputUV[2][0], -inputXY[2][1] * outputUV[2][0]}, 
    {0, 0, 0, inputXY[2][0], inputXY[2][1], 1, -inputXY[2][0] * outputUV[2][1], -inputXY[2][1] * outputUV[2][1]}, 

    {inputXY[3][0], inputXY[3][1], 1, 0, 0, 0, -inputXY[3][0] * outputUV[3][0], -inputXY[3][1] * outputUV[3][0]}, 
    {0, 0, 0, inputXY[3][0], inputXY[3][1], 1, -inputXY[3][0] * outputUV[3][1], -inputXY[3][1] * outputUV[3][1]}, 

    {inputXY[4][0], inputXY[4][1], 1, 0, 0, 0, -inputXY[4][0] * outputUV[4][0], -inputXY[4][1] * outputUV[4][0]}, 
    {0, 0, 0, inputXY[4][0], inputXY[4][1], 1, -inputXY[4][0] * outputUV[4][1], -inputXY[4][1] * outputUV[4][1]}
  };

  RealMatrix A = MatrixUtils.createRealMatrix(AArray);
  showMatrix(A);

  double[] bArray = {
    outputUV[0][0], 
    outputUV[0][1], 
    outputUV[1][0], 
    outputUV[1][1], 
    outputUV[2][0], 
    outputUV[2][1], 
    outputUV[3][0], 
    outputUV[3][1], 
    outputUV[4][0], 
    outputUV[4][1]
  };

  RealVector b = MatrixUtils.createRealVector(bArray);
  showVector(b);

  RealVector x = MatrixUtils.inverse(A.transpose().multiply(A)).multiply(A.transpose()).operate(b);

  double[][] HomographyArray = {
    {x.getEntry(0), x.getEntry(1), x.getEntry(2)}, 
    {x.getEntry(3), x.getEntry(4), x.getEntry(5)}, 
    {x.getEntry(6), x.getEntry(7), 1}
  };

  RealMatrix Homography = MatrixUtils.createRealMatrix(HomographyArray);
  showMatrix(Homography);

  RealMatrix InverseHomography = MatrixUtils.inverse(Homography);
  showMatrix(InverseHomography);

  inputImg.loadPixels();
  loadPixels();

  for (int vIndex = 0; vIndex < 400; vIndex++) {
    for (int uIndex = 0; uIndex < 500; uIndex++) {
      double[] uvArray = {uIndex, vIndex, 1};
      RealVector uv = MatrixUtils.createRealVector(uvArray);
      RealVector xy = InverseHomography.operate(uv);

      double[][] TmpArray = {
        {1.0 / xy.getEntry(2), 0, 0},
        {0, 1.0 / xy.getEntry(2), 0},
        {0, 0, 1.0 / xy.getEntry(2)}
      };

      RealMatrix Tmp = MatrixUtils.createRealMatrix(TmpArray);
      xy = Tmp.operate(xy);

      int pixelIndex = (int)xy.getEntry(0) + (int)xy.getEntry(1) * 500;
      if (uIndex == 0 && vIndex == 0) {  
        println(pixelIndex);
      }
      pixels[uIndex + vIndex * 500] = inputImg.pixels[pixelIndex];
    }
  }

  updatePixels();
  
  save("output.jpg");
}

void showMatrix(RealMatrix M) {
  println("---");
  for (int i=0; i<M.getRowDimension(); i++) {
    for (int j=0; j<M.getColumnDimension(); j++) {
      print( M.getEntry(i, j) + "  " );
    }
    println();
  }
  println("---");
}

void showVector(RealVector v) {
  println("---");
  for (int i=0; i<v.getDimension(); i++) {
    println( v.getEntry(i) );
  }
  println("---");
}