#!/usr/bin/env Rscript

library(Seurat)
library(Azimuth)
library(SeuratData)
library(patchwork)

options(future.globals.maxSize= 850*1024^2)

args = commandArgs(trailingOnly=TRUE)

data = readRDS(args[1])
data <- RunAzimuth(data, reference = "reference")
saveRDS(data, file=args[2])