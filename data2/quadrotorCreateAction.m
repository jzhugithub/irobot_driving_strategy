function [s_f]=quadrotorCreateAction(stateDim,s_f,s_g,maxPisV,pis,Time,minDoingValue,decisionDt)
% 0-null,1-hover,2-headTouch,3-topTouch,4-trace
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
    

    if norm([s_f.x-s_g.x s_f.y-s_g.y])>5
        s_f.action = 4;
    elseif mod(Time,20)>14
        s_f.action = 4;
    else
        dState = stateDiscretize(stateDim,s_f,s_g,Time);
        selectPisValue = maxPisV(dState.id);
        if selectPisValue > minDoingValue
            s_f.action = pis(dState.id);
            action = pis(dState.id)
            selectPisValue
            norTime = mod(Time,20)
        else
            s_f.action = 1;
        end
    end
    lastDecisionTime = Time;
else
    s_f.action = 0;
end
end
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