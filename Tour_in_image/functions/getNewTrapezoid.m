function result = getNewTrapezoid(cases, img, p1, p2, p3, p4, p1_new, p2_new, p3_new, p4_new, judgePts1, judgePts2, judgePts3, judgePts4)
    % Usage: Convert a trapezoid image to a specified shape
    % Inputs:
    % cases: 'fc' floor and ceil, 'lr' left and right wall, 'f' rearwall
    % and foreground.
    % img: Image to be converted
    % Upper left point: p1
    % Upper right point: p2
    % Lower right point: p3
    % Lower left point: p4
    % judgePts1 point: pixel coordinates in image plain, upper left.
    % judgePts2 point: pixel coordinates in image plain, lower right.

    % Outputs:
    % result: A matrix with the target shape of the same size as the original image

    xmax = size(img,2);
    ymax = size(img,1);

    switch cases
        case 'fc'
            if (judgePts1(2)+ymax)<(judgePts3(2)+ymax)||(judgePts2(2)+ymax)<(judgePts4(2)+ymax)
                % Create perspective transformation that warps the cutted rectangle (trapezoid)
                % coordinates to the traget shape (with 4 vertices).
        
                movingPoints = [p1; p2; p3; p4];
                fixedPoints = [p1_new; p2_new; p3_new; p4_new];
        
        
                tform = fitgeotrans(movingPoints, fixedPoints, 'Projective');
        
                % Create a reference coordinate system where the extent is the size of the image
        
                RA = imref2d([ymax xmax], [1 xmax], [1 ymax]);
        
                % Warp the image
                [result,~] = imwarp(img, tform, 'OutputView', RA);
            else
                result = zeros(ymax,xmax,3);
            end
        case 'lr'
            if (judgePts1(1)+xmax)<(judgePts3(1)+xmax)||(judgePts4(1)+xmax)<(judgePts2(1)+xmax)
                % Create perspective transformation that warps the cutted rectangle (trapezoid)
                % coordinates to the traget shape (with 4 vertices).
        
                movingPoints = [p1; p2; p3; p4];
                fixedPoints = [p1_new; p2_new; p3_new; p4_new];
        
        
                tform = fitgeotrans(movingPoints, fixedPoints, 'Projective');
        
                % Create a reference coordinate system where the extent is the size of the image
        
                RA = imref2d([ymax xmax], [1 xmax], [1 ymax]);
        
                % Warp the image
                [result,~] = imwarp(img, tform, 'OutputView', RA);
            else
                result = zeros(ymax,xmax,3);
            end
         case 'f'
             % Create perspective transformation that warps the cutted rectangle (trapezoid)
             % coordinates to the traget shape (with 4 vertices).

             movingPoints = [p1; p2; p3; p4];
             fixedPoints = [p1_new; p2_new; p3_new; p4_new];


             tform = fitgeotrans(movingPoints, fixedPoints, 'Projective');

             % Create a reference coordinate system where the extent is the size of the image

             RA = imref2d([ymax xmax], [1 xmax], [1 ymax]);

             % Warp the image
             [result,~] = imwarp(img, tform, 'OutputView', RA);
    end

end
