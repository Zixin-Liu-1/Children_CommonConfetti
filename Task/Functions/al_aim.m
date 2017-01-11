function al_aim(taskParam, parameter)
%AIM   Prints the aim (as a needle) of the cannon

if ~isequal(taskParam.gParam.taskType, 'chinese')
    
    xPredS = ((taskParam.circle.rotationRad-5) *...
        sin(parameter*taskParam.circle.unit));
    yPredS = ((taskParam.circle.rotationRad-5) *...
        (-cos(parameter*taskParam.circle.unit)));
    outcomeCenter = OffsetRect(taskParam.circle.outcCentSpotRect, xPredS,...
        yPredS);
    x = (outcomeCenter(3)/2) + (outcomeCenter(1)/2);
    y = (outcomeCenter(4)/2) + (outcomeCenter(2)/2);
    Screen('DrawLine', taskParam.gParam.window.onScreen, [0 0 0],...
        taskParam.gParam.zero(1), taskParam.gParam.zero(2), x, y, 2);
    
else
    
%     xBegin = ((taskParam.circle.chineseCannonRad - 50) *...
%         sin(parameter*taskParam.circle.unit));
%     yBegin = ((taskParam.circle.chineseCannonRad - 50) *...
%         (-cos(parameter*taskParam.circle.unit)));
%     
    xBegin = ((taskParam.circle.chineseCannonRad - 55) *...
        sin(parameter*taskParam.circle.unit));
    yBegin = ((taskParam.circle.chineseCannonRad - 55) *...
        (-cos(parameter*taskParam.circle.unit)));
    

%     AimBegin = OffsetRect(taskParam.textures.dstRect, xBegin,...
%         yBegin);
 AimBegin = OffsetRect( taskParam.circle.outcCentSpotRect, xBegin,...
        yBegin);    
    
   
    
    xPredS = ((taskParam.circle.rotationRad-5) *...
        sin(parameter*taskParam.circle.unit));
    yPredS = ((taskParam.circle.rotationRad-5) *...
        (-cos(parameter*taskParam.circle.unit)));
    
    outcomeCenter = OffsetRect(taskParam.circle.outcCentSpotRect, xPredS,...
        yPredS);
    
    
    
    x = (outcomeCenter(3)/2) + (outcomeCenter(1)/2);
    y = (outcomeCenter(4)/2) + (outcomeCenter(2)/2);
    
    
     Screen('DrawLine', taskParam.gParam.window.onScreen, [0 0 0],...
         mean([AimBegin(1) AimBegin(3)]),...
         mean([AimBegin(2) AimBegin(4)]), x, y, 3);

  
end

end
