### MNIST code with scikit-learn's optimizer
### just run 'python mnist_optimized.py'

import sys
import numpy
import keras
from keras.datasets import mnist
from keras.models import Sequential
from keras.layers import Dense, Dropout
from keras.optimizers import RMSprop
from sklearn.model_selection import GridSearchCV
from keras.wrappers.scikit_learn import KerasClassifier

## create model function used to create various models
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
    model.compile(loss='categorical_crossentropy',
                  optimizer=opt,
                  metrics=['accuracy'])
    return model

### various parameters to set
epochs = 10
activ = "tanh"
numTrainSamples = 10000

batch_size = 128
num_classes = 10
input_size = 784
layer_sizes = sys.argv[1:]
default_number_nodes = 10
model_count = 1

# load data and reshape it
(x_train, y_train), (x_test, y_test) = mnist.load_data()
x_train = x_train.reshape(60000, input_size)
x_test = x_test.reshape(10000, input_size)
x_train = x_train.astype('float32')
x_test = x_test.astype('float32')
x_train /= 255
x_test /= 255

# clip to size
x_train = x_train[0 : numTrainSamples]
y_train = y_train[0 : numTrainSamples]

print(x_train.shape[0], 'train samples')
print(x_test.shape[0], 'test samples')
# convert class vectors to binary class matrices
y_train = keras.utils.to_categorical(y_train, num_classes)
y_test = keras.utils.to_categorical(y_test, num_classes)

# create the keras classifier
model = KerasClassifier(build_fn=create_model, epochs=epochs, batch_size=batch_size, verbose=0)

# parameters to try permutations of
depths = [1, 2]
widths = [100, 200]
learning_rates = [.1, .01]

# which parameters to try combinations of 
param_grid = dict(widths=widths, learning_rates=learning_rates, depths=depths)

## change n_jobs to determine how many cores the code uses. set to -1 for all available. i have 4 cores
## so i typically used 3 so computer wasnt unusable
grid = GridSearchCV(estimator=model, param_grid=param_grid, n_jobs=3)

# train
grid_result = grid.fit(x_train, y_train)

# get results back
print("Best: %f using %s" % (grid_result.best_score_, grid_result.best_params_))
means = grid_result.cv_results_['mean_test_score']
stds = grid_result.cv_results_['std_test_score']
params = grid_result.cv_results_['params']
for mean, stdev, param in zip(means, stds, params):
    print("%f (%f) with: %r" % (mean, stdev, param))



