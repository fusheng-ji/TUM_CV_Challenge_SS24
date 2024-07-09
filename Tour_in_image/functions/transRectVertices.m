function [transRectVerticesCoord_pix, transRectVerticesCoord_pix_judge] = transRectVertices(app)
% calculate each pixel coordinate of new vertices after transformation

    points_3d = app.points_3d;
    CameraMatrix = app.CameraMatrix;
    K_trans = app.K_trans;
    
    transRectVerticesCoord_3d = zeros(12,3);

    %%%%%%%
    x = app.x;
    y = app.y;
    z = app.z;
    theta = -app.theta;
    phi = app.phi;
    transRectVerticesFake_3d = zeros(12,3);
    % transformation geometry
    if z>0
        for i = 1:12
            transRectVerticesFake_3d(i,:) = [points_3d(i,1), points_3d(i,2),...
                points_3d(i,3)-z+tan(theta)*(x-points_3d(i,1))-tan(phi)*(y-points_3d(i,2))];
        end
        %%%%%%%

        % new x6 3d
        z6 = (app.x_limit * (K_trans(3,1)*points_3d(6,1)+K_trans(3,2)*points_3d(6,2)+K_trans(3,4)) - ...
            K_trans(1,1)*points_3d(6,1)-K_trans(1,2)*points_3d(6,2)-K_trans(1,4)) / ...
            (K_trans(1,3) - K_trans(3,3) * app.x_limit);
        transRectVerticesCoord_3d(6,:)=[points_3d(6,1),points_3d(6,2),z6];

        % new x12 3d
        z12 = (app.x_limit * (K_trans(3,1)*points_3d(12,1)+K_trans(3,2)*points_3d(12,2)+K_trans(3,4)) - ...
            K_trans(1,1)*points_3d(12,1)-K_trans(1,2)*points_3d(12,2)-K_trans(1,4)) / ...
            (K_trans(1,3) - K_trans(3,3) * app.x_limit);
        transRectVerticesCoord_3d(12,:)=[points_3d(12,1),points_3d(12,2),z12];

        % new x11 3d
        z11 = (0 * (K_trans(3,1)*points_3d(11,1)+K_trans(3,2)*points_3d(11,2)+K_trans(3,4)) - ...
            K_trans(1,1)*points_3d(11,1)-K_trans(1,2)*points_3d(11,2)-K_trans(1,4)) / ...
            (K_trans(1,3) - K_trans(3,3) * 0);
        transRectVerticesCoord_3d(11,:)=[points_3d(11,1),points_3d(12,2),z11];

        % new x5 3d
        z5 = (0 * (K_trans(3,1)*points_3d(5,1)+K_trans(3,2)*points_3d(5,2)+K_trans(3,4)) - ...
            K_trans(1,1)*points_3d(5,1)-K_trans(1,2)*points_3d(5,2)-K_trans(1,4)) / ...
            (K_trans(1,3) - K_trans(3,3) * 0);
        transRectVerticesCoord_3d(5,:)=[points_3d(5,1),points_3d(5,2),z5];

        % new x3 3d
        z3 = (app.y_limit * (K_trans(3,1)*points_3d(3,1)+K_trans(3,2)*points_3d(3,2)+K_trans(3,4)) - ...
            K_trans(2,1)*points_3d(3,1)-K_trans(2,2)*points_3d(3,2)-K_trans(2,4)) / ...
            (K_trans(2,3) - K_trans(3,3) * app.y_limit);
        transRectVerticesCoord_3d(3,:)=[points_3d(3,1),points_3d(3,2),z3];

        % new x4 3d
        z4 = (app.y_limit * (K_trans(3,1)*points_3d(4,1)+K_trans(3,2)*points_3d(4,2)+K_trans(3,4)) - ...
            K_trans(2,1)*points_3d(4,1)-K_trans(2,2)*points_3d(4,2)-K_trans(2,4)) / ...
            (K_trans(2,3) - K_trans(3,3) * app.y_limit);
        transRectVerticesCoord_3d(4,:)=[points_3d(4,1),points_3d(4,2),z4];

        % new x9 3d
        z9 = (0 * (K_trans(3,1)*points_3d(9,1)+K_trans(3,2)*points_3d(9,2)+K_trans(3,4)) - ...
            K_trans(2,1)*points_3d(9,1)-K_trans(2,2)*points_3d(9,2)-K_trans(2,4)) / ...
            (K_trans(2,3) - K_trans(3,3) * 0);
        transRectVerticesCoord_3d(9,:)=[points_3d(9,1),points_3d(9,2),z9];

        % new x10 3d
        z10 = (0 * (K_trans(3,1)*points_3d(10,1)+K_trans(3,2)*points_3d(10,2)+K_trans(3,4)) - ...
            K_trans(2,1)*points_3d(10,1)-K_trans(2,2)*points_3d(10,2)-K_trans(2,4)) / ...
            (K_trans(2,3) - K_trans(3,3) * 0);
        transRectVerticesCoord_3d(10,:)=[points_3d(10,1),points_3d(10,2),z10];

        transRectVerticesCoord_3d(1,:) = points_3d(1,:);
        transRectVerticesCoord_3d(2,:) = points_3d(2,:);
        transRectVerticesCoord_3d(7,:) = points_3d(7,:);
        transRectVerticesCoord_3d(8,:) = points_3d(8,:);

    else
        transRectVerticesFake_3d = points_3d;
        transRectVerticesCoord_3d = points_3d;
    end


    transRectVerticesCoord_homo = zeros(12,3);
    transRectVerticesCoord_pix = zeros(12,2);
    transRectVerticesCoord_homo_judge = zeros(12,3);
    transRectVerticesCoord_pix_judge = zeros(12,2);

    for i = 1:12
        transRectVerticesCoord_homo(i,:) = (CameraMatrix * [transRectVerticesCoord_3d(i,:)';1])';
        transRectVerticesCoord_homo_judge(i,:) = (K_trans * [transRectVerticesFake_3d(i,:)';1])';
        transRectVerticesCoord_pix(i,1) = transRectVerticesCoord_homo(i,1)/transRectVerticesCoord_homo(i,3);
        transRectVerticesCoord_pix(i,2) = transRectVerticesCoord_homo(i,2)/transRectVerticesCoord_homo(i,3);
        transRectVerticesCoord_pix_judge(i,1) = transRectVerticesCoord_homo_judge(i,1)/transRectVerticesCoord_homo_judge(i,3);
        transRectVerticesCoord_pix_judge(i,2) = transRectVerticesCoord_homo_judge(i,2)/transRectVerticesCoord_homo_judge(i,3);
    end
end