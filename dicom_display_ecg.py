import pydicom
from pydicom.tag import Tag
import struct
import numpy as np
from vtk_plot import VTKPlot
from PyQt4.QtGui import QApplication, QFileDialog
import sys
import time





app = QApplication([])

# Use file open dialog to read the DICOM file
fname = str(QFileDialog.getOpenFileName(None,"Open DICOM data file:","","All Files (*)","", QFileDialog.Options()))

# Plot class based on VTK. Initialize the class
vtkplot = VTKPlot(x=np.zeros((2)), y=np.zeros((2)),xrange_=5.)
vtkplot.show()

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
print('length of the signal: ',len(signals))
print('total time of the signal: ',len(signals)/w_samplefreq)
print('signal frequency: ',w_samplefreq)
# Plot the ECG data animation
vtkplot.update_plot(x=np.arange(2)*w_duration, y=signals[0:2], n_remove=len(signals), xrange_=1.0*len(signals)*w_duration)
for i in range(len(signals)/30):
    vtkplot.update_plot(x=np.arange(30*i,30*(i+1))*w_duration, y=signals[30*i:30*(i+1)], n_remove=0, xrange_=1.0*len(signals)*w_duration)
    time.sleep(0.01)



sys.exit(app.exec_())

