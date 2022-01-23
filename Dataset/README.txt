**Dataset**

This folder was made for containing datasets to be used.

We already add "LibriSpeech", which contains the data in 'dev-clean.tar.gz' and 'test-clean.tar.gz' from 'https://www.openslr.org/12/'.
For more information, see the paper 
"LibriSpeech: an ASR corpus based on public domain audio books", Vassil Panayotov, Guoguo Chen, Daniel Povey and Sanjeev Khudanpur, ICASSP 2015.

We used this dataset for training and validation in our experiments.

Although we used 200 data from "TIMIT database" for the declipping section in our experiments, we are not allowed to re-distribute the data.
Thus, we use some of the "LibriSpeech" for the declipping section instead.

You can substitute any other files for them. If so, you need to modify the main file a little bit.

If you want to reproduce the results in our paper, you are kindly requested to download "PhaseLab Toolbox" from https://www2.spsc.tugraz.at/people/pmowlaee/PhaseLab.html 
and process the audio data with 'voicedPartExtraction.m'.