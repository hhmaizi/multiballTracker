% clear
% h = animatedline('Color', 'r');
% axis([0,4*pi,-1,1,-1,1])
% 
% x = linspace(0,4*pi,1000);
% y = sin(x);
% z = cos(x);
% a =tic;

clear;
h = animatedline('Color', 'r');
h1 = animatedline('Color', 'b');
axis([-200, 800, -800, 400, 1400, 2100])
load shape8filtered.mat
load shape8.mat
x = shape8(:,1); y = shape8(:, 2); z = shape8(:,3);
x1 = filteredTrace3d(:,1); y1 = filteredTrace3d(:, 2); z1 = filteredTrace3d(:,3);

%%
for k = 1:length(x)
    addpoints(h, x(k),y(k), z(k));
    addpoints(h1,x1(k),y1(k), z1(k));
    pause(0.1)
    drawnow 
end
%%
% clear;
% load shape8filtered.mat
% shape8 = shape8filtered;
% x = shape8(:,1); y = shape8(:, 2); z = shape8(:,3);
% comet3(h,y, z, x);