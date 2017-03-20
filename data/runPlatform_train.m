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
s_g = iRobotCreator(10,10,pi/2,'.b');% x,y,theta,color
% s_g.mode = 0;% 0-move,1-turn
%% quadrotor
s_f = quadrotorCreator(0,0);% x,y
% s_f.topTouchFlag = 0;% 0-null,1-topTouch;
% s_f.action = 0;% 0-null,1-hover,2-headTouch,3-topTouch,4-trace
% s_f.task = 0;% 0-hover,1-track,2-land,3-touch,4-takeoff,5-trace
% s_f.mode = 0;% 0-hover,1-move2point,2-land,3-touch,4-takeoff
%% touch
touchType = 0;% 0-null,1-topTouch,2-collision
%% MDP-solve P R
disp('MDP-solve P R Start');
% variable definition
sampleStateNumber = 5000;
stateDim = [8,10,3,5];% thetag Tg Dg l
actionDim = 3;%action
Nsas2 = zeros([stateDim,actionDim,stateDim]);
Nsa = zeros([stateDim,actionDim]);
Psas2 = zeros([stateDim,actionDim,stateDim]);
Rsas2 = zeros([stateDim,actionDim,stateDim]);
Rsa = zeros([stateDim,actionDim]);
Rsa_num = zeros([stateDim,actionDim]);
startTime = 0;
endTime = 0;
startS_g = s_g;
startS_f = s_f;
endS_g = s_g;
endS_f = s_f;
% startDState
% endDState
thisAction = 0;
% sample
for i = 1:sampleStateNumber
    % randomState
    [startS_g,startS_f] = randState(startS_g,startS_f);
    startTime = rand(1)*20;
    % startDState
    startDState = stateDiscretize(startS_f,startS_g,startTime);
    % run sample
    for thisAction = 1:actionDim
        tempS_g = startS_g;
        tempS_f = startS_f;
%         figure(1)%%%%%%%%%%% for debug
%         clf;%%%%%%%%%%% for debug
%         figure(2)%%%%%%%%%%% for debug
%         clf;%%%%%%%%%%% for debug
        tempAction = thisAction;
        for Time = startTime:dt:40
            if tempAction ~= 0
                tempS_f.action = tempAction;
                tempS_f.decisionFlag = 0;
                tempAction = 0;
            else
                tempS_f.action = 0;
            end
            tempS_f = quadrotorAction2Task(tempS_f,tempS_g,Time,dt);
            tempS_f = quadrotorTask2Mode(tempS_f,tempS_g);
            tempS_f = quadrotorStateUpdata(tempS_f,dt);
            touchType = touchJudgement(tempS_f,tempS_g);
            tempS_g = iRobotTouch2Mode(touchType,tempS_g,Time);
            tempS_g = iRobotStateUpdata(tempS_g,Time,dt,1);
%             displayArea(tempS_g,tempS_f,Time,dt*5,1);%%%%%%%%%%% for debug
            if tempS_f.decisionFlag == 1
                break;
            end
        end
        % endDState
        endS_f = tempS_f;
        endS_g = tempS_g;
        endTime = Time;
        endDState = stateDiscretize(endS_f,endS_g,endTime);
        % Nsas2
        tempNsas2Count = Nsas2(startDState.theta,startDState.t,startDState.d,startDState.l,thisAction,endDState.theta,endDState.t,endDState.d,endDState.l);
        tempNsas2Count = tempNsas2Count + 1;
        Nsas2(startDState.theta,startDState.t,startDState.d,startDState.l,thisAction,endDState.theta,endDState.t,endDState.d,endDState.l) = tempNsas2Count;
        % Nsa
        tempNsaCount = Nsa(startDState.theta,startDState.t,startDState.d,startDState.l,thisAction);
        tempNsaCount = tempNsaCount + 1;
        Nsa(startDState.theta,startDState.t,startDState.d,startDState.l,thisAction) = tempNsaCount;
        % Psas2
        Psas2(startDState.theta,startDState.t,startDState.d,startDState.l,thisAction,endDState.theta,endDState.t,endDState.d,endDState.l) = tempNsas2Count/tempNsaCount;
        % Rsas2
        reward = rewardCompute(startS_g,endS_g,startDState.d,startTime,endTime);
        Rsas2(startDState.theta,startDState.t,startDState.d,startDState.l,thisAction,endDState.theta,endDState.t,endDState.d,endDState.l) = reward;
        % Rsa_num
        tempRsa_numItem = Rsa_num(startDState.theta,startDState.t,startDState.d,startDState.l,thisAction);
        tempRsa_numItem = tempRsa_numItem + reward;
        Rsa_num(startDState.theta,startDState.t,startDState.d,startDState.l,thisAction) = tempRsa_numItem;
        % Rsa
        Rsa(startDState.theta,startDState.t,startDState.d,startDState.l,thisAction) = tempRsa_numItem/tempNsaCount;
        
    end
end
save('MDP-solve P R');
disp('MDP-solve P R End');
pause();
%% MDP-solve V
disp('MDP-solve V Start');
% variable definition
maxIteration = 1000;
gamma = 0;
gammaHover = 0;
V = zeros(stateDim);% thetag Tg Dg l
V2 = V;
% solve V
for iter = 1:maxIteration
    for i1 = 1:8
        for i2 = 1:10
            for i3 = 1:3
                for i4 = 1:5
                    for ia = 1:3
                        rearange = permute(Psas2(i1,i2,i3,i4,ia,:,:,:,:),[6,7,8,9,1,2,3,4,5]);
                        if ia == 1
                            tempItem = gammaHover * sum(sum(sum(sum(rearange .* V))));
                        else
                            tempItem = gamma * sum(sum(sum(sum(rearange .* V))));
                        end
                        Va(ia) = Rsa(i1,i2,i3,i4,ia) + tempItem;
                    end
                    V(i1,i2,i3,i4) = max(Va);
                end
            end
        end
    end
    error = sum(sum(sum(sum(abs(V-V2)))))
    if error<1e-20
        break;
    end
    V2 = V;
    iter
end
disp('MDP-solve V End');
%% MDP-solve pis
disp('MDP-solve pis Start');
% variable definition
pis = zeros(stateDim);% thetag Tg Dg l
maxPisV = zeros(stateDim);% thetag Tg Dg l
for i1 = 1:8
    for i2 = 1:10
        for i3 = 1:3
            for i4 = 1:5
                for ia = 1:3
                    rearange = permute(Psas2(i1,i2,i3,i4,ia,:,:,:,:),[6,7,8,9,1,2,3,4,5]);
                    sumPV = sum(sum(sum(sum(rearange .* V))));
                    pisa(ia) = sumPV;
                end
                [maxPisV(i1,i2,i3,i4),pis(i1,i2,i3,i4)] = max(pisa);
            end
        end
    end
end
disp('MDP-solve pis End');
save('MDP-solve V pis');