import pip
def install(package):
    pip.main(['install','--upgrade', package])
install('pycav') 
