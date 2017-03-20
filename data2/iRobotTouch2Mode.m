function s_g = iRobotTouch2Mode(touchType,s_g,Time,resetFlag)
%% variable definition
periodTime = mod(Time,20);
persistent modeEndTime savetouchType canTouch;
if isempty(modeEndTime)
   modeEndTime = -1;
end
if isempty(savetouchType)
   savetouchType = 0;
end
if isempty(canTouch)
   canTouch = 0;
end
if resetFlag == 1
    savetouchType = 0;
end
%% touchType handle
% touchType 0-null,1-topTouch,2-collision
if touchType == 1 && periodTime<17.5 && savetouchType == 0 && s_g.mode == 0 && canTouch == 1% topTouch
    modeEndTime = Time + 0.5;
    savetouchType = 1;
    canTouch = 0;
%     disp('iRobot: topTouch');
end
if touchType == 2 && periodTime<16 && savetouchType == 0 && s_g.mode == 0% collision
    modeEndTime = Time + 2;
    savetouchType = 2;
    canTouch = 0;
%     disp('iRobot: collision');
end
%% mode handle
% mode 0-move,1-turn
if Time>modeEndTime
    savetouchType = 0;
end

if Time>modeEndTime + 1.5
    canTouch = 1;
end

s_g.mode = 0;
if savetouchType == 1
    s_g.mode = 1;
end
if savetouchType == 2
    s_g.mode = 1;
end

if periodTime>18
    s_g.mode = 1;
end
end