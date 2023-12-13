//Batch z-projection (max) of .ome.tif files acquired from MM
//Created on 2023-11-27
//Contact SoYeon Kim for questions: soyeon.kim@ucsf.edu

//Show all the images opens up
setBatchMode("show");
print("\\Clear");
run("Close All"); 

//Assign the input file type and output file type
sourceImgType = ".nd2";
resultImgType = ".ome.tif";

//Comanand for enabling Bio-Formats functions
run("Bio-Formats Macro Extensions");

//Choose folders for input and output images
sourceDir=getDirectory("Select source directory with input images");								
destDir=getDirectory("Select or create destination directory for output images and data");
waitForUser("Now the batch process will start - please don't click any windows until the process completes");

//Listing the files within the folder
imgList=getFileList(sourceDir); 

//Conversion loop
for (i=0; i<imgList.length; i++) { 	//Looping through all the files	
	if (endsWith(imgList[i],sourceImgType)) {	//Check the file type is .ome.tif		
		convertColorImg(imgList[i], sourceDir);
	}
 					
} 									

waitForUser("Process is now complete!");

function convertColorImg(file, inDir) {
	filePath = inDir + file;  //Filepath for the input	
	run("Bio-Formats Importer", "open=[" + filePath + "] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT"); //Import the file
	
	//Color formatting
	Stack.setDisplayMode("color");
	Stack.setChannel(1);
	run("Blue");
	setMinAndMax(0, 255);
	Stack.setChannel(2);
	run("Green");
	setMinAndMax(0, 255);
	Stack.setChannel(3);
	run("Red");
	setMinAndMax(0, 255);
	
	//Making a composite
	run("Make Composite");
	run("RGB Color");
	
	outFileName = replace(file,sourceImgType,"");  //Generate the name without the file extension	
	outFilePath = destDir + "RGB_" + outFileName + resultImgType; 	//Filepath for the ouput 			
	run("Bio-Formats Exporter", "save=[" + outFilePath + "] export compression=Uncompressed"); 	//Exporting using bioformats
	print("Finished: " + outFilePath);  //Print the input file location
	run("Close All"); //Closing two image files
}
