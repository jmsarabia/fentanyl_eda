#################################
# DESCRIPTION
#################################
# Ed Hui
# 10.2023
# Calculates Avg Future Life Years based on an age gender.   However since this information is for a dead subgroup (not a living subgroup) then it represents the Avg Life Years Lost
# Takes 1) US Mortality rates from Human Mortality Datatabase.  2019 is the year chosen, not the most recent year of 2021, since 2021 is a pandemic year and not representative of all future rates going forward
# 2) Calculates the Avg Life Years Losts for each age gender and is saved as a LifeYearsLost (LYL) table
# 3) LYL table is joined to the base table by death age and gender to provide the LifeYearsLost metric.  For the base table, the midyr of the # deaths is assumed

#################################
# PRELIMINARY PREP
#################################
# 1) working directory location
getwd()   # C:/Users/edh/Documents 
setwd('C:/Users/hui_e/OneDrive/Documents/Personal Business/MSDS_MyPC/Courses/2023/2023f 498 Capstone') # changes wd, or tab Session - Set Working Directory. For networks specify the domain eg. setwd('//hlramerica.net/us3/Data/MRC')

# 2) Library/packages location
.libPaths()   # C:/Users/edh/Documents/R/R-3.5.3/library
# .libPaths()  # change lp
#.libPaths('C:/Users/hui_e/AppData/Local/R/win-library/4.2')

# 3) R version
version   # 
# To update to new version, (re)install R, copy any installed packages to the library folder in the new installation, run update.packages(checkBuilt=TRUE, ask=FALSE) in the new R and then delete anything left of the old installation. RStudio will detect new version upon re-openning.  Only update if functions needed are available with new version

# 4) CRAN Repository
# view current:  tools - global options - packages
# list: cran.r-project.org/mirrors.html # list of repositories
# change: chooseCRANmirror() or same as tools..  for US56W51XX servers only UC Berkeley and Duke work

# 5) script location
# should be in wd, but could be in RStudio or wd? can also find where open script is save via:  file-save as

# 6) system info
Sys.info()

# Environment Cleanup: identify 'open' info, remove as needed =========

# 1) Packages (should be none each time R is open except std pkgs).  Ensure compatible with R version
# shows all in ws
(.packages())   # Consistent with viewing those checked in the 'package' panel/window
# shows all in library:# .packages(all.available = TRUE)   # Consistent with viewing all in 'package' panel
# Remove from ws. or unclick:# detach("package:data.table", unload = TRUE)  # or quit R q() will remove all
# Remove from library:# remove.package()
# Update: Update button in package panel

# 2) Show data/objects
# ls()      # lists objects   # or view in the top right 'global environment'
rm(list=ls(all=TRUE)) # removes objects including the hidden  # alternative: tab - Session - Clear Workspace

# 3) Clear Command Console
# tab Edit - Clear Console

# Load Tools: =========================================================

# 1) Packages
# Show library packages in lib.path(): see available packages in package panel # or .packages(all.available = TRUE)
# Find useful packages/functions: google or stackoverflow
# Install packages to library: install.packages()   # or in pkg panel, less preferred eg. install.packages(c("car", "carData", "plyr", "MASS","lessR"))
# Load packages to workspace: require()             # or library(), lapply() for multiple, or in pkg panel (less preferred)

Pkgs2Load <- c("data.table",
               "ggplot2")
lapply(Pkgs2Load, require, character.only = TRUE)

# 1. Load the data
data <- fread("HMD_US_MortalityRatesByYearAgeGender.csv")

str(data)
names(data)
data[Age == "110+", Age := "110"]
data[,Age:=as.numeric(Age)]
data <- data[Year==2019]
head(data)

