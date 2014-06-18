function [taskData, Data] = BattleShipsMain(taskParam, vola, condition, Subject)
% This function acutally runs the task. You can specify "main", "practice"
% or "control".

KbReleaseWait()

% Set port to 0.
if taskParam.gParam.sendTrigger == true
    lptwrite(taskParam.triggers.port,0);
end

%% generateOutcomes
taskData = GenerateOutcomes(taskParam, vola, condition);

%% Run trials.
for i=1:taskData.trial
    
    % Trigger: start task.
    SendTrigger(taskParam, taskParam.triggers.startTrigger)
    
    % Trigger: trial onset.
    SendTrigger(taskParam, taskParam.triggers.trialOnsetTrigger)
    
    while 1
        
        if taskData.catchTrial(i) == 1
            DrawNeedle(taskParam, taskData.distMean(i))
        end
        
        % Start trial - subject predicts boat.
        DrawCircle(taskParam)
        DrawCross(taskParam)
        PredictionSpot(taskParam)
        
        Screen('Flip', taskParam.gParam.window);
        
        [ keyIsDown, ~, keyCode ] = KbCheck;
        
        if keyIsDown
            if keyCode(taskParam.keys.rightKey)
                if taskParam.circle.rotAngle < 360*taskParam.circle.unit
                    taskParam.circle.rotAngle = taskParam.circle.rotAngle + 1*taskParam.circle.unit; %0.02
                else
                    taskParam.circle.rotAngle = 0;
                end
            elseif keyCode(taskParam.keys.leftKey)
                if taskParam.circle.rotAngle > 0*taskParam.circle.unit
                    taskParam.circle.rotAngle = taskParam.circle.rotAngle - 1*taskParam.circle.unit;
                else
                    taskParam.circle.rotAngle = 360*taskParam.circle.unit;
                end
            elseif keyCode(taskParam.keys.space)
                taskData.pred(i) = (taskParam.circle.rotAngle / taskParam.circle.unit) ;
                
                % Trigger: prediction.
                SendTrigger(taskParam, taskParam.triggers.predTrigger)
                break
            end
        end
    end
    
    % Calculate prediction error.
    [taskData.predErr(i), taskData.predErrNorm(i), taskData.predErrPlus(i), taskData.predErrMin(i)] = Diff(taskData.outcome(i), taskData.pred(i));
    
    if isequal(condition,'main') || isequal(condition,'practice')
        % Memory error = 999 because there is no memory error in this condition.
        taskData.memErr(i) = 999;
        taskData.memErrNorm(i) = 999;
        taskData.memErrPlus(i) = 999;
        taskData.memErrMin(i) = 999;
    else
        if i >= 2
            % Calculate memory error.
            [taskData.memErr(i), taskData.memErrNorm(i), taskData.memErrPlus(i), taskData.memErrMin(i)] = Diff(taskData.pred(i), taskData.outcome(i-1));
        end
    end
    
    % Calculate hits
    if isequal(condition,'main') || isequal(condition,'practice')
        if taskData.predErr(i) <= taskParam.circle.outcSize/2%13
            taskData.hit(i) = 1;
        end
    elseif isequal(condition,'control')
        if taskData.memErr(i) <= taskParam.circle.outcSize/2%13;
            taskData.hit(i) = 1;
        end
    end
    
    if i >= 2
        % Calculate update.
        [taskData.UP(i), taskData.UPNorm(i), taskData.UPPlus(i), taskData.UPMin(i)] = Diff(taskData.pred(i), taskData.pred(i-1));
    end
    
    % Show baseline 1.
    DrawCross(taskParam)
    DrawCircle(taskParam)
    
    % Trigger: baseline 1.
    SendTrigger(taskParam, taskParam.triggers.baseline1Trigger)
    Screen('Flip', taskParam.gParam.window);
    WaitSecs(1);
    
    % Show outcome.
    DrawCross(taskParam)
    DrawCircle(taskParam)
    DrawOutcome(taskParam, taskData.outcome(i)) %%TRIGGER
    PredictionSpot(taskParam)
    
    % Trigger: outcome.
    SendTrigger(taskParam, taskParam.triggers.outcomeTrigger)
    Screen('Flip', taskParam.gParam.window);
    WaitSecs(1);
    
    % Show baseline 2.
    DrawCross(taskParam)
    DrawCircle(taskParam)
    
    % Trigger: baseline 2.
    SendTrigger(taskParam, taskParam.triggers.baseline2Trigger)
    Screen('Flip', taskParam.gParam.window)
    WaitSecs(1);
    
    % Show boat and calculate performance.       %TRIGGER
    DrawCircle(taskParam)
    if taskData.boatType(i) == 1
        DrawBoat(taskParam, taskParam.colors.gold)
        if Subject.rew == '1' && taskData.hit(i) == 1 
            taskData.perf(i) = taskParam.gParam.rewMag; %0.2;
        end
    else
        DrawBoat(taskParam, taskParam.colors.silver)
        if Subject.rew == '2' && taskData.hit(i) == 1
            taskData.perf(i) = taskParam.gParam.rewMag;
        end
    end
    
    % Calculate accumulated performance.
    
    taskData.accPerf(i) = sum(taskData.perf);% + taskData.perf(i);
    
    % Trigger: boat.
    SendTrigger(taskParam, taskParam.triggers.boatTrigger)
    Screen('Flip', taskParam.gParam.window);
    WaitSecs(1);
    
    % Show baseline 3.
    DrawCircle(taskParam)
    DrawCross(taskParam)
    
    % Trigger: baseline 3.
    SendTrigger(taskParam, taskParam.triggers.baseline3Trigger)
    Screen('Flip', taskParam.gParam.window);
    WaitSecs(1);
    
    taskData.trial(i) = i;
    taskData.age(i) = str2double(Subject.age);
    taskData.ID{i} = Subject.ID;
    taskData.sex{i} = Subject.sex;
    taskData.date{i} = Subject.date;
    taskData.cond{i} = condition;
    taskData.cBal{i} = Subject.cBal;
    taskData.rew{i} = Subject.rew;
    
