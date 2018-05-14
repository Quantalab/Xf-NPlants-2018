#################################
###########
# The following code reproduces the statistical results of the article:

# Zarco-Tejada, P.J., Camino, C., Beck, P.S.A., Calderon, R., Hornero, A., Hernández-Clemente, R., Kattenborn, 
#T., Montes-Borrego, M., Susca, L., Morelli, M., Gonzalez-Dugo, V., North, P.R.J., Landa, B.B., Boscia, D., 
#Saponari, M., Navas-Cortes, J.A., 
#Pre-visual Xylella fastidiosa infection revealed in spectral plant-trait alterations, Nature Plants (2018)
#################################
###########

######################################################################################################
# 1. Loading packages, functions and data -------------------------------------------------------
rm(list=ls())
if (!require("fmsb")) { install.packages("fmsb"); require("fmsb") }  ### VIF analysis
if (!require("klaR")) { install.packages("klaR"); require("klaR") }  ###Wilks.lambda
if (!require("caret")) { install.packages("caret"); require("caret") }  ###  Partition dataset and model LDA
if (!require("e1071")) { install.packages("e1071"); require("e1071") }  ### SVM model
if (!require("nnet")) { install.packages("nnet"); require("nnet") }  ### NNE model
if (!require("pROC")) { install.packages("pROC"); require("pROC") }  ### ROC AUC analysis

#########################
# set workspace

setwd ("choose a directory ...")
path_data<-("Data/")
path_out<-("out/")

#################################
####
## same code for  two datasets
### data set one --> 2-Data_Parcel_with_qPCR.csv (at parcel level)
### data set two --> 3-Data_Orchard_with_qPCR.csv (at orchard level)
code_dataset<-c('2-Data_Parcel_with_qPCR.csv','3-Data_Orchard_with_qPCR.csv')

###choose a data set in the vector code_dataset -->
######### code_dataset: (1 is the data set one and 2 is the data set two)
data <-read.table(paste('Code-Quantalab_v2/Data/',code_dataset[2],sep=''), header=T, sep=",")

model_PSFT_global<-c("Cab","Car","Ant","LAI","LIDFa", "Fi","CWSIv",
                     "T_O","NPQI","VOG2","DCABXC","CRI700M","PRIM1","PRIM4","PRIN","PRI_CI","BF1","BF2","CUR","FLD2")

Vector_to_include<-list(model_PSFT_global)
names_to_include<-c("model PSFT")


################################
######################

# 2. set statistical parameters -------------------------------------------------------

set.seed(100)

#fitControl <- trainControl(method = "cv",number = 10,savePredictions = 'final',classProbs = T)
fitControl2 <- trainControl(method = "LOOCV",number = 10,savePredictions = 'final',classProbs = T,sampling = "down")
fmla <- as.formula(paste("SEV ~ ", paste(Vector_to_include[[k]], collapse= "+")))
### For importance analysis
predictors<-Vector_to_include[[1]]
outcomeName<-"SEV_2"

  k=1
  
  print(k)
  print(names_to_include[k])
  print(Vector_to_include[[k]])
  
dataset<-data[,c("GRID_CODE","qPCR","SEV_A","Sympt_FEB_17",Vector_to_include[[k]])]
names(dataset)[1:4]<-c("GRID_CODE","SEV","SEV_Jun","SEV_Feb")
attach(dataset)
dataset$SEV_2[SEV == "0"  ] <- "C0"
dataset$SEV_2[SEV == "1"] <- "C1"
detach(dataset)


# 3. svm -------------------------------------------------------

