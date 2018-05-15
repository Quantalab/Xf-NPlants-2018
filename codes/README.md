
# Data for the <i>Xylella fastidiosa</i> remote sensing study
### Nature Plants 2018 

__

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
 
Prior to running the scripts you may need to install the appropriate packages, all available on the CRAN repository. In R [codes](https://github.com/Quantalab/Xf-NPlants-2018/tree/master/codes), the procedure to install packages is also indicated. To install the packages, open an R session and execute the following commands:
 
```
if (!require("fmsb")) { install.packages("fmsb"); require("fmsb") }  ### VIF analysis
if (!require("klaR")) { install.packages("klaR"); require("klaR") }  ### Wilks.lambda
if (!require("caret")) { install.packages("caret"); require("caret") }  ###  Partition data set and model LDA
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
<b>[ VIF-function-R](https://github.com/Quantalab/Xf-NPlants-2018/blob/master/codes/vif_function.r)</b><br/>
```
A VIF function for stepwise variable selection.

```
