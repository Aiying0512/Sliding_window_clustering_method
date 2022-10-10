# Sliding_window_clustering_method
The code is based on the sliding window based clusetering method we proposed.
To run the code, we provide the following instructions.

1. System requirements:

Hardware Requirements: 
To implement the source code, it requires only a standard computer with enough RAM to support the operations defined by a user. For minimal performance, this will be a computer with about 2 GB of RAM. For optimal performance, we recommend a computer with the following specs:

CPU	4+ cores, 4.00+ GHz/core   
RAM	32.0+ GB

The runtimes below are generated using a computer with the recommended specs (32 GB RAM, 4 cores@4.0 GHz) and internet of speed 200 Mbps.

Software Requirements:
The source code is written in R, which is a free software environment for statistical computing and graphics. 
It is suggested to use RStudio to run the source code, which has a better GUI environment.
Users should have R version 4.0.4 or higher, RStudio version 2022.02.3+492 or higher.


2. Installation Guide

R can be freely downloaded at https://www.r-project.org/ 

RStudio can be downloaded with the choice of free version at https://www.rstudio.com/products/rstudio/download/ 

The download time should be within a minute. 

Package dependencies:
For test_on_simulated_dataset, only package fpc is needed.
Installation command in R:

install.packages('fpc')

This will be installed in about 5 seconds on a machine with the recommended specs.


3. Demo

For test_on_simulated_dataset.R, the expected run time on a recommended computer is 30 seconds.
The data generation is given in the source code with ground truth plotted.

4. Instruction for use

Simply run the test_on_simulated_dataset.R from an R terminal
