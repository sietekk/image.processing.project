import ij.*;
import ij.plugin.filter.*;
import ij.process.*;
import ij.measure.*;

/*
 * Author: Michael Conroy
 * Affiliation: Southern Connecticut State University
 * 
 * Title: avg_Diameter.java
 * Version: 1.0
 * Date: June 25, 2012
 * Purpose: This ImageJ plugin finds the distances among the centroid of a particle
 * 		in an image to each and every pixel along the particle's perimeter. This
 * 		plugin works only with 8-bit binary images that have been previously
 * 		thesholded.
 * Acknowledgements: Thomas Sadowski for allowing the use and adaptation of his code
 * 		from his Kittler_Threshold.java plugin and guidance to create this plugin.
 */

public class avg_Diameter implements PlugInFilter, Measurements
{
	//Global Object and Variable Declaration - Private to this Class
	private ImagePlus impGlobal = null;	//Global ImagePlus Object
	private ImageStatistics statistics = null; //Global ImageStatistics Object
	private int totalBLKpix; //Total Black Pixels in Perimeter Image
	private int width, height; //Image Dimensions
	private double diameters[]; //Global Array for holding diameter values
	private double distances[]; //Global Array for holding Calc Distances
	private double x_centLoc, y_centLoc; //Holds x,y-coords of Centroid
	
	//Abstract Method, Sets Up PlugInFilter for Use
	public int setup(String arg, ImagePlus impOpen) 
	{
		//SECTION 1
		//SETUP PLUGIN
		//------------------------------------------------------//
		//ImageJ Functionality
		if(arg.equalsIgnoreCase("about"))
        {
            //Show About Method if Selected
            showAbout();
            return DONE; 	           
        } 
		//Test Current ImageJ Version
		if( IJ.versionLessThan( "1.47a" ) )
        {
			IJ.error( "Upgrade to IJ.jar Version 1.47a!!!" );
            return DONE;        
        }
	
		//SECTION 2
		//SET PASSED IMAGE OBJECT TO GLOBAL IMAGE OBJECT
		//------------------------------------------------------//
		
		//Pass Image Object to Global Image Object 'impGlobal'
		impGlobal = impOpen;
			//NOTE: impOpen is ROI/Img passed from ImageJ
		
		//Only Accepts 8bit Gray Scale Images
		return DOES_8G;
	}//End Abstract Method setup

	//MAIN METHOD: Abstract Method run
	public void run(ImageProcessor ipIMG)
	{
		//SECTION 1
		//CONVERT IMAGE DATA
		//------------------------------------------------------//
		//Convert Image to a Byte Array
		ImageProcessor ipImage = impGlobal.getProcessor();
		//Create Binary Processor 'bpImage' from 'ipImage'
		BinaryProcessor bpImage = new BinaryProcessor(new ByteProcessor(ipImage, true));
			//Create ImageStatistics Object -- For centroid and calculated statistics; see below
			statistics = bpImage.getStatistics();
		//Convert to Perimeter Pixels (b/c only black perimeter pixels applicable)
		bpImage.outline();
		//bpTemp to byte-Array
		byte[] pixels = (byte[])bpImage.getPixels();	
		//Cast 'pixels[]' Data to byte-Type
		int value; //Holds pixel value in each pixel[] element
		for (int i = 0; i < pixels.length; i++)
		{
			value = pixels[i] & 0xff;
			pixels[i] = (byte) value;
		}
		
		//SECTION 2
		//ASSIGN VALUES TO GLOBAL VARIABLES
		//------------------------------------------------------//
		//Calculate Total Black Pixel Number in Perimeter
		getTotalBLKpix(pixels);
		//Get Image Dimensions
		getImgDimensions();
		//Find Centroid Location (x,y)
		findCentroid();
		//Find Length of 'distances[]'
		getDistancesLength(bpImage);
		//Find Length of 'diameters[]' (which equals 'distances.length')
		getDiametersLength();
		
		//SECTION 3
		//FIND DISTANCES/RADII
		//------------------------------------------------------//
		//Find Perimeter Pixel Location and Calculate Distances/Radii
		int test; //Holds pixel value (0 or 255)
		double distCalc; //Holds distance from centroid location to perimeter pixel
		int counter = 0; //Counter to address elements in distance[] to store distCalc values
		
		//Find Distance
		for (int i = 0; i < width; i++) //x-coordinate
		{
			for (int j = 0; j < height; j++) //y-coordinate
			{
				test = bpImage.getPixel(i, j);
				if (test == 0)
				{
					//Find Distance
					distCalc = Math.sqrt(
							Math.pow((i - x_centLoc), 2.0) //(x1-x2)^2
							+ Math.pow((j - y_centLoc), 2.0)); //(y1-y2)^2
					
					//Store distCalc into distance[]
					distances[counter] = distCalc;
					
					//Increase counter by 1
					counter++;
				}
				else
					return;
			}
		}
		
		//SECTION 4
		//CONVERT DISTANCES/RADII TO DIAMETERS
		//------------------------------------------------------//
		//Convert Distances/Radii to Diameters
		getDiameters();

		//SECTION 5
		//STATISTICS
		//------------------------------------------------------//
		/*BELOW USES ImageJ ImageStatistics FIELDS AND ARRAY SORTING
		 * distMin
		 * 		-Have to find with array (distances[])
		 * 		-Arrays.sort(distances);
		 * 		-Max = distances[distances.length-1];
		 * distMax
		 * 		-Have to find with array (distances[])
		 * 		-Arrays.sort(distances);
		 * 		-Min = distances[0];
		 * distMean
		 * 		-Use 'statistics'
		 * 		-distances.mean
		 * distAvg
		 * 		-(Max + Min)/2
		 * distStdDev
		 * 		-Use 'statistics'
		 * 		-distances.stdDev
		 * 
		 * ????USE BUILT IN STATS FUNCTIONS IN JAVA IF EXIST?
		*/

	}//End Abstract Method run
	
