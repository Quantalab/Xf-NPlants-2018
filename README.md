
# Data for the <i>Xylella fastidiosa</i> remote sensing study
### Nature Plants 2018 
This repository contains the codes and data needed to reproduce the article:

*Zarco-Tejada, P.J., Camino, C., Beck, P.S.A., Calderon, R., Hornero, A., Hernández-Clemente, R., Kattenborn, T., Montes-Borrego, M., Susca, L., Morelli, M., Gonzalez-Dugo, V., North, P.R.J., Landa, B.B., Boscia, D., Saponari, M., Navas-Cortes, J.A.,* <b>Pre-visual <i>Xylella fastidiosa</i> infection revealed in spectral plant-trait alterations, Nature Plants (2018)</b>

<b>DOI</b>:10.1038/s41477-018-0189-7

The article will be available at the following [address](https://www.nature.com/nplants/) once it is published.
___

### Instructions

The codes and data provided in the repository are the following:
 
| File | Download | Descripcion |
| ------------- |:-----------------| -----|
| **.R** | [Codes](https://github.com/Quantalab/Xf-NPlants-2018/tree/master/codes) | R codes to reproduce the analysis from the original data |
| **.csv** | [Raw data](https://github.com/Quantalab/Xf-NPlants-2018/tree/master/data) | Tables used in the <i>Xylella fastidiosa</i> remote sensing study|

<b>Note:</b> All analyses were done in [R](https://cran.r-project.org/). 

<b>Update:</b> Some trees were misclassified in the original Xf-database. They have been updated. 
___

### .R Files 

To recreate the results, run the commands with the .R extension placed on the [codes folder](https://github.com/Quantalab/Xf-NPlants-2018/tree/master/codes). To achieve this, download the repository, and then open an R session with working directory set to the root of the project.

<b>[Analysis-1.R](https://github.com/Quantalab/Xf-NPlants-2018/blob/master/codes/Analysis1.R) </b>
<br/> 
```
The code reproduces the confusion matrix of the supplementary Table 4. For that purpose, the code splits the data 
set (training and test data), executes the VIF, Wilks.lambda and ROC analylsis and run the classification and
machine learning algorithms described in the article.

This code is valids for the Case A: asymptomatic (AS) vs. symptomatic trees (AF; affected)
```
<b>[Analysis-2.R](https://github.com/Quantalab/Xf-NPlants-2018/blob/master/codes/Analysis2.R) </b><br/>

```
The code reproduces the confusion matrix of the supplementary Table 5. Similar to previous R code, the code splits
the data set (training and test data), executes the VIF, Wilks.lambda and ROC analylsis and run the classification 
and machine learning algorithms described in the article.

This code is valids for the Case B: Initial Xf-symptoms (IN, DS=1) vs. advanced Xf-symptoms (AD,DS = 2 3 and 4) 
severity levels. 
```
<b>Note:</b> Codes [Analysis-1.R](https://github.com/Quantalab/Xf-NPlants-2018/blob/master/codes/Analysis1.R) and [Analysis-2.R](https://github.com/Quantalab/Xf-NPlants-2018/blob/master/codes/Analysis2.R) split the data set according to two criterias:
<br>
 - the training sample (TR), containing 80% of the data collected over two years for each disease severity class selected at random, and the testing or validation sample (TS), with the remaining 20% for testing  the model.

 - the training sample (TR), containing 90% of the data collected over two years for each disease severity class selected at random, and the testing or validation sample (TS), with the remaining 10% for testing  the model.
 
Prior to running the scripts, you may need to install the appropriate packages, all available on the CRAN repository. In R [codes](https://github.com/Quantalab/Xf-NPlants-2018/tree/master/codes), the procedure to install packages is also indicated. To install the packages, open an R session and execute the following commands:
 
```
if (!require("fmsb")) { install.packages("fmsb"); require("fmsb") }  ### VIF analysis
if (!require("klaR")) { install.packages("klaR"); require("klaR") }  ### Wilks.lambda
if (!require("caret")) { install.packages("caret"); require("caret") }  ###  Partition data set and LDA model 
if (!require("e1071")) { install.packages("e1071"); require("e1071") }  ### SVM model
if (!require("nnet")) { install.packages("nnet"); require("nnet") }  ### NN model
if (!require("pROC")) { install.packages("pROC"); require("pROC") }  ### ROC AUC analysis
```
<b>[Analysis-3.R](https://github.com/Quantalab/Xf-NPlants-2018/blob/master/codes/Analysis3.R)</b><br/>
```
The code reproduces the confusion matrix between the field evaluation and remote sensing predictions 
vs qPCR tests at two spatial scales:

 - At parcel level (Figure 5).
 - At orchard level (table 6).
 
The code generates 50 non-linear SVM classification models using a radial basis function and leave one out cross 
validation (LOOCV). Then, the code uses the SVM predictions to generates a stochastic gradient boosting machine to 
test the remote sensing-based PSFT model at parcel and orchard level. 
```
<b>[ VIF-function-R](https://github.com/Quantalab/Xf-NPlants-2018/blob/master/codes/vif_function.r)</b><br/>
```
A VIF function for stepwise variable selection.

```
___

### Raw data

For access to the raw data, see [data folder](https://github.com/Quantalab/Xf-NPlants-2018/tree/master/data):</b>
___


### Contact information

[Pablo J. Zarco-Tejada](https://ec.europa.eu/jrc/en/person/pablo-zarco-tejada)
<br>European Commission (EC), [Joint Research Centre (JRC)](https://ec.europa.eu/jrc/en)
<br>Directorate D – Sustainable Resources
<br>email: pablo.zarco@ec.europa.eu

## 
This repository follows the principles of reproducible research [(Peng, 2011)](http://science.sciencemag.org/content/334/6060/1226).
When using the [raw data](https://github.com/Quantalab/Xf-NPlants-2018/tree/master/Data), please cite the original publication.

___

### Acknowledgments

We thank Z.G. Cerovic, J.Flexas, F.Morales, and P.Martín for scientific discussions, [QuantaLab-IAS-CSIC](http://quantalab.ias.csic.es/) for laboratory assistance, and G.Altamura, A.Ceglie, and D.Tavano for field support. The study was funded by the [European Union’s Horizon 2020](https://ec.europa.eu/programmes/horizon2020/) research and innovation programme through grant agreements [POnTE (635646)](https://www.ponteproject.eu/about/overview/) and [XF-ACTORS (727987)](http://www.xfactorsproject.eu/). The views expressed are purely those of the writers and may not in any circumstance be regarded as stating an official position of the European Commission.

