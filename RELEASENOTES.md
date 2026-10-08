## 0.25.0



* complete transition from mulle-objc-list repo to mulle-objc-tools


feature: add mulle-objc-uniqueid and mulle-objc-signature helper tools

* new `mulle-objc-uniqueid` prints the `@selector()` (uniqueid) value for strings, with CSV and `#define` output modes
* new `mulle-objc-signature` parses runtime signature strings and emits them as CSV
* both tools are built and installed alongside `mulle-objc-list` and can be located as sibling executables by the bundled scripts
* add uninstalled development scripts `bin/mulle-objc-reverse-uniqueid` and `bin/print-methodid-defines`


### 0.24.1



* shared-library linking on macOS now passes the SDK sysroot from mulle-platform, fixing "library 'System' not found" errors on modern SDKs where libSystem lives inside the SDK
* fresh license headers added to public headers; README gains an API summary doc link

## 0.24.0

Various small improvements
