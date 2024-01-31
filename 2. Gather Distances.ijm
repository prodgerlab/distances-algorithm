
directoryTracedCells = getDirectory("Select Traced Cell Images Folder");

// Function set to open the .tif image file first followed by Updated ROIS.zip files in the RoiManager and then performance distance calculations
function OpenRightFiles(DirectorySubSubfolder) {
    listFiles = getFileList(DirectorySubSubfolder);
    roiManager("Reset");
    for (i = 0; i < listFiles.length; i++) {
        filePath = DirectorySubSubfolder + "/" + listFiles[i];
        if (endsWith(filePath, ".tif")) {
            open(filePath);
      	    
        }
        else if (endsWith(listFiles[i], "Updated ROIs.zip")) {
            roiManager("Reset");
            run("Open...", "path=[" + filePath + "]");
        }
    }
/////////////////////////////////////////////////////////////////
// Code to compute the distance of the first roi (surface) to each of the cells
	CurrentImageID = getImageID();
	selectImage(CurrentImageID);
  	run("Remove Overlay"); 
 	getPixelSize(unit, pixelWidth, pixelHeight);
  	run("Set Scale...", "distance=1 known=1 unit=pixel");
  	requires("1.49k"); //Problematic??
 	roiManager("select", 0);
  	run("Interpolate", "interval=2");
  	getSelectionCoordinates(x, y);
  	run("Set Measurements...", "  centroid redirect=None decimal=1");
  	subfolderName = File.getName(DirectorySubSubfolder);
  	output = File.open(DirectorySubSubfolder + "/" + subfolderName + " Distances.txt");
  	print(output, "Selection  \t  Units \t Distance \t Units");
  	for (selection=1;  selection<roiManager("count");  selection++){
      	roiManager("select", selection);
        roiManager("Set Color", "magenta");
        run("Add Selection...");
      	roiManager("select", selection);
      	run("Measure");
      	xc = getResult("X", nResults()-1);         
      	yc = getResult("Y", nResults()-1);
     	pos = 9999999999999;
     	for (line=0; line<x.length; line++) {
        	dx = xc - x[line];
        	dy = yc - y[line];
        	d = sqrt( (dx*dx) + (dy*dy));
        	if (d < pos) { pos = d;  lx = x[line];  ly = y[line]; }
      }  
     
     print(output, (selection+1) + " \t " + pos + " \t pixels\t "+ (pos*pixelWidth) + " \t " + unit);
     makeLine(xc, yc, lx, ly);
     Roi.setStrokeColor("33D7FF");
     run("Add Selection...");        
  }  
  run("Select None");
  run("Set Scale...", "distance=1 known="+pixelWidth+"  unit="+unit);  
  run("Clear Results");
  File.close(output);
  // Selects the image and saves as png with distance markings, useful for double checking
  selectImage(CurrentImageID);
  run("From ROI Manager");
  roiManager("Show All with labels");
  run("Flatten");
  wait(1000);
  roiManager("Show All with labels");
  run("Flatten");
  wait(1000);
  saveAs(".png", DirectorySubSubfolder + "/" + subfolderName + " Distances.txt");
  close("*");
  run("Close All");
  
/////////////////////////////////////////////////////

}





// Function to search for subfolders and open the right files within the subfolder
function searchForROIs(subfolderPath) {
    listSubfolders = getFileList(subfolderPath);
    for (j = 0; j < listSubfolders.length; j++) {
        DirectorySubSubfolder = subfolderPath + "/" + listSubfolders[j];
        OpenRightFiles(DirectorySubSubfolder);
    }
}

// Function to search for subfolders and open the right files within the subfolder
listFolders = getFileList(directoryTracedCells);
for (k = 0; k < listFolders.length; k++) {
    subfolderPath = directoryTracedCells + listFolders[k];
    searchForROIs(subfolderPath);
}
