%Author: Michael Conroy
%Affiliation: Southern Connecticut State University
% 
%Title: BatchImgLoader.m
%Version: 1.0
%Date: September 26, 2012
%Purpose: 
%		*Second script called by 'ImageProcessing.m'*
%		This Matlab script batch loads images from 
%		a specified directory. Specifically, this script
% 		batch loads all of the images in a directory 
%		that will be processed. The images must be 
%		placed in their own folder and must have the
%		same naming convention (ie. Img_*.tff).
%
%Acknowledgements: Steve on Image Processing blog on 
%		the Matlab Central wesbite. Web link: 
% 		http://blogs.mathworks.com/steve/2006/06/06/
%			batch-processing/
%		The Matlab Document section was used as an aid.
%		Web link: http://www.mathworks.com/help/vision/
%			ug/batch-process-image-files.html

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PLEASE NOTE THAT ONLY THE MAIN IMAGE LOCATION DIRECTORY IS CREATED HERE. THE FILENAMES ARE %
%CYCLED THROUGH INSIDE FOR LOOPS WITHIN SUCCEEDING SCRIPTS TO OPEN EACH IMAGE FOR PROCESSING%
%AND THEN TO SAVE THE POST-PROCESSED IMAGES. ALL POST-PROCESSED IMAGE BATCHES PER SCRIPT ARE%
%SAVED IN A FOLDER (NAME CORRESPONDING TO SCRIPT NAME/PROCESSING-TYPE) UNDER THE MAIN IMAGE %
%LOCATION DIRECTORY--NOT SUBSEQUENT SUBFOLDERS.  											%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%DIRECTORY PROCESSING
%The image directory and naming convention are determined
%directory = input('Enter the full directory name of the images: ','s');
%fileNameConv = input('Enter filename convention (ie. Images_*.tff): ','s');
%%%The above commented out for initial query (InitQuery.m)

%BATCH IMAGE LOAD
%The directory is passed to 'MainImgDir' so that 'Images' may load all image names and characteristics in 'directory'
MainImgDir = fullfile(directory);
Images = dir(fullfile(MainImgDir filesep fileNameConv));

%Test Filename Discovery
%For debugging/testing directory and filename discovery only
%words1 = 'Filename ';
%words2 = ' is:';
%for i = 1:numel(Images)
%	readFile(Images(i).name)
%	fprintf(words, i, words2, Images(i).name); %Prints each filename as "Filename i is: name.tif" where 'i' is the image number
%end

%Location convention
%END