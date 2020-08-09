rm(list=ls())
# Yuke Luo
library(optrees)
library(igraph)
s.label <- c('A','B','C','D','E','F','G','H')
nodes <- 1:8
arcs <- matrix(c(1,2,-20, 1,3,-15, 2,4,-10, 2,5,-15, 3,4,-13, 3,6,-15, 3,7,-10, 4,3,-13, 4,5,-10, 4,7,-12, 5,2,-15, 5,6,-7, 5,8,-10, 6,5,-7, 6,7,-8, 6,8,-8, 7,6,-8,  7,8,-10),ncol = 3, byrow = TRUE)
arcs[,3]<- -arcs[,3]
newGraph <- graph_from_edgelist(arcs[,1:2],directed=T)
E(newGraph)$capacity <- arcs[,3]
max_flow(newGraph,source = 1, target=8)

mmax_flow <- c()
for (k in 1:10){
  arcs[c(1,2,13,16,18),3]<- arcs[c(1,2,13,16,18),3]*k
  E(newGraph)$capacity <- arcs[,3]
  mmax_flow[k]<-max_flow(newGraph,source = 1, target=8)$value
}
print('It will not allow it to double the maximum flow per hour from tank 1 to tank 8, but the final value will get over the double of the original one, which is 62')
