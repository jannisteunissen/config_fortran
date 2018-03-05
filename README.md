# config_fortran

A configuration file parser for Fortran. The intended usage is as follows:

1. You create your configuration variables, by providing a default value and
   a description.
2. You read in a text file in which new values are specified for (some of) the
   variables.
3. You use the updated values in your program, so that there is no need to recompile.

Steps 1 and 2 can also be reversed, so that you read in the configuration files
before specifying the variables. Variables can be of type integer, real,
logical/bool, or string, and they can also be an array of such types.

## Example

Suppose you want to use a grid of size `n_grid`, then you could do:

    integer     :: n_grid
    type(CFG_t) :: my_cfg
    
    call CFG_add(my_cfg, "grid_size", 1024, "Size of the grid")
    call CFG_read_file(my_cfg, "my_input_file.txt")
    call CFG_get(my_cfg, "grid_size", n_grid)

Here, the default grid size will be 1024. If the file `my_input_file.txt` contains a line

    grid_size = 512

the actual grid size used in your program will be 512. It is also possible to
read the file first, and to combine the `add` and the `get`:

    integer     :: n_grid = 1024
    type(CFG_t) :: my_cfg
    
    call CFG_read_file(my_cfg, "my_input_file.txt")
    call CFG_add_get(my_cfg, "grid_size", n_grid, "Size of the grid")

When parsing the input file, the variable `n_grid` will be stored as plain text,
since its type is not yet known. The call `CFG_add_get` converts it to the right
type. The files `example_1.f90` and `example_2.f90` provide further usage
examples.

The current configuration can be stored in a file with `CFG_write`, which can
then be used as input again. It is also possible to write markdown files with
`CFG_write_markdown`. Writing to the special file name `"stdout"` causes the
configuration to be printed to the screen. By specifying the optional argument
`hide_unused=.true.`, only the variables whose value was used through a
`CFG_get` (or `CFG_add_get`) are included.

## Command line arguments

A routine `CFG_update_from_arguments` is included, which parses command line arguments. Currently, two types of arguments are supported, as shown in the examples below.

    # Read in two configuration files
    ./my_program config_1.cfg config_2.cfg
    
    # Read in two variables
    ./my_program -var_1=value -var_2=value
    
    # Read in an array of variables
    ./my_program -var_2='value value'
    
    # Mix the above options
    ./my_program config_1.cfg config_2.cfg -var_1=value -var_2=value
    
Note that variable specifications should be preceded by a dash (`-`).

## Configuration file syntax

There are different types of lines:

1. Blank lines, or lines only containing a comment (`# ...` or `; ...`), which are ignored.
2. Lines indicating the start of a category: `[category_name]`
3. Lines with an `=`-sign. If they are part of a user-defined category, they
   should start with an indent.
4. Lines with a `+=` sign. For a scalar string variable, this will append to the
   string. On an array, this will append an element to the array. On other types
   of variables, this operation gives an error.

An example of a configuration file is shown below

    age = 29
    name = John
    
    [weather]
        temperature = 25.2
        humidity = 23.5
    
    happy = .true.
    
    weather%temperature = 23.9

Note that `temperature` and `humidity` are indented, and that `happy` is not,
which means that `happy` is not part of weather (it is in the default unnamed
category). At least two spaces or a tab counts as indentation. Outside an indented
`[weather]` group, you can directly refer to its members by using e.g.
`weather%temperature`, as is done on the last line. To place variables in a
category, you add them like this:

    call CFG_add(my_cfg, "weather%temperature", 25.0_dp, "The temperature")

Variables can also be arrays:

    name_of_variable = value1 [value2 value3 ...] # Optional comment

The extra values `[value2 value3 ...]` are omitted for a scalar variable. You
can create variables of varying array size, by specifying `dynamic_size=.true.`
when creating a config variable:

    call CFG_add(my_cfg, "numbers", [1, 2], "Comment", dynamic_size=.true.)

## Methods

* `CFG_add`: Add a variable to the configuration
* `CFG_get`: Get the value of a variable
* `CFG_add_get`: First `CFG_add`, then `CFG_get`
* `CFG_check`: Check whether all variables read from files have been defined.
  This is automatically performed on `CFG_write` and `CFG_write_markdown`.
* `CFG_get_size`: Get the array size of a variable
* `CFG_get_type`: Get the type of a variable
* `CFG_sort`: Sort the configuration (for faster lookup when there are many variables)
* `CFG_write`: Write the configuration to a standard text/config file, which can
  be read in again. By default, only the variables that were used are printed.
* `CFG_write_markdown`: Write the configuration to a file in markdown format
* `CFG_read_file`: Read in a configuration file
* `CFG_update_from_arguments`: Read in the program's arguments as configuration files.
* `CFG_clear`: Clear config for reuse

## Requirements

A modern Fortran compiler that supports Fortran 2008. The included `Makefile`
was written for `gfortran` (the default) and `ifort`, which you can enable by
typing `make F90=ifort`.

## Comparison to Fortran namelists

Benefits of config_fortran:

* You can read in (1D) arrays of unknown size
* Settings have documentation, and you can write "documented" output in text or markdown format
* If you don't want to use global variables, you have to open and read namelists in each module that requires parameters. I think it's nicer to read in a config_fortran type object once and pass that to the modules
* You can spread out settings over multiple files, which is convenient for setting up parameter studies (this can be done with namelists, but it's not trivial)
* Flexibility: although namelist implementations slightly differ, you cannot change them like you can config_fortran. Config_fortran for example allows to write only those settings that have been requested in a program.

Benefits of namelist format:

* More standard, although not completely the same for different vendors/versions yet
* Support for array(3) = ... syntax
* Support for array = 10*'dummy' syntax

(*Of course, points 2 & 3 could easily be implemented in config_fortran*)

## Alternatives

* [libconfig](http://www.hyperrealm.com/libconfig/) (C/C++)
* [config4*](http://www.config4star.org/) (C/C++)
* [KRACKEN](http://www.urbanjost.altervista.org/LIBRARY/libCLI/arguments/src2015/krackenhelp.html) (Fortran argument parser)
* [FLAP](https://github.com/szaghi/FLAP) (Fortran 2003+ argument parser)
* [FiNeR](https://github.com/szaghi/FiNeR) (Fortran 2003+ config file parser)

## TODO

* Write tests
