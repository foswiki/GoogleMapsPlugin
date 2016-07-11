FOSWIKI_ROOT?=~/foswiki/core
TARGET=pkg.js
PKG_SOURCE=gmap3.uncompressed.js gmap3.init.uncompressed.js

-include $(FOSWIKI_ROOT)/pub/System/JQueryPlugin/Makefile.include

.PHONY: git

git:
	git clone https://github.com/jbdemonte/gmap3.git git

pkg.uncompressed.js: $(PKG_SOURCE)
	cat $(PKG_SOURCE) > $@

ifneq (,$(wildcard git))
gmap3.uncompressed.js: git/dist/gmap3.js
	@echo copying $< to $@ 
	@cp $< $@
endif
