% % train time = sampleStateNumber/(400*dt) + maxIteration/4 (s)
% 
% 
% clear;
clf;
%% time
Time = 0;
dt = 0.04;
stopTime = 600;
%% iRobot
s_g = iRobotCreator(10,10,3,'.b');% x,y,theta,color
% s_g.mode = 0;% 0-move,1-turn
%% quadrotor
s_f = quadrotorCreator(0,0);% x,y
% s_f.topTouchFlag = 0;% 0-null,1-topTouch;
% s_f.action = 0;% 0-null,1-hover,2-headTouch,3-topTouch,4-trace
% s_f.task = 0;% 0-hover,1-track,2-land,3-touch,4-takeoff,5-trace
% s_f.mode = 0;% 0-hover,1-move2point,2-land,3-touch,4-takeoff
%% touch
touchType = 0;% 0-null,1-topTouch,2-collision
%% main
disp('Main Start');
resetFlag = 1;
for Time = 0:dt:stopTime
    s_f = quadrotorCreateAction(stateDim,s_f,s_g,maxPisV,pis,Time,0,1);
    s_f = quadrotorAction2Task(s_f,s_g,Time,dt);
    s_f = quadrotorTask2Mode(s_f,s_g);
    s_f = quadrotorStateUpdata(s_f,dt);
    touchType = touchJudgement(s_f,s_g);
    s_g = iRobotTouch2Mode(touchType,s_g,Time,resetFlag);
    s_g = iRobotStateUpdata(s_g,Time,dt,0);
    displayArea(s_g,s_f,Time,dt/1,1);
    resetFlag = 0;
end
disp('Main End');