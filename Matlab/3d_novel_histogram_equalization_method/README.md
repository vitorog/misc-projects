# Color histogram equalization methods

Implementation of multiple color histogram equalization methods:

[1] - Iso-Luminance: Ji-Hee Han; Sejung Yang; Byung-Uk Lee, "A Novel 3-D Color Histogram Equalization Method With Uniform 1-D Gray Scale Histogram," Image Processing, IEEE Transactions on , vol.20, no.2, pp.506,512, Feb. 2011

[Link](https://ieeexplore.ieee.org/document/5557812)

[2] - Box-shaped CDF: P. E. Trahanias and A. N. Venetsanopoulos, "Color image enhancement through 3-D histogram equalization", Proc. 15th IAPR Int. Conf. Pattern Recognit., vol. 1, pp. 545-548, 1992

[Link](https://ieeexplore.ieee.org/document/202045)

[3] - Marginal CDF: D. Menotti , L. Najman , A. de Araújo and J. Facon, "A fast hue-preserving histogram equalization method for color image enhancement using a Bayesian framework", Proc. 14th Int. Workshop Syst., Signal Image Process. (IWSSIP), pp. 414-417, 2007

[Link](https://ieeexplore.ieee.org/document/4381129)

[4] - Scale and Shift: S. Naik and C. Murthy , "Hue-preserving color image enhancement without gamut problem", IEEE Trans. Image Process., vol. 12, no. 12, pp. 1591-1598, 2003

[Link](https://ieeexplore.ieee.org/document/1257395)

[5] - Independent channel equalization: This method applies a histogram equalization on each RGB channel independently. This does not preserve the relation between the 3 channels.

# Results

![ScreenShot](https://raw.github.com/vitorog/misc-projects/master/Matlab/3d_novel_histogram_equalization_method/screenshots/iso_result.png "Comparison 1")
[1] Original x Result

![ScreenShot](https://raw.github.com/vitorog/misc-projects/master/Matlab/3d_novel_histogram_equalization_method/screenshots/box_result.png "Comparison 2")
[2] Original x Result

![ScreenShot](https://raw.github.com/vitorog/misc-projects/master/Matlab/3d_novel_histogram_equalization_method/screenshots/marginal_result.png "Comparison 3")
[3] Original x Result

![ScreenShot](https://raw.github.com/vitorog/misc-projects/master/Matlab/3d_novel_histogram_equalization_method/screenshots/scale_shift_result.png "Comparison 4")
[4] Original x Result

![ScreenShot](https://raw.github.com/vitorog/misc-projects/master/Matlab/3d_novel_histogram_equalization_method/screenshots/independent_result.png "Comparison 5")
[5] Original x Result
