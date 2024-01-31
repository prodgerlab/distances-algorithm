
directoryTracedCells = getDirectory("Select Traced Cell Images Folder");


function OpenRightFiles(DirectorySubSubfolder) {
    listFiles = getFileList(DirectorySubSubfolder);
    roiManager("Reset");
    for (i = 0; i < listFiles.length; i++) {
        filePath = DirectorySubSubfolder + "/" + listFiles[i];
        if (endsWith(filePath, "Dermis.roi")) {
            roiManager("Open", filePath);
        }
        else if (endsWith(listFiles[i], "Updated ROIs.zip")) {
            run("Open...", "path=[" + filePath + "]");
        }
          
        else if (endsWith(listFiles[i], ".tif")) {
            run("Open...", "path=[" + filePath + "]");
        }
    }
    
///////////////////////////////// 

	requires("1.49k");
	CurrentImageID = getImageID();
	selectImage(CurrentImageID);
	requires("1.49k");
  	run("Remove Overlay");  
 	getPixelSize(unit, pixelWidth, pixelHeight);
  	run("Set Scale...", "distance=1 known=1 unit=pixel");
 	roiManager("select", 1);
  	run("Interpolate", "interval=2"); 
  	getSelectionCoordinates(x, y);
  	run("Set Measurements...", "  centroid redirect=None decimal=1");
  	subfolderName = File.getName(DirectorySubSubfolder);
  	output = File.open(DirectorySubSubfolder + "/" + subfolderName + " Distances.txt");
  	print("Selection  \t  Units \t Distance \t Units \t Inside");
  	print(output, "Selection#  \t  Units \t distance \t Units \t Inside");
  	for (selection=2;  selection<roiManager("count");  selection++){
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
  

     vlx = Array.concat(vlx,lx);
     vly = Array.concat(vly, ly);
     vxc = Array.concat(vxc, xc);
     vyc = Array.concat(vyc, yc);
     vpos = Array.concat(vpos,pos);

  }
  
  ///////////////////////////////////////////////////////
  

  roiManager("Select", 1);
  roiManager("Delete");
  roiManager("select", 0);
  run("Interpolate", "interval=2");  
  getSelectionCoordinates(x, y);
  run("Set Measurements...", "  centroid redirect=None decimal=1");
  for (selection=1;  selection<roiManager("count");  selection++){
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
      
	
	roiManager("select", 0);
       inside = Roi.contains(xc, yc);   
       if (inside > 0) {
         roiManager("select", selection);
         roiManager("Set Color", "magenta");
         roiManager("select", selection);
         roiManager("Set Color", "magenta");
         makeLine(vxc[selection], vyc[selection], vlx[selection], vly[selection]);
         Roi.setStrokeColor("magenta");
         run("Add Selection...");
         
       }
       if (inside < 1) {
         roiManager("select", selection);
         roiManager("Set Color", "green");
         roiManager("select", selection);
         roiManager("Set Color", "green");
         makeLine(vxc[selection], vyc[selection], vlx[selection], vly[selection]);
         Roi.setStrokeColor("green");
         run("Add Selection...");
       }
       print((selection+1) + " \t " + vpos[selection] + " \t pixels\t "+ (vpos[selection]*pixelWidth) + " \t " + unit + "\t" + inside);
       print(output, (selection+1) + " \t " + vpos[selection] + " \t pixels\t "+ (vpos[selection]*pixelWidth) + " \t " + unit + "\t" + inside);
     

  }
    
  selectImage(CurrentImageID);
  run("From ROI Manager");
  roiManager("Show All with labels");
  run("Flatten");
  roiManager("Show All with labels");
  run("Flatten");
  saveAs(".png", DirectorySubSubfolder + "/" + subfolderName + " Distances");
  run("Clear Results");
  File.close(output);
  close("*");
  run("Close All");
/////////////////////////////////////////////////////

}


function searchForROIs(subfolderPath) {
    listSubfolders = getFileList(subfolderPath);
    for (j = 0; j < listSubfolders.length; j++) {
        DirectorySubSubfolder = subfolderPath + "/" + listSubfolders[j];
        OpenRightFiles(DirectorySubSubfolder);
    }
}


listFolders = getFileList(directoryTracedCells);
for (k = 0; k < listFolders.length; k++) {
    subfolderPath = directoryTracedCells + listFolders[k];
    searchForROIs(subfolderPath);
}
