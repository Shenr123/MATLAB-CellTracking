%% ask whether to exclude a region above and/or below a line for this
%section (e.g. debris, out-of-focus background, damaged device edges).
%Uses the already-rotated orientation (angle(s)) so the line is drawn on
%exactly what the tracker will see.
if ~exist('excludeBelow', 'var')
    excludeBelow = nan(1, series);
end
if ~exist('excludeAbove', 'var')
    excludeAbove = nan(1, series);
end

bgExclude = im2uint8(imrotate(imadjust(im(:, :, s)), angle(s)));

if strcmp(questdlg(['Section ' num2str(s) ': do you want to exclude anything below a line?'], 'Accuracy Check', 'Yes', 'No', 'No'), 'Yes')
    approved = false;
    while ~approved
        excludeFig = figure('Name', 'Exclude below line', 'WindowState', 'maximized');
        imshow(bgExclude)
        title(['Section ' num2str(s) ': click where to place the exclusion line'])
        [~, clickY] = ginput(1);
        imshow(insertShape(bgExclude, 'Line', [1 clickY size(bgExclude, 2) clickY], 'LineWidth', t, 'Color', 'red'))
        title('Everything below the red line will be excluded from analysis')
        c2 = questdlg('Exclude everything below this line?', 'Accuracy Check', 'Yes', 'Retry', 'Cancel', 'Yes');
        close(excludeFig)
        if strcmp(c2, 'Yes')
            excludeBelow(s) = clickY;
            approved = true;
        elseif strcmp(c2, 'Cancel')
            approved = true;
        end
    end
end

if strcmp(questdlg(['Section ' num2str(s) ': do you want to exclude anything above a line?'], 'Accuracy Check', 'Yes', 'No', 'No'), 'Yes')
    approved = false;
    while ~approved
        excludeFig = figure('Name', 'Exclude above line', 'WindowState', 'maximized');
        imshow(bgExclude)
        title(['Section ' num2str(s) ': click where to place the exclusion line'])
        [~, clickY] = ginput(1);
        imshow(insertShape(bgExclude, 'Line', [1 clickY size(bgExclude, 2) clickY], 'LineWidth', t, 'Color', 'red'))
        title('Everything above the red line will be excluded from analysis')
        c2 = questdlg('Exclude everything above this line?', 'Accuracy Check', 'Yes', 'Retry', 'Cancel', 'Yes');
        close(excludeFig)
        if strcmp(c2, 'Yes')
            excludeAbove(s) = clickY;
            approved = true;
        elseif strcmp(c2, 'Cancel')
            approved = true;
        end
    end
end
