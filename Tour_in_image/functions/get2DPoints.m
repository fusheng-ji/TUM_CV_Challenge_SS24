
function get2DPoints(app)
    % Usage: calculates the 2D coordinates of 13 points
    % Inputs:
    % user selected vanishing point and 4 points at the ear wall

    % Outputs:
    % app.points_2d: 13*2 matrix, contains 2D coordinates of 13 points 

    [big_im, lmargin, rmargin, tmargin, bmargin] = get5rects(app);

    [app.y_limit, app.x_limit, ~] = size(big_im);

    % get 4 border length
    app.lmargin = lmargin;
    app.rmargin = rmargin;
    app.tmargin = tmargin;
    app.bmargin = bmargin;


    %%% app.rearwall contains [p1; p2; p7; p8]
    app.rearwall(:,1) = app.rearwall_raw(:,1) + lmargin;
    app.rearwall(:,2) = app.rearwall_raw(:,2) + tmargin;

    app.points_2d = zeros(13,2);
    app.points_2d(1,:) = app.rearwall(1,:);
    app.points_2d(2,:) = app.rearwall(2,:);
    app.points_2d(7,:) = app.rearwall(3,:);
    app.points_2d(8,:) = app.rearwall(4,:);


    % calculate the 12 points 2D coordinates based on the 5 wall structure
    app.points_2d(10,2) = tmargin;
    app.points_2d(10,1) = round(find_line_x(app.VP(1),app.VP(2),app.points_2d(8,1),app.points_2d(8,2), app.points_2d(10,2) ));

    app.points_2d(12,1) = app.x_limit - rmargin;
    app.points_2d(12,2) = round(find_line_y(app.VP(1),app.VP(2),app.points_2d(8,1),app.points_2d(8,2), app.points_2d(12,1) ));

    app.points_2d(6,1) = app.x_limit - rmargin;
    app.points_2d(6,2) = round(find_line_y(app.VP(1),app.VP(2),app.points_2d(2,1),app.points_2d(2,2), app.points_2d(6,1) ));

    app.points_2d(4,2) = app.y_limit - bmargin;
    app.points_2d(4,1) = round(find_line_x(app.VP(1),app.VP(2),app.points_2d(2,1),app.points_2d(2,2), app.points_2d(4,2) ));

    app.points_2d(9,2) = tmargin;
    app.points_2d(9,1) = round(find_line_x(app.VP(1),app.VP(2),app.points_2d(7,1),app.points_2d(7,2), app.points_2d(9,2) ));

    app.points_2d(3,2) = app.y_limit - bmargin;
    app.points_2d(3,1) = round(find_line_x(app.VP(1),app.VP(2),app.points_2d(1,1),app.points_2d(1,2), app.points_2d(3,2) ));

    app.points_2d(11,1) = lmargin;
    app.points_2d(11,2) = round(find_line_y(app.VP(1),app.VP(2),app.points_2d(7,1),app.points_2d(7,2), app.points_2d(11,1) ));

    app.points_2d(5,1) = lmargin;
    app.points_2d(5,2) = round(find_line_y(app.VP(1),app.VP(2),app.points_2d(1,1),app.points_2d(1,2), app.points_2d(5,1) ));



end



