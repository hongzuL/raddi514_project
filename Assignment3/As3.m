clear
%% read the reference image and image
Iref_info = dicominfo('./Data/DICOM/P01-0108.dcm');
Iref = dicomread(Iref_info);
I_info = dicominfo('./Data/DICOM/P01-0100.dcm');
I = dicomread(I_info);
label_image_i = imread('./Data/ManualLabel/P01-0100-icontour-manual.png');
label_image_o = imread('./Data/ManualLabel/P01-0100-ocontour-manual.png');
dimy=1;
dimx=1;
dimz=1;

%% convert referecence image and image to double matrix
Iref = double(Iref);
I = double(I);
%% Normalize the reference image
Iref = (Iref - min(Iref(:)))/(max(Iref(:)) - min(Iref(:)));
%% Normalize the image
I = (I - min(I(:)))/(max(I(:)) - min(I(:)));

%% Computation of the highest resolution level to perform
%% (accelerationFactor=0 => computation is done on all resolution levels,
%%  accelerationFactor=1 => computation is done on all resolution levels except the highest one)
accelerationFactor = 0;

%% Number of iterative raffinement within each resolution level 
nb_raffinement_level = 1; 

%% Dynamic image used as the reference position
reference_dynamic = 0; 

%% Define registration method
%% 0: No motion estimation
%% 1: L2L2 optical flow algorithm
%% 2: L2L1 optical flow algorithm
id_registration_method = input('choose 1 or 2 for L2L2 or L2L1(default choice is L2L1): ');
if id_registration_method == 1
    id_registration_method = 1;
else
    id_registration_method = 2;
end

%% Weighting factor (between 0 and 1) Close to 0: motion is highly sensitive to grey level intensity variation. Close to 1: the estimated motion is very regular along the space. See http://bsenneville.free.fr/RealTITracker/ for more informations
alpha = 0.3;   
if (id_registration_method == 2)
  alpha = 0.6;
end
%% Define registration parameters
RTTrackerWrapper(dimx, dimy, dimz, ...
		 id_registration_method, ...
		 nb_raffinement_level, ...
		 accelerationFactor, ...
		 alpha); 
%% Estimate the motion between the reference and the current images
RTTrackerWrapper(Iref,I);
% Apply the estimated motion on the current image
[registered_image] = RTTrackerWrapper(I);

% Get the estimated motion field
[motion_field] = RTTrackerWrapper(label_image_i);

%% Display registered images & estimated motion field
display_result2D(Iref,I,registered_image,motion_field);

RTTrackerWrapper();