########################
#
#   Lecture # 6
#   Data Import/Export
#   Hadi Kharrazi
#
########################

# ============================================================ 
# DATA I/E :: Importing local flat files (csv,txt)
# ============================================================ 

# define the location of the local files to be imported

file_csv = 'C:/Users/hkharrazi/Desktop/PHAV/code/data/data_pat.csv'  # comma separated values
file_txt = 'C:/Users/hkharrazi/Desktop/PHAV/code/data/data_pat.txt'  # text file (containing the same info as csv file)

# reading from local hard drive -- flat file import CSV or TXT
# items to consider: file location; header/columns; separator; quotes; decimals; NA/NULL (empty cells; missing values); and, EOL

# sample CSV file may look like this
# pat_id ,  sex  , age  ,  Dx1               , Dx2                     \r\n
# 1      ,   M   , 78.0 ,  "Diabetes,Type 2" , "Chronic Heart Disease" \r\n
# 2      ,   F   ,  NA  ,  "Asthma"          , ""                      \r\n

dat1 <- read.table(file = file_csv, header = T, sep = ',')           # reading as simple table
dat2 <- read.csv(file = file_csv, header = T, sep = ',')             # reading as a CSV file (as a data.frame)
dat3 <- read.csv2(file = file_csv, header = T, sep = ',')            # reading as a CSV file (with additional optoins; and faster)
dat4 <- read.delim(file = file_csv, header = T, sep = ',')           # reading as a CSV file (with more control on the delimiter)
dat5 <- read.delim2(file = file_csv, header = T, sep = ',')          # reading as a CSV file (with more control on the delimiter; and faster)

sum(dat1 != dat2)                                                    # checking if two datasets are the same
all.equal(dat1, dat2)                                                # checking if two datasets are the same
identical(dat1, dat2)                                                # checking if two datasets are the same

install.packages('readr')                                            # using an advanced package to import/export flat file data
library(readr)                                                       # initializing the readr library (make sure that it's installed)
dat6 <- read_csv(file = file_csv)                                    # reading as a csv file (provides more options; and faster)  
spec(dat6)                                                           # readr function to see the specs of the data.frame

dat7 <- read_lines(file = file_txt, n_max = 10)                      # reading couple lines of a very large file (note that it's in raw format; no columns)
dat7[3]                                                              # show the 3rd line of the file
dat8 <- read_file(file = file_txt)                                   # reading the entire file at once (note that it's in raw format; no data.frame)
substr(dat8, 1, 1000)                                                # printing the first couple lines of the object containing the file

# ============================================================ 
# DATA I/E :: Importing local flat files (xlsx,data.table,rds)
# ============================================================ 

file_xls = 'C:/Users/hkharrazi/Desktop/PHAV/code/data/data_pat.xlsx' # Excel file (containing the same info as csv file)
file_rds = 'C:/Users/hkharrazi/Desktop/PHAV/code/data/data_pat.rds'  # RDS file (containing the same info as csv file)

install.packages('readxl')                                           # using an advanced package to read Microsoft Excel files
library(readxl)                                                      # initializing the readxl library (make sure that it's installed)
dat9 <- read_excel(path = file_xls)                                  # reading an Excel file (xlsx)

library(data.table)                                                  # initializing the data.table library (assuming you have installed the package in prior sessions)
dat9 <- as.data.table(dat9)                                          # converting a data.frame to a data.table
dat10 <- fread(file = file_csv)                                      # using the fread command to read a CSV file (very fast!)
colnames(dat10)                                                      # showing the column names of the data.table

file_big = 'C:/Users/hkharrazi/Desktop/PHAV/code/data/data_big.csv'  # a csv file containing a large dataset

system.time(dat11 <- read.csv(file = file_big,header = T,sep = ',')) # measuring the speed of read.csv command
system.time(dat12 <- fread(file = file_big))                         # measuring the speed of fread command (much faster; almost 10x; if warning, simply install the bit64 package)
colnames(dat12)                                                      # showing the column names of the data.table
dat12[, .N]                                                          # number of rows for the data.table
str(dat12)                                                           # structureof data.table columns
summary(dat12)                                                       # summary of data.table columns

dat13 <- readRDS(file = file_rds)                                    # reading an RDS file (need to check the content; in this case, contains a data.table)
dat13[, .N]                                                          # number of rows for the data.table

# ============================================================ 
# DATA I/E :: Importing local flat files (sas,spss)
# ============================================================ 

# define the location of the local files to be imported

file_sas = 'C:/Users/hkharrazi/Desktop/PHAV/code/data/data_pat.dta'   # sas file (containing the same info as csv file)
file_sav = 'C:/Users/hkharrazi/Desktop/PHAV/code/data/data_pat.sav'   # spss file (containing the same info as csv file)

