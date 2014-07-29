function [taskData, Data] = Main(taskParam, vola, sigma, condition, Subject)
% This function acutally runs the task. You can specify "main",
% "practice" or "control". This loop is optimized for triggering accuracy.



%%%
% Check Feedback!
%%%

KbReleaseWait();

% Set port to 0.
%if taskParam.gParam.sendTrigger == true
%   lptwrite(taskParam.triggers.port,0);
%end

%% generateOutcomes
taskData = GenerateOutcomes(taskParam, vola, sigma, condition);

% For trigger testing.
RT_Flip = zeros(taskData.trial, 1);

%% Run trials.

% Enable real-time mode.
% Priority(9); 

for i=1:taskData.trial
    
    taskData.trial(i) = i;
    taskData.age(i) = str2double(Subject.age);
    taskData.ID{i} = Subject.ID;
    taskData.sex{i} = Subject.sex;
    taskData.Date{i} = Subject.Date;
    taskData.cond{i} = condition;
    taskData.cBal{i} = Subject.cBal;
    taskData.rew{i} = Subject.rew;
    if isequal(taskData.rew{i}, '1') && taskData.boatType(i) == 1
        taskData.actRew(i) = 1;
    elseif isequal(taskData.rew{i}, '1') && taskData.boatType(i) == 2
        taskData.actRew(i) = 2;
    elseif isequal(taskData.rew{i}, '2') && taskData.boatType(i) == 1
        taskData.actRew(i) = 2;    
    elseif isequal(taskData.rew{i}, '2') && taskData.boatType(i) == 2
        taskData.actRew(i) = 1;
    end   
    
    
    while 1
        
       if taskData.catchTrial(i) == 1 && taskData.cp(i) == 0 &&(isequal(condition,'main') || isequal(condition,'practice'))
           Cannon(taskParam, taskData.distMean(i))
       end
        
        
        % Start trial - subject predicts boat.
        DrawCircle(taskParam)
        DrawCross(taskParam)
        
        PredictionSpot(taskParam)

        if i > 1 && taskParam.gParam.PE_Bar == true 
           DrawPE_Bar(taskParam, taskData, i-1) 
        end
        Screen('DrawingFinished', taskParam.gParam.window);
        t = GetSecs;
        Screen('Flip', taskParam.gParam.window, t + 0.01);
        
        
        [ keyIsDown, ~, keyCode ] = KbCheck;
        
        if keyIsDown
            if keyCode(taskParam.keys.rightKey)
                if taskParam.circle.rotAngle < 360*taskParam.circle.unit
                    taskParam.circle.rotAngle = taskParam.circle.rotAngle + 0.75*taskParam.circle.unit; %0.02
                else
                    taskParam.circle.rotAngle = 0;
                end
            elseif keyCode(taskParam.keys.rightSlowKey)
                if taskParam.circle.rotAngle < 360*taskParam.circle.unit
                    taskParam.circle.rotAngle = taskParam.circle.rotAngle + 0.1*taskParam.circle.unit; %0.02
                else
                    taskParam.circle.rotAngle = 0;
                end    
            elseif keyCode(taskParam.keys.leftKey)
                if taskParam.circle.rotAngle > 0*taskParam.circle.unit
                    taskParam.circle.rotAngle = taskParam.circle.rotAngle - 0.75*taskParam.circle.unit;
                else
                    taskParam.circle.rotAngle = 360*taskParam.circle.unit;
                end
            elseif keyCode(taskParam.keys.leftSlowKey)
                if taskParam.circle.rotAngle > 0*taskParam.circle.unit
                    taskParam.circle.rotAngle = taskParam.circle.rotAngle - 0.1*taskParam.circle.unit;
                else
                    taskParam.circle.rotAngle = 360*taskParam.circle.unit;
                end    
            elseif keyCode(taskParam.keys.space)
                taskData.pred(i) = (taskParam.circle.rotAngle / taskParam.circle.unit);
                
                % Trigger: prediction.
                Tevent = 1;
                taskData.predT(i) = SendTrigger(taskParam, taskData, condition, vola, i, Tevent);
                time = GetSecs;
                
                break
            end
        end
    end
    t = GetSecs;
    
    
    % Show baseline 1.
    DrawCross(taskParam)
    DrawCircle(taskParam)
    Screen('DrawingFinished', taskParam.gParam.window, 1);
    [VBLTimestamp(i) StimulusOnsetTime(i) FlipTimestamp(i) Missed(i) Beampos(i)] = Screen('Flip', taskParam.gParam.window, t + 0.1, 1)
    RT_Flip(i) = GetSecs-time;
    
    % Calculate prediction error.
    [taskData.predErr(i), taskData.predErrNorm(i), taskData.predErrPlus(i), taskData.predErrMin(i), taskData.rawPredErr(i)] = Diff(taskData.outcome(i), taskData.pred(i));
    %if i > 1 && taskParam.gParam.PE_Bar == true
      
    
    %end
    % Show outcome.
    %background = false
    %Cannonball(taskParam, taskData.distMean(i), taskData.outcome(i), background)
    %Cannonball(taskParam, distMean, outcome, background)
    
    DrawCircle(taskParam)
    PredictionSpot(taskParam)  
    DrawOutcome(taskParam, taskData.outcome(i)) %%TRIGGER
    DrawPE_Bar(taskParam, taskData, i) 
    %PredictionSpot(taskParam) 
    % DrawNeedle(taskParam, taskData.outcome(i)) % Test whether bar is
    % centered around the outcome
    
    Screen('DrawingFinished', taskParam.gParam.window, 1);
    
        
    if isequal(condition,'main') || isequal(condition,'practice')
        % Memory error = 999 because there is no memory error in this condition.
        taskData.memErr(i) = 999;
        taskData.memErrNorm(i) = 999;
        taskData.memErrPlus(i) = 999;
        taskData.memErrMin(i) = 999;
    else
        if i > 1
            % Calculate memory error.
            [taskData.memErr(i), taskData.memErrNorm(i), taskData.memErrPlus(i), taskData.memErrMin(i)] = Diff(taskData.pred(i), taskData.outcome(i-1));
        else
            taskData.memErr(i) = 999;
        end
    end
    
    % Calculate hits
    if isequal(condition,'main') || isequal(condition,'practice')
        if taskData.predErr(i) <= 9
            taskData.hit(i) = 1;
        end
    elseif isequal(condition,'control')
        if taskData.memErr(i) <= 9
            taskData.hit(i) = 1;
        end
    end
    
    if i > 1
        % Calculate update.
        [taskData.UP(i), taskData.UPNorm(i), taskData.UPPlus(i), taskData.UPMin(i)] = Diff(taskData.pred(i), taskData.pred(i-1));
    end
    
    % Trigger: outcome.
    Tevent = 2;
    Screen('Flip', taskParam.gParam.window, t + 0.5);
    taskData.outT(i) = SendTrigger(taskParam, taskData, condition, vola, i, Tevent);
    
    % Show baseline 2.
    DrawCross(taskParam)
    DrawCircle(taskParam)
    Screen('DrawingFinished', taskParam.gParam.window, 1);
    Screen('Flip', taskParam.gParam.window, t + 1.1, 1);
    
    % Show boat and calculate performance.       %TRIGGER
    DrawCircle(taskParam)
    if taskData.boatType(i) == 1
        RewardTxt = Reward(taskParam, 'gold');
        if Subject.rew == '1' && taskData.hit(i) == 1
            taskData.perf(i) = taskParam.gParam.rewMag;  
        end
    else
        RewardTxt = Reward(taskParam, 'silver');
        if Subject.rew == '2' && taskData.hit(i) == 1
            taskData.perf(i) = taskParam.gParam.rewMag;  
        end
    end
    
    % Calculate accumulated performance.
    taskData.accPerf(i) = sum(taskData.perf);% + taskData.perf(i);
    
    % Trigger: boat.
    Tevent = 3;
    Screen('DrawingFinished', taskParam.gParam.window);
    Screen('Flip', taskParam.gParam.window, t + 2.1);
    taskData.boatT(i) = SendTrigger(taskParam, taskData, condition, vola, i, Tevent);
    %taskData.boatT(i) = SendTrigger(taskParam, taskData, Subject, condition, vola, i, Tevent);
    Screen('Close', RewardTxt);
    
    % Show baseline 3.
    DrawCross(taskParam)
    DrawCircle(taskParam)
    Screen('DrawingFinished', taskParam.gParam.window);
    Screen('Flip', taskParam.gParam.window, t + 2.6);
    
    WaitSecs(1);
