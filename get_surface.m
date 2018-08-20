function  height_map = get_surface(surface_normals, image_size, method)
% surface_normals: 3 x num_pixels array of unit surface normals
% image_size: [h, w] of output height map/image
% height_map: height map of object

height_map = zeros(192,168);

% surface normals: (a,b,c) for each pixel
% df/dx = a/c (aka p) and df/dy = b/c (aka q)
% 
surface_normals_reshaped = reshape(surface_normals,3,192,168);
 %disp(size(surface_normals_reshaped));   
 %disp(surface_normals_reshaped(2,1,1)/surface_normals_reshaped(3,1,1));
 %disp(surface_normals_reshaped(1,1,1)/surface_normals_reshaped(3,1,1));
%% <<< fill in your code below >>>
    prev_height_val = 0;
    switch method
        case 'column' %first along the columns and then the rows
            for r = 2:192
                height_map(r,1) = prev_height_val + surface_normals_reshaped(2,r,1)/surface_normals_reshaped(3,r,1);
                prev_height_val = height_map(r,1);
            end
            for r = 1:192
                prev_height_val = height_map(r,1);
                for x = 2:168
                    height_map(r,x) = prev_height_val + surface_normals_reshaped(1,r,x)/surface_normals_reshaped(3,r,x);
                    prev_height_val = height_map(r,x);
                end
            end
            
        case 'row'   %first along the row of the top pixel and then the columns, doable using cumsum function
            
            for c = 2:168
                height_map(1,c) = prev_height_val + surface_normals_reshaped(1,1,c)/surface_normals_reshaped(3,1,c);
                prev_height_val = height_map(1,c);
            end
            for r = 1:168
                prev_height_val = height_map(1,r);
                for x = 2:192
                    height_map(x,r) = prev_height_val + surface_normals_reshaped(2,x,r)/surface_normals_reshaped(3,x,r);
                    prev_height_val = height_map(x,r);
                end
            end
        case 'average'  % average of the row and column methods
            for r = 2:192
                height_map(r,1) = prev_height_val + surface_normals_reshaped(2,r,1)/surface_normals_reshaped(3,r,1);
                prev_height_val = height_map(r,1);
            end
            for r = 1:192
                prev_height_val = height_map(r,1);
                for x = 2:168
                    height_map(r,x) = prev_height_val + surface_normals_reshaped(1,r,x)/surface_normals_reshaped(3,r,x);
                    prev_height_val = height_map(r,x);
                end
            end
            prev_height_val = 0;
            for c = 2:168
                height_map(1,c) = prev_height_val + surface_normals_reshaped(1,1,c)/surface_normals_reshaped(3,1,c);
                prev_height_val = height_map(1,c);
            end
            for r = 1:168
                prev_height_val = height_map(1,r);
                for x = 2:192
                    height_map(x,r) = prev_height_val + surface_normals_reshaped(2,x,r)/surface_normals_reshaped(3,x,r);
                    prev_height_val = height_map(x,r);
                end
            end
            
            height_map = height_map ./ 2;
            
        case 'random' %average of a bunch of different random methods
            
            num_paths = 4;
            while num_paths > 0
               for r_target = 1:192
                   for c_target = 1:168
                       if r_target == 1 && c_target == 1
                           continue
                       end
                       
                       r=1;
                       c=1;
                       prev_height_val = 0;
                       temp_height_map = zeros(192,168);
                       last_dir = 0;
                       while ~(r == r_target && c == c_target)
                           if r == r_target || r_target == 1
                               random_num = 0;
                           elseif c == c_target || c_target == 1
                               random_num = 1;
                           else
                               random_num = randi([0 1]);
                           end
                           
                           if random_num == 0 %go right
                               temp_height_map(r,c) = prev_height_val + surface_normals_reshaped(1,r,c)/surface_normals_reshaped(3,r,c);
                               prev_height_val = temp_height_map(r,c);
                               c=c+1;
                               last_dir = 0;
                           elseif random_num == 1 %go down
                               temp_height_map(r,c) = prev_height_val + surface_normals_reshaped(2,r,c)/surface_normals_reshaped(3,r,c);
                               prev_height_val = temp_height_map(r,c);
                               r=r+1;
                               last_dir = 1;
                           end

                       end
                       if last_dir == 0
                           height_map(r,c) = height_map(r,c) + temp_height_map(r,c-1);
                       else
                           height_map(r,c) = height_map(r,c) + temp_height_map(r-1,c);
                       end
                       
                   end
               end
               num_paths=num_paths-1;
            end
            
            height_map = height_map ./ 4;
            prev_height_val=0;
            
            
    end

end

