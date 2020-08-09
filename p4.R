#Yuke Luo
# Part 1
library(pracma)
library(RMySQL)
db <- RMySQL::dbConnect(RMySQL::MySQL(),
                        dbname='final',
                        username='root',
                        password='root')
ww_dcs <- dbReadTable(db,'ww_dcs')
ww_stores <- dbReadTable(db,'ww_stores')
dcs <- cbind(ww_dcs$dc_id,ww_dcs$lat,ww_dcs$lon)
stores <- cbind(ww_stores$store_id,ww_stores$lat,ww_stores$lon)


dc <- c()
store <- c()
o <- 0
d <- matrix(NA,nrow=nrow(stores)*nrow(dcs),ncol=1)
for (i in 1:nrow(ww_dcs)){
  for (j in 1:nrow(ww_stores)){
    o <- o+1
    dc[o] <- dcs[i,1]
    store[o] <- stores[j,1]
    d[o,] <- haversine(c(dcs[i,2],dcs[i,3]),c(stores[j,2],stores[j,3]))
  }
}

tablee <- cbind(dc,store,d)

beginSQL <- "insert into ww_mileage (dc_id, store_id, mileage) values "
mysql <- ""
batch <- 100
sql <- rep(NA, batch)
index <-1
for (i in 1:nrow(tablee)){
  j <- j+1
  sql[index] <- sprintf("('%s', '%s', '%s'), ", tablee[i, 1], tablee[i, 2], tablee[i, 3])
  mysql <- paste(mysql, sql[index])
  if (i %% batch == 0) {
    sub <- mysql
    mysql <- substr(sub, 1, nchar(sub)-2)
    dbSendQuery(db, paste(beginSQL, mysql))
    if (i %% 25000 == 0){
      print(paste('still running... row', j))}
    sql <- rep(NA, batch)
    mysql <- ""
    index <- 0
  }
  index <- index + 1
  
}
sub <- mysql
mysql <- substr(sub, 1, nchar(sub)-2)
dbSendQuery(db, paste(beginSQL, mysql))