function metric = kinematic_smoothness_ball(x)

    % Sampling frequency is 90 Hz
    fs = 90; 

    dt = 1/fs;
    duration = length(x)*dt;
    t = linspace(0,duration,length(x));
    x_smooth = smooth(t,x,0.1,'rloess');
    metric = 1/t(end) * (trapz(x_smooth) * dt);

end

