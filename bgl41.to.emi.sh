#!/usr/bin/env Rscript

#####################################################################
# bgl41.to.emi 1.0 21/02/2017 for Linux                             #
# By Ural Yunusbaev 2017   uralub@gmail.com                         #
# This script converts Beagle4.1's gt.ibd output files to EMI input #
# The script require R-2.15.0                                       #
# Before starting the script type: module load R-2.15.0             #
# To start the script type: ./bgl41.to.emi.sh file.gt.ibd file.map  #
# The script outputs file.gt.ibd.emi                                #
# For Beagle 4.1 & EMI details see: http://cs.au.dk/~qianyuxx/EMI/  #
# http://faculty.washington.edu/browning/beagle/beagle.html         #
#####################################################################

print("Converting Beagle 4.1 output to EMI input")

ibd=as.character(commandArgs(TRUE)[1])
map=as.character(commandArgs(TRUE)[2])

map1 <- read.table(map, header = FALSE, col.names = c("chr", "snp", "gdist", "bp1"))
ibd1 <- read.table(ibd, header = FALSE, col.names = c("ind1", "ph1", "ind2", "ph2", "chr", "bp1", "bp2", "lod"))
emi1 <- merge(x = map1, y = ibd1, by = "bp1", all.y = TRUE)
map2 <- read.table(map, header = FALSE, col.names = c("chr", "snp", "gdist", "bp2"))

paste("read  tables ", ibd, map,   "- success")

emi2 <- merge(x = map2, y = emi1, by = "bp2", all.y = TRUE)
emi3 <- cbind(emi2[,c(9,10,11,12,5,1,14,8,4)])

emi3col1modif<-strsplit(as.character(emi3[,1]),split="_")
emi3col1tomatrix<-matrix(unlist(emi3col1modif),nrow=length(emi3col1modif),byrow=T)
emi3col1toframe <- data.frame(emi3col1tomatrix)

emi3col3modif<-strsplit(as.character(emi3[,3]),split="_")
emi3col3tomatrix<-matrix(unlist(emi3col3modif),nrow=length(emi3col3modif),byrow=T)
emi3col3toframe <- data.frame(emi3col3tomatrix)

emi4<-cbind(emi3col1toframe[,c(1,2)], emi3col3toframe[,c(1,2)], emi3[,c(2,4,5,6,7,8,9)])

emi4[,c(2)] <- paste(as.character(emi4[,c(2)]),(emi4[,5]-1),sep=".")
emi4[,c(4)] <- paste(as.character(emi4[,c(4)]),(emi4[,6]-1),sep=".")

emi5 <- cbind(emi4[,c(1,2,3,4,7,8,9,10,11)])

paste("merge tables ", ibd, map,   "- success")

outputfile <- paste(ibd, "emi", sep = ".")
write.table(emi5, file = outputfile, quote = FALSE, row.names = FALSE, col.names = FALSE)

paste("write table  ", outputfile, "- success")
