function Trapezoid = splitTrapezoid (img, p1, p2, p3, p4)
    % Usage: Cut the image to the specified shape and keep the original size.
    % Inputs:
    % img: Image to be cutted
    % Upper left point: p1
    % Upper right point: p2
    % Lower right point: p3
    % Lower left point: p4

    % Outputs:
    % Trapezoid: A matrix with the specified shape of the same size as the original image

    xmin = min([p1(1),p2(1),p3(1),p4(1)]);
    xmax = max([p1(1),p2(1),p3(1),p4(1)]);
    ymin = min([p1(2),p2(2),p3(2),p4(2)]);
    ymax = max([p1(2),p2(2),p3(2),p4(2)]);

    % Create a rectangle matrix fulled by 1, 

    cuttedImg_square = img(ymin+1:ymax, xmin+1:xmax, :);
%     ref = ones(size(cuttedImg_square,1),size(cuttedImg_square,2),3);

    ref = ones(size(img,1),size(img,2),3);

    % Create a perspective transform that warps the created white image 
    % coordinates into a trapezoid
    movingPoints = [1 1;
                    size(ref,2) 1;
                    size(ref,2) size(ref,1); 
                    1 size(ref,1)];
    fixedPoints = [p1; p2; p3; p4];
    tform = fitgeotrans(movingPoints, fixedPoints, 'Projective');

 
    % Create a reference coordinate system where the extent is the size of 
    % the image

%     % The following 1 line code: the size of splited trapezoid will not be 
%     % changed, same to input image.  
    RA = imref2d([size(ref,1),size(ref,2)],[1 size(ref,2)],[1 size(ref,1)]);

    % Warp the image, trapezoidal area = 1 (white), other = 0 (black).
    [cuttedref,r] = imwarp(ref, tform, 'OutputView', RA);

    % The original rectangular image is multiplied by the trapezoidal 
    % white image to obtain the target trapezoidal image
    
    Trapezoid = img.*cuttedref;
end


