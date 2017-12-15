DataFolder = 'C:\Users\Niklas Brake\Documents\01 Education\School\040 Computer Science\COMP 551\Project 4';

% The CIFAR-10 dataset consists of 60000 32x32 colour images in 10 classes,
% with 6000 images per class. There are 50000 training images and 10000 
% test images. 

for batch = 1:5
	fid = fopen(fullfile(DataFolder,'CIFAR',['data_batch_' int2str(batch) '.bin']));
	for i = 1:10000
		training_labels(10000*(batch-1)+i) = fread(fid,1,'uint8');
		training_data(10000*(batch-1)+i,1:3072) = fread(fid,3072,'uint8');
	end
end

fid = fopen(fullfile(DataFolder,'CIFAR','test_batch.bin'));
for i = 1:10000
	test_labels(i) = fread(fid,1,'uint8');
	test_data(i,1:3072) = fread(fid,3072,'uint8');
end


for i = 1:length(training_labels)
	training_data(i,:) = training_data(i,:) / norm(training_data(i,:)) * sqrt(3072);
end

for i = 1:length(test_labels)
	test_data(i,:) = test_data(i,:) / norm(test_data(i,:)) * sqrt(3072);
end