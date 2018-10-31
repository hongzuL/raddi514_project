import numpy as np
import vtk
import Tkinter, tkFileDialog
from vtk.util import numpy_support
root = Tkinter.Tk()
root.withdraw()

file_name = tkFileDialog.askopenfilename()
reader = vtk.vtkPolyDataReader()
reader.SetFileName(str(file_name))
reader.ReadAllScalarsOn()
reader.ReadAllVectorsOn()
reader.ReadAllTensorsOn()
reader.Update()
vtkdata = reader.GetOutput()
print type(npdata)
print vtkdata.GetNumberOfPoints()
print vtkdata.GetPoint(0)