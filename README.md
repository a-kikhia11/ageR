# {ageR}
### Athlete Growth &amp; Maturation R Package

## Intro



## Installation

```
# Install from GitHub  
install.packages("devtools")
devtools::install_github("a-kikhia11/ageR")
```

## Data Collection
Usable data must follow the same template as the **data_sample** sheet supplied within the package. Ensure that there are no blank fields within the dataset. 

**{ageR}** provides two Maturity Offset calculation methods (Mirwald and Fransen) as well as the Khamis-Roche method in the same dataset

**Note** the Fransen method is only applicable to **Males**

### Sample Data / Template

```
library(ageR)

data_sample
```

## Usage

### Data Frames:
The two main functions within the package are *`maturation_cm()`* and *`maturation_in()`*. Both functions perform the same calculations, however the units are different. The function takes the raw data from the template and performs the Khamis-Roche, Mirwarld, and Fransen calculations returning a dataframe that users can manipulate for further analysis.

```
library(ageR)

maturation_cm(data_sample)
```

```
library(ageR)

maturation_in(data_sample)
```

### Plots:
**{ageR}** provides several visualization options:

Predicted Adult Height Plot (note the three options depending on centimeters, inches, or feet and inches)

```
library(ageR)

plot_PAH_cm(data_sample)
plot_PAH_in(data_sample)
plot_PAH_ftin(data_sample)
```

Time to PHV Dumbell Plot (note the two options for calculating Time to PHV, Mirwald and Fransen)

```
library(ageR)

plot_time2phv_Fransen(data_sample)
plot_time2phv_Mirwald(data_sample)
```

Maturity Offset Plot (note the two options for calculating Maturity Offset, Mirwald and Fransen)

```
library(ageR)

plot_MatOffset_Fransen(data_sample)
plot_MatOffset_Mirwald(data_sample)
```

Plot Current and Predicted Height of an Athlete against Normal Growth Curves (must specify the athlete, reference sample, and gender)

```
library(ageR)

plot_growthcurve(data_sample, "Athlete 08", "UK", "Male")
plot_growthcurve(data_sample, "Athlete 17", "US", "Female")
```

Plot % Adult Height against Maturity Offset (maturity stages are further highlighted within the graph)

```
library(ageR)

plot_MatStages(data_sample)
```


## Considerations


## References
