%Author: Michael Conroy
%Affiliation: Southern Connecticut State University
% 
%Title: MeanFilter.m
%Version: 1.0
%Date: September 26, 2012
%Purpose:  
%		*Fourth script called by 'ImageProcessing.m'*
%		This script applies a mean filter of specified
%		radius to the cropped images. This preprocessing
%		prepares the gold nanoparticle images for
%		isodata thresholding later in the process.
%

%DETERMINE THE RADIUS
%The user inputs the desired radius for the filter
%radius = input('Enter the mean filter radius value: ','s');
%%%The above commented out for initial query (InitQuery.m)

%CREATE THE FILTER
%'fspecial' is used to create an averaging/mean filter of the inputed radius
meanfilter = fspecial(average, radius);

%FILTER THE IMAGE
%A simple for loop applies the filter to each image and saves a copy in a subfolder called "filtered\"
for meanCount = 1:numel(cropImages) %'cropImages' is from 'CropImages.m'
	filtImg = imread(cropImages(meanCount).name);
	filtImg = filter2(filtImg, meanfilter, cropImages(meanCount).name);
	imwrite(filtImg, fullfile(MainImgDir filesep 'filtered' filesep cropImages(meanCount).name));
end

%CREATE NEW FILTERED IMAGE BATCH LOADER DIRECTORY
%'filtImages' creates a directory to the filtered images for succeeding scripts to pull from
filtImages = dir(fullfile(MainImgDir filesep 'filtered' filesep fileNameConv));

%All images have been filtered
%END