all: third

third: t3.o
	ld -melf_x86_64 -s t3.o -o t3

t3.o:
	as --64 t3.s -o t3.o

clean:
	rm *.o t[0-9] > /dev/null
