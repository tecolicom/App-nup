.PHONY: all clean

all: perldoc.png

perldoc.png: Makefile capture.sh
	./capture.sh -o $@ -- 'perldoc App::optex::up | ansicolumn -DP -C2 --bs heavy-box | less -R'

clean:
	rm -f perldoc.png
