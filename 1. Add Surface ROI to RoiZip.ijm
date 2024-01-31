//Setting the directory to the Traced Cells folder
// Contains a subfolder with each of the patient ids
// Subsubfolderscontain an image, .roi file for the cell surface, .zip file containing the rois

directoryTracedCells = getDirectory("Select Traced Cell Images Folder");

// Function set to open the .roi file first followed by .zip files in the RoiManager and then saving with the tissue surface first
function OpenRightFiles(DirectorySubSubfolder) {
    listFiles = getFileList(DirectorySubSubfolder);
    i=0;
    j=0;
    k=0;
    roiManager("Reset");
    for (i = 0; i < listFiles.length; i++) {
        filePath = DirectorySubSubfolder + "/" + listFiles[i];
        if (endsWith(filePath, "Surface.roi")) {
            roiManager("Open", filePath);
        }
        else if (endsWith(listFiles[i], "RoiSet.zip")) {
            run("Open...", "path=[" + filePath + "]");
        }
    }
    
//////////////////////////////////////////////

// Saved files are named after the patient, cell type, and Updated ROIs.zip
    subfolderName = File.getName(DirectorySubSubfolder);
    SavePath = DirectorySubSubfolder + "/" + subfolderName + " Updated ROIs.zip";
    roiManager("Save", SavePath);
    close("ROI Manager");
 
////////////////////////////////////////////// 
     
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

