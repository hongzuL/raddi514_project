clc;
close all 
clear all

register_info=dicominfo('P01-0100.dcm');
register_image=dicomread(register_info);
reference_info=dicominfo('P01-0108.dcm');
reference_image=dicomread(reference_info);
%imshow(reference_image,[])
%imshow(register_image,[])

dimy = 1;
dimx = 1;
dimz = 1;
%% Define registration method
%% 0: No motion estimation
%% 1: L2L2 optical flow algorithm
%% 2: L2L1 optical flow algorithm
id_registration_method = 2;

% Dynamic image used as the reference position
reference_dynamic = 0; 

%% Weighting factor (between 0 and 1) Close to 0: motion is highly sensitive to grey level intensity variation. Close to 1: the estimated motion is very regular along the space. 
alpha = 0.3;   
if (id_registration_method == 2)
  alpha = 0.6;
end

%% Computation of the highest resolution level to perform
%% (accelerationFactor=0 => computation is done on all resolution levels,
%%  accelerationFactor=1 => computation is done on all resolution levels except the highest one)
accelerationFactor = 0;

%% Number of iterative raffinement within each resolution level 
nb_raffinement_level = 1;    

%% Normalize the reference image
%reference_image = (reference_image - min(reference_image(:)))/(max(reference_image(:)) - min(reference_image(:)));
reference_image=double(reference_image);
%% Normalize the register image
%register_image = (register_image - min(register_image(:)))/(max(register_image(:)) - min(register_image(:)));
register_image=double(register_image);
%% Define registration parameters
RTTrackerWrapper(dimx, dimy, dimz, ...
		 id_registration_method, ...
		 nb_raffinement_level, ...
		 accelerationFactor, ...
		 alpha);  
 %% Estimate the motion between the reference and the current images
  RTTrackerWrapper(reference_image, register_image);
 
 % Apply the estimated motion on the image
  [registered_image] = RTTrackerWrapper(register_image);
 
 % Get the estimated motion field
  [motion_field] = RTTrackerWrapper();
  
 %% Display registered images & estimated motion field
  display_result2D(reference_image,register_image,registered_image,motion_field);
  
  pause(0.01);

  %%========================= Close the RealTItracker library ===========================

RTTrackerWrapper();
  