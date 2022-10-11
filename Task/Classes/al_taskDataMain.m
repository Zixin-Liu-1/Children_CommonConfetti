classdef al_taskDataMain
    %AL_TASKDATAMAIN This class definition file specifies the 
    % properties of a taskDataMain object
    
    properties
        
        % Todo: more comments
        
        % Subject 
        % -------
        
        % Subject ID
        ID 

        % Sex
        sex

        % Age
        age

        % Test date
        Date

        testDay

        % Condition; currently used for push
        cond

        % General 
        % --------

        % Concentration of the outcome-generating distribution
        concentration

        % Concentration of push manipulation
        pushConcentration

        % Hazard rate
        haz

        % todo: comment
        safe

        % todo: comment
        group

        % Reward condition
        rew

        % todo: comment
        actJitter
        
        % Block number
        block
        
        % Reaction time
        RT

        % Initiation reaction time
        initiationRTs
        
        % All angular shield size
        allASS

        % Changepoint index
        cp
        
        % Actual reward
        actRew
        
        % Trial number
        currTrial
        
        % Outcome
        outcome
        
        % Mean of outcome-generating distribution
        distMean
        
        % Counterbalancing condition
        cBal
        
        % Trials after changepoint
        TAC
        
        % Current shield type
        shieldType
        
        % Catch-trial index
        catchTrial
        
        % Prediction 
        pred
        
        % Prediction error
        predErr

        % Estimation error
        estErr 
        
        % Update
        UP
        
        % Hit vs. miss
        hit
        
        % Trial-by-trial performance
        perf
        
        % Accumulated performance
        accPerf
        
        % todo: comment
        initialTendency
        
        % todo: comment
        cannonDev

        % Default-shield location
        z

        % Push magnitude
        y

        % Chinese-version specific
        latentState

        % EEG
        timestampOnset
        timestampPrediction
        timestampOffset
        triggers

         % todo: comment
        memErr
        memErrNorm 
        memErrPlus
        memErrMin
       
    end
    
end
