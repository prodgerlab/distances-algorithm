// Get the directory containing the ROI files
roiFilesDirectory = getDirectory("Choose the directory containing the ROI files");
roiFiles = getFileList(roiFilesDirectory);

// Get the traced cells folder directory
TracedCellsDirectory = getDirectory("Choose the folder containing traced cells");

// Get the list of subfolders in the base folder
subFolders = getFileList(TracedCellsDirectory);

// Calculate the number of subfolders
nSubFolders = subFolders.length;

// Loop through the ROI files
nFiles = roiFiles.length;

for (i = 0; i < nFiles; i++) {
    // Open the ROI file
    roiFilePath = roiFilesDirectory + "/" + roiFiles[i];
    open(roiFilePath);
    subFolderPath = TracedCellsDirectory + "/" + subFolders[i];
    subsubFolders = getFileList(subFolderPath);

    // Loop through the subfolders in the base folder
   

        // Loop through the subsubfolders
    for (k = 0; k < 7; k++) {
         subsubFolderPath = subFolderPath + "/" + subsubFolders[k];

            // Save the ROI in the subsubfolder
         saveAs("Selection", subsubFolderPath + "/" + roiFiles[i]);
         
       }
       close("*");
    }

    // Close the ROI image


