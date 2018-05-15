
# Data for the <i>Xylella fastidiosa</i> remote sensing study
### Nature Plants 2018 

This repository contains the codes and data needed to reproduce the article:

*Zarco-Tejada, P.J., Camino, C., Beck, P.S.A., Calderon, R., Hornero, A., Hernández-Clemente, R., Kattenborn, T., Montes-Borrego, M., Susca, L., Morelli, M., Gonzalez-Dugo, V., North, P.R.J., Landa, B.B., Boscia, D., Saponari, M., Navas-Cortes, J.A.,* <b>Pre-visual <i>Xylella fastidiosa</i> infection revealed in spectral plant-trait alterations, Nature Plants (2018)</b>

The article will be available at the following [address](https://www.nature.com/nplants/) once it is published.
___

### Instructions

The data provided in the repository are the following:
 
| File | Type | Descripcion |
| ------------- |:-------------| -----|
| **Analysis1.R** | [Codes](https://github.com/Quantalab/Xf-NPlants-2018/tree/master/codes) | R codes to reproduce the analysis from the original data |
| **.csv** | [Data](https://github.com/Quantalab/Xf-NPlants-2018/tree/master/Data) | Tables used in the <i>Xylella fastidiosa</i> remote sensing study|
| **.RData** | [Table-4](https://github.com/Quantalab/Xf-NPlants-2018/tree/master/Table_4) & [Table-5](https://github.com/Quantalab/Xf-NPlants-2018/tree/master/Table_5) | Basic parameter tuning for each machine learning algorithms and Confusion Matrix|

<b>Note:</b> All analyses were done in [R](https://cran.r-project.org/). 

### .R Files



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
