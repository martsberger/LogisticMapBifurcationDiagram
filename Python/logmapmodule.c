#include <Python.h>

static char histogram_docstring[] = "h = logmap.attractor_histogram(r1, r2, "
  "rrlen, xxlen, x1, x2, M)\n\n"
  "Returns a histogram of how many times each of M bins from x1 to x2\n"
  "is visited during iterations of the logistic map.\n\n"
  "rrlen values from r1 to r2 are used as the paramter r in the logistic map.\n\n"
  "500 iterations are thrown away to eliminate transients. xxlen\n"
  "iterations are kept for thie histogram.";

static PyObject *logmap_attractor_histogram(PyObject *self, PyObject *args) {
  double r1, r2, x, x1, x2;
  int xxlen, rrlen, M;
  int transient = 500; // Short transient for each r.

  if (!PyArg_ParseTuple(args, "ddiiddi", &r1, &r2, &rrlen, &xxlen, &x1, &x2, &M)) {
    return NULL;
  }

  // Store our histogram in an int array, copy it to a python list and return
  // the list as a PyObject*
  int array[M];
  PyObject* list = PyList_New(M);
  // Initialize array to all zeros
  int j, k;
  for (j = 0; j < M; ++j) {
    array[j] = 0;
  }

  double r, dr, dx;
  int incr;

  // Set the amount we will step to get from r1 to r2 in rrlen-1 steps
  dr = 0;
  if (rrlen > 1) { dr = (r2 - r1)/(rrlen-1); }

  // Histogram bin size
  dx = (x2 - x1)/(M - 1);

  // Dispense of transients before entering r-loop.
  // Causes a bug at the bifurcation points.
  // x = 0.25;
  // r = r1;
  // for (j = 0; j < 500; ++j) {
  //   x = x*r*(1 - x);
  // }

  // loop over r (perhaps change to for (r=r1; r<=r2; r += dr) )
  for (j = 0; j < rrlen; ++j ) {
    r = r1 + j*dr;
    x = 0.25;
    for (k = 0; k < xxlen + transient; ++k) { // short transient for each r ( + 50)
      x = x*r*(1 - x);
      if (k >= transient) {                   // if passed transient
        incr = (int)((x-x1)/dx);              // histogram bin to update
        if ( incr >= 0 && incr < M) {         // make sure we're in bounds
          array[incr] += 1;
        }
      }
    }
  }

  // Copy array to list and return
  j = 0;
  Py_ssize_t i;
  for (i = 0; i < M; ++i) {
    PyList_SetItem(list, i, Py_BuildValue("i",array[j]));
    ++j;
  }
  return list;
}

static PyMethodDef module_methods[] = {
  { "attractor_histogram", (PyCFunction)logmap_attractor_histogram, METH_VARARGS, histogram_docstring },
  { NULL, NULL, 0, NULL }
};

PyMODINIT_FUNC initlogmap() {
   Py_InitModule3("logmap", module_methods, "docstring...");
}
