//define value for gassian filter 
sigma1 = 1.0; //define the gassian filter for channel 1
sigma2 = 1.2; // define the gassian filter for channel 2; currently, the second channle is for DAPI. Don't use any value greater than 2 for other channle but DAPI 
sigma3 = 2.0; //define the gassian filter for channel 3
sigma4 = 0.8; //define the gassian filter for channel 4

image_folder = getDirectory("Choose widefile images folder");	//get directory for data
dir2=getDirectory("Save you processed files");
//select the right formart to be processed
file_list = getFileList(image_folder);			//get all images at the colder
nWFimages = lengthOf(file_list);

for(numimage = 0; numimage<nWFimages; numimage++) {		
path = image_folder+file_list[numimage];
run("Bio-Formats", "open="+path+" color_mode=Default view=Hyperstack stack_order=XYCZT");

orig = getTitle(); 

Stack.setChannel(4) // remove the TL channel
run("Delete Slice", "delete=channel");// remove the TL channel

//Stack.setChannel(1) // remove the the first channel
//run("Delete Slice", "delete=channel");// remove the the first channel

Stack.setChannel(1);
run("Yellow");
run("Subtract Background...", "rolling=50 slice");
run("Gaussian Blur...", "sigma="+sigma1+" slice"); // you can change sigma to what ever value you want 
setMinAndMax(2, 40);

Stack.setChannel(2);
run("Cyan");
run("Subtract Background...", "rolling=50 slice");
run("Gaussian Blur...", "sigma="+sigma2+" slice"); // you can change sigma to what ever value you want 
setMinAndMax(2, 40);

Stack.setChannel(3)
run("Blue");
run("Gamma...", "value=0.3 slice");
run("Subtract Background...", "rolling=50 slice");
run("Gaussian Blur...", "sigma="+sigma3+" slice");
setMinAndMax(40, 150);

Stack.setChannel(4)
run("Magenta");
run("Subtract Background...", "rolling=50 slice");
run("Gaussian Blur...", "sigma="+sigma4+" slice"); 
setMinAndMax(2, 40);

RGBimage= "RGB_"+orig;
selectWindow(orig);
Stack.setDisplayMode("composite");
run("Stack to RGB");
rename(RGBimage);
saveAs("Tiff", dir2+RGBimage);

selectWindow(orig);
run("Split Channels");
c1Ch = "C1-"+orig;
c2Ch = "C2-"+orig;
c3Ch = "C3-"+orig;
c4Ch = "C4-"+orig;

selectWindow(c1Ch);
run("RGB Color");
saveAs("Tiff", dir2+c1Ch);


selectWindow(c2Ch);
run("RGB Color");
saveAs("Tiff", dir2+c2Ch);


selectWindow(c3Ch);
run("RGB Color");
saveAs("Tiff", dir2+c3Ch);


selectWindow(c4Ch);
run("RGB Color");
saveAs("Tiff", dir2+c4Ch);


run("Concatenate...", "image1="+c1Ch+" image2="+c2Ch+" image3="+c3Ch+" image4="+RGBimage+" image5=[-- None --]");
// you can define the number and the order of channles, if you don't need dapi, you can use image1, image2, and image3, no image4; 



mergeimage  = "Merge_" +orig; 

saveAs("Tiff", dir2+mergeimage);
run("Close All"); 
}
