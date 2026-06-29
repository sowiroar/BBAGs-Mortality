# Biobehavioral Clocks Predict Dementia and Survival Across Latin American Populations

This repository contains the complete analytical workflow and modeling code corresponding to the paper **"Biobehavioral clocks predict dementia and survival across Latin American populations"**. 

The study leverages machine learning pipelines to construct and validate **Biobehavioral Age Gaps (BBAGs)**—the difference between chronological age and predicted age derived from harmonized behavioral, functional, sociodemographic, and clinical risk/protective factors—using harmonized cohort data from the Global 10/66 study across six Latin American countries: Cuba, Dominican Republic, Mexico, Peru, Puerto Rico, and Venezuela.

---

## Abstract Overview
* **Objective:** Test whether biobehavioral age gaps (BBAGs) capture pathological aging trajectories and predict dementia status, mortality risk, and longitudinal aging trajectories across Latin American populations.
* **Data Cohorts:** Cross-sectional cohort ($n = 12,693$) and longitudinal follow-up cohort ($n = 8,391$).
* **Models Tested:**
  * **Model A (Full):** Incorporates all behavioral, sociodemographic, and clinical predictors.
  * **Model B (Cognitive-Negative):** Excludes variables directly involved in diagnostic algorithms (e.g., CSID cognitive score, CERAD immediate/delayed recall, DSM-IV, and ICD-10 criteria) to reduce circularity.
  * **Model C (Cognitive-Mood-Functional-Negative):** A stricter specification further excluding depressive and functional variables (e.g., disability status, Euro-D scale, SRQ).
* **Key Findings:** Individuals with dementia showed significantly accelerated aging (higher BBAGs) across all models. Higher BBAGs were robustly associated with increased mortality risk (each SD increase conferring a $41-48\%$ higher hazard after adjustments) and predicted future accelerated aging at follow-up.

---

## Repository Structure

The code is organized into logical directories matching the different stages of the analysis pipeline:

### 1. Main Analysis Pipelines (`BBAGs-Mortality/`)

* **`Stats_Report/`**: Descriptive demographics and statistical tables.
  * [Descriptive_Statistics_and_Demographics.ipynb](BBAGs-Mortality/Stats_Report/Descriptive_Statistics_and_Demographics.ipynb) — Cohort summary statistics, sample demographics, and table generation.
* **`Wave1/`**: Age prediction and BBAG estimation for the baseline cohort.
  * [Wave1_BBAG_Model-A_Full.ipynb](BBAGs-Mortality/Wave1/Wave1_BBAG_Model-A_Full.ipynb) — Model A age prediction (all features).
  * [Wave1_BBAG_Model-B_Cognitive-Negative.ipynb](BBAGs-Mortality/Wave1/Wave1_BBAG_Model-B_Cognitive-Negative.ipynb) — Model B age prediction (excluding cognitive diagnostic inputs).
  * [Wave1_BBAG_Model-C_Cognitive-Mood-Functional-Negative.ipynb](BBAGs-Mortality/Wave1/Wave1_BBAG_Model-C_Cognitive-Mood-Functional-Negative.ipynb) — Model C age prediction (excluding cognitive, mood, and functional inputs).
* **`Wave1_Performance/`**: Evaluation metrics for Wave 1 models.
  * [Wave1_Performance_Results_Alternative.ipynb](BBAGs-Mortality/Wave1_Performance/Wave1_Performance_Results_Alternative.ipynb) — Model cross-validation and hyperparameter evaluation.
* **`Wave2/`**: Age prediction and longitudinal BBAG estimation at follow-up (Incidence).
  * [Wave2_BBAG_Model-A_Full.ipynb](BBAGs-Mortality/Wave2/Wave2_BBAG_Model-A_Full.ipynb) — Model A longitudinal age prediction.
  * [Wave2_BBAG_Model-B_Cognitive-Negative.ipynb](BBAGs-Mortality/Wave2/Wave2_BBAG_Model-B_Cognitive-Negative.ipynb) — Model B longitudinal age prediction.
  * [Wave2_BBAG_Model-C_Cognitive-Mood-Functional-Negative.ipynb](BBAGs-Mortality/Wave2/Wave2_BBAG_Model-C_Cognitive-Mood-Functional-Negative.ipynb) — Model C longitudinal age prediction.
