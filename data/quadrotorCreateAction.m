function [s_f]=quadrotorCreateAction(s_f,s_g,maxPisV,pis,Time,minDoingValue)
% 0-null,1-hover,2-headTouch,3-topTouch,4-trace
if s_f.decisionFlag == 1
    s_f.decisionFlag = 0;
    
    if norm([s_f.x-s_g.x s_f.y-s_g.y])>5
        s_f.action = 4;
    else
        dState = stateDiscretize(s_f,s_g,Time);
        selectPisValue = maxPisV(dState.theta,dState.t,dState.d,dState.l);
        if selectPisValue > minDoingValue
            s_f.action = pis(dState.theta,dState.t,dState.d,dState.l);
            selectPisValue
        else
            s_f.action = 1;
        end
        
        
    end
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