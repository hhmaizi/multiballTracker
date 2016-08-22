function stat =  videoCut(videoIn, videoOut,startFrame, endFrame, frameRate)
%% read videoIn and cut part of it and write the cut to videoOut
%
%
% vIn = 'E:\repository\datas\videos\3glasses\leftconv.avi'
% vOut = 'left50-150.avi'
stat = false;
%% create a videoReader object
readerObj = vision.VideoFileReader(videoIn);

%% create a videoPlayer object
videoPlayer = vision.VideoPlayer('Position', [100, 100, 500, 400]);

%% create a videowriter object
writerObj = vision.VideoFileWriter(videoOut);

for indFrame = 1:endFrame
    frame = step(readerObj);
    if indFrame > startFrame            
        step(writerObj, frame);        
    end
%     writerObj.FrameCount
    step(videoPlayer, frame);
end

release(readerObj);
release(videoPlayer);
release(writerObj);

stat = true;