.PHONY: all clean

all: perldoc.png

perldoc.png: Makefile capture.sh
	./capture.sh -o $@ -- 'nup man App::optex::up'

clean:
	rm -f perldoc.png
