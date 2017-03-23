function [s_f,s_gTarNum]=quadrotorCreateAction_mult(stateDim,s_f,s_g_mult,maxPisV,pis,Rsa,Time,minDoingValue,decisionDt)
% 0-null,1-hover,2-headTouch,3-topTouch,4-trace
persistent lastS_gTarNum;
if isempty(lastS_gTarNum)
   lastS_gTarNum = 1;
end

persistent lastDecisionTime;
if isempty(lastDecisionTime)
   lastDecisionTime = 0;
end
% task 0-hover,1-track,2-land,3-touch,4-takeoff,5-trace
if (Time> lastDecisionTime + decisionDt) && (s_f.task == 0 || s_f.task == 1 || s_f.task == 5)
    s_f.decisionFlag = 1;
    Time
end

if s_f.decisionFlag == 1
    s_f.decisionFlag = 0;
    
    distancef2g = zeros(1,size(s_g_mult,2));
    pisValue = zeros(1,size(s_g_mult,2));
    aPisValue = -10000*ones(1,size(s_g_mult,2));
    for s_gNum = 1:size(s_g_mult,2)
        [firTurn,secTurn] = computeEnd(s_g_mult(s_gNum),Time);
        if firTurn.y<0 || secTurn.y<0
            continue;
        end
        distancef2g(s_gNum) = norm([s_f.x-s_g_mult(s_gNum).x s_f.y-s_g_mult(s_gNum).y]);
        dState(s_gNum) = stateDiscretize(stateDim,s_f,s_g_mult(s_gNum),Time);
        pisValue(s_gNum) = maxPisV(dState(s_gNum).id);
        pisValue(s_gNum) = max(Rsa(dState(s_gNum).id,:));%%%
        aPisValue(s_gNum) = pisValueAdjust(pisValue(s_gNum),distancef2g(s_gNum));% adjust s_g's pisValue whose distance to quadrotor if bigger than 5
    end
    [maxAPisValue,s_gTarNum] = max(aPisValue);
    
    if maxAPisValue > minDoingValue
        s_f.action = pis(dState(s_gTarNum).id);
        [maxValue,s_f.action] = max(Rsa(dState(s_gTarNum).id,:));%%%
        maxAPisValue
    else
        s_f.action = 1;
    end

    if norm([s_f.x-s_g_mult(s_gTarNum).x s_f.y-s_g_mult(s_gTarNum).y])>5
        s_f.action = 4;
%     elseif mod(Time,20)>16
%         s_f.action = 1;
    end
    
    lastS_gTarNum = s_gTarNum;
    lastDecisionTime = Time;
else
    s_gTarNum = lastS_gTarNum;
    s_f.action = 0;
end
end

% function [s_f,s_gTarNum]=quadrotorCreateAction_mult(stateDim,s_f,s_g_mult,maxPisV,pis,Time,minDoingValue)
% % 0-null,1-hover,2-headTouch,3-topTouch,4-trace
% persistent lastS_gTarNum;
% if isempty(lastS_gTarNum)
%    lastS_gTarNum = 1;
% end
% if s_f.decisionFlag == 1
%     s_f.decisionFlag = 0;
%     
%     distancef2g = zeros(1,size(s_g_mult,2));
%     pisValue = zeros(1,size(s_g_mult,2));
%     aPisValue = zeros(1,size(s_g_mult,2));
%     for s_gNum = 1:size(s_g_mult,2)
%         distancef2g(s_gNum) = norm([s_f.x-s_g_mult(s_gNum).x s_f.y-s_g_mult(s_gNum).y]);
%         dState(s_gNum) = stateDiscretize(stateDim,s_f,s_g_mult(s_gNum),Time);
%         pisValue(s_gNum) = maxPisV(dState(s_gNum).id);
%         aPisValue(s_gNum) = pisValueAdjust(pisValue(s_gNum),distancef2g(s_gNum));% adjust s_g's pisValue whose distance to quadrotor if bigger than 5
%     end
%     [maxAPisValue,s_gTarNum] = max(aPisValue);
%     
%     if maxAPisValue > minDoingValue
%         s_f.action = pis(dState(s_gTarNum).id);
%         maxAPisValue
%     else
%         s_f.action = 1;
%     end
%     if mod(Time,20)>15
%         s_f.action = 1;
%     end
%     if norm([s_f.x-s_g_mult(s_gTarNum).x s_f.y-s_g_mult(s_gTarNum).y])>5
%         s_f.action = 4;
%     end
%     
%     lastS_gTarNum = s_gTarNum;
% else
%     s_gTarNum = lastS_gTarNum;
%     s_f.action = 0;
% end
% end






% % 0-null,1-hover,2-headTouch,3-topTouch,4-trace
% if s_f.decisionFlag == 1
%     s_f.decisionFlag = 0;
%     
%     if norm([s_f.x-s_g.x s_f.y-s_g.y])>5
%         s_f.action = 4;
%     else
%         flag = rand(1);
%         if flag >=0 && flag<0.33
%             s_f.action = 1;
%         elseif flag >=0.33 && flag<0.66
%             s_f.action = 2;
%         else
%             s_f.action = 3;
%         end
%     end
% else
%     s_f.action = 0;
% end
% end