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
    # compute the amplitude difference between two consecutive peaks
    peak_value_diff = [abs(j-i) for i,j in zip(peak_values[:-1],peak_values[1:])]
    # rank the amplitude difference to find the highest value and the 4th highest value
    peak_value_diff_sort = sorted(peak_value_diff,reverse=True)
    # set the threshold to be the min of 1/4 of the max value or the 4th max value
    threshold = min(0.25*peak_value_diff_sort[0],peak_value_diff_sort[3])
    
    # find all candidate peaks for P and T wave, using the threshold
    Peak_candidates = list()
    Peak_candidates_avg_pvd = list()
    other_peaks = list()
    other_peaks_avg_pvd = list()
    for p in range(len(peak_locs)):
        if(peak_locs[p]<=left_R_loc or peak_locs[p]>=right_R_loc):
            # eliminate the peaks on the left of the 1st R peak and on the right of the 2nd R peak
            # that means when p=0 and p=-1, the corresponding peak should be the left and right R peak
            pass
        else:
            # compare the Peak-to-peak amplitudes(peak value diff) for each peak to the threshold
            left_pvd = peak_value_diff[p-1]
            right_pvd = peak_value_diff[p]
            if(left_pvd>=threshold and right_pvd>=threshold):
                Peak_candidates.append(peak_locs[p])
                Peak_candidates_avg_pvd.append((left_pvd+right_pvd)/2)
            else:
                other_peaks.append(peak_locs[p])
                other_peaks_avg_pvd.append((left_pvd+right_pvd)/2)
    # handle event for peaks number is not 2
    while(len(Peak_candidates)!=2):
        # the number of candidates is not 2
        if(len(Peak_candidates)>2):
            # need more conditions
            # Peak_candidates_tmp = [x for _,x in sorted(zip(Peak_candidates_avg_pvd,Peak_candidates),reverse=True)]
            # del Peak_candidates[:]
            # Peak_candidates.append(Peak_candidates_tmp[0])
            # Peak_candidates.append(Peak_candidates_tmp[1])
            break
        else:
            # not enough candidates
            print('Mising peaks!')
            if(len(other_peaks)>=2):
                Peak_candidates += other_peaks
                Peak_candidates_avg_pvd += other_peaks_avg_pvd
            else:
                break
            
    # check for P wave and T wave, T wave peak should close to left R peak and T wave should close to right R peak
    middle_loc = int((left_R_loc+right_R_loc)/2)
    #for i in range(len(Peak_candidates)):

    Peak_candidates.append(left_R_loc)
    Peak_candidates.append(right_R_loc)
    Peak_candidates.sort()
    Peak_candidates_values = signals[Peak_candidates]
    plt.plot(index,signals,'k')
    # plt.plot(index[locs],signals[locs],'bv')
    plt.plot(index[Peak_candidates],Peak_candidates_values,'ro')

    # plt.show()
    plt.savefig(save_path+file_name+'.png')
    plt.clf()