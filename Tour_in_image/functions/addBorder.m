function imgWithBorder = addBorder(app, img)

    % Usage: input img is the origin image, return img with border

    leftBorder = zeros(size(img, 1), app.lmargin, 3);
    rightBorder = zeros(size(img, 1), app.rmargin, 3);

    imgWithBorder = [leftBorder, img, rightBorder];

    topBorder = zeros(app.tmargin, size(imgWithBorder,2), 3);
    bottomBorder = zeros(app.bmargin, size(imgWithBorder,2), 3);

    imgWithBorder = [topBorder; imgWithBorder; bottomBorder];

end