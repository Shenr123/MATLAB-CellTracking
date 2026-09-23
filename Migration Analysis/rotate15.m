%orientationRotation isn't defined when called from v2 (only v3 asks
%about horizontal vs. vertical migration), so default to no extra
%rotation in that case
if ~exist('orientationRotation', 'var')
    orientationRotation = 0;
end
j = 'Rotated Wrong';
while j(1) == 'R'
    im15 = imrotate(im(:, :, s), orientationRotation);
    imshow(imadjust(im15))
    if series == 1
        section2 = str2double(fileName((find(fileName == '(', 1, 'last') + 1):(find(fileName == ')', 1, 'last') - 1)));
    else
        section2 = s;
    end
    title(['Section ' num2str(section2) ', Constriction Size ' num2str(constrictionSize(mod(s - sections(1), length(constrictionSize)) + 1))])
    set(gcf, 'WindowState', 'maximized');
    h = imline(gca, [200 size(im15, 1)/2; size(im15, 2)-200 size(im15, 1)/2]);
    drawnow
    %pause
    while ~waitforbuttonpress
    end
    pos = h.getPosition;
    angle(s) = 180 * (atan((pos(2, 2) - pos(1, 2)) / (pos(2, 1) - pos(1, 1))) / pi + cellsFromTop) + orientationRotation; %#ok<SAGROW>
    j = 'Constrictions Are Off';
    while j(1) == 'C'
        bg = im2uint8(imrotate(imadjust(im(:, :, s)), angle(s)));
        imshow(bg)
        title(['Section ' num2str(section2) ', Constriction Size ' num2str(constrictionSize(mod(s - sections(1), length(constrictionSize)) + 1))])
        set(gcf, 'WindowState', 'maximized');
        c = imhandles(gcf);
        con = [];
        for i = 1:6
            con = [con; ginput(1)]; %#ok<AGROW>
            bg = insertShape(bg, 'Line', [1 con(end, 2)' size(bg, 2) con(end, 2)'], 'LineWidth', t, 'Color', 'red');
            if i < 6
                set(c, 'CData', bg)
            end
        end
        loc(s, :) = sort(con(:, 2)', 'descend'); %#ok<SAGROW>
        i = size(bg, 2);
        bg = insertShape(bg, 'Line', [[1; 1; 1; 1; 1; 1] loc(s, :)' [i; i; i; i; i; i] loc(s, :)'], 'LineWidth', t, 'Color', 'red');
        loc(s, :) = [(loc(s, 1) + loc(s, 2))/2+0.7*l (loc(s, 1) + loc(s, 2))/2-0.7*l (loc(s, 3) + loc(s, 4))/2+0.7*l (loc(s, 3) + loc(s, 4))/2-0.7*l (loc(s, 5) + loc(s, 6))/2+0.7*l (loc(s, 5) + loc(s, 6))/2-0.7*l]; %#ok<SAGROW>
        %loc(s, :) = loc(s, :) + [(loc(s, 2) - loc(s, 1)) (loc(s, 1) - loc(s, 2)) (loc(s, 4) - loc(s, 3)) (loc(s, 3) - loc(s, 4)) (loc(s, 6) - loc(s, 5)) (loc(s, 5) - loc(s, 6))] ./ 6;
        set(c, 'CData', insertShape(bg, 'Line', [[1; 1; 1; 1; 1; 1] loc(s, :)' [i; i; i; i; i; i] loc(s, :)'], 'LineWidth', t, 'Color', 'blue'))
        j = questdlg('How''s this?', 'Accuracy Check', 'Rotated Wrong', 'Constrictions Are Off', 'All Good', 'All Good');
    end
end
close