### Simple neural network code to train on the MNIST network
### single model version of the code
### requires Keras and TensorFlow
### based on the MNIST implementation tutorial from Keras
### can either just run code with no arguments which gives 1 hidden layer with 2000 nodes
# otherwise, can put arguments. each number is size of successive layer, so to get 3 hidden nodes
# with 4000, 1000, and 4000 nodes, call 'python cifar_network.py 4000 1000 4000'

from __future__ import print_function
import sys
import keras
from keras.datasets import mnist
from keras.models import Sequential
from keras.layers import Dense

### hyperparameters to choose
# how many epochs to train for
epochs = 40
# can set 'activ = "relu"' to use ReLU instead
activ = "relu" 
# what data set size to train on
numTrainSamples = 2000
# learning rate to use
learning_rate = .1

batch_size = 128
num_classes = 10
input_size = 784
layer_sizes = sys.argv[1:]
default_number_nodes = 2000

# the data, shuffled and split between train and test sets
(x_train, y_train), (x_test, y_test) = mnist.load_data()

# shape data appropriately and normalize it
x_train = x_train.reshape(60000, 784)
x_test = x_test.reshape(10000, 784)
x_train = x_train.astype('float32')
x_test = x_test.astype('float32')
x_train /= 255
x_test /= 255

## CHOOSE HOW MANY TRAINING / TEST SAMPLES
x_train = x_train[0 : numTrainSamples]
y_train = y_train[0 : numTrainSamples]

# print data shape / numbers
print(x_train.shape[0], 'train samples')
print(x_test.shape[0], 'test samples')

# convert class vectors to binary class matrices
y_train = keras.utils.to_categorical(y_train, num_classes)
y_test = keras.utils.to_categorical(y_test, num_classes)

model = Sequential()

## NUMBER OF NODES / LAYERS
# parse the input to create the model of appropriate size
if(len(layer_sizes) == 0):
	model.add(Dense(default_number_nodes, activation=activ, input_shape=(input_size,)))
else:
	model.add(Dense(int(layer_sizes[0]), activation=activ, input_shape=(input_size,)))
	for l in layer_sizes[1:]:
		model.add(Dense(int(l), activation=activ))

### output layer
model.add(Dense(num_classes, activation='softmax'))

# print shape of model
model.summary()

# actually construct it
opt = keras.optimizers.adam(lr=learning_rate)
model.compile(loss='categorical_crossentropy',
              optimizer=opt,
              metrics=['accuracy'])

# train model
history = model.fit(x_train, y_train,
                    batch_size=batch_size,
                    epochs=epochs,
                    verbose=1,
                    validation_data=(x_test, y_test))

# print shape again
model.summary()
# print how well it did
score = model.evaluate(x_test, y_test, verbose=0)
print('Test loss:', score[0])
print('Test accuracy:', score[1])
print("Epochs: " + str(epochs))
print("Number of training samples: " + str(numTrainSamples))
print("Activation: " + activ)





