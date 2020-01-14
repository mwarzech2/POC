close all; clearvars; clc;
load('tablice_kwantyzacji.mat')

lilia = imread('mglawica_kolor.png');
imshow(lilia);


%% Encoding
liliaYUV = rgb2ycbcr(lilia);

liliaYUVsigned = double(liliaYUV) - 128.0;

[sizeY, sizeX, colorsCount] = size(liliaYUVsigned);

Fdct = dct(liliaYUVsigned, [], 1);
Fdct2 = dct(Fdct, [], 2);

c = 1;

Z = liliaYUVsigned;

for X = 1:sizeX
    for Y = 1:sizeY
        Z(Y,X,1) = round(Fdct2(Y,X,1)/(c*Qy(mod(X,8)+1,mod(Y,8)+1)));
    end
end

for C = 2:3
    for X = 1:sizeX
        for Y = 1:sizeY
            Z(Y,X,C) = round(Fdct2(Y,X,C)/(c*Qc(mod(X,8)+1,mod(Y,8)+1)));
        end
    end
end

%% Decoding
Fidct2 = Z;
for X = 1:sizeX
    for Y = 1:sizeY
        Fidct2(Y,X,1) = Z(Y,X,1)*c*Qy(mod(X,8)+1,mod(Y,8)+1);
    end
end

for C = 2:3
    for X = 1:sizeX
        for Y = 1:sizeY
        Fidct2(Y,X,C) = Z(Y,X,C)*c*Qc(mod(X,8)+1,mod(Y,8)+1);
        end
    end
end

Fidct = idct(Fidct2, [], 2);
decImgYUVsigned = idct(Fidct2, [], 1);
decImgYUV = uint8(round(decImgYUVsigned + 128.0));
decImgRgb = ycbcr2rgb(decImgYUV);
figure;
imshow(decImgRgb);


