# fortran_config

A configuration file parser for Fortran. The intended usage is as follows:

1. You create your configuration variables, by providing a default value and
   a description.
2. You read in a text file in which new values are specified for (some of) the
   variables.
3. You use the updated values in your program, so that there is no need to recompile.

Variables can be of type integer, real, logical/bool, or string, and they can
also be an array of such types.

## Example

Suppose you want to use a grid of size `n_grid`, then you could do:

    integer     :: n_grid
    type(CFG_t) :: my_cfg
    
    call CFG_add(my_cfg, "grid_size", 1024, "Size of the grid")
    call CFG_read_file(my_cfg, "my_input_file.txt")
    call CFG_get(my_cfg, "grid_size", n_grid)

Here, the default grid size will be 1024. If the file `my_input_file.txt` contains a line

    grid_size = 512

the actual grid size used in your program will be 512. See `test_m_config.f90`
for an more extensive example of the usage. If you have a sufficiently recent `gfortran` compiler, you can run the test with

    $ make
    $ ./test_m_config

## Configuration file syntax

Lines with an `=`-sign should be of the form:

    name_of_variable = value1 [value2 value3 ...] # Optional comment

The extra values `[value2 value3 ...]` can be omitted for a scalar variable.
Lines without an `=`-sign are simply ignored. A `#` indicates the start of a
comment, which will be ignored.

## Requirements

A modern Fortran compiler that supports Fortran 2008. The included `Makefile` was written for `gfortran`.

## TODO

* Allow `#` to appear in strings.
* Prevent user from creating same variable twice
* Write tests

## Alternatives

* [libconfig](http://www.hyperrealm.com/libconfig/) (C/C++)
* [config4*](http://www.config4star.org/) (C/C++)
* [KRACKEN](http://www.urbanjost.altervista.org/LIBRARY/libCLI/arguments/src2015/krackenhelp.html) (Fortran argument parser)
