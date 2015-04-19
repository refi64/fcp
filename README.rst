fcp
===

An ultra-fast, multi-threaded file-copy utility written in `Nim <http://nim-lang.org/>`_.

Building
********

If you have `Nimble <https://github.com/nim-lang/nimble>`_ installed::

   $ nimble install

Otherwise::

   $ nim c fcp

Usage
*****

::

   fcp <source directory> <target directory> [<number of threads; defaults to 5>]

TODO
****

- If more than about 7 threads are opened, a SIGSEGV occurs.

- Test on Windows.
