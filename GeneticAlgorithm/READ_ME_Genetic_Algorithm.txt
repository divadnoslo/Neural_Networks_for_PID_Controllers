READ_ME for Genetic Algorithm

This repository contains code for tuning a proportional-integral-derivative (PID)
controller via a Genetic Algorithm (GA).  

In this case, the plant in question is a DC servomotor.  Either two controller schemes can be selected, 
a PID controller or a PI controller w/ rate-feedback.  By providing three specifications, 
overshoot (M), peak time (Tp), or settling time (Ts), the GA will determine the required PID gains 
to meet the specifications.  

GA_Main_File.mlx serves as the main file for implementing the Genetic Algorithm in MATLAB.  
This file is a live script in MATLAB, similar to a Jupyter Notebook.  
The main file pulls from a variety of functions located in the GA_functions folders.  
When the proper directory is selected in MATLAB for which you plan to run the GA_Main_File, 
ensure that GA_functions is in the search path. 
 
To add it to the path, right-click on the folder GA_functions, 
at the bottom it will have an option:

"Add to Path"
     -> Add Folder
     -> Add Folder and Selected Sub-Folders  ***Select this option ***

All outputs of the program will appear in the GA_Main_File.mlx itself.  
Each section explains what is happening in each block of code.  
Towards the bottom of the file, the true ouputs will apear.  