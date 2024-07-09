function GetDatasetList(app)
    % Usage: get the dir information
    if app.DEBUG_MODE
        app.image_path = './dataset';
    else
        app.image_path = uigetdir();
    end
    dir_info = dir(app.image_path);
    dir_info = dir_info(~ismember({dir_info.name},{'.','..','.DS_Store'}));
    % get path list
    dir_list = fullfile({dir_info.folder}, {dir_info.name})';
    % get name list
    data_names = {dir_info.name}';
    app.image_names = cellfun(@getImageName,data_names,'UniformOutput',false);
    
    % update the tree menu
    if ~isempty(app.Tree.Children)
        app.Tree.Children.delete
    end
    
    default_tree = uitreenode(app.Tree,'Text','default Dataset');
    for index = 1:length(data_names)
        uitreenode(default_tree,'Text',app.image_names{index}, ...
                'NodeData', dir_list{index});
    end

    % expand the tree list
    expand(app.Tree);
end

%% function area
function dirname = getImageName(path)
    [~,dirname,~] = fileparts(path);
end