end

% Disable real-time mode.
% Priority(0);

% Compute max gain.
if Subject.rew == '1'
    maxMon = (length(find(taskData.boatType == 1)) * taskParam.gParam.rewMag);
    if isequal(condition, 'control') && taskData.boatType(1) == 1
        maxMon = maxMon - taskParam.gParam.rewMag;
    end
elseif Subject.rew == '2'
    maxMon = (length(find(taskData.boatType == 2)) * taskParam.gParam.rewMag);
    if isequal(condition, 'control') && taskData.boatType(1) == 2
        maxMon = maxMon - taskParam.gParam.rewMag;
    end
end

% Give performance feedback.
% while 1
    if isequal(condition, 'practice')
        txtFeedback = sprintf('In diesem Block h�ttest du %.2f von %.2f Euro gewonnen', taskData.accPerf(end), maxMon);
    else
        txtFeedback = sprintf('In diesem Block hast du %.2f von %.2f Euro gewonnen', taskData.accPerf(end), maxMon);
    end
     hits = sum(taskData.hit == 1)
                goldBall = sum(taskData.boatType == 1)
                goldHit = taskData.accPerf(end)/taskParam.gParam.rewMag %sum(practData.boatType == 1)
                silverBall = sum(taskData.boatType == 2)
                silverHit = hits - goldHit;
                
                maxMon = (length(find(taskData.boatType == 1)) * taskParam.gParam.rewMag);
                txt = sprintf(['Gefangene goldene Kugeln: %.0f von %.0f\n\n'...
                               'Gefangene eiserne Kugeln: %.0f von %.0f\n\n'...
                               'In diesem Block h�ttest du %.2f von '...
                               'maximal %.2f Euro gewonnen'], goldHit, goldBall, silverHit, silverBall, taskData.accPerf(end), maxMon);
                
                header = 'Leistung';
                feedback = true
                [fw, bw] = BigScreen(taskParam, taskParam.strings.txtPressEnter, header, txt, feedback);
            
    
