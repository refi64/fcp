fcp
===

An ultra-fast, multi-threaded file-copy utility written in `Nim <http://nim-lang.org/>`_. fcp excels in moving directories with a large number of moderately-sized or large files.

Building
********

If you have `Nimble <https://github.com/nim-lang/nimble>`_ installed::

   $ nimble install

Otherwise::

   $ nim c fcp

Usage
*****

::

   fcp <source directory> <target directory> [<number of threads; defaults to 20>]

TODO
****

- Test on Windows.
