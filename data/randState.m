function [s_g,s_f] = randState(s_g,s_f)
%% iRobot
s_g.theta = rand(1)*2*pi;
s_g.x = rand(1)*20;
s_g.y = rand(1)*20;
%% quadrotor
l = rand(1)*5;
theta_quad2rob = rand(1)*2*pi;
s_f.x = s_g.x + cos(theta_quad2rob) * l;
s_f.y = s_g.y + sin(theta_quad2rob) * l;
s_f.x = min([max([s_f.x,0]),20]);
s_f.y = min([max([s_f.y,0]),20]);
end

% % for test
% for i = 0:100
%     hold on
%     [s_g,s_f] = randState(s_g,s_f);
%     plot([s_g.x,s_f.x],[s_g.y,s_f.y]);
%     plot(s_g.x,s_g.y,'or');
%     plot(s_f.x,s_f.y,'*b');
% end