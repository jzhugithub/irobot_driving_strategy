function [firTurn,secTurn] = computeEnd(s_g,Time)
%% variable definition
omega = pi/2;
normTime = mod(Time,20);
%% compute end
firTurn.x = 0;
firTurn.y = 0;
secTurn.x = 0;
secTurn.y = 0;
if normTime<18
    firTurn.x = s_g.x + cos(s_g.theta) * s_g.v * (18-normTime);
    firTurn.y = s_g.y + sin(s_g.theta) * s_g.v * (18-normTime);
    secTurn.x = s_g.x - cos(s_g.theta) * s_g.v * normTime;
    secTurn.y = s_g.y - sin(s_g.theta) * s_g.v * normTime;
else
    firTurn.x = s_g.x;
    firTurn.y = s_g.y;
    secTurn.x = firTurn.x + cos(s_g.theta - omega * (20-normTime)) * s_g.v * 18;
    secTurn.y = firTurn.y + sin(s_g.theta - omega * (20-normTime)) * s_g.v * 18;
end
center.x = (firTurn.x + secTurn.x)/2;
center.y = (firTurn.y + secTurn.y)/2;
minX = min(firTurn.x,secTurn.x);
minY = min(firTurn.y,secTurn.y);
maxX = max(firTurn.x,secTurn.x);
maxY = max(firTurn.y,secTurn.y);
end