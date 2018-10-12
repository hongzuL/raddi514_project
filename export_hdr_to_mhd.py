

import vtk
import numpy as np
import os

# Function to read HDR and IMG image pairs
def read_hdr_file(fname):
    with open(fname) as f:
        dim_str = f.readline()
        sp_str = f.readline()
        unknown1_str = f.readline()
        offset_str = f.readline()
        trans_r1_str = f.readline()
        trans_r2_str = f.readline()
        trans_r3_str = f.readline()
        dtype_str = f.readline()
        drange_str = f.readline() 
        
        dim = np.array(dim_str.split()).astype(np.int)
        spacing_ = np.array(sp_str.split()).astype(np.float)
        dtype_ = np.array(dtype_str.split()).astype(np.int)
        
        print(dim, spacing_, dtype_)
        


def read_siemens_echo_file(fname):
    path_, ext_ = os.path.splitext(fname)
    
    read_hdr_file(fname)
    
    im_header = np.genfromtxt(fname, skip_footer=7)
    dim = im_header[0].astype(np.int)
    spacing_ = im_header[1]
           
    im_data = np.fromfile(path_+".img", dtype=np.uint8)
    
    return im_data, dim, spacing_


file_in = r".\20170623_volunteer\CartesianDICOM\IM_0002\63756622_001.hdr"



path_out = "Test"

raw, dim, spacing = read_siemens_echo_file(file_in)

reader = vtk.vtkImageImport()
reader.CopyImportVoidPointer(raw, len(raw))
reader.SetDataScalarTypeToUnsignedChar()
reader.SetNumberOfScalarComponents(1)
reader.SetDataExtent(0, dim[0] - 1, 0, dim[1] - 1, 0, dim[2] - 1)
reader.SetWholeExtent(0, dim[0] - 1, 0, dim[1] - 1, 0, dim[2] - 1)
reader.SetDataOrigin(-(dim[0]-1) * (spacing[0] / 2), -(dim[1]-1) * (spacing[1] / 2), 0)
reader.SetDataSpacing(spacing[0], spacing[1], spacing[2]) 

    


mhdWriter = vtk.vtkMetaImageWriter()
mhdWriter.SetFileName(os.path.splitext(os.path.basename(file_in))[0] + ".mhd")
mhdWriter.SetInput(reader.GetOutput())
mhdWriter.SetCompression(False)
mhdWriter.Write()    



