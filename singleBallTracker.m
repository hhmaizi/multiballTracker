%   Example: Track an occluded object
%   ---------------------------------
% param.motionModel           = 'ConstantAcceleration';
%   param.initialLocation       = 'Same as first detection';
%   param.initialEstimateError  = 1E5 * ones(1, 3);
%   param.motionNoise           = [25, 10, 1];
%   param.measurementNoise      = 25;
%   param.segmentationThreshold = 0.05;
%   % Create required System objects
  path = 'E:\repository\datas\videos\multiballs\';
%   videoReader = vision.VideoFileReader('E:\bak\3D×ËÌ¬¹À¼Æ\datas\brightwindow.avi');
  videoReader = vision.VideoFileReader([path 'left.avi']);
  videoPlayer = vision.VideoPlayer('Position', [100, 100, 500, 400]);
  foregroundDetector = vision.ForegroundDetector(...
    'NumTrainingFrames', 10, 'InitialVariance', 0.05);
  blobAnalyzer = vision.BlobAnalysis('AreaOutputPort', false, ...
    'MinimumBlobArea', 70);

  % Process each video frame to detect and track the object
  kalmanFilter = []; isTrackInitialized = false;
  while ~isDone(videoReader)
    colorImage  = step(videoReader); % get the next video frame

    % Detect the object in a gray scale image
    foregroundMask = step(foregroundDetector, rgb2gray(colorImage));
    detectedLocation = step(blobAnalyzer, foregroundMask);
    isObjectDetected = size(detectedLocation, 1) > 0;

    if ~isTrackInitialized
      if isObjectDetected % First detection.
        kalmanFilter = configureKalmanFilter('ConstantAcceleration', ...
          detectedLocation(1,:), [1 1 1]*1e5, [25, 10, 1], 25);
        isTrackInitialized = true;
      end
      label = ''; circle = []; % initialize annotation properties
    else  % A track was initialized and therefore Kalman filter exists
      if isObjectDetected % Object was detected
        % Reduce the measurement noise by calling predict, then correct
        predict(kalmanFilter);
        trackedLocation = correct(kalmanFilter, detectedLocation(1,:));
        label = 'Corrected';
      else % Object is missing
        trackedLocation = predict(kalmanFilter);  % Predict object location
        label = 'Predicted';
      end
      circle = [trackedLocation, 5];
    end

    colorImage = insertObjectAnnotation(colorImage, 'circle', ...
      circle, label, 'Color', 'red'); % mark the tracked object
    step(videoPlayer, colorImage);    % play video
  end % while
% 
  release(videoPlayer); % Release resources
  release(videoReader);
%
%  See also configureKalmanFilter, assignDetectionsToTracks 

%   Copyright  The MathWorks, Inc.
%   Date: 2013/03/31 00:10:03 $
% 
%   References:
% 
%   [1] Greg Welch and Gary Bishop, "An Introduction to the Kalman Filter," 
%       TR95-041, University of North Carolina at Chapel Hill.
%   [2] Samuel Blackman, "Multiple-Target Tracking with Radar
%       Applications," Artech House, 1986.
