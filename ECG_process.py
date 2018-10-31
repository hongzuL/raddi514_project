from PyQt4 import QtGui
import matplotlib.pyplot as plt
from scipy import signal
import numpy as np


def ECG_analysis(signals,fs,signal_len,slice_len,sig_list,matlab_eng,file_name,save_path):
    # locs = matlab_eng.return_peaks(sig_list)
    # locs = np.asarray(locs[0], dtype=np.int)
    # print(locs)
    index = np.arange(0,signal_len)
    widths = np.arange(slice_len/10,slice_len) # the possible widths for the waves, used for peak detection
    peak_locs = signal.find_peaks_cwt(signals, widths) # there should not be two peaks in one slice(no two waves in one slice)
    # sort the peak location based on the its amplitude
    peak_values = signals[peak_locs]
    peaks_rank = peak_values.argsort()
    peak_value_sort = peak_values[peaks_rank[::-1]]
    R_one_loc = 0
    R_two_loc = 0
    left_R_loc = 0
    right_R_loc = 0
    for p in range(len(peak_locs)):
        if(peak_values[p]==peak_value_sort[0]):
            R_one_loc = peak_locs[p]
        elif(peak_values[p]==peak_value_sort[1]):
            R_two_loc = peak_locs[p]
        if(R_one_loc>R_two_loc):
            left_R_loc = R_two_loc
            right_R_loc = R_one_loc
        else:
            left_R_loc = R_one_loc
            right_R_loc = R_two_loc
    print(peak_locs)
    print(peak_values)
    print(left_R_loc,right_R_loc)
    # compute the amplitude difference between two consecutive peaks
    peak_value_diff = [abs(j-i) for i,j in zip(peak_values[:-1],peak_values[1:])]
    # rank the amplitude difference to find the highest value and the 4th highest value
    peak_value_diff_tmp = peak_value_diff
    peak_value_diff_tmp.sort(reverse=True)
    # set the threshold to be the min of 1/4 of the max value or the 4th max value
    threshold = min(0.25*peak_value_diff_tmp[0],peak_value_diff_tmp[3])
    print(threshold)
    # Find the P and T wave candidates
    peak_loc_candidates = list()
    finish_add_peaks = False
    # while finish_add_peaks:
    #     if()
    plt.plot(index,signals,'k')
    # plt.plot(index[locs],signals[locs],'bv')
    plt.plot(index[peak_locs],peak_values,'ro')

    # plt.show()
    plt.savefig(save_path+file_name+'.png')
    plt.clf()