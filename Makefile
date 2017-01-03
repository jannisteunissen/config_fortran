# Use gfortran unless already defined
F90 ?= gfortran

ifeq ($(F90), gfortran)
	FFLAGS	?= -O2 -g -std=f2008 -Wall -Wextra
else ifeq ($(F90), ifort)
	FFLAGS	:= -O2 -stand f08 -warn all
endif

OBJS	:= m_config.o

.PHONY:	all test clean

all: 	libconfig_fortran.a example_1 example_2

libconfig_fortran.a: $(OBJS)
	$(RM) $@
	$(AR) rcs $@ $^

clean:
	$(RM) example_1 example_2 m_config.o m_config.mod libconfig_fortran.a

# Dependency information
example_1:	m_config.o
example_2:	m_config.o

# How to get .o object files from .f90 source files
%.o: %.f90
	$(F90) -c -o $@ $< $(FFLAGS)

# How to get executables from .o object files
%: %.o
	$(F90) -o $@ $^ $(FFLAGS)
