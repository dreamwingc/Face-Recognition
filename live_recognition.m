%% use IP camera 
clear all;close all;clc;
load image_number;
load final_output_number;
load label;
load largest_feature_vectors;
load mean_image;
load hidden_weight;
load output_weight;
load SVMStruct_all;
load compare_image;
load thresh;
load his_all;


i = 1;
url = 'http://192.168.22.18/image?res=half&x0=0&y0=[object%20Window]&x1=1600&y1=1200&quality=15&doublescan=0&ssn=1400608181593&id=1400609576374'; 
ss = imread(url); 
FileNum = 1; 
fh = image(ss); 
warn_person = 0;
warn_person_old = 0;
num_warnr = 0;
point = 0;
nu = 0;
denu = 0;
sbox = [];
while(1) 
%pause(1) 
ss = imread(url); 

faceDetector = vision.CascadeObjectDetector('MergeThreshold', 8); % Default: finds faces 
 
bbox = step(faceDetector, ss); % Detect faces

if (size(bbox) ~= 0)
    position = bbox;
    for a = 1:length(bbox(:,1))
        face{:,:,:,a} = ss(position(a,2):position(a,2)+position(a,4)-1, position(a,1):position(a,1)+position(a,3)-1, :);

        [warn(:,a) percentage(:,a) test ddd] = face_recognition(face{:,:,:,a}, mean_image, final_output_number, largest_feature_vectors, SVMStruct_all, compare_image, thresh, his_all);

        [num_warnr(:,a) num_wanc(:,a)] = size(find(warn(:,a)~=0));
        
        if (num_warnr(:,a) ~= 0)
            [warn_person(:,a) warn_c(:,a)] = find(warn(:,a)~=0);
        else
            warn_person(:,a) = 0;
        end
    end
    
    whole(:,:,:,i) = ss;
    i = i+1;
else
   set(fh,'CData',ss); 
   drawnow;
   nu = 0;
   denu = 0;
end

for a = 1:length(bbox(:,1))
if (num_warnr(:,a) ~= 0)
    
    sbox = [sbox; bbox(a,:)];
    
% Text of the bounding boxes
        if(warn_person(:,a) == 1)
            text = vision.TextInserter('Sai');
        else if (warn_person(:,a) == 2)
        text = vision.TextInserter('Evan');
        else if (warn_person(:,a) == 3)
        text = vision.TextInserter('Tom');
        else if (warn_person(:,a) == 4)        
        text = vision.TextInserter('John');
        else if (warn_person(:,a) == 5)
        text = vision.TextInserter('Kevin');
        else if (warn_person(:,a) == 6)
        text = vision.TextInserter('Fatima');
        else if (warn_person(:,a) == 7)
        text = vision.TextInserter('Nina');   
            end
            end
            end
            end
            end
            end
        end
        
%         
%         if (warn_person(:,a) == 1)
%             text = vision.TextInserter('Michelle');
%         else if(warn_person(:,a) == 2)
%             text = vision.TextInserter('Sai');
%         else if (warn_person(:,a) == 3)
%         text = vision.TextInserter('Evan');
%         else if (warn_person(:,a) == 4)
%         text = vision.TextInserter('Tom');
%         else if (warn_person(:,a) == 5)        
%         text = vision.TextInserter('John');
%         else if (warn_person(:,a) == 6)
%         text = vision.TextInserter('Kevin');
%         else if (warn_person(:,a) == 7)
%         text = vision.TextInserter('Fatima');
%         else if (warn_person(:,a) == 8)
%         text = vision.TextInserter('Nina');   
%             end
%             end
%             end
%             end
%             end
%             end
%             end
%         end
        
        text.Color = [255, 0, 0]; % [red, green, blue]
        text.FontSize = 24;
        
        text_name{a,:} = text;
        
        denu = denu + 1;
        
%         if (warn_person(:,a) == warn_person_old(:,a)||warn_person_old == 0)
%             nu = nu +1;
%             percentage = 100*nu/denu;
%         else
%             nu = 0;
%             denu = 0;
%             percentage = 0;
%         end
        
        
        
        text_per = sprintf('%f', percentage);
        text2 = vision.TextInserter(text_per);
        text2.Color = [0, 255, 0]; % [red, green, blue]
        text2.FontSize = 24;

        if (~isempty(bbox))
            text.Location = [bbox(a,1) bbox(a,2)]; % [x y]
            text2.Location = [bbox(a,1) + bbox(a,3) bbox(a,2) + bbox(a,4)];
        end

% Draw bounding boxes
        shapeInserter = vision.ShapeInserter(...    
                            'BorderColor','Custom',...
                            'CustomBorderColor',[255 255 0]);
        I_faces = step(shapeInserter, ss, int32(sbox));
        
        for tn = 1:length(sbox(:,1))
            if(length(text_name{tn,1}) ~= 0)
                I_faces = step(text_name{tn,:}, I_faces);
%                 I_faces = step(text2, I_faces);
            end
        end

        set(fh,'CData',I_faces); 
        drawnow;
        clear text text2
else
   set(fh,'CData',ss); 
   drawnow; 
   denu = denu +1;
end
end

warn_person_old = warn_person;

clear face warn percentage test ddd warn_person warn_c num_warnr num_wanc text_name;

sbox = [];


warn_person = 0;
num_warnr = 0;

FileNum = FileNum + 1; 

%filename = 'haarcascades/haarcascade_frontalface_alt.xml';
%cls = cv.CascadeClassifier(filename);
%boxes = cls.detect(im);


end