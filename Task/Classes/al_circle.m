classdef al_circle
    %AL_CIRCLE This class definition file specifies the properties and methods of a circle object
    %
    % TODO: Add more comments
    

    % Properties of the circle object
    % -------------------------------
    
    properties
        
        windowRect
        shieldAngle
        shieldOffset
        shieldWidth
        shieldFixedSizeFactor % only applied when shield depends in concentration
        cannonEndCent
        cannonEndRect
        outcCentSpotRect
        predSpotRad
        outcSize
        meanPoint
        rotationRad
        chineseCannonRad
        shieldImageRad
        heliImageRad
        tendencyThreshold
        predSpotDiam
        outcDiam
        spotDiamMean
        predSpotRect
        outcRect
        spotRectMean
        boatRect
        centBoatRect
        predCentSpotRect
        outcCentRect
        centSpotRectMean
        unit
        initialRotAngle
        rotAngle
        cannonEndDiam
        tickWidth
        
    end
    
    % Methods of the circle object
    % ----------------------------
    
    methods
        
        function circleobj = al_circle(windowRect)
            % AL_CIRCLE This function creates a circle object of
            % class al_circle
            %
            %   The initial values correspond to useful defaults that
            %   are often used across tasks.
            %
            %   Input
            %       windowRect: Window rectangle from PTB Screen
            %
            %   Output
            %       circleobj: Circle object with default values
            
            circleobj.windowRect = windowRect;
            circleobj.shieldAngle = 30; % Todo: is this currently used?
            circleobj.shieldWidth = 30; 
            circleobj.shieldOffset = 10; 
            circleobj.shieldFixedSizeFactor = 2; 
            circleobj.cannonEndCent = nan;
            circleobj.cannonEndRect = nan;
            circleobj.outcCentSpotRect = nan;
            circleobj.predSpotRad = 10; % Todo: can this be combined with diameter?
            circleobj.outcSize = 10;
            circleobj.meanPoint = 1;
            circleobj.rotationRad = 150;
            circleobj.chineseCannonRad = 500; % Todo: used to be 300; update when getting back to chinese version
            circleobj.shieldImageRad = 275;
            circleobj.heliImageRad = 70;
            circleobj.tendencyThreshold = 15;
            circleobj.boatRect = [0 0 50 50];
            circleobj.centBoatRect = nan;
            circleobj.predCentSpotRect = nan;
            circleobj.outcCentRect = nan;
            circleobj.centSpotRectMean = nan;
            circleobj.unit = 2*pi/360;  % Todo: maybe get rid of unit and use rad2deg for computing pred
            circleobj.initialRotAngle = 0*circleobj.unit; % Todo: delete unit here when tets are implemented
            circleobj.rotAngle = circleobj.initialRotAngle;
            circleobj.cannonEndDiam = 10;
            circleobj.cannonEndRect = [0 0 circleobj.cannonEndDiam circleobj.cannonEndDiam];
            circleobj.tickWidth = 2;
            
        end

        function circleobj = compute_circle_props(circleobj)
            % COMPUTE_CIRCLE_PROPS This function computes the parameters of
            % the circle
            %
            %   Input
            %       circleobj: Circle object with default values
            %       
            %   Output
            %       circleobj: Circle object with default values

            % Todo: rename function to computeCircleProps
            
            circleobj.predSpotDiam = circleobj.predSpotRad * 2;
            circleobj.outcDiam = circleobj.outcSize * 2;
            circleobj.spotDiamMean = circleobj.meanPoint * 2;
            circleobj.predSpotRect = [0 0 circleobj.predSpotDiam circleobj.predSpotDiam];
            circleobj.outcRect = [0 0 circleobj.outcDiam circleobj.outcDiam];
            circleobj.spotRectMean = [0 0 circleobj.spotDiamMean circleobj.spotDiamMean];

            circleobj.centBoatRect = CenterRect(circleobj.boatRect, circleobj.windowRect);
            circleobj.predCentSpotRect = CenterRect(circleobj.predSpotRect, circleobj.windowRect);
            circleobj.outcCentRect = CenterRect(circleobj.outcRect, circleobj.windowRect);
            circleobj.outcCentSpotRect = CenterRect(circleobj.outcRect, circleobj.windowRect);
            circleobj.cannonEndCent = CenterRect(circleobj.cannonEndRect, circleobj.windowRect);
            circleobj.centSpotRectMean = CenterRect(circleobj.spotRectMean, circleobj.windowRect);
        end

        function circleobj = rightMovement(circleobj, keySpeed)
            % RIGHTMOVEMENT This function implements keyboard mvements to the right
            % 
            %   Input
            %       circleobj: Circle object with current values
            %       keySpeed: Determines speed with which spot moves around
            %       circle
            %   
            %   Output
            %       circleobj: Circle object with current values


            if circleobj.rotAngle < 360*circleobj.unit
                circleobj.rotAngle = circleobj.rotAngle + keySpeed*circleobj.unit;
            else
                circleobj.rotAngle = 0;
            end
        end

        function circleobj = leftMovement(circleobj, keySpeed)
            % LEFTMOVEMENT This function implements keyboard mvements to
            % the left
            % 
            %   Input
            %       circleobj: Circle object with current values
            %       keySpeed: Determines speed with which spot moves around
            %       circle
            %   
            %   Output
            %       circleobj: Circle object with current values

            if circleobj.rotAngle > 0*circleobj.unit
                circleobj.rotAngle = circleobj.rotAngle - keySpeed*circleobj.unit;
            else
                circleobj.rotAngle = 360*circleobj.unit;
            end
        end
    end
end





