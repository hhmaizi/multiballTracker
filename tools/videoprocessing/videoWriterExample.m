videoFReader = vision.VideoFileReader('viplanedeparture.avi');
videoFWriter = vision.VideoFileWriter('myFile.avi',...
                                      'FrameRate',...
                                      videoFReader.info.VideoFrameRate);

for i=1:50
    videoFrame = step(videoFReader);
    step(videoFWriter, videoFrame);
end

release(videoFReader);
release(videoFWriter);