install.packages('haven')                                             # using an advanced package to import/export sas/spss files (alternate package: foreign)
library(haven)                                                        # initializing the haven library (make sure that it's installed)

dat14 <- read_sas(data_file = file_sas)
dat15 <- read_spss(file = file_sav)

# ============================================================ 
# DATA I/E :: Importing files from web
# ============================================================ 

web_csv = 'http://hkharrazi.com/dat/data_pat.csv'                      # location of the csv file on the web
dat16 <- read.table(file = web_csv, header = T, sep = ',')             # reading the csv file directly from the web
str(dat16)                                                             # structure of data.frame

# note: be careful while importing or exporting data to the web (i.e., HIPAA issues)
# note: cloud connectivity packages can help you to read/write to cloud folders directly (e.g., googledrive & dropbox packages)

# ============================================================ 
# DATA I/E :: Exploring the imported data
# ============================================================ 
data_pat <- copy(dat10)                           # copying the data.table
data_pat                                          # exploring the data.table
str(data_pat)                                     # structure of the data.table
View(data_pat)                                    # visualizing the data.table in a spreadsheet format
colnames(data_pat)                                # listing the col names of the data.table
head(data_pat)                                    # the first couple rows of the data.table
tail(data_pat)                                    # the last couple rows of the data.table
data_pat[, .N]                                    # number of rows in the data.table
data_pat[, uniqueN(id)]                           # number of unique patients
data_pat[, unique(sex)]                           # unique sexes
data_pat[, unique(plan)]                          # unique plans
data_pat[, .(ct = .N), by = age][order(age)]      # showing the number of rows/patients per age
data_pat[, .(ct = .N), by = plan]                 # showing the number of rows/patients per plan
data_pat[, .(ct = .N), by = urban_rural]          # showing the number of rows/patients per urban/rural categories
data_pat[urban_rural == '.', urban_rural := NA]   # replacing '.' cell value with actual NA value

# ============================================================ 
# DATA I/E :: Exporting as flat files (txt,csv,xlsx,rds,...)
# ============================================================ 

# define the location of the local files to be exported

file_csv_save = 'C:/Users/hkharrazi/Desktop/PHAV/code/data/data_pat_save.csv'    # csv file format
file_rds_save = 'C:/Users/hkharrazi/Desktop/PHAV/code/data/data_pat_save.rds'    # rds file format
file_sas_save = 'C:/Users/hkharrazi/Desktop/PHAV/code/data/data_pat_save.dta'    # sas file format
file_sav_save = 'C:/Users/hkharrazi/Desktop/PHAV/code/data/data_pat_save.sav'    # spss file format

write.csv(data_pat, file_csv_save)                 # saving the CSV file
write_csv(data_pat, file_csv_save)                 # saving the CSV file (faster using the readr library)
write_sas(data_pat, file_sas_save)                 # saving the SAS file
write_sav(data_pat, file_sav_save)	               # saving the SPSS file

saveRDS(data_pat, file_rds_save)                   # saving the rds file (preferred way for large datasets)
fwrite(data_pat, file_csv_save)                    # saving the csv file (fastest way to write large CSV files)

# ============================================================ 
# DATA I/E :: SQL data (read and write)
# ============================================================ 

# note: many packages exists to faciliate the real-time connection to SQL servers
# you will be able to run SQL command against the server within R (read or write)
# embedded SQL connections and SQL execution will NOT be covered in this course

# ============================================================ 
# Sample training questions
# ============================================================ 

# (1) import the data_pat.txt file as a data.table
file_txt = 'C:/Users/hkharrazi/Desktop/PHAV/code/data/data_pat.txt'
dt <- fread(file_txt)

# (2) show the historgram of "cost_current_total"; do you see a pattern?
hist(dt$cost_current_total)

# (3) add a column to store the log of "cost_current_total" -- call the new column as "cost_current_total_log"
dt[, cost_current_total_log := log(cost_current_total)]

# (4) show the historgram of "cost_current_total_log"; do you see a pattern?
hist(dt$cost_current_total_log)

# (5) count how many of the "cost_current_total_log" values are "-Inf", and then replace all of them with 0
dt[cost_current_total_log == -Inf, .N]
dt[cost_current_total_log == -Inf, cost_current_total_log := 0]

# (6) show the historgram of "cost_current_total_log" once more; do you see a new pattern?
hist(dt$cost_current_total_log)

# (7) save the new data.table as data_pat_new.csv, but use "|" as the separator
file_csv = 'C:/Users/hkharrazi/Desktop/PHAV/code/data/data_pat_new.csv'
fwrite(dt, file_csv, sep = "|")