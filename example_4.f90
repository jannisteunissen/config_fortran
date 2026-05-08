program test_m_config4
  use m_config

  integer, parameter :: dp = kind(0.0d0)
  type(CFG_t)        :: my_cfg

  print *, "Testing m_config.f90 (test 4)"
  print *, "This code calls CFG_print_help, which happens automatically when"
  print *, "-help or --help is parsed by CFG_check"

  call CFG_add(my_cfg, "filename", "this/is/a/filename", &
       "A string containing a filename")

  ! Variables can be placed inside categories
  call CFG_add(my_cfg, "author%age", 25, &
       "Age of the author of this code")
  call CFG_add(my_cfg, "author%fav_reals", (/1.337_dp, 13.37_dp, 133.7_dp/), &
       "My favorite numbers", dynamic_size=.true.)
  call CFG_add(my_cfg, "author%lots_of_work", .true., &
       "Whether I have a lot of work to do")

  call CFG_update_from_arguments(my_cfg)
  call CFG_check(my_cfg)

  print *, "Now calling CFG_print_help"
  call CFG_print_help(my_cfg)

end program test_m_config4
