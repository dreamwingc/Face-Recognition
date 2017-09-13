clear all;clc;

image_number = 155;

final_output_number = 6;

label = ones(1,image_number);
label = [label zeros(1,image_number); zeros(1,image_number) label];
mean_image = [];

his_all = [];

thresh = [];

save image_number image_number;
save final_output_number final_output_number;
save label label;
save mean_image mean_image;
save his_all his_all;
save thresh thresh;