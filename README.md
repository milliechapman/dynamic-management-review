
# dynamic-management-review

## Authors:

- William Oestreich, @woestreich
- Melissa Chapman, @milliechapman
- Larry Crowder

## Description
A comparative analysis of dynamic management (DM) strategies across marine and terrestrial systems, focusing on the scales underlying DM approaches in these domains.

## Analyses and Data
All cases from the systematic literature review were coded into `data/cases.csv` and include information on domain, year, spatial scale, temporal scale, and regulatory mechanism.

All figures were made with `scripts/generate-figures.Rmd` and can be seen in knitted document `scripts/generate-figures.md` or `scripts/generate-figures-files`

### Common files

- `README.md` this file, a general overview of the repository in markdown format.  

### Infrastructure for Testing

- `.travis.yml`: A configuration file for automatically running [continuous integration](https://travis-ci.com) checks to verify reproducibility of all `.Rmd` notebooks in the repo.  If all `.Rmd` notebooks can render successfully, the "Build Status" badge above will be green (`build success`), otherwise it will be red (`build failure`).  
- `DESCRIPTION` a metadata file for the repository, based on the R package standard. It's main purpose here is as a place to list any additional R packages/libraries needed for any of the `.Rmd` files to run.
- `tests/render_rmds.R` an R script that is run to execute the above described tests, rendering all `.Rmd` notebooks. 
