function get3DPoints(app)
    % get3DPoints.m calculates the 3D coordinates of 13 points
    % Inputs:
    % 2D coordinates of 13 points

    % Outputs:
    % app.points_3d: 14*3 matrix, contains 2D coordinates of 13 points and
    % view point

    [points_2d_recoord,VP] = recoord(app);

    eyep = [VP(1), VP(2), 0];

    app.points_3d = zeros(14,3); % set 3D coordinates of view point to [0 0 0]
    
    
    for i = 1:6

        app.points_3d(i,:) = trans_p1_6(points_2d_recoord(i,:), eyep);

    end

    VP_3d = [VP(1), VP(2), app.points_3d(1,3)];

    height = ( points_2d_recoord(7,2) - points_2d_recoord(1,2) ) /  (-1) * ( app.points_3d(1,3) );

    app.points_3d(7,1) = app.points_3d(1,1);
    app.points_3d(8,1) = app.points_3d(2,1);
    app.points_3d(8,2) = height - 1;
    app.points_3d(7,2) = height - 1;
    app.points_3d(7,3) = app.points_3d(1,3);
    app.points_3d(8,3) = app.points_3d(2,3);


    for i = 9:12

        app.points_3d(i,:) = trans_p9_12(points_2d_recoord(i,:), eyep, height);

    end

    app.points_3d(13,:) = VP_3d;
    app.points_3d(14,:) = eyep;

end


function [points_2d_recoord,VP] = recoord(app)

    %%% recoordinate, now rearwall is at (0,0)
    points_2d_recoord = zeros(13,2);

    points_2d_recoord(:,1) = (app.points_2d(:,1) - app.VP(1)) / app.x_limit;
    points_2d_recoord(:,2) = - (app.points_2d(:,2) - app.VP(2)) / app.y_limit;

    VP = [0,0];

end

function p_3d = trans_p1_6(p, eyep)
    % calculate the 6 points at the floor

    p_3d = [0 0 0];

    grad = - ( 1 + eyep(2) ) /( p(2) - eyep(2) );

    p_3d(1) = grad * ( p(1) - eyep(1) ) + eyep(1);
    p_3d(3) = grad * ( -1 - eyep(3) ) + eyep(3);
    p_3d(2) = -1;

end

function p_3d = trans_p9_12(p, eyep, height)
    % calculate the 6 points at the ceil
    p_3d = [0 0 0];
    
    grad = ( height - eyep(2) -1 ) / ( p(2) - eyep(2) );
    p_3d(1) = grad * ( p(1) - eyep(1) ) + eyep(1);
    p_3d(2) = height - 1;
    p_3d(3) = grad * ( -1 - eyep(3) ) + eyep(3);

end



