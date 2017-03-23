% % train time = sampleStateNumber/(400*dt) + maxIteration/4 (s)
% 
% 
% clear;
figure(1)
clf;
figure(2)
clf;
%% video
global aviobj;
aviobj = VideoWriter('strategy_sim','MPEG-4');
aviobj.FrameRate = 10;
open(aviobj);
%% time
Time = 0;
dt = 0.05;
stopTime = 600;
%% iRobot
for s_gi = 1:10
    s_g_mult(s_gi) = iRobotCreator(10+cos(2*pi*s_gi/10),10+sin(2*pi*s_gi/10),2*pi*s_gi/10,'.b');% x,y,theta,color
end
s_g_mult(1).color = [0 0 0];
s_g_mult(3).color = [1 .6 .6];
s_g_mult(5).color = [0 .5 0];
s_g_mult(7).color = [0 0 .5];
s_g_mult(9).color = [.6 .6 1];
s_g_mult(2).color = [.5 0 0];
s_g_mult(4).color = [1 0 1];
s_g_mult(6).color = [.6 1 .6];
s_g_mult(8).color = [0 1 1];
s_g_mult(10).color = [1 1 0];


% s_g_mult(1) = iRobotCreator(10,10,pi/2,'.b');% x,y,theta,color
% s_g_mult(2) = iRobotCreator(9,9,pi,'.r');
% s_g_mult(3) = iRobotCreator(9,9,pi,'.r');
%% quadrotor
s_f = quadrotorCreator(10,0);% x,y
%% touch
touchType = 0;% 0-null,1-topTouch,2-collision
%% main
disp('Main Start');
resetFlag = 1;
for Time = 0:dt:stopTime
    [s_f,s_gTarNum] = quadrotorCreateAction_mult(stateDim,s_f,s_g_mult,maxPisV,pis,Rsa,Time,1.5,1);
    s_f = quadrotorAction2Task(s_f,s_g_mult(s_gTarNum),Time,dt);
    s_f = quadrotorTask2Mode(s_f,s_g_mult(s_gTarNum));
    s_f = quadrotorStateUpdata(s_f,dt);
    touchType = touchJudgement(s_f,s_g_mult(s_gTarNum));
    for s_gNum = 1:size(s_g_mult,2)
        if s_gNum == s_gTarNum
            s_g_mult(s_gNum) = iRobotTouch2Mode(touchType,s_g_mult(s_gNum),Time,resetFlag);
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
    resetFlag = 0;
end
% close video
close(aviobj);

disp('Main End');