from PyQt4.QtGui import QMainWindow, QApplication, QWidget, QDialog, QGridLayout
import vtk
import numpy as np
from vtk.qt4.QVTKRenderWindowInteractor import QVTKRenderWindowInteractor
import sys
import time

# Class for plotting 1D signals
class VTKPlot(QDialog):
    def __init__(self, x, y, xrange_ = 10.): 
        super(VTKPlot, self).__init__()   
        self.setGeometry(50,50,700,350)
        
        self.setWindowOpacity(1.)

        self.view = vtk.vtkContextView()     
        chartMatrix = vtk.vtkChartMatrix()
        chartMatrix.SetSize(vtk.vtkVector2i(1,1))
        chartMatrix.SetGutter(vtk.vtkVector2f(50,50))
        
        self.vtkWidget = QVTKRenderWindowInteractor(self) 
        self.view.SetRenderWindow(self.vtkWidget.GetRenderWindow())       
        self.view.GetRenderer().SetBackground(1.0,1.0,1.0)
        self.view.GetScene().AddItem(chartMatrix)            

        self.chart = chartMatrix.GetChart(vtk.vtkVector2i(0,0))
        self.arrY = vtk.vtkFloatArray()         
        self.arrX = vtk.vtkFloatArray()        
                
        self.table = vtk.vtkTable()
        self.add_plot(x,y, xrange_=xrange_)       
            
        self.chart.GetAxis(vtk.vtkAxis.BOTTOM).SetTitle("Time")
        self.chart.GetAxis(vtk.vtkAxis.LEFT).SetTitle("Signal")
        
        self.view.GetRenderWindow().SetMultiSamples(0)
        self.view.GetRenderWindow().Render()

        layout = QGridLayout()
        layout.addWidget(self.vtkWidget, 0, 0)
                
        self.setLayout(layout)      

    # Add plot (initial step)
    def add_plot(self, x, y, xrange_=10.):
        for k in range(len(x)):
            self.arrX.InsertNextValue(x[k])
            self.arrY.InsertNextValue(y[k])           
        
        self.arrX.SetName("Time (ms)")
        self.table.AddColumn(self.arrX)
 
        self.arrY.SetName("Strain")
        self.table.AddColumn(self.arrY) 
            
        self.plot = self.chart.AddPlot(0)
        self.plot.SetInput(self.table,0,1) if vtk.VTK_VERSION < '6' else self.plot.SetInputData(self.table,0,1)
                
        self.plot.SetColor(0, 200, 50, 255)
        self.plot.SetWidth(2.0)  
                
        self.plot.GetXAxis().SetRange(self.arrX.GetRange()[0],self.arrX.GetRange()[1]) if xrange_ < self.arrX.GetRange()[1] else self.plot.GetXAxis().SetRange(self.arrX.GetRange()[0],xrange_)
            
        self.plot.GetYAxis().SetRange(self.arrY.GetRange()[0],self.arrY.GetRange()[1])
        
        
        self.plot.GetXAxis().SetBehavior(vtk.vtkAxis.FIXED)
        self.plot.GetYAxis().SetBehavior(vtk.vtkAxis.FIXED)
    
        self.view.GetRenderWindow().Render()
        
    # Update existing plot (useful for animating plots)    
    def update_plot(self, x, y, n_remove=0, xrange_=10.):
        for i in range(n_remove):
            self.arrX.RemoveFirstTuple()
            self.arrY.RemoveFirstTuple()
            
        for k in range(len(x)):
            self.arrX.InsertNextValue(x[k])
            self.arrY.InsertNextValue(y[k])                       

        self.arrX.Modified()
        self.arrY.Modified()
        
        self.plot.GetXAxis().SetRange(self.arrX.GetRange()[0],self.arrX.GetRange()[1]) if xrange_ < self.arrX.GetRange()[1] else self.plot.GetXAxis().SetRange(self.arrX.GetRange()[0],xrange_)
        self.plot.GetYAxis().SetRange(self.arrY.GetRange()[0],self.arrY.GetRange()[1])
                
        self.table.Modified()        
        self.chart.Update()
        
        self.view.GetRenderWindow().Render()
    
    # Remove plot from the chart
    def remove_plot(self):
        self.chart.RemovePlot(0)
        


if __name__ == "__main__":
 
    # Test the vtkplot class with random data
    app = QApplication([])
        
    x = np.arange(0,200,1)
    y = np.random.rand((200))
    vtkplot = VTKPlot(x=x, y=y)
    vtkplot.show()

    st = time.time()
    for i in range(100):
        x = np.arange(x[-1]+1, x[-1]+2)
        y = np.random.rand((1))

        vtkplot.update_plot(x,y,1)
        vtkplot.update()
        time.sleep(0.05)
    
    
    sys.exit(app.exec_())
