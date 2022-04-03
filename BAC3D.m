function BAC3D(varargin)
% recebe cortes tomograficos e reconstroi tridimensionalmente

D=varargin{1};
E=D/max(D(:));
% [x y z E]= subvolume(E,[1 size(E,1)/2 1 size(E,2) 1 size(E,3)]);
% p = patch(isosurface(x,y,z,E), 'FaceColor', 'blue', 'EdgeColor', 'red');
% p2 = patch(isocaps(x,y,z,E, 5), 'FaceColor', 'interp', 'EdgeColor', 'none');
% isonormals(x,y,z,E,p);
% view(3);
% daspect([1 1 .4])
% colormap(gray(100))
% camva(9);
% box on
% camlight(40, 40);
% camlight(-20,-10);
% lighting gouraud

% E(:,1:size(E,2)/2,:) = [];
close all
p1 = patch(isosurface(E, 0.87),'FaceColor','red',...
 'EdgeColor','none');
p2 = patch(isocaps(E, 0.87),'FaceColor','interp',...
 'EdgeColor','none');
view(3); axis tight; daspect([1,1,.4])
colormap(gray(100))
camlight left; camlight; lighting gouraud
isonormals(D,p1)

end