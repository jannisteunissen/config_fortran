program test_m_config
  use m_config

  integer, parameter    :: dp = kind(0.0d0)
  type(CFG_t)           :: my_cfg

  ! Some dummy variables
  real(dp), allocatable :: my_reals(:)
  logical               :: my_logic
  integer               :: my_int
  integer               :: n_reals
  integer               :: variable_type
  character(len=20)     :: fmt_string
  logical               :: check

  print *, "Testing m_config.f90 implementation"

  call CFG_add(my_cfg, "filename", "this/is/a/filename", &
       "A string containing a filename")

  ! Variables can be placed inside categories
  call CFG_add(my_cfg, "author%age", 25, &
       "Age of the author of this code")
  call CFG_add(my_cfg, "author%fav_reals", (/1.337_dp, 13.37_dp, 133.7_dp/), &
       "My favorite numbers", dynamic_size=.true.)
  call CFG_add(my_cfg, "author%lots_of_work", .true., &
       "Whether I have a lot of work to do")

  ! Categories cannot be nested
  call CFG_add(my_cfg, "author_name%first", "jannis", &
       "First name of the author of this code")
  call CFG_add(my_cfg, "author_name%full", &
       ["Jannis   ", "Teunissen"], "Full name of the author")

  call CFG_add(my_cfg, "weather%temperature", 25.0_dp, &
       "Temperature (Celsius)")
  call CFG_add(my_cfg, "weather%humidity", 90.0_dp, &
       "Humidity (percent)")

  ! Sort the configuration (this can speed up looking for variables, but only if
  ! you have a sufficiently large number of them)
  call CFG_sort(my_cfg)

  print *, "**Original values**"
  print *, ""

  ! Write to stdout (only when given the filename "stdout")
  call CFG_write(my_cfg, "stdout")
  print *, "printed also to: example_config.cfg"
  call CFG_write(my_cfg, "example_config.cfg")
  print *, ""

  print *, "** Reading in example_config.cfg **"
  call CFG_read_file(my_cfg, "example_config.cfg") ! Update values with file

  print *, "** Updated values: **"
  print *, ""
  call CFG_write(my_cfg, "stdout")                 ! Write to stdout
  call CFG_write(my_cfg, "example_config_out.cfg") ! Write to file
  call CFG_write_markdown(my_cfg, "example_config_out.md") ! Write markdown file

  print *, "The code below demonstrates how to get values: "
  print *, ""

  call CFG_get(my_cfg, "author%lots_of_work", my_logic)
  write(*, "(A25,L10)") "Lots of work: ", my_logic

  call CFG_get(my_cfg, "author%age", my_int)
  write(*, "(A25,I10)") "My age: ", my_int

  call CFG_get_size(my_cfg, "author%fav_reals", n_reals)
  write(*, "(A25,I10)") "Size favourite numbers: ", n_reals

  ! Generate format string
  write(fmt_string, "(A,I0,A)") "(A25,", n_reals, "E10.2)"

  allocate(my_reals(n_reals))
  call CFG_get(my_cfg, "author%fav_reals", my_reals)
  write(*, fmt_string) "Favourite numbers: ", my_reals
  deallocate(my_reals)

  call CFG_get_type(my_cfg, "author_name%full", variable_type)
  write(*, "(A25,A10)") "Type of full name: ", CFG_type_names(variable_type)
  
  print *, ""
  print *, "The code below checks if a certain variable is present: "
  call CFG_check_presence(my_cfg, "author_name%full", check)
  print *, "author_name%full is present?:", check
  call CFG_check_presence(my_cfg, "author%number", check)
  print *, "author%number is present?:", check

end program test_m_config
