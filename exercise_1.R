library(dplyr)
library(tidyr)
#Set the working directory and load file into R
setwd("~/Documents/School/Springboard/Data Wrangling")
refine <- read.csv("refine_original.csv", stringsAsFactors = FALSE)
refine$company <- tolower(refine$company)

#View the structure of the file
View(refine)
summary(refine)
str(refine)
dim(refine)

#Find values in data frame
grepl("[pP]h|[fF]i", refine$company)
grepl("^a", refine$company)
grepl("^v", refine$company)
grepl("[uU]n", refine$company)

#1 Clean up brand names
refine$company[grepl("[pP]h|[fF]i", refine$company)] <- "philips"
refine$company[grepl("^a", refine$company)] <- "akzo"
refine$company[grepl("^v", refine$company)] <- "van houten"
refine$company[grepl("[uU]n", refine$company)] <- "unilever"

#2 Separate product code and ndumber
#rename second column
colnames(refine)[2] <- "product_code"

#Split product code into two 
refine <- separate(refine, product_code, c("product_code", "product_number"), sep = "-")

#3 Add Product Categories
lut <- c("p" = "Smartphone", "v" = "TV", "x" ="Laptop", "q" = "Tablet")
#Creating column product categories in refine from lut - look up table
refine$product_categories <- lut[refine$product_code]
#glimpse
glimpse(refine)

#4 Add Full Address
refine <- unite(refine, "full_address", address, city, country, sep = ",")
#glimpse
glimpse(refine)

#5 Create dummy variables for company and product category
#Add four binary (1 or 0) columns for company
refine <- mutate(refine, company_philips = as.numeric(company=="philips"))
refine <- mutate(refine, company_akzo = as.numeric(company=="akzo"))
refine <- mutate(refine, company_van_houten = as.numeric(company=="van houten"))
refine <- mutate(refine, company_unilever = as.numeric(company=="unilever"))

#Add four binary (1 or 0) columns for product category
refine <- refine %>% mutate(product_smartphone = as.numeric(product_categories=="Smartphone"))
refine <- refine %>% mutate(product_tv = as.numeric(product_categories=="TV"))
refine <- refine %>% mutate(product_laptop = as.numeric(product_categories=="Laptop"))
refine <- refine %>% mutate(product_tablet = as.numeric(product_categories=="Tablet"))

#6 Export cleaned data as CSV
write.csv(refine, "refine_clean.csv")




