dnl Process this file with autoconf to produce a configure script.
AC_INIT(src/Attack.cxx)

AM_INIT_AUTOMAKE(crack-attack, 1.1.8)
AM_CONFIG_HEADER(src/config.h)

dnl Checks for programs.
AC_PROG_CC
AC_PROG_CXX
AC_PROG_INSTALL

dnl Checks for libraries.

dnl Checks for header files.
AC_HEADER_STDC
AC_CHECK_HEADERS(limits.h unistd.h sys/socket.h sys/poll.h netinet/in.h netdb.h arpa/inet.h sys/stat.h)

dnl Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_C_INLINE

AC_PATH_XTRA

dnl Checks for library functions.
AC_CHECK_FUNCS(socket poll)

AC_OUTPUT(Makefile src/Makefile data/Makefile doc/Makefile)
