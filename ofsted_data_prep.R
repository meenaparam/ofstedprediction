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
myofsted$urn <- as.integer(myofsted$urn)

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
                                        "Voluntary",
                                        "Voluntary")
                                 )

myofsted$ofstedgrade <- factor(myofsted$ofstedgrade, levels = c(1,2,3,4), labels = c("Outstanding", "Good", "Requires Improvement", "Inadequate"))

# Load in selected columns of the KS4 dataset - this loading doesn't work
# ks4 <- openxlsx::read.xlsx(xlsxFile = "england_ks4.xlsx", sheet = 1, colNames = TRUE, startRow = 2, cols = c(5,17,19,27,96))

# Unfortunately, need to manually load the above file in Excel and then copy and paste the targe columns into a fresh csv file.

# Load in the data using the pre-prepared csv file
ks4 <- read.csv(file = "ks4.csv", stringsAsFactors = FALSE, blank.lines.skip = TRUE)

# Tidy up the data - convert columns to factors
ks4$RELDENOM <- as.factor(ks4$RELDENOM)
ks4$EGENDER <- as.factor(ks4$EGENDER)

# Tidy up the data - recode the factors above
ks4$RELDENOM <- mapvalues(x = ks4$RELDENOM, 
                          from = c(levels(ks4$RELDENOM)[1:5],
                                   levels(ks4$RELDENOM)[6],
                                   levels(ks4$RELDENOM)[7:22]
                                   ),
                          to = c(rep("Religious", 5),
                                 "Non-religious",
                                 rep("Religious", 16)
                                )
                        )

ks4$EGENDER <- mapvalues(x = ks4$EGENDER,
                         from = c(levels(ks4$EGENDER)[1],
                                  levels(ks4$EGENDER)[2:3],
                                  levels(ks4$EGENDER)[4]
                                  ),
                         to = c("Mixed",
                                rep("Single-sex", 2),
                                "Mixed"
                                )
                         )

# Tidy up the data - fix latter two numeric columns
ks4$KS2APS[ks4$KS2APS == "NP"] <- NA
ks4$KS2APS[ks4$KS2APS == "SUPP"] <- NA
ks4$KS2APS <- as.numeric(ks4$KS2APS)

ks4$TTAPSCP_PTQ_EE[ks4$TTAPSCP_PTQ_EE == "NE"] <- NA
ks4$TTAPSCP_PTQ_EE[ks4$TTAPSCP_PTQ_EE == "SUPP"] <- NA
ks4$KS4APS <- as.numeric(ks4$TTAPSCP_PTQ_EE)
ks4$TTAPSCP_PTQ_EE <- NULL

# Merge the myosfted df to the ks4 df
schools <- dplyr::inner_join(x = ks4, y = myofsted, by = c("URN" = "urn"))

# Drop the laestab column
schools$laestab <- NULL

# Make all column names lowercase
colnames(schools) <- lapply(colnames(schools), function(x) tolower(x))

# Fix the region and totpups column classes
schools$region <- as.factor(schools$region)
schools$totpups <- as.integer(schools$totpups)

# Data prep complete - use the schools dataset in the ofsted prediction app
save(schools, file = "Ofsted_App/data/schools.RData")
