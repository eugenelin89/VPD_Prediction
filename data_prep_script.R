library(sp)
library(rgdal)
library(caret)
df <- read.csv("/Users/eugenelin/Downloads/crime_csv_all_years/crime_csv_all_years.csv")
df <- df[complete.cases(df),]

# Map from UTM to Coordinate
utmcoor<-SpatialPoints(cbind(df$X,df$Y), proj4string=CRS("+proj=utm +zone=10"))
spdf<-as.data.frame(spTransform(utmcoor,CRS("+proj=longlat")))
df$longitude <- spdf$coords.x1
df$latitude <- spdf$coords.x2

# Only use 2017 data. Otherwise... half million rows...
df <- df[which(df$YEAR==2017),]

df$WEEKDAY <- weekdays(as.Date(paste(df$DAY, df$MONTH, "2017", sep="-"),'%d-%m-%Y'))

# Remove unused columns
#remove <- c(2,4,6,7,8,9,10)
remove <- c(2,6,7,8,9,10)
df <- df[,-remove]

# Write Cleaned Data to disk.
write.csv(df, file = "/Users/eugenelin/RStudio/DP_Proj/DDP/crime2017.csv",row.names=FALSE)

# Load the data back to new dataframe 
df17 <- read.csv("/Users/eugenelin/RStudio/DP_Proj/DDP/crime2017.csv") 

# Preparing Training and Validation Data
inTrain <- createDataPartition(df17$TYPE, p = .75, list = F)
training <- df17[inTrain,]
validation <- df17[-inTrain,]

#model_tree <- train(TYPE~., data=training, method="rpart", trControl=trainControl(method="cv", number=5))
#pred_tree_validation <- predict(model_tree,newdata=validation)
#confusionMatrix(validation$TYPE,pred_tree_validation)$overall[1]

# Train with Random Forest
model_forest <- train(TYPE~., data=training, method="rf", trControl=trainControl(method="cv", number=5))
pred_forest_validation <- predict(model_forest,newdata=validation)
confusionMatrix(validation$TYPE,pred_forest_validation)$overall[1]

# Save Model to Disk
saveRDS(model_forest, "/Users/eugenelin/RStudio/DP_Proj/DDP/model_forest.rds")

