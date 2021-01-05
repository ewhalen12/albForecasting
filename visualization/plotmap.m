% Visualize map data as either a static image or animation.
% Input data x should be 2D (Nv1xNv2) for static imate or 3D (Nv1xNv2xT)
% for animation where T is the number of frames.
function plotmap(x, plotTitle, options)

    % validate inputs and use default values
    arguments
       x
       plotTitle
       options.cutoff = nan
       options.fps = 10
       options.background = nan
    end
    
    % get plot size
    [Nv1, Nv2, numTimesteps] = size(x);
    pos = [950 50 700 700*Nv1/Nv2];
    
    % if using a background, load background
    if ~isnan(options.background)
        if strcmp(options.background,'driving')
            backgroundImg = imread('../maps/map0/drivingMap0.jpg');
        else
            backgroundImg = imread('../maps/map0/satelliteMap0.jpg');
        end
    end
   
    % if using a cutoff, build the isoMask
    if ~isnan(options.cutoff)
        isoMask = double(x > options.cutoff);
    else
        isoMask = ones(size(x));
    end

    % plot static image
    if numTimesteps==1 
        f = figure('Position', pos, 'Name', 'imageFig');
        
        % optional background image
        if ~isnan(options.background)
            ax1 = axes('Parent',f);
            axC = axes('Parent',f);
            
            imagesc(axC, x(:,:,1), 'AlphaData', isoMask(:,:,1));
            colorbar; 
            colormap turbo;
            title(plotTitle);            
            scPos = get(axC, 'Position');
            set(ax1, 'Position', scPos);
            imshow(backgroundImg,'Parent',ax1);
        else
            % no background
            imagesc(x(:,:,1), 'AlphaData', isoMask(:,:,1));
            colorbar; 
            colormap turbo;
            title(plotTitle);
        end

        axis image;
        axis off;
        
    % plot animation
    else
        cLimits = [min(x(:)), max(x(:))];
        f = figure('Position', pos, 'visible', 'on', 'Name', 'movieFig');
        F(numTimesteps) = struct('cdata',[],'colormap',[]);
        colormap turbo;
        
        % optional background image
        if ~isnan(options.background)
            set(f, 'visible', 'off');
            ax1 = axes('Parent',f);
            axC = axes('Parent',f);
            
            imagesc(axC, x(:,:,1), 'AlphaData', isoMask(:,:,1));
            colorbar; 
            colormap turbo;
            caxis(cLimits);
            scPos = get(axC, 'Position');
            set(ax1, 'Position', scPos);
            imshow(backgroundImg,'Parent',ax1); 
            
            ax = gca;
            ax.NextPlot = 'replaceChildren';
        
        % no background image
        else
            axC = gca;
            set(f, 'visible', 'off');
        end
        
        % generate one frame for each timestep and store in struct
        for t = 1:numTimesteps
            imagesc(axC, x(:,:,t), 'AlphaData', isoMask(:,:,t)); 
            axis(axC,'image')
            axis(axC,'off')
            colorbar(axC); 
            caxis(axC, cLimits);
            frameTitle = sprintf('%s   iter %03i', plotTitle, t);
            title(axC, frameTitle);
            drawnow
            F(t) = getframe(f); % capture the frame
        end

        % launch the video player and play the animation
        implay(F, options.fps)
        set(findall(0,'tag','spcui_scope_framework'),'position', pos);
    end
