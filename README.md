# APPLADE (Adjustable Plug-and-PLay Audio DEclipper)
**Tomoro Tanaka (Department of Intermedia Art and Science, Waseda University, Tokyo, Japan)**\
[![DOI](https://zenodo.org/badge/456819164.svg)](https://zenodo.org/badge/latestdoi/456819164) [![View APPLADE on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://jp.mathworks.com/matlabcentral/fileexchange/106800-applade)

This README file describes the MATLAB codes provided to test, analyze, and evaluate the methods named APPLADE.\
APPLADE is an audio declipping method introduced in the following paper
>[1] Tomoro Tanaka, Kohei Yatabe, Masahiro Yasuda, and Yasuhiro Oikawa, "APPLADE: Adjustable plug-and-play audio declipper combining DNN with sparse optimization," in IEEE Int. Conf. Acoust. Speech Signal Process. (ICASSP), 2022 (accepted).

## Requirements
The codes were developed in MATLAB version R2021a and have been tested in R2021a and R2021b.\
Some functions rely on 

1. MathWorks Toolbox: You are kindly requested to download some of them, such as 'Deep Learning Toolbox' and 'Parallel Computing Toolbox'.

2. Toolboxes available online: These are available online under the [MIT license](https://opensource.org/licenses/mit-license.php).

- DGTtool\
  *A simple and user-friendly MATLAB tool for computing the short-time Fourier transform (STFT) and the discrete Gabor transform (DGT).*
  I already installed it so you can easily execute the codes. Plaese refer to https://github.com/KoheiYatabe/DGTtool or its helps for more detailed information.

- `calcCanonicalDualWindow.m`\
  This is a function for generating the canonical dual window. It is from the MATLAB codes that is available in https://doi.org/10/c3qb. \
  Please refer to the paper  below for more detailed information and other helpful codes.
  
  >[2] Kohei Yatabe, Yoshiki Masuyama, Tsubasa Kusano and Yasuhiro Oikawa, "Representation of complex spectrogram via phase conversion," Acoustical Science and Technology, vol.40, no.3, May 2019. (Open Access)

## Data
There are 4 audio data in the folder `Dataset/Examples`.\
They are from [LibriSpeech ASR corpus](https://www.openslr.org/12/), which is a corpus of English speech sampled at 16kHz.
This is freely available under [CC BY 4.0 license](https://creativecommons.org/licenses/by/4.0/).\
Please refer to the URL above and the paper

>[3] V. Panayotov, G. Chen, D. Povey and S. Khudanpur, "Librispeech: An ASR corpus based on public domain audio books," 2015 IEEE International Conference on Acoustics, Speech and Signal Processing (ICASSP), 2015, pp. 5206-5210.

for more information about this corpus.

## Usage
Execute `main.mlx` to perform APPLADE. The trained DNN parameters that were used in our experiments are to be used.

- `Declipping`
  - `DGTtool-main` contains DGTtool explained above including the license file.
  - `Tools` contains some functions used in `main.mlx` and so on.
  - `main_APPLADE.mlx` is the mainloop of APPLADE.

- `Training`
  - `Train_main.mlx` is for training a DNN in your own manner.
  - `Models` contains model functions to be used as a DNN.
  - `Tools` contains some functions used in `Train_main.mlx` and so on. `calcCanonicalDualWindow.m` is in this folder.
  - `modelParameters` contains the trained DNN parameters, and your own DNN parameters are also to be in this folder. 


## License
See the file named `LICENSE.pdf`.
