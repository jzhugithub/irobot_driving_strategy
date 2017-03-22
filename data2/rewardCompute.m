function reward = rewardCompute(thisAction,startS_g,endS_g,startTime,endTime,d)
%% hover action
if thisAction == 1
    reward = 0;
    return;
end
%% variable definition
omega = pi/2;
dt = endTime - startTime;
normEndTime = mod(endTime,20);
%% start
startFirTurn.x = 0;
startFirTurn.y = 0;
startSecTurn.x = 0;
startSecTurn.y = 0;
if startTime<18
    startFirTurn.x = startS_g.x + cos(startS_g.theta) * startS_g.v * (18-startTime);
    startFirTurn.y = startS_g.y + sin(startS_g.theta) * startS_g.v * (18-startTime);
    startSecTurn.x = startS_g.x - cos(startS_g.theta) * startS_g.v * startTime;
    startSecTurn.y = startS_g.y - sin(startS_g.theta) * startS_g.v * startTime;
else
    startFirTurn.x = startS_g.x;
    startFirTurn.y = startS_g.y;
    startSecTurn.x = startFirTurn.x + cos(startS_g.theta - omega * (20-startTime)) * startS_g.v * 18;
    startSecTurn.y = startFirTurn.y + sin(startS_g.theta - omega * (20-startTime)) * startS_g.v * 18;
end
startCenter.x = (startFirTurn.x + startSecTurn.x)/2;
startCenter.y = (startFirTurn.y + startSecTurn.y)/2;
startMinX = min(startFirTurn.x,startSecTurn.x);
startMinY = min(startFirTurn.y,startSecTurn.y);
startMaxX = max(startFirTurn.x,startSecTurn.x);
startMaxY = max(startFirTurn.y,startSecTurn.y);
%% end
endFirTurn.x = 0;
endFirTurn.y = 0;
endSecTurn.x = 0;
endSecTurn.y = 0;
if normEndTime<18
    endFirTurn.x = endS_g.x + cos(endS_g.theta) * endS_g.v * (18-normEndTime);
    endFirTurn.y = endS_g.y + sin(endS_g.theta) * endS_g.v * (18-normEndTime);
    endSecTurn.x = endS_g.x - cos(endS_g.theta) * endS_g.v * normEndTime;
    endSecTurn.y = endS_g.y - sin(endS_g.theta) * endS_g.v * normEndTime;
else
    endFirTurn.x = endS_g.x;
    endFirTurn.y = endS_g.y;
    endSecTurn.x = endFirTurn.x + cos(endS_g.theta - omega * (20-normEndTime)) * endS_g.v * 18;
    endSecTurn.y = endFirTurn.y + sin(endS_g.theta - omega * (20-normEndTime)) * endS_g.v * 18;
end
endCenter.x = (endFirTurn.x + endSecTurn.x)/2;
endCenter.y = (endFirTurn.y + endSecTurn.y)/2;
endMinX = min(endFirTurn.x,endSecTurn.x);
endMinY = min(endFirTurn.y,endSecTurn.y);
endMaxX = max(endFirTurn.x,endSecTurn.x);
endMaxY = max(endFirTurn.y,endSecTurn.y);
%% reward
% reward  = startMinY - endMinY;% v4
if d == 1
%     reward  = (startMinY - endMinY)*sqrt((startMinY - endMinY)^2);% v5
    reward  = startMinY - endMinY;% v4
%     reward  = startMinY - endMinY;% v3
%     reward = (startCenter.y - endCenter.y);% v2
%     reward = (startCenter.y - endCenter.y)/dt;% v1
elseif d == 2
%     reward  = (startMinY - endMinY)*sqrt((startMinY - endMinY)^2);% v5
    reward  = startMinX - endMinX;% v4
%     reward  = startMinX - endMinX;% v3
%     reward = (startCenter.x - endCenter.x);% v2
%     reward = (startCenter.x - endCenter.x)/dt;% v1
elseif d == 3
%     reward  = (startMinY - endMinY)*sqrt((startMinY - endMinY)^2);% v5
    reward  = endMinX - startMinX;% v4
%     reward  = endMinX - startMinX;% v3
%     reward = (endCenter.x - startCenter.x);% v2
%     reward = (endCenter.x - startCenter.x)/dt;% v1
else
    disp('startDState.d');
end
reward = reward - 0.05*(endTime-startTime);
%% for debug
% figure(2)
% hold on;
% plot(startS_g.x,startS_g.y,'ob');
% plot(startFirTurn.x,startFirTurn.y,'or');
% plot(startSecTurn.x,startSecTurn.y,'ok');
% 
% plot(endS_g.x,endS_g.y,'*b');
% plot(endFirTurn.x,endFirTurn.y,'*r');
% plot(endSecTurn.x,endSecTurn.y,'*k');

%% 10s after endTime
% if normEndTime < 8
%     endS_g_add10.x = endS_g.x + cos(endS_g.theta) * endS_g.v * 10;
%     endS_g_add10.y = endS_g.y + cos(endS_g.theta) * endS_g.v * 10;
% elseif normEndTime <10
%     endS_g_add10.x = endS_g.x + cos(endS_g.theta) * endS_g.v * (18-normEndTime);
%     endS_g_add10.y = endS_g.y + cos(endS_g.theta) * endS_g.v * (18-normEndTime);
% else
%     endS_g_add10.x = endS_g.x + cos(endS_g.theta) * endS_g.v * (28-2*normEndTime);
%     endS_g_add10.y = endS_g.y + cos(endS_g.theta) * endS_g.v * (28-2*normEndTime);
% end
% %% reward2
% if d == 1
%     reward  = startS_g.y - endS_g_add10.y;
% elseif d == 2
%     reward  = startS_g.x - endS_g_add10.x;
% elseif d == 3
%     reward  = endS_g_add10.y - startS_g.x;
% else
%     disp('startDState.d');
% end
end