# if( "$ENV{CC}" MATCHES "^musl-mulle-*")
#    unset( ENV{CC})
#    message( STATUS "Ignore CC environment, as mulle-objc-list can't be built with musl-mulle")
#    set( ENV{CFLAGS} "-fPIC -fno-common")
#    message( STATUS "Set ENV{CFLAGS} to $ENV{CFLAGS}")
# endif()
#

# try_compile(), triggered by project( mulle-objc-list C) will have problems
# linking an executable, but we don't care

if( MULLE_MUSL_STATIC OR COSMOPOLITAN)
   set( CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
   set( SKIP_EXECUTABLE_INSTALL ON)
endif()

cmake_minimum_required( VERSION 3.13...99.99)


project( mulle-objc-list VERSION 0.25.0 LANGUAGES C)


### mulle-sde environment

# add cmake module paths to search path
list( INSERT CMAKE_MODULE_PATH 0 "${CMAKE_CURRENT_SOURCE_DIR}/cmake/share")
list( INSERT CMAKE_MODULE_PATH 0 "${CMAKE_CURRENT_SOURCE_DIR}/cmake/reflect")
list( INSERT CMAKE_MODULE_PATH 0 "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

include( Environment)

include( Files)

if( HEADERS_PHASE)
   install( FILES ${PUBLIC_HEADERS} DESTINATION "include/${PROJECT_NAME}")

   # short cut out
   if( NOT COMPILE_PHASE AND NOT LINK_PHASE)
      return()
   endif()
endif()

if( LINK_PHASE)
   include( Dependencies OPTIONAL)
endif()


### Executable

#
# we just link mulle-objc-runtime as a c library and not with everything
# but we do need to link atinit and atexit normally

if( LINK_PHASE)
   list( REMOVE_ITEM ALL_LOAD_DEPENDENCY_LIBRARIES "${MULLE__OBJC__RUNTIME_LIBRARY}")
   list( INSERT DEPENDENCY_LIBRARIES 0 "${MULLE__OBJC__RUNTIME_LIBRARY}")
   set( ALL_LOAD_DEPENDENCY_LIBRARIES
      ${ALL_LOAD_DEPENDENCY_LIBRARIES}
      CACHE INTERNAL "need to cache this"
   )
   set( DEPENDENCY_LIBRARIES
      ${DEPENDENCY_LIBRARIES}
      CACHE INTERNAL "need to cache this"
   )
endif()

include( Executable)

# only for Executable
include( Motd OPTIONAL)

# the main executable carries the special link options below
set( _MULLE_OBJC_LIST_LINK_TARGET "${EXECUTABLE_LINK_TARGET}")

#
# Additional tools. These used to be built by mulle-objc-runtime and then by
# the short-lived mulle-objc-tools project. The scripts in this project look
# for them as siblings, so they are built and installed here.
#
unset( EXECUTABLE_IDENTIFIER)
unset( EXECUTABLE_UPCASE_IDENTIFIER)
unset( EXECUTABLE_DOWNCASE_IDENTIFIER)
set( EXECUTABLE_NAME            mulle-objc-uniqueid)
set( EXECUTABLE_SOURCES         ${UNIQUEID_SOURCES})
set( EXECUTABLE_DEPENDENCY_NAMES "")

include( Executable)

# only for Executable
include( Motd OPTIONAL)

unset( EXECUTABLE_IDENTIFIER)
unset( EXECUTABLE_UPCASE_IDENTIFIER)
unset( EXECUTABLE_DOWNCASE_IDENTIFIER)
set( EXECUTABLE_NAME            mulle-objc-signature)
set( EXECUTABLE_SOURCES         ${SIGNATURE_SOURCES})
set( EXECUTABLE_DEPENDENCY_NAMES "")

include( Executable)

# only for Executable
include( Motd OPTIONAL)

if( NOT SKIP_EXECUTABLE_INSTALL)

   include( InstallExecutable)

   # need this for mulle-atexit
   if( LINK_PHASE AND UNIX AND NOT APPLE)
      target_link_options( "${_MULLE_OBJC_LIST_LINK_TARGET}"
         PUBLIC
            "SHELL:LINKER:--export-dynamic"
      )
   endif()

#
# see: https://john.nachtimwald.com/2012/07/15/calling-functions-in-exe-from-plugins-in-windows/
#
   if( LINK_PHASE AND MSVC)
      target_link_libraries( "${_MULLE_OBJC_LIST_LINK_TARGET}"
         "-export:__mulle_objc_loadinfo_callback"
         "-export:__mulle_objc_list_callback"
      )
   endif()

# not sure why this is suddenly needed "Executable" used to do this ?
#
   if( LINK_PHASE AND APPLE)
      set_target_properties("${_MULLE_OBJC_LIST_LINK_TARGET}" PROPERTIES
          INSTALL_RPATH "@loader_path/../lib/;@loader_path/../Frameworks/"
          BUILD_RPATH "@loader_path/../lib/;@loader_path/../Frameworks/"
      )
   endif()

   install( FILES ${SCRIPTS}
PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ
            GROUP_EXECUTE GROUP_READ
            WORLD_EXECUTE WORLD_READ
DESTINATION "bin")

endif()

include( FinalOutput OPTIONAL)
