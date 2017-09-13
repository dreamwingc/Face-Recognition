function [result percentage test ddd] = face_recognition(testing_image, mean_image, final_output_number, largest_feature_vectors, SVMStruct_all, compare_image, thresh, his_all)

[a b c] = size(testing_image);

if (c ~= 3)
    testing_image = im2double(testing_image);
else 
    testing_image = rgb2gray(testing_image);
    testing_image = im2double(testing_image);
end

module_number = 16;
L = 40;

testing_image = imresize(testing_image,[66 66]);
% 
mapping=getmapping(8,'riu2');
% 
testing_image = elbp(testing_image, [0 1;1 1;1 0;1 -1;0 -1;-1 -1;-1 0;-1 1;])/255;

test = testing_image;

testing_weight = reshape(test, 64*64, 1);

% histgram
% testing_weight = hist(testing_weight, 100);
% testing_weight = testing_weight';

ddd = 0;

percentage = 0;

% EMD

% his_test = hist(testing_weight, 256)';
% 
% EMD = zeros(256, final_output_number);
% for j=2:256
%     EMD(j,:)=(his_test(j-1,:)+EMD(j-1,1))-his_all(j-1,:);
% end
% 
% distance = sum(abs(EMD),1);
% 
% result = zeros(final_output_number,1);
% 
% for di = 1: size(distance(1,:)')
%    if distance(1,di) < thresh(1,di)
%        result(di,:) = 1;
%    end
% end
% 
% percentage = distance(:);
       

% %%
% [n m z]=size(testing_image);
% D1_testing=n/sqrt(module_number)*ones(1,sqrt(module_number));
% D2_testing=m/sqrt(module_number)*ones(1,sqrt(module_number));
% D3_testing=ones(1,z);
% testing_image=mat2cell(testing_image,D1_testing,D2_testing,D3_testing);
% %%
% testing_image=reshape([testing_image{1:sqrt(module_number),1:sqrt(module_number),1:z}],[(n/sqrt(module_number))*(m/sqrt(module_number)) module_number*z]);
% 
% %% PCA testing
% mean_subtracted_testing_image=testing_image-repmat(mean_image,1,module_number);
% testing_weight=largest_feature_vectors'*mean_subtracted_testing_image;
% 
% tt = testing_weight;
% 
% testing_mid=testing_weight./repmat(max(abs(testing_weight)),[L 1]);
% testing_mid=reshape(testing_mid,[L*module_number z]);
% testing_weight=reshape(testing_weight,[L*module_number z]);



% bbb=largest_feature_vectors*tt(:,1:16)+repmat(mean_image,[1 16]);
% % bbb=reshpae(bbb,[64 64]);
% 
% bbb=reshape(bbb,[16 16 16]);
% ccc=[];
% ddd=[];
% for j=1:4
% for i=1:4
% ccc=[ccc;bbb(:,:,(j-1)*4+i)];
% end
% ddd=[ddd ccc];
% ccc=[];
% end
% MLP
% % hidden layer outputs
% hidden_testing_parameter=hidden_weight*testing_weight;
% hidden_testing_output=1./(1+exp(-hidden_testing_parameter));
% % output layer outputs
% output_testing_parameter=output_weight*hidden_testing_output;
% output_testing=1./(1+exp(-output_testing_parameter));
% % output_testing(output_testing>=0.99)=1;
% % output_testing(output_testing~=1)=0;
% 
% result = output_testing;

% SVM
for i=1:final_output_number
    i
    Group = svmclassify(SVMStruct_all{i,1},testing_weight');
    [Ga Gb]=find(Group==1);
    
    if (size(Ga) == 0)
        result(i,1) = 0;
    else
        result(i,1) = Ga;
%         percentage = 1-sqrt(1/(64*64)*sum((testing_weight - mean_image(:,Ga)).^2));
%         percentage = 1-sqrt(1/(64*64)*sum((testing_weight - compare_image(:,Ga)).^2));
        his1 = hist(compare_image(:,Ga), 9);
        his2 = hist(testing_weight, 9);
        histSize=size(his1);
        percentage=zeros(histSize(1),1);
        for i=1:histSize(1)
            EMD = zeros(1,9);
            for j=2:9
                EMD(:,j)=(his1(:,j-1)+EMD(:,j-1))-his2(:,j-1);
            end;
            %EMDtype = sum(abs(EMD),2)'.*(numLayers+1-(1:numLayers)); %Weighted ring Gaussian
            %EMDtype = sum(abs(EMD),2)'.*((numLayers+1-(1:3))*50); %Weighted ring Gaussian
            %difference(i) = sum(EMDtype);
            percentage(i) = sum(sum(abs(EMD),2));
        end;    
    end
end


