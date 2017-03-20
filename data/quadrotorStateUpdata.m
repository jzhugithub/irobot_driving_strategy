function s_f = quadrotorStateUpdata(s_f,dt)
if s_f.mode == 0% hover
    %s_f = s_f;
elseif s_f.mode == 1% move2point
    s_f.theta = atan2(s_f.ty-s_f.y,s_f.tx-s_f.x);
    
    s_f.x = s_f.x + s_f.vxy * cos(s_f.theta) * dt;
    s_f.y = s_f.y + s_f.vxy * sin(s_f.theta) * dt;
    %s_f.z = s_f.z;
elseif s_f.mode == 2% land
    s_f.theta = atan2(s_f.ty-s_f.y,s_f.tx-s_f.x);
    
    s_f.x = s_f.x + s_f.vxyLR * cos(s_f.theta) * dt;
    s_f.y = s_f.y + s_f.vxyLR * sin(s_f.theta) * dt;
    s_f.z = s_f.z - s_f.vz * dt;
elseif s_f.mode == 3% touch
    %s_f = s_f;
elseif s_f.mode == 4% takeoff
    %s_f.x = s_f.x;
    %s_f.y = s_f.y;
    s_f.z = s_f.z + s_f.vz * dt;
else
    display('s_f.mode error');
end

end