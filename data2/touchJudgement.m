function touchType = touchJudgement(s_f,s_g)
% touchType 0-null,1-topTouch,2-collision

s_g_head.x = s_g.x + cos(s_g.theta) * 0.2;
s_g_head.y = s_g.y + sin(s_g.theta) * 0.2;
s_g_head.z = s_g.z;

if (s_f.z-s_g_head.z)<0.1 && norm([s_f.x-s_g_head.x s_f.y-s_g_head.y])<0.2
    touchType = 2;
    figure(1)
    plot(s_f.x,s_f.y,'.r','MarkerSize',8);
elseif s_f.topTouchFlag == 1  && s_f.z<0.25 && norm([s_f.x-s_g_head.x s_f.y-s_g_head.y])<0.2
    touchType = 1;
    figure(1)
    plot(s_f.x,s_f.y,'.g','MarkerSize',8);
else
    touchType = 0;
end
end