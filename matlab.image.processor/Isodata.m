
%Author: Michael Conroy
%Affiliation: Southern Connecticut State University
% 
%Title: Isodata.m
%Version: 1.0
%Date: October 3, 2012
%Purpose:  
%		*Fifth script called by 'ImageProcessing.m'*
%		This script thresholds the images utilizing the
%		Isodata algorithm. This script was built upon the
%		the 'isodata.m' script available from the Matlab
%		Central File Exchange. Please see below...
%
%Acknowledgements:
%		User 'zephyr' on the Matlab Central File Exchange 
%		for providing his/her 'isodata.m' script for download.
%
%		There is no BSD license according to the website,
%		and no other licensing info can be found at this
%		time. 
%		
% 		The description from the website: "Provides automatic
%		thresholding based on the ISODATA method."
%
%		Web link: http://www.mathworks.com/matlabcentral/
%				fileexchange/3195-automatic-thresholding
%
%Note: The documentation from the original script has been
%		included below for documentation quality and for
%		debugging and error correction.
%

%START THRESHOLDING LOOP
%A simple for loop is used to cycle through all images to be thresholded
for threshCount = 1:numel(filtImages) %'filtImages' is from 'MeanFilter.m'
	
	%IMAGE HOLDER
	threshImg = imread(filtImages(threshCount).name);
	
	function level = isodata(threshImg)
	%%%%%%%%%%START ORIGINAL SCRIPT DOCUMENTATION%%%%%%%%%%%%%%%%%%%%%
	
	%   ISODATA Compute global image threshold using iterative isodata method.
	%   LEVEL = ISODATA(I) computes a global threshold (LEVEL) that can be
	%   used to convert an intensity image to a binary image with IM2BW. LEVEL
	%   is a normalized intensity value that lies in the range [0, 1].
	%   This iterative technique for choosing a threshold was developed by Ridler and Calvard .
	%   The histogram is initially segmented into two parts using a starting threshold value such as 0 = 2B-1, 
	%   half the maximum dynamic range. 
	%   The sample mean (mf,0) of the gray values associated with the foreground pixels and the sample mean (mb,0) 
	%   of the gray values associated with the background pixels are computed. A new threshold value 1 is now computed 
	%   as the average of these two sample means. The process is repeated, based upon the new threshold, 
	%   until the threshold value does not change any more. 
  
	%
	%   Class Support
	%   -------------
	%   The input image I can be of class uint8, uint16, or double and it
	%   must be nonsparse.  LEVEL is a double scalar.
	%
	%   Example
	%   -------
	%       I = imread('blood1.tif');
	%       level = graythresh(I);
	%       BW = im2bw(I,level);
	%       imshow(BW)
	%
	%   See also IM2BW.
	%
	% Reference :T.W. Ridler, S. Calvard, Picture thresholding using an iterative selection method, 
	%            IEEE Trans. System, Man and Cybernetics, SMC-8 (1978) 630-632.
	%%%%%%%%%%END ORIGINAL SCRIPT DOCUMENTATION%%%%%%%%%%%%%%%%%%%%%
	
	
   	% Convert all N-D arrays into a single column.  Convert to uint8 for
	% fastest histogram computation.
	threshImg = im2uint8(threshImg(:));

	% STEP 1: Compute mean intensity of image from histogram, set T=mean(I)
	[counts,N]=imhist(threshImg);
	i = 1;
	mu = cumsum(counts);
	T(i) = (sum(N.*counts))/ mu(end);
	T(i) = round(T(i));

	% STEP 2: compute Mean above T (MAT) and Mean below T (MBT) using T from
	% step 1
	mu2 = cumsum(counts(1:T(i)));
	MBT = sum(N(1:T(i)).*counts(1:T(i)))/mu2(end);
	
	mu3 = cumsum(counts(T(i):end));
	MAT = sum(N(T(i):end).*counts(T(i):end))/mu3(end);
	i = i+1;
	% new T = (MAT+MBT)/2
	T(i) = round((MAT+MBT)/2);
	
	% STEP 3 to n: repeat step 2 if T(i)~=T(i-1)
		while abs(T(i)-T(i-1)) >= 1
			mu2 = cumsum(counts(1:T(i)));
			MBT = sum(N(1:T(i)).*counts(1:T(i)))/mu2(end);
			
			mu3 = cumsum(counts(T(i):end));
			MAT = sum(N(T(i):end).*counts(T(i):end))/mu3(end);
			
			i = i+1;
			T(i) = round((MAT+MBT)/2); 
			Threshold = T(i);
		end

	% Normalize the threshold to the range [i, 1].
	level = (Threshold - 1) / (N(end) - 1);
	
	%SAVE THRESHOLDED IMAGES
	threshImg = filter2(meanfilter, filtImages(threshCount).name);
	
	%PROCESS AND SAVE IMAGES
	%The thresholding is applied through 'im2bw'
	threshImg = im2bw(threshImg, level);
	%This step saves the processed images to a subdirectory "thresholded"
	imwrite(threshImg, fullfile(MainImgDir filesep 'thresholded' filesep filtImages(theshCount).name]);
	
	%DISPLAY THRESHOLDED IMAGES
	%imshow(threshImg) %For debugging
end
%END THRESHOLDING LOOP

%CREATE NEW THRESHOLDED IMAGE BATCH LOADER DIRECTORY
%'filtImages' creates a directory to the thresholded images for succeeding scripts to pull from
threshImages = dir(fullfile(MainImgDir filesep 'thresholded' filesep fileNameConv));

%All images have been thresholded
%END