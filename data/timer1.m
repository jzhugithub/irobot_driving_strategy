function endFlag = timer1(dt,setTime,setTimeFlag)
persistent RemainTime;
if isempty(RemainTime)
   RemainTime = 0;
end

if setTimeFlag == 1
    RemainTime = setTime;
else
    RemainTime = RemainTime - dt;
end

if RemainTime <= 0
    endFlag = 1;
else
    endFlag = 0;
end
end