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
  }
  else if((data$Car[x]>=40&&data$Car[x]<=50)){
    data$GROUP[x]<-2
  }
  else{
    data$GROUP[x]<-3
  }
}

#MARS(training)

library(earth);

#輸入所要訓練的資料
mars_data<-read.csv("/Users/millie/Desktop/水庫/testdata1.csv",header=TRUE,sep=",", fileEncoding = "big5")
#設定名稱
names(mars_data)<-c("Car","temp","pH","EC","TDS","GROUP")
#training
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

pasummary(mars)
plot(mars)

#45警報
data$GROUP1<-0
for(x in c(1:length(data$Car))){
  if((data$Car[x]<45)){
    data$GROUP1[x]<-1
  }
  else if((data$Car[x]>=45)){
    data$GROUP1[x]<-2
  }
  
}

predict$GROUP1<-0
for(x in c(1:length(predict$Car))){
  if((predict$Car[x]<45)){
    predict$GROUP1[x]<-1
  }
  else if((predict$Car[x]>=45)){
    predict$GROUP1[x]<-2
  }
  
}

#警報設置為45準確率
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
