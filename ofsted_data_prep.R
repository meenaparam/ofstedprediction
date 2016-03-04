# Title: Preparing Ofsted grade data
# Author: Meenakshi Parameshwaran
# Date: 04/03/2016

## Data comes from the DfE statistics site downloaded on 04/03/16 ##

# Download the latest official Ofsted maintained schools statisics release - Sep 2014 to Aug 2015
ofstedurl <- "https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/483703/School_inspection_data_provisional_2.xlsx"

if(!file.exists("ofsted.xlsx")){download.file(url = ofstedurl, destfile = "ofsted.xlsx", method = "curl")} # use curl method for Mac OS X

# Download the latest KS4 results attainment data for England as a zip file
ks4url <- "http://www.education.gov.uk/schools/performance/download/xls/england_ks4.zip"
if(!file.exists("england_ks4.xlsx")){download.file(url = ks4url, destfile = "ks4.zip", method = "curl")}
unzip("ks4.zip")

rm(ofstedurl, ks4url)

# Load in the ofsted dataset
library(pacman) # package manager library
p_load(openxlsx)
ofsted <- read.xlsx(xlsxFile = "ofsted.xlsx", sheet = 2, colNames = TRUE)

# Select target columns in the ofsted dataset
p_load(dplyr)
names(ofsted)
ofstedvars <- c("URN", "LAESTAB", "Region", "Type.of.establishment", "Total.number.of.pupils", "Overall.effectiveness:.how.good.is.the.school")
myofsted <- dplyr::select(ofsted, one_of(ofstedvars))

# Fix names in myofsted df
myofstednames <- c("urn", "laestab", "region", "instype", "totpups", "ofstedgrade")
names(myofsted) <- myofstednames

# Check and fix column types in myofsted df
lapply(myofsted, class)
myofsted$instype <- factor(myofsted$instype)

p_load(plyr) # for recoding
myofsted$instype <- mapvalues(myofsted$instype, 
                                 from = c(levels(myofsted$instype)[1:5],
                                          levels(myofsted$instype)[6],
                                          levels(myofsted$instype)[7:8],
                                          levels(myofsted$instype)[9:10],
                                          levels(myofsted$instype)[11:13],
                                          levels(myofsted$instype)[14:18],
                                          levels(myofsted$instype)[19],
                                          levels(myofsted$instype)[20]),
                                 to = c(rep("Academy", 5),
                                        "Other",
                                        rep("Community", 2),
                                        rep("Foundation", 2),
                                        rep("Academy", 3),
                                        rep("Other", 5),
                                        "Voluntary Aided",
                                        "Voluntary Controlled")
                                 )

myofsted$ofstedgrade <- factor(myofsted$ofstedgrade, levels = c(1,2,3,4), labels = c("Outstanding", "Good", "Requires Improvement", "Inadequate"))

# Load in the first 26 columns of the KS4 dataset
ks4 <- read.xlsx(xlsxFile = "england_ks4.xlsx", sheet = 1, colNames = TRUE, startRow = 2, cols = c(3,4,5,16,17,18,19,27,96))

