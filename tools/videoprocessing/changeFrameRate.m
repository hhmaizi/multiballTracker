%% Change Video Frame Rate
% changeFrameRate(videoIn, videoOut, frameRate)
% videoIn is the source video file
% videoOut is the target video file with a desired frameRate
% frameRate specifies the video Frame Rate
function changeFrameRate(videoIn, videoOut, frameRate)
%% 
% videoIn is the source video file
% videoOut is the target video file with a desired frameRate
% frameRate specifies the video Frame Rate

stat =false;
%% create a videoReader object
readerObj = vision.VideoFileReader(videoIn);

%% create a videoPlayer object
videoPlayer = vision.VideoPlayer('Position', [100, 100, 500, 400]);

%% create a videoWriter object
writerObj = vision.VideoFileWriter(videoOut);
writerObj.FrameRate = frameRate;

while ~isDone(readerObj)
    frame = step(readerObj);
    step(writerObj, frame);
    step(videoPlayer, frame)    
end

%%
% release all the resources
release(readerObj);
release(writerObj);
release(videoPlayer);

stat = true;