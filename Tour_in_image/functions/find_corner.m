function [x,y] = find_corner(vx,vy,rx,ry,limitx,limity)
    % given a line thru (vx,vy) and (rx,ry), find where it should end given the
    % image edges limitx and limity
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

function x = find_line_x(x1,y1,x2,y2,y)
    m = (y1-y2)./(x1-x2);
    b = y1 - m*x1;
    x = (y-b)/m;
end

function y = find_line_y(x1,y1,x2,y2,x)
    m = (y1-y2)./(x1-x2);
    b = y1 - m*x1;
    y = m*x + b;
end