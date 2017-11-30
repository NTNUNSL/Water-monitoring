data1 <- read.csv("/Users/millie/Downloads/Dam_309436.csv", header = TRUE, sep = ",", fileEncoding = "big5") 
names(data1)<-c("name","time","Car","temp","pH","EC","TDS")


#data空值
data1<-subset(data1,data1$Car!="")
data1<-subset(data1,data1$Car!=" ")
data1<-subset(data1,data1$Car!="--")
data1<-subset(data1,data1$temp!="--")
data1$Car<-as.character(data1$Car)
data1$Car<-as.numeric(data1$Car)

#data去掉ＮＡ
for(x in c(1:length(data1$Car))){
  if(is.na(data1$Car[x])){
    data1<-data1[-x,]
  }
}
#data GROUP 
data1$GROUP<-0
for(x in c(1:length(data1$Car))){
  if((data1$Car[x]<40)){
    data1$GROUP[x]<-1
  }
  else if((data1$Car[x]>=40&&data1$Car[x]<=50)){
    data1$GROUP[x]<-2
  }
  else{
    data1$GROUP[x]<-3
  }
}

#
count1<-0
count2<-0
count3<-0
for(x in c(1:length(data$Car))){
  if(data$GROUP[x]==1){
    count1<-count1+1
  }
  else if(data$GROUP[x]==2){
    count2<-count2+1

  }
  else {
    count3<-count3+1
  }
}
count1
count2
count3

write.csv(data,"/Users/millie/Desktop/水庫/各縣/widedou.csv", row.names = FALSE, fileEncoding = "big5")

data<-subset(data,data$GROUP!="1")
data<-subset(data,data$GROUP!="3")

#random
data1<-sample(data$Car,15,replace = TRUE)
data1<-subset(data,Car %in% data1)

#
count6<-0
count7<-0
count8<-0
for(x in c(1:length(data$GROUP))){
  if(predict$GROUP[x]==1&&data$GROUP[x]==1){
    count6<-count6+1
  }
  else if(predict$GROUP[x]==2&&data$GROUP[x]==2){
    count7<-count7+1
  }
  else if(predict$GROUP[x]==3&&data$GROUP[x]==3){
    count8<-count8+1
  }
}
count6/length(which(predict$GROUP==1))
count7/length(which(predict$GROUP==2))
count8/length(which(predict$GROUP==3))


#
count5<-0
for(x in c(1:length(data$Car))){
  if(data$GROUP1[x]==predict$GROUP1[x]){
    count5<-count5+1}
}
count5/length(predict$GROUP1)


sample(data1,100)
data2<-sample(data$GROUP,30,replace = TRUE)
data2<-subset(data,GROUP %in% data1)
