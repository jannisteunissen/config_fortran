FC 	:= gfortran
FFLAGS	:= -O0 -g -std=f2008 -Wall -Wextra

OBJS	:= m_config.o

.PHONY:	all test clean

all: 	test_m_config

clean:
	$(RM) test_m_config m_config.o m_config.mod

# Dependency information
test_m_config:	m_config.o

# How to get .o object files from .f90 source files
%.o: %.f90
	$(FC) -c -o $@ $< $(FFLAGS)

# How to get executables from .o object files
%: %.o
	$(FC) -o $@ $^ $(FFLAGS)
