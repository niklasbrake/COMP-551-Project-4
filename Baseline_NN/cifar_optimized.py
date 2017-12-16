### CIFAR-10 code with scikit-learn's optimizer
### just run 'python cifar_optimized.py'

import sys
import numpy
import cPickle
import keras
from keras.datasets import mnist
from keras.models import Sequential
from keras.layers import Dense, Dropout
from keras.optimizers import RMSprop
from sklearn.model_selection import GridSearchCV
from keras.wrappers.scikit_learn import KerasClassifier

def unpickle(file):
    with open(file, 'rb') as fo:
        dict = cPickle.load(fo)
    return dict

# create the models
def create_model(learning_rates, widths, depths):
    global model_count
    global activ    
    print model_count
    model_count = model_count + 1
    model = Sequential()
    model.add(Dense(widths, activation=activ, input_shape=(input_size,)))
    for i in range(1, depths):
          model.add(Dense(widths, activation=activ))
    opt = keras.optimizers.Adam(lr=learning_rates)
    model.add(Dense(num_classes, activation='softmax'))
 #   model.summary()
    model.compile(loss='categorical_crossentropy',
                  optimizer=opt,
                  metrics=['accuracy'])
    return model

### various parameters to set
epochs = 20
activ = "tanh"
numTrainSamples = 10000

batch_size = 128
num_classes = 10
input_size = 3072
layer_sizes = sys.argv[1:]
default_number_nodes = 10
model_count = 1

### Read and format data
## CHOOSE HOW MANY TRAINING / TEST SAMPLES
batch1 = unpickle("cifar-10-batches-py/data_batch_1")
test_batch = unpickle("cifar-10-batches-py/test_batch")
# structure of dictionaries
# possible keys:
# data
# labels
# batch_label
# filenames
# for example
# batch1['data'][0]
x_train = batch1['data'][0 : numTrainSamples]
y_train = batch1['labels'][0 : numTrainSamples]
x_test = test_batch['data']
y_test = test_batch['labels']
x_train = x_train.reshape(numTrainSamples, input_size)
x_test = x_test.reshape(10000, input_size)
x_train = x_train.astype('float32')
x_test = x_test.astype('float32')
x_train /= 255
x_test /= 255

print(x_train.shape[0], 'train samples')
print(x_test.shape[0], 'test samples')

# convert class vectors to binary class matrices
y_train = keras.utils.to_categorical(y_train, num_classes)
y_test = keras.utils.to_categorical(y_test, num_classes)

# create the model classifier
model = KerasClassifier(build_fn=create_model, epochs=epochs, batch_size=batch_size, verbose=0)

# parameters and their possible values
depths = [1, 2]
widths = [100, 500, 1000]
learning_rates = [.1, .01]

# which parameters to try combinations of 
param_grid = dict(widths=widths, learning_rates=learning_rates, depths=depths)

## change n_jobs to determine how many cores the code uses. set to -1 for all available. i have 4 cores
## so i typically used 3 so computer wasnt unusable
grid = GridSearchCV(estimator=model, param_grid=param_grid, n_jobs=1)

# train
grid_result = grid.fit(x_train, y_train)

# print results
print("Best: %f using %s" % (grid_result.best_score_, grid_result.best_params_))
means = grid_result.cv_results_['mean_test_score']
stds = grid_result.cv_results_['std_test_score']
params = grid_result.cv_results_['params']
for mean, stdev, param in zip(means, stds, params):
    print("%f (%f) with: %r" % (mean, stdev, param))



