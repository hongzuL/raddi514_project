import SimpleITK as sitk
import numpy as np
import Tkinter, tkFileDialog


def load_itk(filename):
    #This funciton reads a '.mhd' file using SimpleITK and return the image array, origin and spacing of the image.
    # Reads the image using SimpleITK
    itkimage = sitk.ReadImage(filename)

    # Convert the image to a numpy array first and then shuffle the dimensions to get axis in the order z,y,x
    scan = sitk.GetArrayFromImage(itkimage)

    # Read the origin of the scan, will be used to convert the coordinates from world to voxel and vice versa.
    origin = np.array(list(reversed(itkimage.GetOrigin())))

    # Read the spacing along each dimension
    spacing = np.array(list(reversed(itkimage.GetSpacing())))

    return scan, origin, spacing

def main():
    root = Tkinter.Tk()
    root.withdraw()

    file_name = tkFileDialog.askopenfilename()
    scan, origin, spacing = load_itk(str(file_name))
    print(np.shape(scan),np.shape(origin),np.shape(spacing))
    np.savetxt('origin.txt',origin)
if __name__ == '__main__':
    main()