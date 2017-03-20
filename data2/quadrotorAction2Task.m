function [s_f] = quadrotorAction2Task(s_f,s_g,Time,dt)
%% variable definition
persistent modeEndTime saveAction saveSubaction;
if isempty(modeEndTime)
   modeEndTime = 0;
end
if isempty(saveAction)
   saveAction = 0;
end
if isempty(saveSubaction)
   saveSubaction = 0;
end

%% action initialize
% action 0-null,1-hover,2-headTouch,3-topTouch,4-trace
if s_f.action == 0% null
elseif s_f.action == 1% hover
%     disp('action: hover');
    modeEndTime = Time + 0.1;
    saveAction = 1;
elseif s_f.action == 2% headTouch
%     disp('action: headTouch');
    saveAction = 2;
    saveSubaction = 2.1;% track iRobot
elseif s_f.action == 3% topTouch
%     disp('action: topTouch');
    saveAction = 3;
    saveSubaction = 3.1;% track iRobot
elseif s_f.action == 4% trace
%     disp('action: trace');
    saveAction = 4;
else
    disp('s_f.action error');
end
%% action handle
% action 0-null,1-hover,2-headTouch,3-topTouch,4-trace
% task 0-hover,1-track,2-land,3-touch,4-takeoff,5-trace
%% hover
if saveAction == 1
    s_f.task = 0;
    
    % switch action
    if Time>modeEndTime
        s_f.decisionFlag = 1;
    end
end
%% headTouch
% headTouch 2.1-track iRobot 2.2-land 2.3-touch 2.4-takeoff
if saveAction == 2
    
    if saveSubaction == 2.1 % track iRobot
        s_f.task = 1;

        % switch action
        if norm([s_f.x-s_g.x s_f.y-s_g.y])<0.1
            saveSubaction = 2.2;
        end
    elseif saveSubaction == 2.2 % land
        s_f.task = 2;
        
        % switch action
        if s_f.z <= 0
            saveSubaction = 2.3;
            timer1(dt,3,1);% set touch time 
        end
    elseif saveSubaction == 2.3 % touch
        s_f.task = 3;
        
        % switch action
        endFlag = timer1(dt,2,0);
        if endFlag == 1
            saveSubaction = 2.4;
        end
    elseif saveSubaction == 2.4 % takeoff
        s_f.task = 4;
        
        % switch action
        if s_f.z >= 2
            s_f.decisionFlag = 1;
        end
    end
end

%% topTouch
% topTouch 2.1-track iRobot 2.2-land 2.3-touch 2.4-takeoff
if saveAction == 3
    
    if saveSubaction == 3.1 % track iRobot
        s_f.task = 1;

        % switch action
        if norm([s_f.x-s_g.x s_f.y-s_g.y])<0.1
            saveSubaction = 3.2;
        end
    elseif saveSubaction == 3.2 % land
        s_f.task = 2;
        
        % switch action
        if s_f.z <= 0.2
            saveSubaction = 3.3;
            timer1(dt,2,1);% set touch time 
        end
    elseif saveSubaction == 3.3 % touch
        s_f.task = 3;
        s_f.topTouchFlag = 1;
        
        % switch action
        endFlag = timer1(dt,2,0);
        if endFlag == 1
            s_f.topTouchFlag = 0;
            saveSubaction = 3.4;
        end
    elseif saveSubaction == 3.4 % takeoff
        s_f.task = 4;
        
        % switch action
        if s_f.z >= 2
            s_f.decisionFlag = 1;
        end
    end
end
%% trace
if saveAction == 4
    s_f.task = 1;

    % switch action
    if norm([s_f.x-s_g.x s_f.y-s_g.y])<0.2
        s_f.decisionFlag = 1;
    end
end
%% if outside the area
if s_g.inside == 0
    s_f.decisionFlag = 1;
end

end