# Calculate life expectancy for given gender column
compute_life_expectancy <- function(data, gender_col){
  
  # 1. Compute nqx (already available as the gender column)
  
  # 2. Compute lx
  data[, lx := shift(cumprod(1 - get(gender_col)), n=1, fill=1)]
  
  # 3. Compute nLx
  data[, nLx := lx * (1 - get(gender_col) / 2)]
  
  # 4. Compute Tx
  data[, Tx := cumsum(rev(nLx))]
  data[, Tx := rev(Tx)]
  
  # 5. Compute ex
  data[, ex := Tx / lx]
  
  return(data[, .(Age, ex)])
}

# Compute life expectancy for both genders
male_life_expectancy <- compute_life_expectancy(data, "Male")
female_life_expectancy <- compute_life_expectancy(data, "Female")

# Merge the results
merged_results <- merge(male_life_expectancy, female_life_expectancy, by = "Age", suffixes = c("_Male", "_Female"))
print(merged_results)


######
# Merge with base data

# Basedata <- fread("Multiple Cause of Death, 1999-2020 Age Gender Year Race COD Socioec.txt")
Basedata <- fread("cleaned_wonder.csv")
Basedata
names(Basedata)
Basedata[,.N,keyby = `Five-Year Age Groups`]
library(data.table)

# Convert eBasedata to data.table (if it isn't already)
setDT(Basedata)

# Remove leading and trailing spaces from column names
names(Basedata) <- trimws(names(Basedata))

# setnames(Basedata,"Five-Year Age Groups", "AgeGroup")
# # Create Midpt Age variable
# Basedata[AgeGroup == "< 1 year", MidAge := 0]
# Basedata[AgeGroup == "1-4 years", MidAge := 2]
# Basedata[AgeGroup == "5-9 years", MidAge := 7]
# Basedata[AgeGroup == "10-14 years", MidAge := 12]
# Basedata[AgeGroup == "15-19 years", MidAge := 17]
# Basedata[AgeGroup == "20-24 years", MidAge := 22]
# Basedata[AgeGroup == "25-29 years", MidAge := 27]
# Basedata[AgeGroup == "30-34 years", MidAge := 32]
# Basedata[AgeGroup == "35-39 years", MidAge := 37]
# Basedata[AgeGroup == "40-44 years", MidAge := 42]
# Basedata[AgeGroup == "45-49 years", MidAge := 47]
# Basedata[AgeGroup == "50-54 years", MidAge := 52]
# Basedata[AgeGroup == "55-59 years", MidAge := 57]
# Basedata[AgeGroup == "60-64 years", MidAge := 62]
# Basedata[AgeGroup == "65-69 years", MidAge := 67]
# Basedata[AgeGroup == "70-74 years", MidAge := 72]
# Basedata[AgeGroup == "75-79 years", MidAge := 77]
# Basedata[AgeGroup == "80-84 years", MidAge := 82]
# Basedata[AgeGroup == "85-89 years", MidAge := 87]
# Basedata[AgeGroup == "90-94 years", MidAge := 92]
# Basedata[AgeGroup == "95-99 years", MidAge := 97]
# Basedata[AgeGroup == "100+ years", MidAge := 101]
# 
# str(Basedata)
# Perform the join and create LifeYearsLost variable based on Gender
# Basedata[, LifeYearsLost := as.numeric(LifeYearsLost)]
Basedata[merged_results, LifeYearsLostUnit := ifelse(Gender == "Female", i.ex_Female, i.ex_Male), on = .(age_midpoint = Age)]
Basedata[,LifeYearsLostTotal := LifeYearsLostUnit * Deaths]
Basedata[`Multiple Cause of death Code` == "T40.4", sum(LifeYearsLostTotal, na.rm = TRUE)]
Basedata[`Multiple Cause of death Code` == "T40.4", sum(Deaths, na.rm = TRUE)]
fwrite(Basedata, 'C:/Users/hui_e/OneDrive/Documents/Personal Business/MSDS_MyPC/Courses/2023/2023f 498 Capstone/cleaned_wonder_LifeYrsLostAdded10212023.csv')
