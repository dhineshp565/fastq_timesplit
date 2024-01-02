# fastq_timesplit
Shell script for splitting fastq file (oxford nanopore sequencing)  based on time (in minutes).
## Usage
```
./fastq_timesplit.sh path/to/dir/sub-directory_with_fastq 30
$1 path to directory containing sub-directories with fasat files
$2 Interger representing time interval (eg. 30 mean 30 minutes)

```

Uses python script from  @wdecoster/nanopore_timefilt.py (https://gist.github.com/wdecoster/1ab9adac7c8095498ff91ee22468eaac#file-nanopore_timefilt-py) to split fastq files


## Dependencies
* biopython
* python module (https://pypi.org/project/python-dateutil/)
