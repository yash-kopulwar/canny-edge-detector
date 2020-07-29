I0 = double(imread('lenna512.png'));
si = size(I0);

% GRAYSCALE
if(length(si)==2)
    I = I0;
elseif(length(si)==3)
    I = 0.2989.*I0(:,:,1) + 0.587.*I0(:,:,2) + 0.114.*I0(:,:,3);
end


% PADDING
% done in kernal_conv() function.

% GAUSSIAN BLURR
gb_mask = [1 2 1;
           2 4 2;
           1 2 1];
Igb = kernal_conv(I, gb_mask);
size(Igb);

% VERTICAL EDGE
ver_mask =  [1 0 -1;
            2 0 -2;
            1 0 -1];
Iver_gr = kernal_conv(Igb, ver_mask);

% HORIZONTAL EDGE
h_mask = [-1 -2 -1;
          0 0 0;
          1 2 1];
Ih_gr = kernal_conv(Igb, h_mask);

% HORIZONTAL PLUS VERTICAL
I_mag = sqrt(Iver_gr.^2 + Ih_gr.^2);        % first image with all edges is I_mag

% ANGLE MATRIX
Iver_gr = Iver_gr + 0.001;
Ih_gr = Ih_gr + 0.001;
I_angles = atan(Iver_gr./Ih_gr);


% NON-MAXIMUM SUPPRESSION
I_mag_padded = padding(I_mag);
I_nms = zeros();
for i = 1:size(I_mag, 1)
    for j = 1:size(I_mag, 2)
        if(I_angles(i,j)<=pi/2+0.1 && I_angles(i,j)>3*pi/8)
            I_nms(i, j) = min_edge([I_mag_padded(i+1, j) I_mag_padded(i+1, j+1) I_mag_padded(i+1, j+2)]);
        elseif(I_angles(i,j)<=3*pi/8 && I_angles(i,j)>pi/8)
            I_nms(i, j) = min_edge([I_mag_padded(i+2, j) I_mag_padded(i+1, j+1) I_mag_padded(i, j+2)]);
        elseif(I_angles(i,j)<=pi/8 && I_angles(i,j)>-pi/8)
            I_nms(i, j) = min_edge([I_mag_padded(i, j+1) I_mag_padded(i+1, j+1) I_mag_padded(i+2, j+1)]);
        elseif(I_angles(i,j)<=-pi/8 && I_angles(i,j)>-3*pi/8)
            I_nms(i, j) = min_edge([I_mag_padded(i, j) I_mag_padded(i+1, j+1) I_mag_padded(i+2, j+2)]);
        elseif(I_angles(i,j)<=-3*pi/8 && I_angles(i,j)>=-pi/2-0.01)
            I_nms(i, j) = min_edge([I_mag_padded(i+1, j) I_mag_padded(i+1, j+1) I_mag_padded(i+1, j+2)]);
        end
        
    end
end

% DOUBLE THRESHOLD
upth = .15*max(max(I_nms));
loth = .05*max(max(I_nms));
I_dth = zeros();
I_nms = uint8(I_nms);
for i = 1:size(I_nms, 1)
    for j = 1:size(I_nms, 2)
        if(I_nms(i, j)<loth)
            I_dth(i, j) = 0;
        elseif(I_nms(i, j)>upth)
            I_dth(i, j) = 255;
        elseif isConnected(I_nms, i, j, upth)==1
            I_dth(i, j) = 255;
        end
        
    end
end


% figure; imshow(uint8(I_dth)); title(['double threshold (upper\_th - ', num2str(upth), ', lower\_th - ', num2str(loth), ')'])
% %figure; a2 = I_nms'; b2 = a2(:); plot((b2)); title('non-maximim suppression graph')
% figure; imshow(uint8(I_nms)); title('non-maximim suppression')
% figure; imshow(uint8(I_angles.*100)); title('gradient matrix')
% %figure; a1 = I_mag'; b1 = a1(:); plot((b1)); title('sobel_graph')
% figure; imshow(uint8(I_mag)); title('sobel (magnitude matrix)')
% % figure; a0 = I'; b0 = a0(:); plot(b0)
% figure; imshow(uint8(I)); title('grayscale')
% figure; imshow(uint8(I0)); title('original')

figure(1)
imshow(uint8(I_dth)); title(['double threshold (upper\_th - ', num2str(upth), ', lower\_th - ', num2str(loth), ')'])
% figure(2)
% imshow(edge(I, 'canny')); title('inbuilt function')

function b = kernal_conv(I, mask)
    s = size(I);
  
        I = padding(I);
        b1 = zeros();
       for i = 2:size(I, 1)-1
         for j = 2:size(I, 2)-1
              conv_matrix=mask.*I(i-1:i+1, j-1:j+1);  
              avg=sum(sum(conv_matrix));
             b1(i-1, j-1)=(avg);
         end
       end    
    
        if(sum(sum(mask))~=0)
            b = b1/sum(sum(mask));
        else
            b = b1;
        end
    
end
function b = padding(I)
    s = size(I);
        b = [ I(:, 1)  I  I(:, s(1, 2)) ];
        b = [ b(1, :); b; b(s(1, 1), :) ];
end
function b = min_edge(a)
    x = a(1, 1);
    y = a(1, 2);
    z = a(1, 3);
    
    if(y>x && y>z)
        y = y;
    elseif(x==y && y>z)
        x = x;
        y = y;
    elseif(x<y && y==z)
        y = y;
        z = z;
    elseif(x==y && y==z)
        y = y;
    else
        y = 0;
    end
        
    b = y;
end
function b = isConnected(I, i, j, upth)
    b = 0;
    I1 = padding(I);
    if I1(i, j)>upth || I1(i, j+1)>upth ||I1(i, j+2)>upth ||I1(i+1, j)>upth ||I1(i+1, j+2)>upth ||I1(i+2, j)>upth ||I1(i+2, j+1)>upth ||I1(i+2, j+2)>upth 
        b = 1;
    end
    
end
