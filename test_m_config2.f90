program test_m_config2
  use m_config

  integer, parameter    :: dp = kind(0.0d0)
  type(CFG_t)           :: my_cfg

  ! Some dummy variables
  real(dp)              :: my_real
  logical               :: my_logic
  integer               :: my_int
  character(len=20)     :: my_string
  real(dp)              :: my_real_array(4)
  logical               :: my_logic_array(4)
  integer               :: my_int_array(4)
  character(len=20)     :: my_string_array(4)


  print *, "Testing m_config.f90 implementation 2"


  print *,  "Test to read arguments and skip because my_cfg is empty"
  call CFG_update_from_arguments(my_cfg,.true.)
  call CFG_write(my_cfg, "stdout")
  print *, ""
  
  print *, "Test of real"
  my_real = 1.0d0
  call CFG_add_up(my_cfg,"scalar%real", my_real,"my_real")
  print *, "Test of logic"
  my_logic = .true.
  call CFG_add_up(my_cfg,"scalar%logic", my_logic,"my_logic")
  print *, "Test of integer"
  my_int = 5
  call CFG_add_up(my_cfg,"scalar%int", my_int,"my_int")
  print *, "Test of string"
  my_string = "word"
  call CFG_add_up(my_cfg,"scalar%char", my_string,"my_string")
  
  print *, ""
  print *, "output cfg to terminal and file example_config_out2.cfg"
  call CFG_write(my_cfg, "stdout")
  call CFG_write(my_cfg, "example_config_out_2a.cfg") ! Write to file
  print *, "update from arguments"
  call CFG_update_from_arguments(my_cfg,.true.)
  print *, "output cfg to terminal again"
  call CFG_write(my_cfg, "stdout")
  print *, ""
  
  print *, "Test of real array"
  my_real_array = [1.0d0, 2.0d0, 3.0d0, 4.0d0]
  call CFG_add_up(my_cfg,"array%real", my_real_array,"my_real_array")
  print *, "Test of logic array"
  my_logic_array = [.true., .true., .true., .true.]
  call CFG_add_up(my_cfg,"array%logic", my_logic_array,"my_logic_array")
  print *, "Test of integer array"
  my_int_array = [1,2,3,4]
  call CFG_add_up(my_cfg,"array%int", my_int_array,"my_int_array")
  print *, "Test of string array"
  my_string_array = ["word A", "word B", "word C", "word D"]
  call CFG_add_up(my_cfg,"array%char", my_string_array,"my_string_array")
  
  print *, ""
  print *, "output cfg to terminal and file example_config_out2.cfg"
  call CFG_write(my_cfg, "stdout")
  call CFG_write(my_cfg, "example_config_out_2b.cfg") ! Write to file
  print *, "update from arguments"
  call CFG_update_from_arguments(my_cfg,.true.)
  print *, "output cfg to terminal again:"
  call CFG_write(my_cfg, "stdout")
  print *, ""

  
end program test_m_config2