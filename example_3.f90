program test_m_config3
  use m_config

  type(CFG_t)          :: my_cfg
  integer, allocatable :: my_int(:)

  print *, "Testing m_config.f90 (test 3)"
  print *, "You can pass e.g. -my_int='1 2 3'"

  allocate(my_int(1))
  my_int(:) = 1

  call CFG_update_from_arguments(my_cfg)
  call CFG_add_get(my_cfg, "my_int", my_int, "my_int", dynamic_size=.true.)
  call CFG_check(my_cfg)

  print *, my_int

end program test_m_config3
