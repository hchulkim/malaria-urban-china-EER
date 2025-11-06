# Replication repository information

This is a GitHub repository for replicating "Malaria suitability, urbanization and persistence: Evidence from China over more than 2000 years (European Economic Review)" at UKRN Replication Games. 

## Collaborators (PLEASE ADD)

[Hyoungchul Kim](https://hchulkim.github.io/)

## Citation

# Replication instructions

## High-level structures for this replication

In this replication, we have three main components:

1. **Local folder (in your local machine)**: This is where you do your analysis. Your local folder tracks GitHub remote repo. You should periodically pull the results from GitHub remote repo to incorporate them into your local folder. You should also periodically push your results to remote repo to update it with your results.
2. **GitHub remote repository (hosted on GitHub)**: This is a remote folder hosted on GitHub that is shared by all the collaborators for consistency. Make sure your local folder tracks the remote repo.
3. **Overleaf (synced to GitHub repo)**: This is a place for writing documents. It is currently synced to GitHub so all the tables and figures created in GitHub will be available here.

## Recommended workflow

0. (You only need to do this the first time) `git clone` the GitHub remote repo to your local machine. From then on, this would be your local folder tracking the remote repo.
1. Do `git pull` before doing your analysis on the local folder to ensure you have the most updated version of GitHub remote repo.
2. Do all the analysis in the local folder and use git to record them. Use `git commit` to record them and `git push` to update the GitHub remote repo.
3. IF YOU WANT TO SAVE PROCESSED DATA, IT SHOULD BE SAVED IN `data/processed`. ALL TABLES AND FIGURES OUTPUTS THAT WILL BE USED FOR OVERLEAF REPORTS SHOULD BE SAVED IN `output/tables` and `output/figures`.
4. Your results will be updated on GitHub and Overleaf.
5. Write reports/papers in the overleaf.

## File/Folder structure

- `original-scripts`: This is a folder that contains original replication files (compressed as zip file). DO NOT USE IT UNLESS RAW DATA GETS CONTAMINATED DURING REPLICATION ANALYSIS.
- `code`: This is a folder for code scripts used in the analysis. It also contains the original Stata do files of the authors of the paper. For consistency, try to have a subdirectory with your name to keep your codes for now (e.g. hyoungchul).
- `data/raw`: This is a folder that contains original replication raw data files. DO NOT MODIFY or OVERWRITE THEM! (READ ONLY!)
- `data/processed`: This is a folder that contains intermediary data processed from the original raw data. Instead of overwriting raw data, try to save processed data in this folder.
- `output/tables` and `output/figures`: These are folders that contain tables and/or figures used for our final report.
- `output/paper`: This is a folder that contains Overleaf document. I RECOMMEND EDITING THEM ONLY FROM OVERLEAF!

## Caution

1. DO NOT MODIFY or OVERWRITE FILES IN `data/raw`. IF YOU WANT TO SAVE PROCESSED DATA, IT SHOULD BE SAVED IN `data/processed`. ALL TABLES AND FIGURES OUTPUTS THAT WILL BE USED FOR OVERLEAF REPORTS SHOULD BE SAVED IN `output/tables` and `output/figures`.
2. IN OVERLEAF, TRY TO ONLY EDIT `output/paper/main.tex` document

# README document from original replication file

### *Malaria Suitability, Urbanization and Persistence: Evidence From China Over More Than 2000 Years*  

---

## Replication Code

- **EER-D-16-00243_Main.do**  
  Contains the Stata code used to replicate the results presented in the main paper (Tables 1–5).

- **EER-D-16-00243_Appendix.do**  
  Contains the Stata code used to replicate the results presented in the Appendix.

---

## Data Sets

Three datasets are used in the main empirical analysis:

- **SouthChinaPixelLevelMain.dta** – Cross-section, grid-cell level dataset.  
- **PanelSouthChina.dta** – Grid-cell level panel dataset.  
- **CountyLevelDataset.dta** – Cross-section, county-level dataset.

---

## Additional Datasets (Robustness Checks)

Seven datasets are employed for robustness analyses:

- **MannEtAl2009Data.dta** – 5×5 degree grid-cell level panel dataset.  
- **NorthChinaPixelLevel.dta** – Cross-section, grid-cell level dataset for North China.  
- **PanelPooledChina.dta** – Grid-cell level panel dataset (covering China Proper).  
- **SouthChinaPixelLevel19011925.dta** – Dataset using climate data from 1901–1925.  
- **SouthChinaPixelLevel19261950.dta** – Dataset using climate data from 1926–1950.  
- **SouthChinaPixelLevel19511975.dta** – Dataset using climate data from 1951–1975.  
- **SouthChinaPixelLevel19762000.dta** – Dataset using climate data from 1976–2000.
