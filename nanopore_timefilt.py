from argparse import ArgumentParser
from Bio import SeqIO
import gzip
from dateutil.parser import parse as dparse


def main():
    args = get_args()
    time_from = dparse(args.time_from)
    time_to = dparse(args.time_to)
    for record in SeqIO.parse(args.fastq, "fastq"):
        if filter_time(record.description, time_from, time_to):
            print(record.format("fastq"), end="")


def get_args():
    parser = ArgumentParser(description="Filter nanopore data based on time")
    parser.add_argument("fastq", help="input gzip compressed fastq file")
    parser.add_argument("--time_from", help="filtering reads after this", required=True)
    parser.add_argument("--time_to", help="filtering reads before this", required=True)
    return parser.parse_args()


def filter_time(descr, tfrom, tto):
    "e.g. runid=2582f1be82a0c29a01c4c852b672559257416ff6 read=12 ch=2153 start_time=2017-10-13T11:54:09Z"
    time = dparse([i for i in descr.split() if i.startswith('start_time')][0].split('=')[1])
    return True if tfrom <= time <= tto else False


if __name__ == '__main__':
    main()
