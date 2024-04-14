function msj = kinematic_jerk_ball(x)

    % Ensure that x is a column vector
    x = x(:);
        % Original signal and sampling rate
        Fs_orig = 90;  % Replace 'your_sampling_rate' with your actual sampling rate
        
        % Desired sampling rate
        Fs_new = 1800;
        
        % Calculate upsample factor
        P = Fs_new / Fs_orig;
        
        % Resample the signal
        x = resample(x, P, 1);
    
    
    dt = 1/Fs_new;
    duration = length(x)*dt;
    t_x = linspace(0,duration,length(x));
    x = smooth(t,x,0.2,'rloess');


    % Calculate the time step based on the sampling frequency
    dt = 1/Fs_new;
    dddx = diff(x, 3) / dt^3;
    duration = length(x)*dt - 3*dt;
    
    t_dddx = linspace(0,duration,length(dddx));
%     length(t)
%     length(x)
    dddx = smooth(t_dddx,dddx,0.1,'rloess');
    f = figure;
    f.Position(2) = 100;
    plot(t_x, x)
    hold on
    plot(t_dddx, dddx)
    % Square of the jerk
    squared_jerk = dddx.^2;
    
    % Numerically integrate the squared jerk using the trapezoidal rule
    integral_squared_jerk = trapz(squared_jerk) * dt;
    
    % Calculate the mean squared jerk (MSJ)
    msj = integral_squared_jerk / (duration * dt);
end


