DataFolder = 'C:\Users\Niklas Brake\Documents\01 Education\School\040 Computer Science\COMP 551\Project 4';

% The CIFAR-10 dataset consists of 60000 32x32 colour images in 10 classes,
% with 6000 images per class. There are 50000 training images and 10000 
% test images. 

training_labels = [];
training_data = [];
for batch = 1:5
	fid = fopen(fullfile(DataFolder,'CIFAR',['data_batch_' int2str(batch) '.bin']));
	temp = fread(fid,[3073 10000]);
	training_labels = [training_labels; temp(1,:)'];
	training_data = [training_data; temp(2:end,:)'];

	% for i = 1:10000
	% 	training_labels(10000*(batch-1)+i) = fread(fid,1,'uint8');
	% 	training_data(10000*(batch-1)+i,1:3072) = fread(fid,3072,'uint8');
	% end
% end

% fid = fopen(fullfile(DataFolder,'CIFAR',['data_batch_' int2str(1) '.bin']));
% temp = fread(fid,[3073 10000]);
% training_labels = temp(1,:)';
% training_data = temp(2:end,:)';

fid = fopen(fullfile(DataFolder,'CIFAR','test_batch.bin'));
temp = fread(fid,[3073 10000]);

test_labels = temp(1,:)';
test_data = temp(2:end,:)';

N = sqrt(3072);

for i = 1:length(training_labels)
	training_data(i,:) = training_data(i,:) / norm(training_data(i,:)) * N;
end

for i = 1:length(test_labels)
	test_data(i,:) = test_data(i,:) / norm(test_data(i,:)) * N;
end