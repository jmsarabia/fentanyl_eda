# Ed Hui
# 5.2023
# Assignment_03.R

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
data[Age == "110+", Age := "110"]
data[,Age:=as.numeric(Age)]

head(data)
# 2. Compute mortality improvements
# Setting the data.table key to ensure ordering by Age and then by Year
setkey(data, Age, Year)

# For Male
data[, Male_MI := 1 - Male / shift(Male, type = "lag"), by = Age]

# For Female
data[, Female_MI := 1 - Female / shift(Female, type = "lag"), by = Age]
#setorder(data,Year,Age)

data

# Filter data to include only Ages up to 100
filtered_data <- data[Age <= 90]
filtered_data <- data[Year != 1933]
# Loess smoothing for Male_MI
male_smoothed <- filtered_data[, .(
  Year, 
  Age, 
  Male_MI_smoothed = predict(loess(Male_MI ~ Year + Age, span=0.01, data = filtered_data))
)]

female_smoothed <- filtered_data[, .(
  Year, 
  Age, 
  Female_MI_smoothed = predict(loess(Female_MI ~ Year + Age, span=0.01, data = filtered_data))
)]

# Heatmap for Smoothed Male Mortality Improvement
male_plot <- ggplot(male_smoothed[Age >= 0 & Age <= 90], aes(x = Year, y = Age)) +
  geom_raster(aes(fill = Male_MI_smoothed)) +
  scale_fill_gradient2(low = "red", mid = "yellow", high = "green", 
                       midpoint = 0, limits = c(-0.1, 0.1), 
                       name = "Smoothed Mortality Improvement") +
  labs(title = "Smoothed Male Mortality Improvement", x = "Year", y = "Age") +
  coord_fixed(ratio = 1.5) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 8),         # Adjust title font size
    legend.key.size = unit(0.5, "cm"),            # Adjust legend key size
    legend.text = element_text(size = 4),         # Adjust legend text size
    legend.title = element_text(size = 5)         # Adjust legend title size
  ) +
  ylim(0, 90)

# Heatmap for Smoothed Female Mortality Improvement
female_plot <- ggplot(female_smoothed[Age >= 0 & Age <= 90], aes(x = Year, y = Age)) +
  geom_raster(aes(fill = Female_MI_smoothed)) +
  scale_fill_gradient2(low = "red", mid = "yellow", high = "green", 
                       midpoint = 0, limits = c(-0.1, 0.1), 
                       name = "Smoothed Mortality Improvement") +
  labs(title = "Smoothed Female Mortality Improvement", x = "Year", y = "Age") +
  coord_fixed(ratio = 1.5) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 8),         # Adjust title font size
    legend.key.size = unit(0.5, "cm"),            # Adjust legend key size
    legend.text = element_text(size = 4),         # Adjust legend text size
    legend.title = element_text(size = 5)         # Adjust legend title size
  ) +
  ylim(0, 90)

# To adjust the size of the plot in RStudio or similar environments, you can set the plot output dimensions
options(repr.plot.width = 15, repr.plot.height = 15)

library(gridExtra)
# Display the plots side-by-side using grid.arrange from gridExtra
grid.arrange(male_plot, female_plot, ncol=2, widths = c(10, 10), heights = c(10, 10))