%     txtBreak = 'Ende des Blocks';
%     txtPressEnter = 'Weiter mit Enter';
%     Screen('TextSize', taskParam.gParam.window, 50);
%     DrawFormattedText(taskParam.gParam.window, txtBreak, 'center', taskParam.gParam.screensize(4)*0.3);
%     Screen('TextSize', taskParam.gParam.window, 30);
%     DrawFormattedText(taskParam.gParam.window, txtFeedback, 'center', 'center');
%     DrawFormattedText(taskParam.gParam.window,txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9);
%     Screen('DrawingFinished', taskParam.gParam.window);
%     t = GetSecs;
%     Screen('Flip', taskParam.gParam.window, t + 0.1);
%     
%     [~, ~, keyCode ] = KbCheck;
%     if find(keyCode) == taskParam.keys.enter % don't know why it does not understand return or enter?
%         break
%     end
% end

KbReleaseWait();

vola = repmat(vola, length(taskData.trial),1);
sigma = repmat(sigma, length(taskData.trial),1);

%% Save data.

fieldNames = taskParam.fieldNames;
Data = struct(fieldNames.ID, {taskData.ID}, fieldNames.age, taskData.age, fieldNames.rew, {taskData.rew}, fieldNames.actRew, taskData.actRew, fieldNames.sex, {taskData.sex},...
    fieldNames.cond, {taskData.cond}, fieldNames.cBal, {taskData.cBal}, fieldNames.trial, taskData.trial,...
    fieldNames.vola, vola, taskParam.fieldNames.sigma, sigma, fieldNames.outcome, taskData.outcome, fieldNames.distMean, taskData.distMean, fieldNames.cp, taskData.cp,...
    fieldNames.TAC, taskData.TAC, fieldNames.boatType, taskData.boatType, fieldNames.catchTrial, taskData.catchTrial, ...
    fieldNames.predT, taskData.predT, fieldNames.outT, taskData.outT, fieldNames.boatT, taskData.boatT, fieldNames.pred, taskData.pred, fieldNames.predErr, taskData.predErr, fieldNames.predErrNorm, taskData.predErrNorm,...
    fieldNames.predErrPlus, taskData.predErrPlus, fieldNames.predErrMin, taskData.predErrMin,...
    fieldNames.memErr, taskData.memErr, fieldNames.memErrNorm, taskData.memErrNorm, fieldNames.memErrPlus, taskData.memErrPlus,...
    fieldNames.memErrMin, taskData.memErrMin, fieldNames.UP, taskData.UP,fieldNames.UPNorm, taskData.UPNorm,...
    fieldNames.UPPlus, taskData.UPPlus, fieldNames.UPMin, taskData.UPMin, fieldNames.hit, taskData.hit,...
    fieldNames.perf, taskData.perf, fieldNames.accPerf, taskData.accPerf, fieldNames.Date, {taskData.Date});
end
