% % train time = sampleStateNumber/(400*dt) + maxIteration/4 (s)
% 
% 
% clear;
clf;
%% time
Time = 0;
dt = 0.05;
stopTime = 600;
%% iRobot
for s_gi = 1:10
    s_g_mult(s_gi) = iRobotCreator(10+cos(2*pi*s_gi/10),10+sin(2*pi*s_gi/10),2*pi*s_gi/10,'.b');% x,y,theta,color
end

% s_g_mult(1) = iRobotCreator(10,10,pi/2,'.b');% x,y,theta,color
% s_g_mult(2) = iRobotCreator(9,9,pi,'.r');
% s_g_mult(3) = iRobotCreator(9,9,pi,'.r');
%% quadrotor
s_f = quadrotorCreator(10,0);% x,y
%% touch
touchType = 0;% 0-null,1-topTouch,2-collision
%% main
disp('Main Start');
for Time = 0:dt:stopTime
    [s_f,s_gTarNum] = quadrotorCreateAction_mult(s_f,s_g_mult,maxPisV,pis,Time,3.5);
    s_f = quadrotorAction2Task(s_f,s_g_mult(s_gTarNum),Time,dt);
    s_f = quadrotorTask2Mode(s_f,s_g_mult(s_gTarNum));
    s_f = quadrotorStateUpdata(s_f,dt);
    touchType = touchJudgement(s_f,s_g_mult(s_gTarNum));
    for s_gNum = 1:size(s_g_mult,2)
        if s_gNum == s_gTarNum
            s_g_mult(s_gNum) = iRobotTouch2Mode(touchType,s_g_mult(s_gNum),Time);
        else
            if mod(Time,20) > 18
                s_g_mult(s_gNum).mode = 1;
            else
                s_g_mult(s_gNum).mode = 0;
            end
        end
        s_g_mult(s_gNum) = iRobotStateUpdata(s_g_mult(s_gNum),Time,dt,0);
    end
    displayArea(s_g_mult,s_f,Time,dt/30,s_gTarNum);
end
disp('Main End');