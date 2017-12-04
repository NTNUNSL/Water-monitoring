#輸入欲測試的資料
data <- read.csv("/Users/millie/Downloads/Dam_309436.csv", header = TRUE, sep = ",", fileEncoding = "big5") 
#輸入名稱
names(data)<-c("location","time","Car","temp","pH","EC","TDS")

#去掉data空值
data<-subset(data,data$Car!="")
data<-subset(data,data$Car!=" ")
data<-subset(data,data$Car!="--")
data<-subset(data,data$temp!="--")
data$Car<-as.character(data$Car)
data$Car<-as.numeric(data$Car)

#data去掉ＮＡ
for(x in c(1:length(data$Car))){
  if(is.na(data$Car[x])){
    data<-data[-x,]
  }
}
#data分成卡爾森指數三類 
data$GROUP<-0
for(x in c(1:length(data$Car))){
  if((data$Car[x]<40)){
    data$GROUP[x]<-1 
  } #Car小於40時設為1
  else if((data$Car[x]>=40&&data$Car[x]<=50)){
    data$GROUP[x]<-2
  }#Car大於等於40，小於等於50時設為2
  else{
    data$GROUP[x]<-3
  }#其他皆設為3(>50)
}

#MARS(training)

library(earth);

#輸入所要訓練的資料
mars_data<-read.csv("/Users/millie/Desktop/水庫/testdata1.csv",header=TRUE,sep=",", fileEncoding = "big5")
#設定訓練資料的名稱
names(mars_data)<-c("Car","temp","pH","EC","TDS","GROUP")

#MARS training (Car=temp+pH+EC+TDS)
mars<-earth(Car~temp+pH+EC+TDS,data=mars_data)

#進行與測試資料預測
predict<-predict(mars,data)
predict <- data.frame(predict,data$Car)

#判斷預測與實際誤差
predict$diff <- abs(predict$Car-data$Car)
plot(ecdf(predict$diff),xlim = c(0,20),ylim = c(0,1),col ="black",main ="") 
par(new=TRUE)
length(which(predict$diff<10))/length(predict$data1.Car)

#絕對誤差率
sort(predict$diff/predict$data.Car)
new<-sort(predict$diff/predict$data.Car)
new[length(new)*4/5]
#畫CDF
plot(ecdf(new),xlim = c(0,0.30),ylim = c(0,1),col ="yellow")
par(new = TRUE)
abline(h = 0.8)

#show predict Model data
summary(mars)
plot(mars)

#設置Car為45警報，將測試資料及預測資料分成兩類，判斷準確度
#測試資料
data$GROUP1<-0
for(x in c(1:length(data$Car))){
  if((data$Car[x]<45)){
    data$GROUP1[x]<-1
  } #data<45時為1
  else if((data$Car[x]>=45)){
    data$GROUP1[x]<-2
  } #data>=45為2
  
}
#系統預測的資料
predict$GROUP1<-0
for(x in c(1:length(predict$Car))){
  if((predict$Car[x]<45)){
    predict$GROUP1[x]<-1
  } #data<45時為1
  else if((predict$Car[x]>=45)){
    predict$GROUP1[x]<-2
  } #data>=45為2
  
}

#實際資料與預測資料的準確率

count2<-0
count3<-0
for(x in c(1:length(data$GROUP1))){
  if(predict$GROUP1[x]==1&&data$GROUP1[x]==1){
    count2<-count2+1
  }
  else if(predict$GROUP1[x]==2&&data$GROUP1[x]==2){
    count3<-count3+1
  }
}
count2/length(which(predict$GROUP1==1))
count3/length(which(predict$GROUP1==2))
