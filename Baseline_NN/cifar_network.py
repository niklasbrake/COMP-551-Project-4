### Simple neural network code to train on the CIFAR-10 network
### single model version of the code
### requires Keras and TensorFlow
### based on the MNIST implementation tutorial from Keras
### can either just run code with no arguments which gives 1 hidden layer with 2000 nodes
# otherwise, can put arguments. each number is size of successive layer, so to get 3 hidden nodes
# with 4000, 1000, and 4000 nodes, call 'python cifar_network.py 4000 1000 4000'

import sys
import numpy
import itertools
import cPickle
import keras
from keras.datasets import mnist
from keras.models import Sequential
from keras.layers import Dense

def unpickle(file):
    with open(file, 'rb') as fo:
        dict = cPickle.load(fo)
    return dict


# structure of dictionaries
# possible keys:
# data
# labels
# batch_label
# filenames

# for example
# batch1['data'][0]

# load data
batch1 = unpickle("cifar-10-batches-py/data_batch_1")
batch2 = unpickle("cifar-10-batches-py/data_batch_2")
batch3 = unpickle("cifar-10-batches-py/data_batch_3")
batch4 = unpickle("cifar-10-batches-py/data_batch_4")
batch5 = unpickle("cifar-10-batches-py/data_batch_5")
test_batch = unpickle("cifar-10-batches-py/test_batch")

# parameters to choose
epochs = 20
numTrainSamples = 20000
activ = "relu"
learning_rate = .1

batch_size = 128
num_classes = 10
input_size = 3072
layer_sizes = sys.argv[1:]

# load data as list to concatenate
tx1 = list(batch1['data'])
tx2 = list(batch2['data'])
tx3 = list(batch3['data'])
tx4 = list(batch4['data'])
tx5 = list(batch5['data'])
ty1 = list(batch1['labels'])
ty2 = list(batch2['labels'])
ty3 = list(batch3['labels'])
ty4 = list(batch4['labels'])
ty5 = list(batch5['labels'])

## CHOOSE HOW MANY TRAINING / TEST SAMPLES
# build the actual training and test sets, and then clip them to appropriate size
x_train = numpy.array(tx1 + tx2 + tx3 + tx4 + tx5)
y_train = numpy.array(ty1 + ty2 + ty3 + ty4 + ty5)

x_test = test_batch['data']
y_test = test_batch['labels']

# reshape them
x_train = x_train.reshape(50000, input_size)
x_test = x_test.reshape(10000, input_size)
x_train = x_train.astype('float32')
x_test = x_test.astype('float32')
x_train /= 255
x_test /= 255

x_train = x_train[0 : numTrainSamples]
y_train = y_train[0 : numTrainSamples]
print(x_train.shape[0], 'train samples')
print(x_test.shape[0], 'test samples')

# convert class vectors to binary class matrices
y_train = keras.utils.to_categorical(y_train, num_classes)
y_test = keras.utils.to_categorical(y_test, num_classes)

## HOW MANY LAYERS
model = Sequential()

## NUMBER OF NODES / LAYERS
default_number_nodes = 2000
if(len(layer_sizes) == 0):
	model.add(Dense(default_number_nodes, activation=activ, input_shape=(input_size,)))
else:
	model.add(Dense(int(layer_sizes[0]), activation=activ, input_shape=(input_size,)))
	for l in layer_sizes[1:]:
		model.add(Dense(int(l), activation=activ))

### output layer
model.add(Dense(num_classes, activation='softmax'))

### print the shape of the model
model.summary()

opt = keras.optimizers.Adam()
model.compile(loss='categorical_crossentropy',
              optimizer=opt,
              metrics=['accuracy'])

### start training
history = model.fit(x_train, y_train,
                    batch_size=batch_size,
                    epochs=epochs,
                    verbose=1,
                    validation_data=(x_test, y_test))
### test it
model.summary()
score = model.evaluate(x_test, y_test, verbose=0)
print('Test loss:', score[0])
print('Test accuracy:', score[1])
print("Epochs: " + str(epochs))
print("Number of training samples: " + str(numTrainSamples))
print("Activation: " + activ)





