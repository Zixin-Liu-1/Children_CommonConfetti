function [txt, header] = Feedback(Data, taskParam, subject, condition)

hits = sum(Data.hit == 1);

rewTrials = sum(Data.actRew == 1);
noRewTrials = sum(Data.actRew == 2);

rewCatches = max(Data.accPerf)/taskParam.gParam.rewMag;
noRewCatches = hits - rewCatches;
maxMon = (length(find(Data.boatType == 1))...
    * taskParam.gParam.rewMag);

if taskParam.gParam.oddball
    header = 'Performance';
    if subject.rew == 1
        colRewCap = 'Blue';
        colNoRewCap = 'Green';
    elseif subject.rew == 2
        colRewCap = 'Green';
        colNoRewCap = 'Blue';
    end
    
    if isequal(condition, 'practice') || isequal(condition, 'practiceNoOddball') || isequal(condition, 'practiceOddball')
        wouldHave = ' would have ';
    else
        wouldHave = ' ';
    end
    txt = sprintf(['%s shield catches: %.0f of '...
        '%.0f\n\n%s shield catches: %.0f of '...
        '%.0f\n\nIn this block you%searned %.2f of '...
        'possible $ %.2f.'], colRewCap, rewCatches,...
        rewTrials, colNoRewCap, noRewCatches, noRewTrials,...
        wouldHave, max(Data.accPerf), maxMon);
else
    
    header = 'Leistung';
    if subject.rew == 1
        colRewCap = 'goldenen';
        colNoRewCap = 'silbernen';
    elseif subject.rew == 2
        colRewCap = 'silbernen';
        colNoRewCap = 'goldenen';
    end
    
    if isequal(condition, 'mainPractice') || isequal(condition, 'followOutcomePractice') ||  isequal(condition, 'followCannonPractice')
        wouldHave = 'h�ttest';
    else
        wouldHave = 'hast ';
    end
    
    if isequal(condition, 'mainPractice') || isequal(condition, 'followCannonPractice') || isequal(condition, 'main') || isequal(condition, 'followCannon')
        
        gefangenVsGesammelt = 'gefangen';
        
    elseif isequal(condition, 'followOutcomePractice') || isequal(condition, 'followOutcome')
        
        gefangenVsGesammelt = 'gesammelt';
        
    end
    
    
    %     txt = sprintf(['%s Schild: %.0f von %.0f gefangenen Kugeln\n\n'...
    %         '%s Schild: %.0f von %.0f gefangenen Kugeln\n\n'...
    %         'In diesem Block%sdu %.2f von '...
    %         'maximal %.2f Euro gewonnen'], colRewCap, rewCatches,...
    %         rewTrials, colNoRewCap, noRewCatches, noRewTrials,...
    %         wouldHave, max(Data.accPerf), maxMon);
    if isequal(subject.group, '1')
        if isequal(condition, 'mainPractice') || isequal(condition, 'followOutcomePractice') ||  isequal(condition, 'followCannonPractice')
            wouldHave = 'h�ttest';
        else
            wouldHave = 'hast ';
        end
        
        txt = sprintf(['Weil du %.0f von %.0f Kugeln mit dem %s Schild '...
            '%s hast,\n\n%s du %.2f von maximal %.2f Euro gewonnen.' ], rewCatches,...
            rewTrials, colRewCap, gefangenVsGesammelt, wouldHave, max(Data.accPerf), maxMon);
    else
        if isequal(condition, 'mainPractice') || isequal(condition, 'followOutcomePractice') ||  isequal(condition, 'followCannonPractice')
            wouldHave = 'h�tten';
        else
            wouldHave = 'haben';
        end
        txt = sprintf(['Weil Sie %.0f von %.0f Kugeln mit dem %s Schild '...
            '%s haben,\n\n%s Sie %.2f von maximal %.2f Euro gewonnen.' ], rewCatches,...
            rewTrials, colRewCap, gefangenVsGesammelt, wouldHave, max(Data.accPerf), maxMon);
    end
    
    
end
end

