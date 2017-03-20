function discState = stateDiscretize(stateDim,s_f,s_g,Time)
%% theta
s_g.theta = mod(s_g.theta,2*pi);
discState.theta = floor((s_g.theta+pi*3/8) / (pi/4));
if discState.theta>8
    discState.theta = 1;
end
%% t
Time = mod(Time,20);
discState.t = max([min([ceil(Time/2),10]),1]);
% max([1,floor((Time+1.99)/2)]);
%% d 
discState.d = 1;
% if s_g.x>18
%     discState.d = 2;
% elseif s_g.x<2
%     discState.d = 3;
% end
%% l
discState.l = ceil(norm([s_g.x-s_f.x s_g.y-s_f.y]));
discState.l = max([min([discState.l,5]),1]);
%% id
discState.id = (discState.theta-1)*stateDim(2)*stateDim(3)*stateDim(4) + ...
    (discState.t-1)*stateDim(3)*stateDim(4) + ...
    (discState.d-1)*stateDim(4) + ...
    discState.l;
end