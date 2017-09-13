%% use IP camera 
clear all;close all;clc;

i = 1;
url = 'http://192.168.22.18/image?res=half&x0=0&y0=[object%20Window]&x1=1600&y1=1200&quality=15&doublescan=0&ssn=1400608181593&id=1400609576374'; 
ss = imread(url); 
fh = image(ss); 

while(1) 
%pause(1) 
ss = imread(url); 
set(fh,'CData',ss); 
drawnow;
end