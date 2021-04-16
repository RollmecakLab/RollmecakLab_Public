


// a macro to get the growthrates and growthtimes from a kymograph.
// To use, draw a multi segmented line on the kymograph and then run
// A (+) growth rate = a growth, a (-) growth rate = a catastrophe
// outputs the growth rates and the distance and time of each event

setBatchMode(true);

seconds_per_frame = 1;//getNumber("enter time between frames (in seconds)", 1);
minutes_per_frame=seconds_per_frame/60; //gets the minutes per frame
pixelsize = 0.077;// um getNumber("enter pixel size ( in um) ", 0.120  for tirf   or 0.108 for DF) ;

startRow=0; // for the results table
seed = 0 ;// for holding the coordinted of the seed
tubeNumber = 0 ;//for holding the uber of the tube we are on...


for (i=0;i<roiManager("count");i++){ 
	roiManager("select",i)	

/******************************************************
 *   
 *     Try looking for the seeds by using every odd numbered roi
 *     (0,1,3,5 etc..) as the seed.
 *     this can be checked with  "%2"                        
**************************************/

	if( i%2 ==0) { //the even ones have mod 2 = 0
		getSelectionCoordinates(x, y);
		seed=x[0]; 

		// Check if Seed is a straight line...if NOT, USE the first clicked points 
		
		tubeNumber=tubeNumber+1;
	}
	else{ // do all this stuff when there is a growth


	numberOfRescues = 0; // for counting rescue events
	numberOfNewGrowthEvents =0; // for counting number of new growth events
	
 	getSelectionCoordinates(x, y); // returns the selected points
     
     for( j=0;j<x.length-1;j++){ // loop over all the clicked points in a multi-line selection
   
		linelength=sqrt( pow( (x[j+1]-x[j]),2 ) + pow( (y[j+1]-y[j]),2 ) ); // gets the length of this segment
		growthlength=(x[j+1]-x[j]); // space is X-axis
		growthtime=(y[j+1]-y[j]); // time is Y- Axis
		GrowthRate = (growthlength/growthtime)*(pixelsize)*(1/minutes_per_frame);// gets the rate in the right units..

		numberOfNewGrowthEvents = numberOfNewGrowthEvents +1;
		
		numberOfRescues = numberOfRescues+1 ;			
		

		setResult("Growth Rate um/min",startRow+j,GrowthRate); // growth rate in um/min
		setResult("Growth Length um",startRow+j,growthlength*pixelsize); //put growth length in um
		setResult("Growth Time min",startRow+j,growthtime*minutes_per_frame); //put growth time in s
		//setResult("NumberOfRescues",startRow+j,numberOfRescues);  // count rescues
		//setResult("NumberOfNewGrowthEvents",startRow+j,numberOfNewGrowthEvents); 
	
		setResult("Tube Number",startRow+j,tubeNumber);
        setResult("Distance to Seed",startRow+j,(x[j+1]-seed));
         

		if(GrowthRate > 0 ) {   // if it is a growth
				   if(x[j]<=seed+2 || j==0){ // always start with  new growth or if it catastrophes within2 pixels of the seed
				   	setResult("New Growth ",startRow+j,1); // new growth
				  }
				
				   else{
					setResult("Rescue ",startRow+j,1); // new growth
					
				   }
				
				
		} // end positive growth rate check..
		
				if(GrowthRate  < 0){
					 if(x[j+1]<=seed+2){	
					setResult("Total Catastrophe ",startRow+j,1); // new growth
					 }
					
					else{
						setResult("Rescued Catastrophe ",startRow+j,1); // new growth
					}
				} // end negative growth rate check

				if(GrowthRate == 0){  // this is for pauses
					setResult("Pause ",startRow+j,1);
					
				}
			
		          MTend = ( atan( (x[1]-x[0])/(y[1]-y[0])) )/abs(atan( (x[1]-x[0])/(y[1]-y[0]))); //Returns +1 for +  end and -1 for - end.
												// Assumes the - end is on the Lefthand side of the kymograph
				setResult("MT end",startRow+j,   MTend    ); 

   	}
	 
		startRow=startRow+x.length-1; // keep track of which row of the results table we are on...

}

}
