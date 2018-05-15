# Codes and data for the <i>Xylella</i> fastidiosa remote sensing study
## Nature Plants 2018 

This repository contains code needed to reproduce the article:

Zarco-Tejada, P.J., Camino, C., Beck, P.S.A., Calderon, R., Hornero, A., Hernández-Clemente, R., Kattenborn, T., Montes-Borrego, M., Susca, L., Morelli, M., Gonzalez-Dugo, V., North, P.R.J., Landa, B.B., Boscia, D., Saponari, M., Navas-Cortes, J.A., <b>Pre-visual <i>Xylella</i> fastidiosa infection revealed in spectral plant-trait alterations, Nature Plants (2018)</b>

The article will be available at the following address once it is published.



| Files | folder | Type |
--- | --- | ---

| **.RData** | Table-4 & Table-5 | Basic parameter tuning for each machine learning algorithms and Confusion Matrix|
| **.R** | Codes | codes In R for repeat the analysis from the original data |
| **.csv** | Data | Tables |



## Instructions

For access to the source codes, see files with .R extension placed on [codes folder](https://github.com/Quantalab/Xf-NPlants-2018/tree/master/codes):</b>

<b>[Analysis-1.R](https://github.com/Quantalab/Xf-NPlants-2018/blob/master/codes/Analysis1.R) </b>
<br/> 
```
The code reproduces the confusion matrix of the supplementary Table 4.
```

<b>[Analysis-2.R](https://github.com/Quantalab/Xf-NPlants-2018/blob/master/codes/Analysis2.R) </b><br/>

```
The code reproduces the confusion matrix of the supplementary Table 5.
```
<b>Note:</b> Codes [Analysis-1.R](https://github.com/Quantalab/Xf-NPlants-2018/blob/master/codes/Analysis1.R) and [Analysis-2.R](https://github.com/Quantalab/Xf-NPlants-2018/blob/master/codes/Analysis2.R) reproduce the article spliting the data into two data sets:
<br>
 - 80% of the data collected over two years (2016 and 2017) for each disease severity class selected at random, and the testing or validation sample (TS), with the remaining 20% for testing  the model.

 - 90% of the data collected over two years (2016 and 2017) for each disease severity class selected at random, and the testing or validation sample (TS), with the remaining 10% for testing  the model.
 
 - All analyses were done in [R](https://cran.r-project.org/). Prior to running the scripts you may need to install the appropriate packages, all available on the CRAN repository. On the codes the procedure to install packages is indicated. To install, open R and execute the following line of code:
 ```
 if (!require("fmsb")) { install.packages("fmsb"); require("fmsb") }  ### VIF analysis
if (!require("klaR")) { install.packages("klaR"); require("klaR") }  ###Wilks.lambda
if (!require("caret")) { install.packages("caret"); require("caret") }  ###  Partition dataset and model LDA
if (!require("e1071")) { install.packages("e1071"); require("e1071") }  ### SVM model
if (!require("nnet")) { install.packages("nnet"); require("nnet") }  ### NNE model
if (!require("pROC")) { install.packages("pROC"); require("pROC") }  ### ROC AUC analysis
```
<b>[Analysis-3.R](https://github.com/Quantalab/Xf-NPlants-2018/blob/master/codes/Analysis3.R)</b><br/>

```
The code reproduces the confusion matrix between the field evaluation and remote sensing predictions 
vs qPCR tests at two spatial scales:
 - At parcel level (Figure 5).
 - At orchard level (table 6).
```
##

For access to the raw data, see [data folder](https://github.com/Quantalab/Xf-NPlants-2018/tree/master/Data):</b>


### .RData Files

As consecuence of the random selection procedure of the data (train and test data), in order to reproduce exactly the statistical accuracy showed in Table 4 and Table 5. You will need to use the following .RData files for [Table 4](https://github.com/Quantalab/Xf-NPlants-2018/tree/master/Table_4) and [Table 5](https://github.com/Quantalab/Xf-NPlants-2018/tree/master/Table_4). 

The .RData files contain the workspace enviroment during the classification and machine learning algorithms used in this article. This files also save the main functions and the parameter tuning performed during classification methods. In addtion, the two split data sets (train and test data), the predictions, the model configuration and the confusion matrix is also stored in the .RData files.

Prior to running the .RData (as executable file)  you need to install R sofware. Next,download the file and put it in the following path:
```
C:/Data_NaturePlants
```
The .RData files contain the statistical procedure used on classification and machine learning algorithms to classify disease incidence and severity using the support vector machine (SVM), neural network (NN) and linear discriminant analysis (LDA). Furthermore, the .RData  files contains the confusion matrix of each classification and machine learning algorithms.


Once the .RData file is executed, type the following bold commands to see the following:
 
````
i.e: type "results_train" to see the Confusion Matrix of trainning data set
````
General setting (Data):
 
````
dataset --> "train data"
dataset_test --> "test data set"
predictors --> "Inputs of each model
````
Classification and machine learning algorithms:

````
The basic parameter tuning for the support vector machine (SVM)
fitControl --> "Base parameter tuning"
tobj -->  "The generic function tunes hyperparameters of statistical methods using a specific grid" 
gg --> "gamma parameter needed for all kernels" 
cc --> "cost of constraints violation"
fitControl --> "Base parameter tuning"
model_svm  --> "Support vector machine (SVM)"

The basic parameter tuning for For the Neural network (NN) with the best tune parameters for 500 iterations

nnet.grid --> "The parameter tuning grid"
nnet.fit  --> "The parameter tuning fit"
size  --> "The parameter tuning size"
data.nnet <-- "Fit single-hidden-layer neural network, possibly with skip-layer connections"
best.value  --> "Best parameter tuning of 500 iterations"
aux.nnet  --> "aux.nnet of 500 iterations"
data.nnet --> "Neural network (NN)"

The basic parameter tuning for linear discriminant analysis (LDA)

fitControl --> "Base parameter tuning"
model_lda --> "linear discriminant analysis  (LDA)"
````
Confusion Matrix:
````
results_train --> "Confusion Matrix and Statistics for training data set"
results_test  --> "Confusion Matrix and Statistics for testing data set"
````



### Contact information

Contact  pablo.zarco@csic.es for any further information.

This repository follows the principles of reproducible research (Peng, 2011).
