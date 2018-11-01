import pydicom
from pydicom.tag import Tag
import struct
import numpy as np
from vtk_plot import VTKPlot
from PyQt4.QtGui import QApplication, QFileDialog
import sys
import time
import os.path
import os
from os import listdir
from ECG_process import ECG_analysis
import matlab.engine

app = QApplication([])

# Use file open dialog to read the DICOM file
#fname = str(QFileDialog.getOpenFileName(None,"Open DICOM data file:","","All Files (*)","", QFileDialog.Options()))
ECG_dir = str(QFileDialog.getExistingDirectory(None,"Open Root folder for all ECG:","", QFileDialog.Options()))
#* segement the file name from the path
#full_path = fname.split('/')
#ECG_name = full_path[-1]
#* find the corresponding ultrasound folder, and count the total number of slices
USIMG_dir = str(QFileDialog.getExistingDirectory(None,"Open Root folder for all ultrasound images:","", QFileDialog.Options()))
for ecg_files in listdir(ECG_dir):
    ECG_name = ecg_files
    fname =  os.path.join(ECG_dir,ecg_files)
    
    US_found = False
    sequence_file = ''
    for subdir,dirs,files in os.walk(USIMG_dir):
        for US_file in files:
            extension_check = US_file.split('.')
            if(extension_check[1]=='seq' and extension_check[0]==ECG_name):
                US_found = True
                sequence_file = os.path.join(subdir,US_file)
                break
    if(US_found==False):
        print ('==================================='+ECG_name)
    else:
        #* read and parse the sequence file to get the information of the ultrasound image slice
        seq_file = open(sequence_file,'r')
        US_slices_name = list()
        num_slices = 0
        for i,line in enumerate(seq_file):
            if(i == 0):
                num_slices = int(line)
            elif(i>0 and i<num_slices):
                US_slices_name.append(line)
        print ('There are '+str(num_slices)+' Ultrasound slices for '+ECG_name)

        # Plot class based on VTK. Initialize the class
        # vtkplot = VTKPlot(x=np.zeros((2)), y=np.zeros((2)),xrange_=5.)
        # vtkplot.show()

        # DICOM tag correspond to ECG data
        tag_waveform_data = Tag(0x5400,0x0100)

        # Read DICOM file
        ds = pydicom.read_file(fname)

        # Get parameters assicated with the ECG data
        waveform_data = ds.WaveformSequence[0].WaveformData
        w_samples = ds.WaveformSequence[0].NumberOfWaveformSamples
        w_samplefreq= ds.WaveformSequence[0].SamplingFrequency
        w_channels_no = ds.WaveformSequence[0].NumberOfWaveformChannels
        w_duration = 1.0/w_samplefreq


        # Retrieve ECG data
        unpack_fmt = '<%dh' % (len(waveform_data) / 2)
        unpacked_waveform_data = struct.unpack(unpack_fmt, waveform_data)
        signals = np.asarray(unpacked_waveform_data,dtype=np.float32)

        #* check how many ECG data is contrained in one ultrasound image slice
        save_folder = './ECGS/'
        save_plot = './ECG_plots/'
        ECG_len = len(signals)
        slice_len = int(ECG_len/num_slices)
        # print('length of the signal: '+str(ECG_len))
        # print('total time of the signal: '+str(len(signals)/w_samplefreq))
        # print('signal frequency: '+str(w_samplefreq))
        # print('Each slice should contain '+str(slice_len)+' sample points')
        #* start matlab engine
        matlab_eng = matlab.engine.start_matlab()
        #* convert the np.asarray to python list
        sig_list = signals.tolist()
        sig_list = matlab.double(sig_list)
        ECG_analysis(signals,w_samplefreq,ECG_len,slice_len,sig_list,matlab_eng,ECG_name,save_plot)
        # Plot the ECG data animation
        # vtkplot.update_plot(x=np.arange(2)*w_duration, y=signals[0:2], n_remove=len(signals), xrange_=1.0*len(signals)*w_duration)
        # for i in range(len(signals)/30):
        #     vtkplot.update_plot(x=np.arange(30*i,30*(i+1))*w_duration, y=signals[30*i:30*(i+1)], n_remove=0, xrange_=1.0*len(signals)*w_duration)
        #     time.sleep(0.01)



        # sys.exit(app.exec_())

