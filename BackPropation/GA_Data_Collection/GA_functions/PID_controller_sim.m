function [M, Tp, Ts] = PID_controller_sim(kp, ki, kd, plot_flag)
%PID_CONTROLLER_SIM Simulates the step response of a DC electric motor
%given PID controller gains in a closed-loop feedback system.  
%Inputs:   kp - proportional gain
%          ki - integral gain
%          kd - derivative gain
%          plot_flag - "0" for no, "1" for yes of resulting step response
% Outputs: M - Overshoot 
%          Tp - Peak Time
%          Ts - Settling Time

% Define Plant
K = 193; a = 9.96;
Gp_ol = tf([K], [1 a 0]);

% Define Controller
Gc = pid(kp, ki, kd);

% Close the Loop
G = Gc * Gp_ol;
G_cl = G / (1 + G);

% Determine Step Response
t_lim = 2;
[y, t] = step(G_cl, t_lim);

% Determine Step Response Performance
[M, index] = max(y);
Tp = t(index);   

for ii = length(y) : -1 : 1
    if ((y(ii) < 0.98) || (y(ii) > 1.02))
        Ts = t(ii);
        break
    end
end

% Plot Step Response
if (plot_flag == 1)
    figure
    hold on
    plot(t, y, 'r')
    line([0 t(end)], [1 1], 'Color', 'black', 'LineStyle', '--')
    line([t(index) t(index)], [0 M], 'Color', 'blue', 'LineStyle', '--')
    line([Ts Ts], [0 1], 'Color', 'blue', 'LineStyle', '--')
    text(Tp + 0.1, M + 0.01, ['M = ', num2str(M)])
    text(Tp + 0.1, 0.2, ['Tp = ', num2str(Tp), 's'])
    text(Ts + 0.1, 0.1, ['Ts = ', num2str(Ts), 's'])
    title_str = ['k_p = ', num2str(kp), '  k_i = ', num2str(ki), '  k_d = ', num2str(kd)];
    title(['Step Response for PID: ', title_str])
    xlabel('Time (s)')
    ylabel('\theta(t) (rad)')
    grid on
    hold off
end


end

