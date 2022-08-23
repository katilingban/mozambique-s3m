
<!-- README.md is generated from README.Rmd. Please edit that file -->

# R workflow for Simple Spatial Surveys Method (S3M) survey in Mozambique

<!-- badges: start -->

[![test S3M
workflow](https://github.com/katilingban/mozambique_s3m/actions/workflows/test-s3m-workflow.yaml/badge.svg)](https://github.com/katilingban/mozambique_s3m/actions/workflows/test-s3m-workflow.yaml)
[![run S3M
workflow](https://github.com/katilingban/mozambique_s3m/actions/workflows/run-s3m-workflow.yaml/badge.svg)](https://github.com/katilingban/mozambique_s3m/actions/workflows/run-s3m-workflow.yaml)
[![check endline
data](https://github.com/katilingban/mozambique-s3m/actions/workflows/check-s3m-data.yaml/badge.svg)](https://github.com/katilingban/mozambique-s3m/actions/workflows/check-s3m-data.yaml)
<!-- badges: end -->

This repository is a
[`docker`](https://www.docker.com/get-started)-containerised,
[`{targets}`](https://docs.ropensci.org/targets/)-based,
[`{renv}`](https://rstudio.github.io/renv/articles/renv.html)-enabled
[`R`](https://cran.r-project.org/) workflow developed for the design,
data management, data analysis, and reporting of the implementation of
Simple Spatial Surveys Method (S3M) survey in Mozambique.

## Spatial sample workfow

✓ Successfully auto-authenticated via
auth/mozambique-s3m-e9da207bc2a3.json

``` mermaid
graph LR
  subgraph legend
    x7420bd9270f8d27d([""Up to date""]):::uptodate --- xbf4603d6c2c2ad6b([""Stem""]):::none
  end
  subgraph Graph
    x3fcad629bf609680(["selected_ea_file_updated"]):::uptodate --> x92e3f678d50e7191(["selected_ea_complete"]):::uptodate
    xfdb6a9b6a0e24e2c(["selected_urban_ea_file"]):::uptodate --> x92e3f678d50e7191(["selected_ea_complete"]):::uptodate
    xac05260670c94749(["sofala_district"]):::uptodate --> x07b06a64d6979765(["cidade_da_beira"]):::uptodate
    x216c8615edb5b18d(["cidade_da_beira_sp"]):::uptodate --> x91135f521fae67c1(["cidade_da_beira_grid"]):::uptodate
    x75893273a2726411(["moz_provinces"]):::uptodate --> x89b92e016b1a0789(["sofala_province"]):::uptodate
    xb7ac41c07a011c84(["sofala_settlements"]):::uptodate --> xbac0d63338e90727(["sofala_sample_12"]):::uptodate
    x36ac982d46cbe0a5(["sofala_sp_12"]):::uptodate --> xbac0d63338e90727(["sofala_sample_12"]):::uptodate
    xeb7dee2731da6b05(["moz_settlements"]):::uptodate --> xb7ac41c07a011c84(["sofala_settlements"]):::uptodate
    x89b92e016b1a0789(["sofala_province"]):::uptodate --> x36ac982d46cbe0a5(["sofala_sp_12"]):::uptodate
    x07b06a64d6979765(["cidade_da_beira"]):::uptodate --> x216c8615edb5b18d(["cidade_da_beira_sp"]):::uptodate
    x2ae35f7d7ffcedde(["moz_districts"]):::uptodate --> xac05260670c94749(["sofala_district"]):::uptodate
    x36ac982d46cbe0a5(["sofala_sp_12"]):::uptodate --> x3e8475df052020ee(["sofala_grid_12"]):::uptodate
  end
  classDef uptodate stroke:#000000,color:#ffffff,fill:#354823;
  classDef none stroke:#000000,color:#000000,fill:#94a4ac;
  linkStyle 0 stroke-width:0px;
```

## Authors

-   Mark Myatt
-   Ernest Guevarra