print(paste('SVM for ',names_to_include[[k]],sep=""))
###n? de iteracciones
n_cases<-50
outputs<-data.frame()
outputs_prob<-data.frame()
for(j in c(1:n_cases)) {
  
  print(j)
  set.seed(j+1)
  model_svm2<-train(dataset[,predictors],dataset[,outcomeName],method='svmRadial',trControl=fitControl2,tuneLength=3)
  vector<-as.integer(substr(predict(object = model_svm2,dataset[,predictors]),2,2))
  outputs<-rbind(outputs,vector)
  #Predicting the probabilities
  vector_prob<-predict(object = model_svm2,dataset[,predictors],type='prob')[2]
  vector_prob<-as.vector(vector_prob[,1])
  outputs_prob<-rbind(outputs_prob,vector_prob)
}

# 4. get statistical scores and predictions -------------------------------------------------------

outputs_pred<-t(outputs)
outputs_pred<-data.frame(outputs_pred,qPCR=data[,"qPCR"],GRID=data[,"GRID_CODE"] )
vector_OA<-rep("NA",dim(outputs_pred)[2]-2)
vector_kappa<-rep("NA",dim(outputs_pred)[2]-2)
for (k in c(1:(dim(outputs_pred)[2]-2))){
  print(k)
  results<-confusionMatrix(outputs_pred[,51],outputs_pred[,k])
  OA<-as.numeric(round(results$overall['Accuracy'],5)*100)
  Kappa<-as.numeric(round(results$overall['Kappa'],5) )
  vector_OA
  vector_OA[k]<-OA
  vector_kappa[k]<-Kappa
}

which.max(vector_OA)
which.max(vector_kappa)

# 4. get statistical scores for ensemble model -------------------------------------------------------

outputs_pred_prob<-t(outputs_prob)
outputs_pred_prob<-data.frame(outputs_pred_prob,qPCR=data[,"qPCR"], GRID=data[,"GRID_CODE"])
pred_avg<-rowMeans(outputs_pred_prob[,1:n_cases])
#Splitting into binary classes at 0.5
pred_avg_class<-as.numeric(ifelse(pred_avg>0.5,'1','0'))
results_avg<-confusionMatrix(outputs_pred[,51],pred_avg_class)
OA_avg<-as.numeric(round(results_avg$overall['Accuracy'],5)*100)
print(OA_avg)
kappa_avg<-as.numeric(round(results_avg$overall['Kappa'],5) )
print(kappa_avg)

#Defining the training control
fitControl_ensemb <- trainControl( method = "cv",number = 10,
                                   savePredictions = 'final', # To save out of fold predictions for best parameter combinantions
                                   classProbs = T) # To save the class probabilities of the out of fold predictions

#Predictors for top layer models 
predictors_top<-names(outputs_pred_prob)[1:n_cases]
#GBM as top layer model 
set.seed(100)
model_gbm<- train(outputs_pred_prob[,predictors_top],paste('C',outputs_pred_prob[,"qPCR"],sep=''),method='gbm',trControl=fitControl_ensemb,tuneLength=3)
gbm_stacked<-predict(model_gbm,outputs_pred_prob[,predictors_top])
gbm_stacked<-as.numeric(substr(gbm_stacked,2,2))

results_gbm<-confusionMatrix(outputs_pred_prob[,51],gbm_stacked)

OA_gbm<-as.numeric(round(results_gbm$overall['Accuracy'],5)*100)
print(OA_gbm)
kappa_gbm<-as.numeric(round(results_gbm$overall['Kappa'],5) )
print(kappa_gbm)
outputs_pred_prob$gbm_stacked<-gbm_stacked


# 5. confusion matrix (patologist visit) -------------------------------------------------------

####Patologist on June 2016 (data set 1)
results<-confusionMatrix(outputs_pred[,51],data$SEV_A)
OA_jun<-as.numeric(round(results$overall['Accuracy'],5)*100)
Kappa_jun<-as.numeric(round(results$overall['Kappa'],5) )
###Patologist on Feb 2016 (data set 1 and data set 2)
########################
results_Feb<-confusionMatrix(outputs_pred[,51],data$Sympt_FEB_17)
OA_feb<-as.numeric(round(results_Feb$overall['Accuracy'],5)*100)
Kappa_feb<-as.numeric(round(results_Feb$overall['Kappa'],5) )






