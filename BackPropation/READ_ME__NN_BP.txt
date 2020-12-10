READ_ME for Neural Network (NN) trained via Back-Propagation (BP)


It is assumed that you are familiar with the Genetic Algorithm repository prior to viewing this repository.  

This repository contains code for performing the following:
 - Creating training and testing data for the NN  
 - Training the NN via BP
 - Testing the performance of the NN

The NN in this case takes specifications for control system design performance of a DC Servomotor, 
and outputs the necessary PID gains to meet those specifications.  
Either two controller schemes can be selected, a PID controller or a PI controller w/ rate-feedback.  

*** There are 3 main files to perform each task in the bulleted list above ***

1.)  GA_Data_Collection.mlx -- Creating Training and Testing Data

In the folder titled GA_Data_Collection, there is a .mlx file of the same name.
At the beginning of the file, you can specify a range of specifications to test for both training and testing.  
This file will then run the GA algorithm to determine the best gains for each set of specifications.  
At the end of this program, two .mat files are saved containing the training and testing data.  

2.) Training_Script.mlx -- Training the NN via BP

Training_Script.mlx loads the data saved by GA_Data_Collection, and trains a neural network via back-propagation. 
Within this script, you can modify the training conducted by adjusting the step size "eta" as well as
how many training cycles are performed on each training set.  This script then saves the NN object
in a file named "neural_network.mat".  

3.)  Testing_Script.mlx -- Testing the performance of the NN

Testing_Script.mlx load the test_cases created by GA_Data_Collection and runs the NN on the data. 
For each test case, you can view:
 - The PID Controller Response created by the gains calculated by the NN
 - Tables containing specs vs. performance, GA gains and NN gains, and their % error.

*** To ensure proper operation of this repository ***

Ensure you have the proper directory selected in MATLAB.  You will see two folders: 
 - GA_Data_Collection        
 - NN_Class_Def

These folders need to be added to the search path to work properly.  Follow the instructions below:
 
Highlight both folers, right-click and select:

"Add to Path"
     -> Add Folder
     -> Add Folder and Selected Sub-Folders  ***Select this option ***