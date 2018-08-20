function [albedo_image, surface_normals] = photometric_stereo(imarray, light_dirs)
% imarray: h x w x Nimages array of Nimages no. of images
% light_dirs: Nimages x 3 array of light source directions
% albedo_image: h x w image
% surface_normals: h x w x 3 array of unit surface normals

%192x168x64
% 64 = Nimages
surface_normals = zeros(192,168,3);
albedo_image = zeros(192,168);
%g_vec = zeros(3,32256);  
g_vec_x = zeros(1,32256);
g_Vec_y = zeros(1,32256);
g_vec_z = zeros(1,32256);


 %x = A\b; % to solve for x in Ax=b
 %use reshape and cat to change layout of matrices before and after least
 %square 
 %Ax=b where A is light_dirs, b is imarray, x is g_vec
 % reshape imarray to 64x32,256
 imarray = permute(imarray, [3 1 2]);
 imarray_reshaped = reshape(imarray,64,32256);
 
 %g_vec = light_dirs\imarray_reshaped;
 g_vec_x = light_dirs(:,1)\imarray_reshaped;
 g_vec_y = light_dirs(:,2)\imarray_reshaped;
 g_vec_z = light_dirs(:,3)\imarray_reshaped;
 
 %g_vec_reshaped = reshape(g_vec,3,192,168);
 g_vec_x_reshaped = reshape(g_vec_x,192,168);
 g_vec_y_reshaped = reshape(g_vec_y,192,168);
 g_vec_z_reshaped = reshape(g_vec_z,192,168);
 
 for x = 1 : 192
     for y = 1 : 168
        
        %albedo_image(x,y) = sqrt(g_vec_reshaped(1,x,y)^2 + g_vec_reshaped(2,x,y)^2 + g_vec_reshaped(3,x,y)^2);
        albedo_image(x,y) = sqrt(g_vec_x_reshaped(x,y)^2 + g_vec_y_reshaped(x,y)^2 + g_vec_z_reshaped(x,y)^2);
        
        
        %surface_normals(x,y,:) = g_vec_reshaped(:,x,y)./albedo_image(x,y);
        surface_normals(x,y,:) = [g_vec_x_reshaped(x,y),g_vec_y_reshaped(x,y),g_vec_z_reshaped(x,y)]./albedo_image(x,y);
        %disp(surface_normals(x,y,:));
        
     end
 end
end

