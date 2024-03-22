//Batch color setup change of the .ome.tif files
//Created on 2023-12-20
//Contact SoYeon Kim for questions: soyeon.kim@ucsf.edu

//Show all the images opens up
setBatchMode("show"); 

//Assign the input file type and output file type
sourceImgType = ".ome.tif";
resultImgType = ".ome.tif";

//Comanand for enabling Bio-Formats functions
run("Bio-Formats Macro Extensions");

//Choose folders for input and output images
sourceDir=getDirectory("Select source directory with input images");								
destDir=getDirectory("Select or create destination directory for output images and data");
waitForUser("Now the batch process will start - please don't click any windows until the process completes");

//List the files within the folder
imgList=getFileList(sourceDir); 

//Conversion loop

for (i=0; i<imgList.length; i++) { 	//Looping through all the files	
	
	if (endsWith(imgList[i],sourceImgType)) {	//Check the file type is .ome.tif		
		print("Processing: " + imgList[i]);
		colorSetup(imgList[i], sourceDir);
	}
 					
}

waitForUser("Process is now complete!");

function colorSetup(file, inDir) {
	filePath = inDir + file;  //Filepath for the input	
	run("Bio-Formats Importer", "open=[" + filePath + "] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT use_virtual_stack"); //Import the file
	
	Stack.setDisplayMode("color");
	Stack.setChannel(1);
	run("Magenta");
	Stack.setChannel(2);
	run("Red");
	Stack.setChannel(3);
	run("Green");
	Stack.setChannel(4);
	run("Cyan");
	
	outFileName = replace(file,sourceImgType,"");  //Generate the name without the file type extension
	outFilePath = destDir + "Color_" + outFileName + resultImgType; 	//Filepath for the ouput 			
	run("Bio-Formats Exporter", "save=[" + outFilePath + "] compression=Uncompressed"); 	//Exporting using bioformats
	print("Finished: " + outFilePath);  //Print the input file location
	run("Close All"); //Closing two image files
}