* **`Wave2_Performance/`**: Evaluation metrics for Wave 2 models.
  * [Wave2_Performance_Results.ipynb](BBAGs-Mortality/Wave2_Performance/Wave2_Performance_Results.ipynb) — Incidence model performance analysis.
* **`Mortality_Models/`**: Longitudinal survival analyses and mortality risk estimations.
  * [Survival_Model-A_Full.ipynb](BBAGs-Mortality/Mortality_Models/Survival_Model-A_Full.ipynb) — Survival curves and Cox proportional hazards regression for Model A.
  * [Survival_Model-B_Cognitive-Negative.ipynb](BBAGs-Mortality/Mortality_Models/Survival_Model-B_Cognitive-Negative.ipynb) — Survival analysis and mortality hazard ratios for Model B.
  * [Survival_Model-C_Cognitive-Mood-Functional-Negative.ipynb](BBAGs-Mortality/Mortality_Models/Survival_Model-C_Cognitive-Mood-Functional-Negative.ipynb) — Survival analysis and mortality hazard ratios for Model C.
  * [Survival_Model-A_Biomarker_Comparison.ipynb](BBAGs-Mortality/Mortality_Models/Survival_Model-A_Biomarker_Comparison.ipynb) — Comparison of mortality predictive value between BBAGs and biological/blood biomarkers.
* **`Supplementary/`**: Sensitivity analysis notebooks.
  * [Supp_Wave1_BBAG_Model-A_OnlyHC.ipynb](BBAGs-Mortality/Supplementary/Supp_Wave1_BBAG_Model-A_OnlyHC.ipynb) — Baseline age estimation restricted only to healthy control (HC) subjects.
  * [Supp_Wave1_BBAG_Model-B_OnlyHC.ipynb](BBAGs-Mortality/Supplementary/Supp_Wave1_BBAG_Model-B_OnlyHC.ipynb) — Baseline age estimation for HC in Model B.
  * [Supp_Wave1_BBAG_Model-C_OnlyHC.ipynb](BBAGs-Mortality/Supplementary/Supp_Wave1_BBAG_Model-C_OnlyHC.ipynb) — Baseline age estimation for HC in Model C.
  * [Supp_Survival_Model-A_OnlyHC.ipynb](BBAGs-Mortality/Supplementary/Supp_Survival_Model-A_OnlyHC.ipynb) — Survival analyses restricted only to healthy controls.

### 2. Supporting Assets

* **`Data/`**: Folder containing the harmonized and fully anonymized data files (such as `data_wave1.parquet`, `data_wave2.parquet`, and `incidence_db.csv`).
* **`SFS/`**: Pickled files (`.pkl`) storing the pre-calculated Sequential Feature Selection results to prevent long runtime recalculations.
* **`Results/`**: Clean intermediate predictions and models results.

---

## Data Anonymization and Privacy

To comply with patient data privacy regulations and protect identity information, all raw identifiers—specifically `'householdid'` (family units) and `'particid'` (individual participants)—have been completely removed from this repository. 

* Subject-matching across baseline and incidence waves is preserved using a cryptographically anonymized generic identifier (`uid`), generated via an MD5 hashing algorithm (`SUBJ_` prefix followed by the first 8 characters of the hashed baseline ID).
* All parquet, excel, and text datasets in the `Data/` and `Results/` folders have been cleaned to guarantee that no raw personal identifiers are leaked.

---

## Installation & Setup

Make sure you have Python 3.8+ installed. You can install all the required external libraries using the provided [requirements.txt](requirements.txt):

```bash
pip install -r requirements.txt
```