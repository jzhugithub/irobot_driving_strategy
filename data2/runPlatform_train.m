% % train time = sampleStateNumber/(430*dt) + maxIteration/4 (s)
% 
% 
% clear;
clf;
%% time
Time = 0;
dt = 0.05;
stopTime = 600;
%% iRobot
s_g = iRobotCreator(10,10,pi/2,[0 0 1]);% x,y,theta,color
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
sampleStateNumber = 250000;
stateDim = [16,10,3,5];% thetag Tg Dg l
stateNum = prod(stateDim);
actionNum = 3;%action
Nsas2 = zeros(stateNum,actionNum,stateNum);
Nsa = zeros(stateNum,actionNum);
Psas2 = zeros(stateNum,actionNum,stateNum);
Rsas2 = zeros(stateNum,actionNum,stateNum);
Rsa = zeros(stateNum,actionNum);
Rsa_num = zeros(stateNum,actionNum);
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
    i
    % randomState
    [startS_g,startS_f] = randState(startS_g,startS_f);
    startTime = 20*rand(1);
    % startDState
    startDState = stateDiscretize(stateDim,startS_f,startS_g,startTime);
    % run sample
    for thisAction = 1:actionNum
        tempS_g = startS_g;
        tempS_f = startS_f;
%         figure(1)%%%%%%%%%%% for debug
%         clf;%%%%%%%%%%% for debug
%         figure(2)%%%%%%%%%%% for debug
%         clf;%%%%%%%%%%% for debug
        tempAction = thisAction;
        resetFlag = 1;
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
            tempS_g = iRobotTouch2Mode(touchType,tempS_g,Time,resetFlag);
            tempS_g = iRobotStateUpdata(tempS_g,Time,dt,1);
%             displayArea(tempS_g,tempS_f,Time,dt*5,1);%%%%%%%%%%% for debug
            resetFlag = 0;
            if tempS_f.decisionFlag == 1 && tempS_g.mode == 0
                break;
            end
        end
        % endDState
        endS_f = tempS_f;
        endS_g = tempS_g;
        endTime = Time;
        endDState = stateDiscretize(stateDim,endS_f,endS_g,endTime);
        % Nsas2
        tempNsas2Count = Nsas2(startDState.id,thisAction,endDState.id) + 1;
        Nsas2(startDState.id,thisAction,endDState.id) = tempNsas2Count;
        % reward
        reward = rewardCompute(thisAction,startS_g,endS_g,startTime,endTime,startDState.d);
        % Rsa_num
        tempRsa_numItem = Rsa_num(startDState.id,thisAction) + reward;
        Rsa_num(startDState.id,thisAction) = tempRsa_numItem;
    end
end
% Nsa
Nsa = sum(Nsas2,3);
Nsa = max(0.00001,Nsa);
for is = 1:stateNum
    for ia = 1:actionNum
        % Psas2
        Psas2(is,ia,:) = Nsas2(is,ia,:)/Nsa(is,ia);
        % Rsa
        Rsa(is,ia) = Rsa_num(is,ia)/Nsa(is,ia);
    end
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rsa = zeros(stateNum,actionNum);
% tarS1 = (7-1)*stateDim(2)*stateDim(3)*stateDim(4) + ...
%     (8-1)*stateDim(3)*stateDim(4) + ...
%     (1-1)*stateDim(4) + ...
%     1;
% tarS2 = (7-1)*stateDim(2)*stateDim(3)*stateDim(4) + ...
%     (7-1)*stateDim(3)*stateDim(4) + ...
%     (1-1)*stateDim(4) + ...
%     1;
% % Rsa(tarS1,2) = 1;
% Rsa(tarS2,2) = 1;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
save('MDP-solve P R');
disp('MDP-solve P R End');
% pause();
%% MDP-solve V
disp('MDP-solve V Start');
% variable definition
maxIteration = 1000;
gamma = 0;
gammaHover = 0;
V = zeros(1,1,stateNum);% thetag Tg Dg l
V2 = V;% V(s')
% solve V
for iter = 1:maxIteration
    for is = 1:stateNum
        for ia = 1:actionNum
            tempPV = sum(Psas2(is,ia,:) .* V);
            if ia == 1
                tempItem = gammaHover * tempPV;
            else
                tempItem = gamma * tempPV;
            end
            Va(ia) = Rsa(is,ia) + tempItem;
        end
        V(1,1,is) = max(Va);
    end
    iter
    error = sum(sum(sum(sum(abs(V-V2)))))
    if error<1e-20
        break;
    end
    V2 = V;
end
disp('MDP-solve V End');
%% MDP-solve pis
disp('MDP-solve pis Start');
% variable definition
pis = zeros(stateNum,1);% thetag Tg Dg l
maxPisV = zeros(stateNum,1);% thetag Tg Dg l
for is = 1:stateNum
    for ia = 1:actionNum
        sumPV = sum(Psas2(is,ia,:) .* V);
        pisa(ia) = sumPV;
    end
    [maxPisV(is),pis(is)] = max(pisa);
end
disp('MDP-solve pis End');
save('MDP-solve V pis');