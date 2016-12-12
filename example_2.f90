program test_m_config2
  use m_config

  integer, parameter    :: dp = kind(0.0d0)
  type(CFG_t)           :: my_cfg

  ! Some dummy variables
  integer               :: my_int

  print *, "Testing m_config.f90 (test 2)"
  print *, "This program reads its arguments as configuration files"
  print *, "Try running it like this:"
  print *, "./example_2"
  print *, "./example_2 example_2_input.cfg"
  print *, ""

  call CFG_update_from_arguments(my_cfg)

  call CFG_add(my_cfg, "scalar%real", 1.0_dp, "my_real")
  call CFG_add(my_cfg, "scalar%logic", .true., "my_logic")

  print *, "Using CFG_add_get you can immediately get the value"
  print *, "that previously has been read in, for example:"
  my_int = 5
  call CFG_add_get(my_cfg, "scalar%int", my_int, "my_int")
  print *, "my_int: ", my_int
  print *, ""

  call CFG_add(my_cfg, "scalar%string", "a string", "my_string")
  call CFG_add(my_cfg, "array%real", [1.0_dp, 2.0_dp], "my_real_array")
  call CFG_add(my_cfg, "array%logic", [.true., .true.], "my_logic_array")
  call CFG_add(my_cfg, "array%int", [1, 2], "my_int_array")
  call CFG_add(my_cfg, "array%string", ["A", "B"], "my_string_array")

  call CFG_write(my_cfg, "stdout")                       ! Write to screen
  call CFG_write(my_cfg, "example_2_output.cfg")         ! Write to file
  call CFG_write_markdown(my_cfg, "example_2_output.md") ! Write markdown file

end program test_m_config2
