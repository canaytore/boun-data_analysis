library(tidyverse)

setwd("~/GitHub/boun01-canaytore/final")
carsales <- readxl::read_excel("2018.01.xlsx",skip=7,col_names=FALSE)
colnames(carsales) <- c("brand","auto_dom","auto_imp","auto_total","comm_dom","comm_imp","comm_total","total_dom","total_imp","total_total")
carsales <- carsales %>% mutate_if(is.numeric,funs(ifelse(is.na(.),0,.))) %>% mutate(year=2018,month=1)
row_count <- nrow(carsales)

for(files in dir()){
  if (files == "2018.01.xls"){
    next
  }
  carsales_new<-readxl::read_excel(files,skip=7,col_names=FALSE)
  
  row_count <- row_count + nrow(carsales_new)
  colnames(carsales_new) <- c("brand","auto_dom","auto_imp","auto_total","comm_dom","comm_imp","comm_total","total_dom","total_imp","total_total")
  carsales_new <- carsales_new %>% mutate_if(is.numeric,funs(ifelse(is.na(.),0,.))) %>% mutate(year=strsplit(files, "[.]")[[1]][1],month=strsplit(files, "[.]")[[1]][2])
  carsales <- rbind(carsales, carsales_new)                                                                                    
}

str(carsales) #Check
row_count #Check

carsales <- carsales %>%
  filter(!(is.na(brand) | brand == "TOPLAM:" | brand == "TOPLAM" | grepl("ODD", brand))) %>%
  mutate(year = as.integer(year), month = as.integer(month))

saveRDS(carsales, file = "carsales")
