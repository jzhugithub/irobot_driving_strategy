function displayArea(s_g_mult,s_f,Time,delay,s_gTarNum)
%% plot rate
persistent plotFrame;
if isempty(plotFrame)
   plotFrame = 0;
end
if plotFrame >1
    plotFrame = plotFrame - 1;
    return;
else
    plotFrame = 10;
    figure(1)
%     set(gcf,'color','w');
    %% x-y view
    subplot(1,2,1);
    box on;
    hold on;
    for s_gNum = 1:size(s_g_mult,2)
        iRobotTrace(s_gNum) = plot(s_g_mult(s_gNum).x,s_g_mult(s_gNum).y,s_g_mult(s_gNum).color,'MarkerSize',3);
        iRobot(s_gNum) = plot(s_g_mult(s_gNum).x,s_g_mult(s_gNum).y,'ok','MarkerSize',8);
    end

    TariRobot = plot(s_g_mult(s_gTarNum).x,s_g_mult(s_gTarNum).y,'or','MarkerSize',8);
    quadrotor = plot(s_f.x,s_f.y,'*g','MarkerSize',8);
%     quadrotorTrace = plot(s_f.x,s_f.y,'.g','MarkerSize',3);%%%%%%%%%%% for debug
    [firTurn,secTurn] = computeEnd(s_g_mult(s_gTarNum),Time);
    turn1 = plot(firTurn.x,firTurn.y,'*b');
    turn2 = plot(secTurn.x,secTurn.y,'*r');
    axis([0,20,0,20]);
    %% z view
    subplot(1,2,2);
    box on;
    grid on;
    hold on;
    iRobotZ = plot(Time,s_f.z,'*b','MarkerSize',8);
    axis([Time-20,Time+5,-1,3]);
    %% delete
    pause(delay);
    delete(iRobot,TariRobot,quadrotor,iRobotZ,turn1,turn2);
%     delete(TariRobot,iRobotZ);%%%%%%%%%%% for debug
end
end