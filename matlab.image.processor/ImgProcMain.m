
%Author: Michael Conroy
%Affiliation: Southern Connecticut State University
% 
%Title: ImgProcMain.m
%Version: 1.0
%Date: October 3, 2012
%Purpose:  
%		*Sixth script called by 'ImageProcessing.m'*
%		The main processing script takes the thresholded images
%		and finds the areas of the gold nanoparticle/-sphere in
%		in each image. All gathered areas will be held under the
%		corresponding filename in a single, large matrix, which
%		will be pushed to 'Data.m' for saving and processing.
%Acknowledgements:
%		These Matlab documentation sections were used as aids:
%		http://www.mathworks.com/help/images/ref/regionprops.html
%		http://www.mathworks.com/help/images/ref/bwconncomp.html
%		http://www.mathworks.com/matlabcentral/answers/7094
%

%MAIN IMAGE PROCESSING LOOP
%Finds the areas in pixels of each region in each image
for mainCount = 1:numel(threshImages) %'threshImages' is from 'Isodata.m'
	mainProcImg = imread(threshImages(mainCount).name);
	
	%DETERMINE REGIONS BY CONNECTED COMPONENTS
	CC = bwconncomp(mainProcImg); %Identifies the connected components so area data can be pulled out
	%Area = regionprops(CC, 'Area'); %Actual number of pixels in the region; Area is a structure, so can't 'sort()'
									 %Finding the max area with the Area structure more inconvenient than the following
	ObjArea = cellfun(@numel, CC.PixelIdxList); %Finds objects' sizes similar to 'regionprops(I,'Area')'
	[Area, Region] = sort(ObjArea, 'descending'); %Sorts the regions from largest area/pixel-count/numel(linear indices for each object's pxs) to lowest
	ParticleArea = Area(1); %Assign particle px area
	
	%APPEND 'ParticleArea' TO HOLDING MATRIX
	DataMatrix(mainCount)= ParticleArea; %Don't need name; loop provides that the first filename pulled corresponds to the first area
										 %found, which corresponds to the first index (mainProcImg) of DataMatrix; Same for 2nd, 3rd,...
end

%All images processed and areas calculated
%END