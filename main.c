#include <uk/config.h>
#define Py_BUILD_CORE
#include <Python.h>

int main(int argc, char *argv[])
{
	int rc;

	rc = _Py_UnixMain(argc, argv);
	if (rc) {
		fprintf(stderr, "Error initiating Python (rc=%d)\n", rc);
		goto out;
	}

out:
	return rc;
}
