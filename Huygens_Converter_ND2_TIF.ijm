//Converting ND2 images in batch to .ome.tif files so it can be run with Huygens software
//Last update 2022-04-21
//Contact SoYeon Kim for questions: soyeon.kim@ucsf.edu

//Show all the images opens up
setBatchMode("show"); 

//Assign the input file type and output file type
inFileType = ".nd2";
outFileType = ".ome.tif";

//Comanand for enabling Bio-Formats functions
run("Bio-Formats Macro Extensions");

//Choose folders for input and output images
inMainDir=getDirectory("Select source directory with input images");								
outDir=getDirectory("Select or create destination directory for output images and data");

//Listing the subfolders within the main source folder
fileListMain=getFileList(inMainDir); //Listing the files within the main input folder

for (i=0; i<fileListMain.length; i++) { //Looping through all the subfolders and files within the main input folder 	
	
	
	if (endsWith(fileListMain[i],inFileType)) {	//Check the file type
			print(inMainDir);
			convertFile(fileListMain[i], inMainDir);
		}
		
	else {
		print(fileListMain[i]);
		inSubDir = inMainDir+fileListMain[i];
		fileListSub=getFileList(inSubDir); //Listing the files within the subfolder
	
		for (j=0; j<fileListSub.length; j++) { 	//Looping through all the files
		
			if (endsWith(fileListSub[j],inFileType)) {	//Check the file type is .ome.tif		
				convertFile(fileListSub[j], inSubDir);
			}	
		}
	}
}


waitForUser("Process is now complete!");

function convertFile(file, inDir){
	filePath = inDir + file;  //Filepath for the input	
	run("Bio-Formats Importer", "open=[" + filePath + "] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT use_virtual_stack"); //Import the file
	nameNoExt = replace(file,inFileType,"");  //Generate the name without the extension
	
	outFile = outDir + nameNoExt + outFileType; 	//Filepath for the ouput 			
	run("Bio-Formats Exporter", "save=[" + outFile + "] compression=Uncompressed"); 	//Exporting using bioformats
	print(file);  //Print the input file location
	run("Close All"); //Closing two image files
}

