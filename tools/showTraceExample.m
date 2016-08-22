x = [0 1];
y = [1 1];
numSteps = 100;
% Calculate the trajectory by linear interpolation of the x and y coordinate.
trajectory = [ linspace(x(1),x(2),numSteps); linspace(y(1),y(2),numSteps) ];
% Make figure with axes.
figure; axis square; hold on;
set(gca,'XLim',[-2 2], 'YLim', [-2 2]);
% Make the frames for the movie.
for frameNr = 1 : numSteps
	cla;
	
	% Plot the point.
	plot( trajectory(1,frameNr), trajectory(2,frameNr), 'o' );
	
% 	% Plot the path line.
% 	line( 'XData', [trajectory(1,1) trajectory(1,frameNr)], ...
%           'YData', [trajectory(2,1) trajectory(2,frameNr)] );
	
	% Get the frame for the animation.
	frames(frameNr) = getframe;
end
movie(frames);