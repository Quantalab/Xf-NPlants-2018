# Codes and data for the Xylella fastidiosa remote sensing study
## Nature Plants 2018

This repository contains code needed to reproduce the article:

Zarco-Tejada, P.J., Camino, C., Beck, P.S.A., Calderon, R., Hornero, A., Hernández-Clemente, R., Kattenborn, T., Montes-Borrego, M., Susca, L., Morelli, M., Gonzalez-Dugo, V., North, P.R.J., Landa, B.B., Boscia, D., Saponari, M., Navas-Cortes, J.A., <b>Pre-visual <i>Xylella</i> fastidiosa infection revealed in spectral plant-trait alterations, Nature Plants (2018)</b>

The article will be available at the following address once it is published.

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

<b>[Analysis3.R](https://github.com/Quantalab/Xf-NPlants-2018/blob/master/codes/Analysis3.R)</b><br/>

```
The code reproduces the confusion matrix between the field evaluation and remote sensing predictions 
vs qPCR tests at two spatial scales:
 - At parcel level (Figure 5).
 - At orchard level (table 6).
```

For access to the raw data, see [data folder](https://github.com/Quantalab/Xf-NPlants-2018/tree/master/Data):</b>

Contact  pablo.zarco@csic.es for any further information.

This repository follows the principles of reproducible research (Peng, 2011).