function [big_im ,lmargin,rmargin,tmargin,bmargin] = get5rects(app)

    im = app.image_BG;
    vx = app.VP_raw(1);
    vy = app.VP_raw(2);
    irx = app.irx;
    iry = app.iry;
    
    % find where the line from VP thru inner rectangle hits the edge of image
    [ox,oy] = find_corner(vx,vy,irx(1),iry(1),0,0);
    orx(1) = ox;  ory(1) = oy;
    [ox,oy] = find_corner(vx,vy,irx(2),iry(2),app.x_limit,0);
    orx(2) = ox;  ory(2) = oy;
    [ox,oy] = find_corner(vx,vy,irx(3),iry(3),app.x_limit,app.y_limit);
    orx(3) = ox;  ory(3) = oy;
    [ox,oy] = find_corner(vx,vy,irx(4),iry(4),0,app.y_limit);
    orx(4) = ox;  ory(4) = oy;
    orx = round(orx);
    ory = round(ory);
    
    
    % expand the image so that each "face" of the box is a proper rectangle
    [ymax,xmax,cdepth] = size(im);
    lmargin = -min(orx);
    rmargin = max(orx) - xmax;
    tmargin = -min(ory);
    bmargin = max(ory) - ymax;
    big_im = zeros([ymax+tmargin+bmargin xmax+lmargin+rmargin cdepth]);
    big_im_alpha = zeros([size(big_im,1) size(big_im,2)]);
    big_im(tmargin+1:end-bmargin,lmargin+1:end-rmargin,:) = im2double(im);
    big_im_alpha(tmargin+1:end-bmargin,lmargin+1:end-rmargin) = 1;
    
    app.bim = big_im;
    
    % update all variables for the new image
    vx = vx + lmargin;
    vy = vy + tmargin;
    
    app.VP(1) = app.VP_raw(1) + lmargin;
    app.VP(2) = app.VP_raw(2) + tmargin;
    
    
    irx = irx + lmargin;
    iry = iry + tmargin;
    orx = orx + lmargin;
    ory = ory + tmargin;
    
    
    %%%%%%%%%%%% define the 5 rectangles
    
    % ceiling 
    ceilrx = [orx(1) orx(2) irx(2) irx(1)];
    ceilry = [ory(1) ory(2) iry(2) iry(1)];
    if (ceilry(1) < ceilry(2)),
         ceilrx(1) = round(find_line_x(vx,vy,ceilrx(1),ceilry(1),ceilry(2)));
         ceilry(1) = ceilry(2);
    else
         ceilrx(2) = round(find_line_x(vx,vy,ceilrx(2),ceilry(2),ceilry(1)));
         ceilry(2) = ceilry(1);
    end
    
    % floor
    floorrx = [irx(4) irx(3) orx(3) orx(4)];
    floorry = [iry(4) iry(3) ory(3) ory(4)];
    if (floorry(3) > floorry(4)),
         floorrx(3) = round(find_line_x(vx,vy,floorrx(3),floorry(3),floorry(4)));
         floorry(3) = floorry(4);
    else
         floorrx(4) = round(find_line_x(vx,vy,floorrx(4),floorry(4),floorry(3)));
         floorry(4) = floorry(3);
    end
    
    % left
    leftrx = [orx(1) irx(1) irx(4) orx(4)];
    leftry = [ory(1) iry(1) iry(4) ory(4)];
    if (leftrx(1) < leftrx(4)),
         leftry(1) = round(find_line_y(vx,vy,leftrx(1),leftry(1),leftrx(4)));
         leftrx(1) = leftrx(4);
    else
         leftry(4) = round(find_line_y(vx,vy,leftrx(4),leftry(4),leftrx(1)));
         leftrx(4) = leftrx(1);
    end
    
    %%% Fix leftwall error begins
    
    
    if (lmargin > 0)
    
        leftry(1) = round(find_line_y(vx,vy,leftrx(1),leftry(1),lmargin));
        leftrx(1) = lmargin;
        
        leftry(4) = round(find_line_y(vx,vy,leftrx(4),leftry(4),lmargin));
        leftrx(4) = lmargin;
    
    end
    %%% Fix leftwall error ends
    
    
    
    % right
    
    rightrx = [irx(2) orx(2) orx(3) irx(3)];
    rightry = [iry(2) ory(2) ory(3) iry(3)];
    if (rightrx(2) > rightrx(3))
         rightry(2) = round(find_line_y(vx,vy,rightrx(2),rightry(2),rightrx(3)));
         rightrx(2) = rightrx(3);
    else
         rightry(3) = round(find_line_y(vx,vy,rightrx(3),rightry(3),rightrx(2)));
         rightrx(3) = rightrx(2);
    end
    
    %%% fix rightwall error begins
    
    if( rmargin>0 )
        rightry(2) = round(find_line_y(vx,vy,rightrx(2),rightry(2), max(orx) -rmargin));
        rightrx(2) = max(orx) - rmargin;
        
        rightry(3) = round(find_line_y(vx,vy,rightrx(3),rightry(3), max(orx) -rmargin));
        rightrx(3) = max(orx) - rmargin;
    
    end
    
    %%% fix rightwall error ends

end

% given two points (x1,y1) and (y1,y2) and a value of x, find y that 
% makes (x,y) belong to the line.
function x = find_line_x(x1,y1,x2,y2,y)
    
    m = (y1-y2)./(x1-x2);
    b = y1 - m*x1;
    x = (y-b)/m;

end

% given two points (x1,y1) and (y1,y2) and a value of x, find y that 
% makes (x,y) belong to the line.
function y = find_line_y(x1,y1,x2,y2,x)

    m = (y1-y2)./(x1-x2);
    b = y1 - m*x1;
    y = m*x + b;

end

% given a line thru (vx,vy) and (rx,ry), find where it should end given the
% image edges limitx and limity
function [x,y] = find_corner(vx,vy,rx,ry,limitx,limity)
    
    y1 = limity;
    x1 = find_line_x(vx,vy,rx,ry,limity);
    x2 = limitx;
    y2 = find_line_y(vx,vy,rx,ry,limitx);
    if (sum(([vx vy]-[x1 y1]).^2) > sum(([vx vy]-[x2 y2]).^2))
      x = x1;
      y = y1;
    else
      x = x2;
      y = y2;
    end

end