% new training images captured from IP camera
i = 1;
url = 'http://192.168.22.18/image?res=half&x0=0&y0=[object%20Window]&x1=1600&y1=1200&quality=15&doublescan=0&ssn=1400608181593&id=1400609576374'; 
% url = 'http://192.168.22.6:80/jpg/image.jpg?timestamp=';
ss = imread(url); 
FileNum = 1; 
fh = image(ss); 
num_warnr = 0;
while(1) 
%pause(1) 
ss = imread(url); 

 faceDetector = vision.CascadeObjectDetector('MergeThreshold', 4); % Default: finds faces 
%faceDetector = vision.CascadeObjectDetector;
 
bbox = step(faceDetector, ss); % Detect faces

if (size(bbox) ~= 0)
    i
    position = bbox;
    face = ss(position(1,2):position(1,2)+position(1,4), position(1,1):position(1,1)+position(1,3), :);
    
    filename = sprintf('/home/chen/Dropbox/Face_Rec_Demo/test/persont_%d.png', i);
    imwrite(face,filename);
    
    whole(:,:,:,i) = ss;
    i = i+1;
end

% Draw bounding boxes
shapeInserter = vision.ShapeInserter(...    
                    'BorderColor','Custom',...
                    'CustomBorderColor',[255 255 0]);    
I_faces = step(shapeInserter, ss, int32(bbox));   

set(fh,'CData',I_faces); 
drawnow;

FileNum = FileNum + 1; 

end