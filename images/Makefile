# Generate screenshot images for documentation.
# Requires: iTerm2, capture.sh, nup, mdee
#
# Note: On Retina displays, captured images will be at 2x resolution.
#
# The grid image uses 51 rows: with -R2 the page height is
# int((51 - 1) / 2) = 25, so two rows fill the 50 lines above the
# pager prompt.
#
# MANPAGER is unset because macOS man always pipes its output through
# $MANPAGER, and MANPAGER=nup would run nup inside nup.

MAN = env -u MANPAGER

IMAGES = nup.png nup-parallel.png nup-grid.png nup-green-board.png mdee.png

.PHONY: all clean

all: $(IMAGES)

nup.png:
	./capture.sh -o $(CURDIR)/$@ -- '$(MAN) nup man nup'

nup-parallel.png:
	./capture.sh -o $(CURDIR)/$@ -- 'cd $(CURDIR)/.. && nup script/nup lib/App/optex/up.pm'

nup-grid.png:
	./capture.sh -r 51 -d 4 -o $(CURDIR)/$@ -- '$(MAN) nup -C2,2 man perl'

nup-green-board.png:
	./capture.sh -o $(CURDIR)/$@ -- 'cd $(CURDIR)/.. && nup --green-board README.md'

mdee.png:
	./capture.sh -d 3 -o $(CURDIR)/$@ -- 'cd $(CURDIR)/.. && mdee README.md'

clean:
	rm -f $(IMAGES)

# a2ps images (not in "all"): man nup printed 2-up on A4, rendered
# at 150dpi.  The GNU a2ps footer date is garbled under ja_JP.UTF-8,
# which is intended.  a2ps-perl.png was made the same way with the old
# Perl a2ps (1.45.1.1), patched to run on current Perl.
A2PS_DPI = 150

a2ps-gnu.png:
	env -u MANPAGER MANPAGER=cat man nup > $(CURDIR)/man-nup.txt
	cd $(CURDIR) && /opt/homebrew/bin/a2ps -o a2ps-gnu.ps man-nup.txt
	cd $(CURDIR) && ps2pdf -sPAPERSIZE=a4 a2ps-gnu.ps a2ps-gnu.pdf
	cd $(CURDIR) && magick -density $(A2PS_DPI) "a2ps-gnu.pdf[0]" -background white -flatten $@
	cd $(CURDIR) && rm -f man-nup.txt a2ps-gnu.ps a2ps-gnu.pdf
