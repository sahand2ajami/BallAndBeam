function [jerk_metric, speed_metric] = traj_analysis(trajectory)
% TRAJ_ANALYSIS Summary of this function goes here
%   Detailed explanation goes here
% speed_metric = 0
% jerk_metric = 0
x = trajectory.X; % x position
y = trajectory.Y; % y position
z = trajectory.Z; % z position

traj_3D = sqrt(x.^2 + y.^2 + z.^2);
time = seconds(trajectory.Time);

dt = diff(time);
dt_mean = mean(dt);

x = my_filter(dt_mean, x);
y = my_filter(dt_mean, y);
z = my_filter(dt_mean, z);

%% Velocity calculation
dx = diff(x);  % change in x position
dy = diff(y);  % change in y position
dz = diff(z);  % change in z position
% % dtraj_3D = sqrt(dx.^2 + dy.^2 + dz.^2);
% dtraj_3D = diff(traj_3D);
% % % 
vx = dx ./ dt;
vy = dy ./ dt;
vz = dz ./ dt;

vx = my_filter(dt_mean, vx);
vy = my_filter(dt_mean, vy);
vz = my_filter(dt_mean, vz);
v3D = sqrt(vx.^2 + vy.^2 + vz.^2);

mean_vx = mean(abs(vx)); 
mean_vy = mean(abs(vy));
mean_vz = mean(abs(vz));
mean_vel = mean(abs(v3D));

peak_vx = max(abs(vx));
peak_vy = max(abs(vy));
peak_vz = max(abs(vz));
peak_vel = max(abs(v3D));

% The Speed Metric (SM) is measured as the ratio between the mean velocity
% and the peak of velocity [1]
% The SM value increases when movement smoothness increases
speed_metric = mean_vel ./ peak_vel

%% Acceleration calculation
ddx = diff(vx);  % change in x position
ddy = diff(vy);  % change in y position
ddz = diff(vz);  % change in z position
% % ddtraj_3D = sqrt(ddx.^2 + ddy.^2 + ddz.^2);
% ddtraj_3D = diff(dtraj_3D);
ddt = dt(2:end);  % time intervals
% % 
ax = ddx ./ ddt; 
ay = ddy ./ ddt;
az = ddz ./ ddt;

ax = my_filter(dt_mean, ax);
ay = my_filter(dt_mean, ay);
az = my_filter(dt_mean, az);
a3D = sqrt(ax.^2 + ay.^2 + az.^2);
%

%% Jerk calculation
dddx = diff(ax);  % change in x position
dddy = diff(ay);  % change in y position
dddz = diff(az);  % change in z position
% % dddtraj_3D = sqrt(dddx.^2 + dddy.^2 + dddz.^2);
% dddtraj_3D = diff(ddtraj_3D);
dddt = dt(3:end);  % time intervals
% 
jx = dddx ./ dddt; 
jy = dddy ./ dddt;
jz = dddz ./ dddt;

jx = my_filter(dt_mean, jx);
jy = my_filter(dt_mean, jy);
jz = my_filter(dt_mean, jz);

j3D = sqrt(jx.^2 + jy.^2 + jz.^2);
% % a3D = sqrt(ax.^2 + ay.^2 + az.^2);
% % 
% 
jerk = j3D;
velocity = v3D(3:end);
% dt = mean(dt);
% figure
% 
% figure
% plot(time(4:end), velocity)
% title("Velocity")
% figure
% plot(time(4:end), jerk)
% title("Jerk")
% Assuming jerk and velocity are both column vectors [nx1]
% and dt is the time step between samples
% Calculate the integral of the square of the jerk over time
% disp("size jerk")
% size(jerk)
% disp("size vel")
% size(velocity)
jerk_squared_integral = sum(jerk.^2) * dt_mean;
% 
% % Calculate the integral of the square of the velocity over time
velocity_squared_integral = sum(velocity.^2) * dt_mean;
% 
% % Calculate the duration of the movement
T = length(jerk) * dt_mean;
% T = time(end);
% 
% % Calculate the Normalized Jerk (NJ)
NJ = sqrt( (1/2) * jerk_squared_integral ./ (velocity_squared_integral.^(5/2)) );
% disp("size NJ")
% size(NJ)
jerk_metric = NJ;

% [1]: Scalona, Emilia, et al. "Perturbed point-to-point reaching tasks in 
% a 3d environment using a portable haptic device." 
% Electronics 8.1 (2019): 32.
end

