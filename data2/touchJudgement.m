function touchType = touchJudgement(s_f,s_g)
% touchType 0-null,1-topTouch,2-collision

s_g_head.x = s_g.x + cos(s_g.theta) * 0.2;
s_g_head.y = s_g.y + sin(s_g.theta) * 0.2;
s_g_head.z = s_g.z;

if norm([s_f.x-s_g_head.x s_f.y-s_g_head.y])<0.2 && (s_f.z-s_g_head.z)<0.1
    touchType = 2;
elseif norm([s_f.x-s_g_head.x s_f.y-s_g_head.y])<0.2 && s_f.z<0.25 && s_f.topTouchFlag == 1
    touchType = 1;
else
    touchType = 0;
end

end