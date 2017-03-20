function [s_f] = quadrotorTask2Mode(s_f,s_g)
% task 0-hover,1-track,2-land,3-touch,4-takeoff,5-trace,6-decision
% mode 0-hover,1-move2point,2-land,3-touch,4-takeoff
if s_f.task == 0% hover
    s_f.mode = 0;
elseif s_f.task == 1% track
    s_f.mode = 1;
    s_f.vxy = 2;
    s_f.tx = s_g.x;
    s_f.ty = s_g.y;
elseif s_f.task == 2% land
    s_f.mode = 2;
    s_f.tx = s_g.x + cos(s_g.theta) * 0.5;
    s_f.ty = s_g.y + sin(s_g.theta) * 0.5;
    s_f.vxyLR = 0.4;
    s_f.vz = 1;
elseif s_f.task == 3% touch
    s_f.mode = 3;
elseif s_f.task == 4% takeoff
    s_f.mode = 4;
    s_f.vz = 1;
elseif s_f.task == 5% trace
    s_f.mode = 1;
    s_f.vxy = 2;
    s_f.tx = s_g.x;
    s_f.ty = s_g.y;
end
end