end

if Subject.rew == '1'
    maxMon = (length(find(taskData.boatType == 1)) * taskParam.gParam.rewMag);
elseif Subject.rew == '2'
    maxMon = (length(find(taskData.boatType == 2)) * taskParam.gParam.rewMag);
end

while 1
    if isequal(condition, 'practice')
        txtFeedback = sprintf('In diesem Block h�ttest du %.2f von %.2f Euro gewonnen', taskData.accPerf(end), maxMon);
    else
        txtFeedback = sprintf('In diesem Block hast du %.2f von %.2f Euro gewonnen', taskData.accPerf(end), maxMon);
    end
    txtBreak = 'Ende des Blocks';
    txtPressEnter = 'Weiter mit Enter';
    Screen('TextSize', taskParam.gParam.window, 50);
    DrawFormattedText(taskParam.gParam.window, txtBreak, 'center', taskParam.gParam.screensize(4)*0.3);
    Screen('TextSize', taskParam.gParam.window, 30);
    DrawFormattedText(taskParam.gParam.window, txtFeedback, 'center', 'center');
    DrawFormattedText(taskParam.gParam.window,txtPressEnter,'center',taskParam.gParam.screensize(4)*0.9);
    Screen('Flip', taskParam.gParam.window);
    
    [~, ~, keyCode ] = KbCheck;
    if find(keyCode) == taskParam.keys.enter % don't know why it does not understand return or enter?
        break
    end
end

KbReleaseWait()

vola = repmat(vola, length(taskData.trial),1);
sigma = repmat(taskParam.gParam.sigma, length(taskData.trial),1);

%% Save data.

fieldNames = taskParam.fieldNames;
Data = struct(fieldNames.ID, {taskData.ID}, fieldNames.age, taskData.age, fieldNames.rew, {taskData.rew}, fieldNames.sex, {taskData.sex},...
    fieldNames.cond, {taskData.cond}, fieldNames.cBal, {taskData.cBal}, fieldNames.trial, taskData.trial,...
    fieldNames.vola, vola, taskParam.fieldNames.sigma, sigma, fieldNames.outcome, taskData.outcome, fieldNames.distMean, taskData.distMean, fieldNames.cp, taskData.cp,...
    fieldNames.TAC, taskData.TAC, fieldNames.boatType, taskData.boatType, fieldNames.catchTrial, taskData.catchTrial, ...
    fieldNames.pred, taskData.pred, fieldNames.predErr, taskData.predErr, fieldNames.predErrNorm, taskData.predErrNorm,...
    fieldNames.predErrPlus, taskData.predErrPlus, fieldNames.predErrMin, taskData.predErrMin,...
    fieldNames.memErr, taskData.memErr, fieldNames.memErrNorm, taskData.memErrNorm, fieldNames.memErrPlus, taskData.memErrPlus,...
    fieldNames.memErrMin, taskData.memErrMin, fieldNames.UP, taskData.UP,fieldNames.UPNorm, taskData.UPNorm,...
    fieldNames.UPPlus, taskData.UPPlus, fieldNames.UPMin, taskData.UPMin, fieldNames.hit, taskData.hit,...
    fieldNames.perf, taskData.perf, fieldNames.accPerf, taskData.accPerf, fieldNames.date, {taskData.date});

end
