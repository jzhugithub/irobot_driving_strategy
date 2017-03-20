function s_f = quadrotorCreator(x,y)
s_f.x = x;
s_f.y = y;
s_f.z = 2;
s_f.theta = 0;
s_f.vxy = 2;
s_f.vxyLR = 0.4;
s_f.vz = 1;
s_f.tx = 0;
s_f.ty = 0;
s_f.decisionFlag = 1;
s_f.topTouchFlag = 0;% 0-null,1-topTouch;
s_f.action = 0;% 0-null,1-hover,2-headTouch,3-topTouch,4-trace
s_f.task = 0;% 0-hover,1-track,2-land,3-touch,4-takeoff,5-trace
s_f.mode = 0;% 0-hover,1-move2point,2-land,3-touch,4-takeoff
end