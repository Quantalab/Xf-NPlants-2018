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
path_data<-("data/")
path_out<-("out/") ### choose a directory ...

######################################################################
### CASE A : Asympt. (0) Sympt. (1) (1-2-3-4) ### SEV_A 
###############################################################################
###############################################################################

##Modify the percentage to split the data

xi<-0.8 ## 0.8 or 0.9
        #0.8 containing 80% of the data collected over two years (2016 and 2017) for trainining the model and 20% for testing the model
        # 0.9 containing 90% of the data collected over two years (2016 and 2017) for trainining the model and 10% for testing the model

data <-read.table("data/1-Data_Global_model_Xf.csv", header=T, sep=",")
index <- createDataPartition(data$SEV_A, p = xi, list = F)
data.training<- data[index, ]
data.testing  <- data[-index, ]

cases_var<-c("SEV_A","SEV_B")

################################
######################

# 2. VIF analysis -------------------------------------------------------
source("codes/vif_function.R")
### Spectral indices 
pred_ind<-names(data.training[,5:74]) ##
pred_ind_rtm<-c(names(data.training[,5:74]),'Cab','Car','Ant','LAI','LIDFa','Fi') ### inputs from RTM inversion

###Selection of spectral indices  VIF values are below 10
keep.indices.model<-vif_func(data.training[,pred_ind],thresh=10,trace=T)
###Selection of spectral indiceswith rtm inputs 
keep.indices.rtm.model<-vif_func(data.training[,pred_ind_rtm],thresh=10,trace=T)

# 2. Wilks.lambda -------------------------------------------------------

fmla <- as.formula(paste(cases_var[1]," ~ ", paste(keep.indices.model, collapse= "+")))
gw_obj <- greedy.wilks(fmla, data = data.training, niveau = 0.1)
print(gw_obj)

################################
######################
# 3. Models  -------------------------------------------------------

model_PSFT<-c( keep.indices.model,"Cab","Car","Ant","LAI","LIDFa","Fi")
model_PS<-c(keep.indices.model[1:10],"Cab","Car","Ant","LAI","LIDFa")
model_SVI<-c("NDVI","BGI1","BRI1","RGI")

Vector_to_include<-list(model_PSFT,model_PS,model_SVI)
names_to_include<-c("model PSFT","model PS","model SVI")

