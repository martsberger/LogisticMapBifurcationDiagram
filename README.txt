Logistic Map Bifurcation Diagram

This is a repository of tools for creating pretty images of the bifurcation diagram of the logistic map. Mildly inspired by the wikipedia image:
http://upload.wikimedia.org/wikipedia/commons/5/50/Logistic_Bifurcation_map_High_Resolution.png

The tools will allow creating images zoomed in to any location of the diagram (computational limits apply). Sample images of the diagram at the same zoom as the wikipedia image is provided.

There is a Matlab version and a Python version.

Matlab instructions:
1. Put LogisticBifurcationDiagram2.m and Cobweb2.m in a directory in your matlab path.
2. help LogisticBifurcationDiagram2 has the details of the rest.

Python instructions:
Developed and tested using Python 2.7.3.
Depends on numpy and matplotlib
Depends on an C extension; source included, you'll have to build (I'll give instructions that worked on my machine).

1. Make sure you have numpy and matplotlib
2. build the logmap module:

Supposedly this can be done by: python setup_logmap.py install
But that didn't work on my Windows machine. Apparently the setup script does not work well with MS C compilers. So I used MinGW (free compiler). After installing MinGW, make sure the directory with gcc is on your path. Now this might work:

python setup_logmap.py install build --compiler=mingw32

Or you might get an error message about a -mno-cygwin flag. This was a deprecated compiler flag that gcc has now removed, but the python build tool was still using it. You'll have to remove this flag from the cygwinccompiler.py file. This may be located, for example, in C:\Python27\Lib\distutils\. Then the above install command should work.

3. Now you can import/run the module logistic_map_bifurcation_diagram, which defines the function logistic_map_bifurcation_diagram().
