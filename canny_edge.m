%image reading
II = imread('week2.gif');
si = size(II);

% GRAYSCALE
if(length(si)==2)
    I = II;
elseif(length(si)==3)
    I = 0.2989.*II(:,:,1) + 0.587.*II(:,:,2) + 0.114.*II(:,:,3);
end
%gaussian blur filter(3*3)
g = [1 2 1;2 4 2;1 2 1]/16;
%edge detection sobel filters(3*3)
h = [-1 -2 -1;0 0 0;1 2 1];
v = [-1 0 1;-2 0 2;-1 0 1];
%convolution of filter and image
G = convl(g,double(I));
H = convl(h,double(G));
V = convl(v,double(G));
%final sobel edge using H and V
M = sqrt(H.*H + V.*V);
mag = padding(M);
%gradient
gd = atan((V+0.001)./(H+0.001));
[r,s] = size(gd);

for x=1:r
   for y=1:s
       if (-pi/2<=gd(x,y) && gd(x,y)<-3*pi/8) || (3*pi/8<=gd(x,y) && gd(x,y)<=pi/2)
           gd(x,y) = pi/2;
       elseif (pi/8<=gd(x,y) && gd(x,y)<3*pi/8)
           gd(x,y) = pi/4;
       elseif (-3*pi/8<=gd(x,y) && gd(x,y)<-pi/8)
           gd(x,y) = -pi/4;
       elseif (-pi/8<=gd(x,y) && gd(x,y)<pi/8)
           gd(x,y) = 0;
       end
   end
end

te = zeros(r,s);

%non-maximum suppression
 for m=2:r-1
     for n=2:s-1
         if gd(m,n) == 0
             if (mag(m,n)>mag(m-1,n)) && (mag(m,n)>mag(m+1,n))
                 te(m,n) = mag(m,n);
             else
                 te(m,n) = 0;
             end
         elseif gd(m,n) == pi/4
             if (mag(m,n)>mag(m-1,n-1)) && (mag(m,n)>mag(m+1,n+1))
                 te(m,n) = mag(m,n);   
             else
                 te(m,n) =0;
             end
         elseif gd(m,n) == -pi/4
             if (mag(m,n)>mag(m-1,n+1)) && (mag(m,n)>mag(m+1,n-1))
                 te(m,n) = mag(m,n);    
             else
                 te(m,n) =0;
             end
         elseif gd(m,n) == pi/2
              if (mag(m,n)>mag(m,n-1)) && (mag(m,n)>mag(m,n+1))
                  te(m,n) = mag(m,n);
              else
                  te(m,n) = 0;
              end
         end
     end
 end 
[x,y] = size(te);
teb = zeros(x,y);
upth = 0.15*max(max(te));
loth = 0.05*max(max(te));

%double thresholding and edge hysteresis
for i = 1:x
    for j = 1:y
        if (te(i, j)>loth && te(i, j)<upth) && ((teb(i-1,j)==255) || (teb(i+1,j)==255) || (teb(i+1,j-1)==255) || (teb(i-1,j-1)==255) || (teb(i,j-1)==255) || (teb(i+1,j+1)==255) || (teb(i-1,j+1)==255) || (teb(i,j+1)==255))
            teb(i, j)=255;
        elseif(te(i, j)>upth)
            teb(i, j)=255;
         else
             teb(i, j)=0;
        end
    end
end


figure
imshow(II)
title('original')
figure
imshow(I)
title('grayscale')
figure
imshow(uint8(M))
title('sobel magnitude')
figure
imshow(uint8(te))
title('non max suppression')
figure
imshow(uint8(teb)) 
title('canny edge')
 
 
%convolution function
function[fimage] = convl(filter,image)
img = padding(image);
[row,col] = size(img);
fimage = zeros(row-2,col-2);
 for m=2:1:row-1
     for n=2:1:col-1
         fimage(m-1,n-1) = sum(sum(filter.*img(m-1:m+1,n-1:n+1)));
     end
 end
end
%padding function
function[pimage] = padding(image)
p1 = [image(:,1) image image(:,size(image,2))];
pimage = [p1(1,:); p1; p1(size(p1,1),:)];
end





