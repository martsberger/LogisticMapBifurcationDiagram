from numpy import linspace, zeros, array
import matplotlib.pyplot as plt
import matplotlib.cm as cm

import logmap

import time
import sys

def logistic_map_bifurcation_diagram(M=500, N=800, r1=2.4, r2=3.99,
                                     x1=0, x2=1, quality=10):
    ''' Creates an image of the Logistic Map Bifurcation Diagram similar to
    the one on Wikipedia:
    http://upload.wikimedia.org/wikipedia/commons/5/50/Logistic_Bifurcation_map_High_Resolution.png

    Uses numpy and matplotlib

    # Make a nice plot:
    >>> logistic_map_bifurcation_diagram(500, 800, 2.4, 4.0, 0, 1, 10)
    '''

    start_time = time.time()
    r_vector = linspace(r1, r2, N)

    xxlen = quality*100
    rrlen = quality

    bif_diag = zeros((N, M), float)

    # for making a progress bar
    progressbar_width = 40
    sys.stdout.write("[%s]" % (" " * (progressbar_width - 1)))
    sys.stdout.flush()
    sys.stdout.write("\n ")
    mod_val = int(N/progressbar_width)
    
    for k in range(1,N-1):
        # For pixel at r, we calculate r values from r - dr/2 to r + dr/2
        r1 = 0.5*(r_vector[k] + r_vector[k-1])
        r2 = 0.5*(r_vector[k] + r_vector[k+1])

        # histogram of how frequently each pixel is visited.
        h = logmap.attractor_histogram(r1, r2, rrlen, xxlen, x1, x2, M)

        # Normalize the histogram to go from 0 to 1.
        h = 1.0*array(h[:])/max(h)

        # stick it in upside down to the image
        bif_diag[k-1] = h[::-1]

        # update progress bar
        if k % mod_val == 0:
            sys.stdout.write("-")

    sys.stdout.write("\n")

    print("computed in " + str(time.time() - start_time) + " seconds")

    # Display 1 - histogram, transpose the matrix. Use a gray colormap
    plt.imshow(1 - bif_diag.transpose(), cm.gray, clim = (0.6, 1))
    plt.show()
