function aPisValue = pisValueAdjust(pisValue,distancef2g)
% adjust s_g's pisValue whose distance to quadrotor if bigger than 5
if distancef2g>5
    aPisValue = pisValue - distancef2g * 10;
else
    aPisValue = pisValue;
end

end