	//Method Finds Total Number Black Pixels in Perimeter
	public void getTotalBLKpix(byte[] blackPixels)
	{
		//Initial Count at Zero
		totalBLKpix = 0;
		
		//Loop Through Each 'blackPixels[]' Element to Sum Number of Black Pixels
		for (int i = 0; i < blackPixels.length; i++)
		{
			if (blackPixels[i] == 0)
			{
				totalBLKpix++; //Increase value if pixel value is black
			}
		}
	}//End calc_totalBLKpix()
	
	//Method Finds Image Dimensions
	public void getImgDimensions()
	{
		//Assign values to width and height
		width = impGlobal.getWidth();
		height = impGlobal.getHeight();
	}
	
	//Method Finds x/y-Coordinates of the Centroid
	public void findCentroid()
	{
		//Assign x,y-values into xy_Location Array
		x_centLoc = statistics.xCentroid;
		y_centLoc = statistics.yCentroid;
	}//End findCentroid()

	//Method finds the Length for 'distances[]'
	//Method Finds Length Needed for 'distances[]' Array
	public void getDistancesLength(BinaryProcessor bpImg)
	{
		//Get the histogram of the binary image
		int[] histogram = bpImg.getHistogram();
		
		//Count Black Values
		int size = 0; //Holds size of black pixel count
		for (int i = 0; i < histogram.length; i++)
		{
			if (histogram[i] == 0)
				size++;
		}
		
		//Set Size of distances[]
		distances = new double[size];
		
	}//End getDistancesLength()
	
	//Method Finds Length Needed for 'diameters[]' Array (
	public void getDiametersLength()
	{
		//Length is equal to length of 'distances[]'
		diameters = new double[distances.length];
	}
	
	//Method Converts Distances/Radii to Diameters
	public void getDiameters()
	{
		//Convert Distances/Radii to Diameters
		for (int i = 0; i < distances.length; i++)
			diameters[i] = 2 * distances[i];
	}//End getDiameters()
	
	//Method Showing Plugin Info
	//Method Used to Implement the ImageJ showAbout Functionality
	public static void showAbout()
    {
        //Show Message Giving Plugin Information
        IJ.showMessage("About avg_Diameter...",
        		"Author: Michael Conroy\n"
				+ "Affiliation: Southern Connecticut State University\n"
        		+ "Version 1.0, June 14, 2006\n"
        		+ "Purpose: This ImageJ plugin finds the distances among the centroid of a particle\n"
		 		+ "in an image to each and every pixel along the particle's perimeter. This\n"
		  		+ "plugin works only with 8-bit binary images that have been previously\n"
		  		+ "thesholded./n"
		  		+ "Acknowledgements: Thomas Sadowski for allowing the use and adaptation of his code\n"
		 		+ "from his Kittler_Threshold.java plugin and guidance to create this plugin.");
                        
    }//End showAbout()
	
}