videoFReader = vision.VideoFileReader('occ-line.avi');
videoPlayer = vision.VideoPlayer;
while ~isDone(videoFReader)
  videoFrame = step(videoFReader);
  step(videoPlayer, videoFrame);
  videoPlayer.getNumOutputs()
end
release(videoPlayer);
release(videoFReader);