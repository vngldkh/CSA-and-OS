main_files: a-main.o a-funcs.o 
	gcc -o assemblied_main a-main.o a-funcs.o
main_files.o: main_files.s
	as --gstabs -o a-main.o a-main.s
a-functions.o: functions.s
	as --gstabs -o a-funcs.o a-funcs.s
