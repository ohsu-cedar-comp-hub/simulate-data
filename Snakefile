__author__ = "Breeshey Roskams-Hieter"
__email__ = "roskamsh@ohsu.edu"

"""Simulated data pipeline"""

import datetime
import sys
import os
import pandas as pd
import json


timestamp = ('{:%Y-%m-%d_%H:%M:%S}'.format(datetime.datetime.now()))

# Config file
configfile:"omic_config.yaml"

# Variables from config file
nrep = config['n_rep']

# Wildcards
CHRS = ['chr1','chr2','chr3','chr4','chr5','chr6','chr7','chr8','chr9','chr10','chr11','chr12','chr13','chr14','chr15','chr16','chr17','chr18','chr19','chr20','chr21','chr22','chrX','chrY']
ext = ['R1','R2']
REPS = list(range(1, nrep+1))

with open('cluster.json') as json_file:
    json_dict = json.load(json_file)

rule_dirs = list(json_dict.keys())
rule_dirs.pop(rule_dirs.index('__default__'))

for rule in rule_dirs:
    if not os.path.exists(os.path.join(os.getcwd(),'logs',rule)):
        log_out = os.path.join(os.getcwd(), 'logs', rule)
        os.makedirs(log_out)
        print(log_out)

def message(mes):
    sys.stderr.write("|--- " + mes + "\n")

rule all:
    input:
       expand("output/Sample{rep}_{ext}.fastq", rep = REPS, ext = ext) 

include: "rules/simulate.smk"
