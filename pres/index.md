---
title       : Predicting school inspection grades using Shiny   
subtitle    : 
author      : Meenakshi Parameshwaran
job         : 
framework   : shower    # {io2012, html5slides, shower, dzslides, landslide, Slidy ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : [mathjax, quiz, bootstrap, shiny, interactive]
ext_widgets:: #{rCharts: [libraries/nvd3]}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides

--- .class #id 



## Predicting Ofsted grades

### Purpose
- This app allows users to enter school characteristics and see how this changes the chances of achieving different school inspection grades

### Background
- Schools in England are inspected by the school's inspectorate, Ofsted
- Inspections lead to grades on the effectiveness of the school
- Although judgements are meant to be objective, factors outside of the school's control seem to be associated with the resulting grades

---

## User Interface

![ofsted_app_image](ofsted_app_screenshot.png)

---

## User inpus and tabs

### User inputs

- Region (dropdown)
- School type (dropdown)
- Average test score of the cohort at age 11 (numeric entry)
- Religious status of the school (radio button)
- Gender composition of the school (radio button)
- Classification algorithm (dropdown)
- Number of pupils in the school (slider)

### Tabs
1. The app itself
2. Feature descriptions - so the user can understand the features in the model
3. Methods - so the user can understand how the algorithms were fitted and where the data came from

---

## Feature descriptions and methods
One tab shows a **description** of the features (variables in the model)
![features_image](features_description.png)

Another tab explains the **methods** used to implement the models.
![methods_image](methods.png)

---

## Future improvements
Some ideas to improve this app in the future:

1. Use `rCharts` to make the figure more interactive
2. Allow users to select further features
3. Extend the app to primary (elementary) schools too
4. Improve the prediction performance of the algorithms offered
5. Allows users to decide which features to include in the model
6. Update the underlying dataset so that it draws on more years of Ofsted judgement data
7. Bootstrap the predictions to provide confidence intervals