for (k in c(1:3)){
  
  print(k)
  print(names_to_include[k])
  print(Vector_to_include[[k]])
  
  dataset<-data.training[,c("SEV_A",Vector_to_include[[k]])]
  dataset$SEV<-as.factor(dataset$SEV_A)
  
  #names(dataset)[1]<-paste("SEV")
  attach(dataset)
  dataset$SEV_2[SEV == "0"  ] <- "C0"
  dataset$SEV_2[SEV == "1"] <- "C1"
  detach(dataset)
  
  dataset_test<-data.testing[,c("SEV_A",Vector_to_include[[k]])]
  dataset_test$SEV<-as.factor(dataset_test$SEV_A)
  # names(dataset_test)[1]<-paste("SEV")
  dataset_test$SEV<-as.factor(dataset_test$SEV)
  attach(dataset_test)
  dataset_test$SEV_2[SEV == "0"  ] <- "C0"
  dataset_test$SEV_2[SEV == "1"] <- "C1"
  detach(dataset_test)
  
  
  fmla <- as.formula(paste("SEV ~ ", paste(Vector_to_include[[k]], collapse= "+")))
  predictors<-Vector_to_include[[k]]
  outcomeName<-"SEV_2"
  
  ################################
  ######################
  # 3.1 SVM Model  -------------------------------------------------------
  
  print(paste('SVM for ',names_to_include[[k]],sep=""))
  tobj <- tune.svm(fmla, data = dataset, gamma = 2^(-4:1), cost = 2^(1:4))
  cc <- as.numeric(tobj$best.parameters[2])
  gg <- as.numeric(tobj$best.parameters[1])
  summary(tobj)
  ## svm model with tune parameters
  model_svm <- svm(fmla, kernel="radial", data = dataset, gamma=gg, cost=cc,probability=TRUE)
  
  ##predictions on train dataset
  dataset$pred_svm<- as.factor(predict(object=model_svm, dataset[,predictors]))
  
  ##predictions on test dataset
  dataset_test$pred_svm<-predict(object = model_svm,dataset_test[,predictors])
  
  ## ROC Analysis
  auc_train_svm<- roc(as.numeric(dataset[,"SEV"]), as.numeric(dataset$pred_svm))
  auc_test_svm<- roc(as.numeric(dataset_test[,"SEV"]), as.numeric(dataset_test$pred_svm))
  ##
  filterVarImp(dataset[,predictors],dataset[,'SEV']) ## from SEV
  filterVarImp(dataset[,predictors],dataset[,'pred_svm']) ### from predictions
  
  ##Checking the accuracy of the model (confusionMatrix)
  results_train_svm<-  confusionMatrix(dataset$SEV,dataset$pred_svm)
  results_test_svm<-  confusionMatrix(dataset_test$SEV,dataset_test$pred_svm)
  
  #export results
  OA<-round(results_train_svm$overall['Accuracy'],4)*100
  Kappa<-round(results_train_svm$overall['Kappa'],2)  
  precision <- round(results_train_svm$byClass['Pos Pred Value'],4)*100 ##Precision (class 0)
  precision_false <- round(results_train_svm$byClass['Neg Pred Value'],4)*100 ##Precision (class 0)
  recall <- round(results_train_svm$byClass['Sensitivity'],4)*100    ###Recall (class 0)
  recall_false <- round(results_train_svm$byClass['Specificity'],4)*100 ###Recall (class 1)
  #f_measure <- 2 * ((precision * recall) / (precision + recall))
  Table_train<-data.frame(Caso="CASE-A",Method="SVM",Type=names_to_include[k],Data="TR",
                         PA_AS=as.vector(precision),PA_AF=as.vector(precision_false),
                         RC_AS=as.vector(recall),RC_AF=as.vector(recall_false),
                         OA=as.vector(OA),Kappa=as.vector(Kappa))
  write.table(Table_train, file = paste(path_out,"1-Table_confusion_matrix.csv",sep=""),sep=",",row.names = F, col.names = F,append = T) 
  
  OA<-round(results_test_svm$overall['Accuracy'],4)*100
  Kappa<-round(results_test_svm$overall['Kappa'],2)  
  precision <- round(results_test_svm$byClass['Pos Pred Value'],4)*100 ##Precision (class 0)
  precision_false <- round(results_test_svm$byClass['Neg Pred Value'],4)*100 ##Precision (class 0)
  recall <- round(results_test_svm$byClass['Sensitivity'],4)*100    ###Recall (class 0)
  recall_false <- round(results_test_svm$byClass['Specificity'],4)*100 ###Recall (class 1)
  #f_measure <- 2 * ((precision * recall) / (precision + recall))
  Table_test<-data.frame(Caso="CASE-A",Method="SVM",Type=names_to_include[k],Data="TS",
                    PA_AS=as.vector(precision),PA_AF=as.vector(precision_false),
                    RC_AS=as.vector(recall),RC_AF=as.vector(recall_false),
                    OA=as.vector(OA),Kappa=as.vector(Kappa))
  write.table(Table_test, file = paste(path_out,"1-Table_confusion_matrix.csv",sep=""),sep=",",row.names = F, col.names = F,append = T) 
  
  ################################
  ######################
  # 3.2. NN Model  -------------------------------------------------------

  print(paste('NN for ',names_to_include[[k]],sep=""))
  nnet.grid <- expand.grid(.decay = seq(0,0.1,by=0.01), .size = seq(1,10,by=1))
  nnet.fit <- train(fmla, data = dataset,method = "nnet", maxit = 50, tuneGrid = nnet.grid) 
  size<-getElement(nnet.fit,"bestTune")$size
  decay<-getElement(nnet.fit,"bestTune")$decay
  
  #nne model with the best tune parameters for 500 iterations
  data.nnet <- nnet(fmla,data=dataset,size=size,decay=decay,trace=F)
  best.value <- data.nnet$value
  value <- NULL
  for(i in 1:500)
  {
    aux.nnet <- nnet (fmla,data=dataset,size=size,decay=decay,trace=F)
    value[i] <- aux.nnet$value
    if(aux.nnet$value < best.value)
    {
      data.nnet <- aux.nnet
      best.value <- data.nnet$value
    }
    
  }

  data.nnet$value
  plot(1:500,value,type="s",xlab="iteractions")
  ##predictions on train dataset
  dataset$pred_knn<-predict(object = data.nnet,dataset[,predictors],type="class")
  ##predictions on test dataset
  dataset_test$pred_knn<-predict(object = data.nnet,dataset_test[,predictors],type="class")
  ## ROC Analysis
  auc_train_nne<- roc(as.numeric(dataset[,"SEV"]), as.numeric(dataset$pred_knn))
  auc_test_nne<- roc(as.numeric(dataset_test[,"SEV"]), as.numeric(dataset_test$pred_knn))
  ##
  filterVarImp(dataset[,predictors],dataset[,'pred_knn']) ### from predictions
  
  ##Checking the accuracy of the model (confusionMatrix)
  results_train_nne<-  confusionMatrix(dataset$SEV,dataset$pred_knn)
  results_test_nne<-  confusionMatrix(dataset_test$SEV,dataset_test$pred_knn)
  
  #export results
  OA<-round(results_train_nne$overall['Accuracy'],4)*100
  Kappa<-round(results_train_nne$overall['Kappa'],2)  
  precision <- round(results_train_nne$byClass['Pos Pred Value'],4)*100 ##Precision (class 0)
  precision_false <- round(results_train_nne$byClass['Neg Pred Value'],4)*100 ##Precision (class 0)
  recall <- round(results_train_nne$byClass['Sensitivity'],4)*100    ###Recall (class 0)
  recall_false <- round(results_train_nne$byClass['Specificity'],4)*100 ###Recall (class 1)
  #f_measure <- 2 * ((precision * recall) / (precision + recall))
  Table_train<-data.frame(Caso="CASE-A",Method="KNN",Type=names_to_include[k],Data="TR",
                          PA_AS=as.vector(precision),PA_AF=as.vector(precision_false),
                          RC_AS=as.vector(recall),RC_AF=as.vector(recall_false),
                          OA=as.vector(OA),Kappa=as.vector(Kappa))
  write.table(Table_train, file = paste(path_out,"1-Table_confusion_matrix.csv",sep=""),sep=",",row.names = F, col.names = F,append = T) 
  
  OA<-round(results_test_nne$overall['Accuracy'],4)*100
  Kappa<-round(results_test_nne$overall['Kappa'],2)  
  precision <- round(results_test_nne$byClass['Pos Pred Value'],4)*100 ##Precision (class 0)
  precision_false <- round(results_test_nne$byClass['Neg Pred Value'],4)*100 ##Precision (class 0)
  recall <- round(results_test_nne$byClass['Sensitivity'],4)*100    ###Recall (class 0)
  recall_false <- round(results_test_nne$byClass['Specificity'],4)*100 ###Recall (class 1)
  #f_measure <- 2 * ((precision * recall) / (precision + recall))
  Table_test<-data.frame(Caso="CASE-A",Method="NNE",Type=names_to_include[k],Data="TS",
                         PA_AS=as.vector(precision),PA_AF=as.vector(precision_false),
                         RC_AS=as.vector(recall),RC_AF=as.vector(recall_false),
                         OA=as.vector(OA),Kappa=as.vector(Kappa))
  write.table(Table_test, file = paste(path_out,"1-Table_confusion_matrix.csv",sep=""),sep=",",row.names = F, col.names = F,append = T) 
  
  
  ################################
  ######################
  #3.3 LDA Model  -------------------------------------------------------
  print(paste('LDA for ',names_to_include[[k]],sep=""))
  
  #Training the LDA model
  fitControl <- trainControl(method = "cv",number = 10,savePredictions = 'final',classProbs = T)
  model_lda<-train(dataset[,predictors],dataset[,outcomeName],method='lda',trControl=fitControl,tuneLength=3)
  ##train
  dataset$pred_lda<-predict(object = model_lda,dataset[,predictors])
  ##test
  dataset_test$pred_lda<-predict(object = model_lda,dataset_test[,predictors])
  
  ## ROC Analysis
  auc_train_lda<- roc(as.numeric(dataset[,"SEV"]), as.numeric(dataset$pred_lda))
  auc_test_lda<- roc(as.numeric(dataset_test[,"SEV"]), as.numeric(dataset_test$pred_lda))
  #
  roc_lda<-varImp(model_lda, scale = F)  ## from SEV
  
  #######################
  #Checking the accuracy of the model (confusionMatrix)
  results_train_lda<-confusionMatrix(dataset$SEV_2,dataset$pred_lda)
  results_test_lda<-confusionMatrix(dataset_test$SEV_2,dataset_test$pred_lda)
  
  #export results
  OA<-round(results_train_lda$overall['Accuracy'],4)*100
  Kappa<-round(results_train_lda$overall['Kappa'],2)  
  precision <- round(results_train_lda$byClass['Pos Pred Value'],4)*100 ##Precision (class 0)
  precision_false <- round(results_train_lda$byClass['Neg Pred Value'],4)*100 ##Precision (class 0)
  recall <- round(results_train_lda$byClass['Sensitivity'],4)*100    ###Recall (class 0)
  recall_false <- round(results_train_lda$byClass['Specificity'],4)*100 ###Recall (class 1)
  #f_measure <- 2 * ((precision * recall) / (precision + recall))
  Table_train<-data.frame(Caso="CASE-A",Method="LDA",Type=names_to_include[k],Data="TR",
                          PA_AS=as.vector(precision),PA_AF=as.vector(precision_false),
                          RC_AS=as.vector(recall),RC_AF=as.vector(recall_false),
                          OA=as.vector(OA),Kappa=as.vector(Kappa))
  write.table(Table_train, file = paste(path_out,"1-Table_confusion_matrix.csv",sep=""),sep=",",row.names = F, col.names = F,append = T) 
 
  OA<-round(results_test_lda$overall['Accuracy'],4)*100
  Kappa<-round(results_test_lda$overall['Kappa'],2)  
  precision <- round(results_test_lda$byClass['Pos Pred Value'],4)*100 ##Precision (class 0)
  precision_false <- round(results_test_lda$byClass['Neg Pred Value'],4)*100 ##Precision (class 0)
  recall <- round(results_test_lda$byClass['Sensitivity'],4)*100    ###Recall (class 0)
  recall_false <- round(results_test_lda$byClass['Specificity'],4)*100 ###Recall (class 1)
  #f_measure <- 2 * ((precision * recall) / (precision + recall))
  Table_test<-data.frame(Caso="CASE-A",Method="LDA",Type=names_to_include[k],Data="TS",
                         PA_AS=as.vector(precision),PA_AF=as.vector(precision_false),
                         RC_AS=as.vector(recall),RC_AF=as.vector(recall_false),
                         OA=as.vector(OA),Kappa=as.vector(Kappa))
  write.table(Table_test, file = paste(path_out,"1-Table_confusion_matrix.csv",sep=""),sep=",",row.names = F, col.names = F,append = T) 
  
  save.image(paste(path_out,k,'-stats_Models_A.R',sep=""))
}


  
  
  



