function getTransCoordinates2D(app)
% calculate pixel coordinates of vertices after transformation
% used to stretch image
    cameraMatrix = getKaliMatrix(app);
    K_trans = getTransMatrix(app, cameraMatrix);
    transPointCoordinates(K_trans, app);

 
function cameraMatrix = getKaliMatrix(app)    
% getKaliMatrix.m calculates the original camera matrix
% Inputs:
% p1_3d, p2_3d: World coordinates of p1 and p2
% vp_2d, p1_2d, p3_2d: Pixel coordinates of vanishing point, p1 and p2
% Outputs:
% cameraMatrix: Camera matrix of dimension 3x4
    p1_3d = app.points_3d(1, :);
    p2_3d = app.points_3d(2, :);
    vp_2d = app.VP;
    p1_2d = app.points_2d(1, :);
    p2_2d = app.points_2d(2, :);

    o_x = vp_2d(1);
    o_y = vp_2d(2);
    K_11 = (p1_3d(3) * (p1_2d(1) - o_x) * p2_3d(2) - ...
            p2_3d(3) * (p2_2d(1) - o_x) * p1_3d(2)) / ...
            (p1_3d(1) * p2_3d(2) - p2_3d(1) * p1_3d(2));
    K_12 = (p1_3d(3) * (p1_2d(1) - o_x) * p2_3d(1) - ...
            p2_3d(3) * (p2_2d(1) - o_x) * p1_3d(1)) / ...
            (p1_3d(2) * p2_3d(1) - p2_3d(2) * p1_3d(1));
    K_22 = p1_3d(3) * (p1_2d(2) - o_y) / p1_3d(2);
    cameraMatrix = [K_11 K_12 o_x;
         0    K_22 o_y;
         0    0    1  ];
    Pi_0 = [1 0 0 0;
            0 1 0 0;
            0 0 1 0];
    cameraMatrix = cameraMatrix * Pi_0;
    app.CameraMatrix = cameraMatrix;



function K_trans = getTransMatrix(app, K)
% getTransMatrix calculates the camera matrix after transformation
% Inputs: 
% theta: yaw in rad
% phi: pitch in rad
% x, y, z: displacement
% K: original camera matrix
% Outputs:
% K_trans: camera matrix after transformation in dimension 3x4
% RT: rotation matrix ; displacement
    phi = app.phi;
    theta = app.theta;
    x = app.x;
    y = app.y;
    z = app.z;
    %K = app.K;

    R = [cos(theta)              0         sin(theta);
         -sin(theta) * sin(phi)   cos(phi)  cos(theta) * sin(phi);
         -sin(theta) * cos(phi)  -sin(phi)  cos(theta) * cos(phi)];
    T = [-x; -y; z];
    RT = [R T; 0 0 0 1];
    K_trans = K * RT;
    app.K_trans = K_trans;


function [trans_points_3d, trans_points_2d] =  transPointCoordinates(K_trans, app)
% transPointCoordinates.m calculates point coordinates after sight transformation
% Inputs:
% K_trans: Camera matrix after transformation
% ..._3d: World coordinates of vertices
% Outputs:
% trans..._3: Homogeneous coordinates of vertices after transformation;
%             dimension 1x3
% trans..._2: Devide the third component of homogenous coordinates;
%             dimension 1x2
    
    trans_points_3d = zeros(13,3);
    trans_points_2d = zeros(13,2);
    for i = 1:13
        % homogeneous coordinates
        trans_points_3d(i,:) = K_trans * [app.points_3d(i, :)';1];
        % homogeneous coordinates to pixel coordinates
        if trans_points_3d(i,3) ~= 0
            trans_points_2d(i,1) = trans_points_3d(i,1)/trans_points_3d(i,3);
            trans_points_2d(i,2) = trans_points_3d(i,2)/trans_points_3d(i,3);
        else
            trans_points_2d(i,1) = trans_points_3d(i,1)/0.01;
            trans_points_2d(i,2) = trans_points_3d(i,1)/0.01;
        end
    end
   
    app.trans_points_3d = trans_points_3d;
    app.trans_points_2d = trans_points_2d;
    
        
