FC 	:= gfortran
FFLAGS	:= -O2 -g -std=f2008 -Wall -Wextra

OBJS	:= m_config.o

.PHONY:	all test clean

all: 	libconfig_fortran.a test_m_config test_m_config2

libconfig_fortran.a: $(OBJS)
	$(RM) $@
	$(AR) rcs $@ $^

clean:
	$(RM) test_m_config m_config.o m_config.mod libconfig_fortran.a

# Dependency information
test_m_config:	m_config.o
test_m_config2:	m_config.o

# How to get .o object files from .f90 source files
%.o: %.f90
	$(FC) -c -o $@ $< $(FFLAGS)

# How to get executables from .o object files
%: %.o
	$(FC) -o $@ $^ $(FFLAGS)
