# QCEW data

This is a small repository created merely to illustrate how one can share data effectively using a small repository of code.
The QCEW programs offers alternative ways of accessing its data and the provision of this repository is not intended to replace those other ways.

## Getting QCEW data

According to [its website], "The Quarterly Census of Employment and Wages (QCEW) program publishes a quarterly count of employment and wages reported by employers covering more than 95 percent of U.S. jobs, available at the county, MSA, state and national levels by industry."

QCEW data files are provided [here](https://www.bls.gov/cew/downloadable-data-files.htm).
The script `process_qcew_data.R` downloads (if necessary) raw data files from the QCEW website and converts them into parquet files which are easier to work with.

Before running the script: you should:

1. Install the needed R packages:

```{r}
install.packages("stringr", "duckdb", "DBI")
```

2. Set up two environment variables.

Editing the values for `RAW_DATA_DIR` and `DATA_DIR` in `.Renviron` may be the easiest way.
Note that you may need to restart R before using the new values if you edit these.

The location `RAW_DATA_DIR` is where the downloaded raw data files will be stored.
The location `DATA_DIR` indicates the location of the parquet data repository that will used to store the parquet files.
For more on one approach to setting up and using such a data repository, see [here](https://iangow.github.io/far_book/parquet-wrds.html).
