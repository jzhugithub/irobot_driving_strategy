function s_g = iRobotCreator(x,y,theta,color)
s_g.x = x;
s_g.y = y;
s_g.z = 0;
s_g.theta = theta;
s_g.mode = 0;% 0-move,1-turn
s_g.v = 0.33;
s_g.inside = 1;
s_g.color = color;
end