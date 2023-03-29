../../gambit/gsi/gsi ./rsc.scm -t c -l max $1.scm && clang $1.scm.c -o $1
./$1
