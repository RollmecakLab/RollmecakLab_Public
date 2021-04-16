/*  
 A macro to generate a montage of kymographs from darkfield polarity marked seed experiments. The Seeds should be channel 1 and will be blue
 the polarity bit is green and channel 2 and the DF is gray and in channel 3.  kymoLineWidth is the width of the line used to make a kymograph... 
 v1.0 9/25/2015 adapted from multi_kymo_maker v6   
 */

// THIS VERSION IS FOR 1-CHANNEL IMAGES I.E. NO FLUOR. SEEDS


setBatchMode(true);

kymoLineWidth=5; //set the line width for the kymo maker

savedir = getDirectory("Choose where to Save Kymographs "); // choose where to save
registered_image_id=getImageID(); //get ID of original image
selectImage(registered_image_id); // select ut
moviename=getTitle(); //get title of original file
//run("Split Channels"); //split the channels


/*
selectWindow("C1-"+moviename); // get Channel 1 and make it blue
blueID=getImageID();
selectWindow("C2-"+moviename); //get Channel 2 and make it green
greenID=getImageID();
selectWindow("C3-"+moviename);  //get Channel 3 and make it gray
grayID=getImageID();
*/

grayID=getImageID();

for(i=0;i<roiManager("count");i++){ //iterate over all the rois
	/*

selectImage(greenID);     //make the green channel montage
roiManager("Select", i);
selectImage(greenID);
run("Multi Kymograph","linewidth="+kymoLineWidth);   //HERE YOU CAN CHANGE THE LINEWIDTH
grkymoID=getImageID();
selectImage(grkymoID);
run("Green");
rename("grkymo");

//waitForUser();

selectImage(blueID);   
roiManager("Select", i);
selectImage(blueID);
run("Multi Kymograph","linewidth="+kymoLineWidth); // HERE YOU CAN CHANGE THE LINEWIDTH
blkymoID=getImageID();
selectImage(blkymoID);
run("Blue");
rename("blkymo");

//waitForUser();
*/
selectImage(grayID);   
roiManager("Select", i);
selectImage(grayID);
run("Multi Kymograph","linewidth="+kymoLineWidth); // HERE YOU CAN CHANGE THE LINEWIDTH
graykymoID=getImageID();
selectImage(graykymoID);
run("Grays");
rename("graykymo");

/*
We will now make a composite image and save it for later nice image making, and then make an RGB montage for drawing kymoLines..
*/
//run("Merge Channels...", "c1=*None* c2=grkymo c3=blkymo  c4=graykymo create keep "); // Merge the channels for saving as composites
selectImage("graykymo");
saveAs("Tiff", savedir+"tube"+i+"_kymo_"+moviename);
close("*graykymo*");

//run("Merge Channels...", "c1=graykymo c2=grkymo c3=blkymo"); // Merge the channels for the analysis montage?
//selectImage("RGB");
//saveAs("Tiff", savedir+"tube"+i+"_RGB_"+moviename);


}
//close("C1*")
//close("C2*")
//close("C3*")

run("Images to Stack","method=[Copy (center)] name=Stack title=[] use");
run("Make Montage...");
saveAs("Tiff", savedir+moviename+"Montage.tif");






