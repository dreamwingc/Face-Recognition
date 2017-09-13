function [mean_image, final_output_number, largest_feature_vectors, SVMStruct_all, percentage_features, image_number,imageData, label] = face_train(in_image_number, final_output_number, image_number, imageData, label, mean_image)
% Training

module_number=16;

SVMStruct_all = {};

final_output_number = final_output_number + 1;
image_number = image_number + in_image_number;

% make label
% label_mid = zeros(final_output_number, in_image_number);   
% label_mid(1, :) = 1;
% 
% label = [zeros(1, size(label,2)); label];
% label = [label_mid label];

imageData=imresize(round(255*imageData),[66 66]);
% front_image = imresize(round(255*front_image), [66 66]);

mapping=getmapping(8,'riu2');
for i=1:image_number
    imageData_(:,:,i)=elbp(imageData(:,:,i),[0 1;1 1;1 0;1 -1;0 -1;-1 -1;-1 0;-1 1;])/255;
end
clear imageData

% front_image = elbp(front_image, [0 1;1 1;1 0;1 -1;0 -1;-1 -1;-1 0;-1 1;])/255;
% front_image = reshape(front_image, 64*64, 1);

imageData=imageData_;

training_weight = reshape(imageData, 64*64, image_number);

% histgram
% training_weight = hist(training_weight, 100);

if(final_output_number == 2)
    mean_image = [sum(training_weight(:,1:in_image_number),2)./in_image_number sum(training_weight(:,in_image_number + 1:end),2)./(image_number - in_image_number)];
else
    mean_image = [sum(training_weight(:,1:in_image_number),2)./in_image_number mean_image];
end

% EMD feature
% mean_image = mean(training_weight, 2);
% 
% 
largest_feature_vectors = 0;
percentage_features = 0;
% 
% his1 = hist(mean_image, 256);
% his2 = hist(training_weight, 256)';
% EMD = zeros(image_number,256);
% for j=2:256
%     EMD(:,j)=(his1(:,j-1)+EMD(:,j-1))-his2(:,j-1);
% end;
% 
% training_weight = EMD';

%EMD

% his_train = hist(training_weight(:, 1: in_image_number), 256);
% 
% front_his = hist(front_image, 256)';
% 
% EMD = zeros(256, in_image_number);
% for j=2:256
%     EMD(j,:)=(his_train(j-1,:)+EMD(j-1,:))-front_his(j-1,:);
% end
% 
% dis = mean(sum(abs(EMD),1));
% 
% thresh = [dis thresh];
% 
% his_all = [front_his his_all];

%% PCA Training
% [n m z]=size(imageData);
% D1=n/sqrt(module_number)*ones(1,sqrt(module_number));
% D2=m/sqrt(module_number)*ones(1,sqrt(module_number));
% D3=ones(1,z);
% L=40;
% train_image=mat2cell(imageData,D1,D2,D3);
% train_image=reshape([train_image{1:sqrt(module_number),1:sqrt(module_number),1:z}],[n/sqrt(module_number)*m/sqrt(module_number) module_number*z]);
% mean_image=1/(image_number*module_number)*sum(train_image,2);
% mean_subtracted_image=train_image-repmat(mean_image,[1,image_number*module_number]);
% 
% 
% covariance_matrix=1/(image_number*module_number)*(mean_subtracted_image*mean_subtracted_image');
% [eigen_vector eigen_value]=eig(covariance_matrix);
% eigen_value(eigen_value==0)=[];
% [eigen_value_descending index_matrix]=sort(eigen_value,'descend');
% 
% percentage_features=sum(eigen_value_descending(1:L))/sum(eigen_value_descending);
% largest_feature_vectors=eigen_vector(:,index_matrix(1:L));
% 
% training_weight=largest_feature_vectors'*mean_subtracted_image;
% training_weight=reshape(training_weight,[L*module_number z]);


% MLP
% nita=0.5;
% [n z]=size(training_weight);
% % Initialize hidden layer and output layer weight matrics, from -1 to 1
% hidden_weight=-1+(1-(-1)).*rand(final_output_number,n);
% output_weight=-1+(1-(-1)).*rand(final_output_number,final_output_number);
% % 
% % save weight hidden_weight output_weight;
% 
% % load weight;
% 
% % Initialize the bias for hidden layer and output layer,all
% % zeros
% hidden_bias=zeros(final_output_number,z);
% output_bias=zeros(final_output_number,z);
% 
% for er=1:100 %training cycles 
%     for i=1:image_number
%         % hidden layer outputs
%         hidden_parameter=hidden_weight*training_weight(:,i)+hidden_bias(:,i);
%         hidden_output(:,i)=1./(ones(final_output_number,1)+exp(-hidden_parameter));
%         % output layer outputs
%         output_parameter=output_weight*hidden_output(:,i)+output_bias(:,i);
%         output(:,i)=1./(ones(final_output_number,1)+exp(-output_parameter));
% 
%         % difference from the label and the calculated output
%         difference(:,i)=label(:,i)-output(:,i);
% 
% 
%         % update the output layer weight
%         delta_output_weight=nita*difference(:,i).*output(:,i).*(ones([final_output_number,1])-output(:,i))*hidden_output(:,i)';
%         output_weight=output_weight+delta_output_weight;
%         output_bias(:,i)=nita*difference(:,i).*output(:,i).*(ones([final_output_number,1])-output(:,i));
%         % update the hidden layer weight
%         difference_hidden(:,i)=output_weight'*difference(:,i);
%         delta_hidden_weight=nita*difference_hidden(:,i).*hidden_output(:,i).*(ones([final_output_number,1])-hidden_output(:,i))*training_weight(:,i)';
%         hidden_weight=hidden_weight+delta_hidden_weight;
%         hidden_bias(:,i)=nita*difference_hidden(:,i).*hidden_output(:,i).*(ones([final_output_number,1])-hidden_output(:,i));
%     end
% 
% Error(er)=sum(sum(difference.^2));
% end

image_number_ = [25 26 25 26 26 26 26];

image_mid_number = 0;

% SVM
for i=1:final_output_number
    i
    group=zeros(image_number,1);
    group(image_mid_number + 1: image_mid_number + image_number_(i), 1)=1;
    SVMStruct=svmtrain(training_weight',group, 'kernel_function','linear');
    SVMStruct_all = cat(1,SVMStruct_all,SVMStruct);
    image_mid_number = image_mid_number + image_number_(i);
end