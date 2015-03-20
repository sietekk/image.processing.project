%Author: Michael Conroy
%Affiliation: Southern Connecticut State University
% 
%Title: CropImages.m
%Version: 1.0
%Date: September 26, 2012
%Purpose:  
%		*Third script called by 'ImageProcessing.m'*
%		This script takes a set of batch loaded images
%		and crops them. This script will take gold
%		nanoparticle images and crop them to remove the
%		the scale bar at the bottom.
%
%Acknowledgements: Steve on Image Processing blog on 
%		the Matlab Central wesbite; web link: 
% 		http://blogs.mathworks.com/steve/2006/06/06/
%			batch-processing/
%		This Matlab Document section was used as an aid:
%		Web link: http://www.mathworks.com/help/vision/
%			ug/batch-process-image-files.html
%

%DETERMINE CROP SIZE
%ycropsize = input('Enter y-axis pixel crop value: ','s');
%xcropsize = input('Enter x-axis pixel crop value: ','s');
%%%The above commented out for initial query (InitQuery.m)

%File output folder notification
fprintf('The cropped files will be output to ', directory filesep 'cropped\');

%CROP ALL IMAGES
%A simple for loop applies the croping according to the size parameters and saves a copy to the subfolder "cropped\"
for cropCount = 1:numel(Images) %'Images' is from 'BatchImgLoader.m'
   cropImg = imread(Images(cropCount).name);
   cropImg = imcrop(cropImg,[0 0 xcropsize ycropsize]);
   imwrite(cropImg, fullfile(MainImgDir filsep 'cropped' filesep Images(cropCount).name));
end

%CREATE NEW CROPPED IMAGE BATCH LOADER DIRECTORY
%'cropImages' creates a directory to the cropped images for succeeding scripts to pull from
cropImages = dir(fullfile(MainImgDir filesep 'cropped' filesep fileNameConv));

%All images have been cropped
%END