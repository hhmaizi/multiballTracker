%   Example: Track an occluded object
%   ---------------------------------
% param.motionModel           = 'ConstantAcceleration';
%   param.initialLocation       = 'Same as first detection';
%   param.initialEstimateError  = 1E5 * ones(1, 3);
%   param.motionNoise           = [25, 10, 1];
%   param.measurementNoise      = 25;
%   param.segmentationThreshold = 0.05;
%   % Create required System objects
%   videoReader = vision.VideoFileReader('E:\bak\3D×ËÌ¬¹À¼Æ\datas\brightwindow.avi');
%   videoPlayer = vision.VideoPlayer('Position', [100, 100, 500, 400]);
%   foregroundDetector = vision.ForegroundDetector(...
%     'NumTrainingFrames', 10, 'InitialVariance', 0.05);
%   blobAnalyzer = vision.BlobAnalysis('AreaOutputPort', false, ...
%     'MinimumBlobArea', 70);
  %%
%   detectedTrace3d = [];
clear
%% prepare for animateline
h = animatedline('Color', 'r', 'Marker', 'o');
h1 = animatedline('Color', 'b', 'Marker', '*');
axis([130 200 -350, -100, 1900, 2200])
  
  load('./datas/shape8.mat');
%   load pt2.mat
  filteredTrace3d = [];
  detectedTrace3d = shape8; 
  %%
  % Process each video frame to detect and track the object
  kalmanFilter = []; isTrackInitialized = false;
  isObjectDetected = false;
  idetected = 1;
  while idetected <= 40 % size(detectedTrace3d, 1)
    
    detectedLocation = detectedTrace3d(idetected, :);
    if (detectedLocation(1)==0 && detectedLocation(2)==0 && ...
            detectedLocation(3) == -1)
        isObjectDetected = false;
    else
        isObjectDetected = true;
    end
    
    if ~isTrackInitialized
      if isObjectDetected % First detection.
%         kalmanFilter = configureKalmanFilter('ConstantAcceleration', ...
%           detectedLocation(1,:), [1 1 1]*1e5, [25, 10, 1], 25);
        kalmanFilter = configureKalmanFilter('ConstantAcceleration', ...
          detectedLocation(1,:), [1 1 1]*1e5, [15, 8, 1], 65);
%         kalmanFilter = configureKalmanFilter('ConstantVelocity', ...
%           detectedLocation(1,:), [1 1 ]*1e5, [25, 1], 525);
        isTrackInitialized = true;
        filteredTrace3d = [filteredTrace3d; detectedLocation(1,:)];
      end
      label = ''; circle = []; % initialize annotation properties
    else  % A track was initialized and therefore Kalman filter exists
      if isObjectDetected % Object was detected
        % Reduce the measurement noise by calling predict, then correct
        predict(kalmanFilter);
        trackedLocation = correct(kalmanFilter, detectedLocation(1,:));
        label = 'Corrected';
        addpoints(h1,trackedLocation(1),...
            trackedLocation(2), trackedLocation(3));
      else % Object is missing
        trackedLocation = predict(kalmanFilter);  % Predict object location
        label = 'Predicted';
        addpoints(h1,trackedLocation(1),...
            trackedLocation(2), trackedLocation(3));
      end
      circle = [trackedLocation, 5];
      filteredTrace3d = [filteredTrace3d; trackedLocation];      
    end    
    
    idetected = idetected + 1;

    %% drawnow
     addpoints(h, detectedLocation(1),...
         detectedLocation(2), detectedLocation(3));     
%     pause 
     drawnow 
%     colorImage = insertObjectAnnotation(colorImage, 'circle', ...
%       circle, label, 'Color', 'red'); % mark the tracked object
    
  end % while
%
save('./results/sh8occFil40fs.mat', 'filteredTrace3d');
csvwrite('.\results\sh8occFil40fs.txt', filteredTrace3d);
 