setwd("C:\\Users\\it24100010\\Desktop\\IT24100010_LAB_05")

Delivery_Times<-read.table("Exercise - Lab 05.txt",header = TRUE)
head(Delivery_Times)

histogram <- hist(Delivery_Times$Delivery_Time_.minutes.,
                  main="Histogram for Delivery Times",
                  breaks =seq(20,70,length=10),
                  right=FALSE)
str(Delivery_Times)
colnames((Delivery_Time))
breaks<- round(histogram$breaks)
freq<- histogram$counts
mids<-histogram$mids
classes<-c()
for(i in 1:(length(breaks)-1)){
  classes[i]<- paste0("[",breaks[i],",",breaks[i+1],")")
}
cbind(classes=classes,frequency=freq,midpoint=mids)
cum_freq<- cumsum(freq)
(breaks[-1])
plot(breaks[-1],cum_freq,
     type="o",pch=16,col="blue",
     main="Cumulative Frequency Polygon(ogive)",
     xlab= "Delivery Time",ylab ="Cumulative Frequency")