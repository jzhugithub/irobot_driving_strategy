function s_g = iRobotStateUpdata(s_g,Time,dt,trainFlag)
omega = pi/2;
if s_g.mode == 0 % move
    s_g.x = s_g.x + s_g.v * cos(s_g.theta) * dt;
    s_g.y = s_g.y + s_g.v * sin(s_g.theta) * dt;
    s_g.theta = s_g.theta + randTheta(Time);
elseif s_g.mode == 1 % turn
    s_g.x = s_g.x;
    s_g.y = s_g.y;
    s_g.theta = s_g.theta - omega * dt;
else
    display('s_g.mode error');
end
if trainFlag == 0 % if it's not train
    if s_g.x<0 || s_g.x>20 || s_g.y<0 || s_g.y>20 % outside the area
        s_g.inside = 0;
        s_g.x = 100;
        s_g.y = 100;
    end
end
end