#
# You can put more source and resource file definitions here.
#
set( SOURCES
   src/main.c
)

#
# The following tools used to be built by mulle-objc-runtime, then lived in
# a short-lived mulle-objc-tools project. They are needed by the scripts in
# this project (which look for a sibling executable), so they are built here.
#
set( UNIQUEID_SOURCES
   src/mulle-objc-uniqueid/main.c
)

set( SIGNATURE_SOURCES
   src/mulle-objc-signature/main.c
)

set( SCRIPTS
   mulle-objc-deps-tool
   mulle-objc-encode
   mulle-objc-lista
   mulle-objc-leaks
   mulle-objc-optimize
   mulle-objc-printline
   mulle-objc-searchid
   mulle-objc-unarchive
   mulle-objc-uncovered-methods
)

#
# The scripts in bin/ (mulle-objc-reverse-uniqueid, print-methodid-defines)
# are helper scripts that we keep, but do not install.
#

if( MSVC)
   set( SCRIPTS
      ${SCRIPTS}
      mulle-objc-deps-tool-mingw.bat
      mulle-objc-deps-tool.bat
      mulle-objc-list-mingw.bat
      mulle-objc-list.bat
   )
endif()
