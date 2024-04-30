
# Makefile template

Here is my usual Makefile to compile my .c or .cpp programs.
Use it as it pleases you.

# What is a Makefile and what is Make ?

Make is an automation tool usually used for compilation on unix based systems.

With it you can write a text file called "Makefile" that provides a set of rules generally used to build executable programs.

You can install it in linux by using your package manager:
- Ubuntu: ` sudo apt-get install make`

# What about mine ?

To use my Makefile, the least operations you'll have to do are the following:
- Change the NAME variable (that will be your executable's name).
- Add to the SOURCES_NAMES variable the files you want to compile. Take into account that the source folder (SOURCES_PATH) and extensions (SOURCES_EXTENSION) are appended and prepended. Here is an example.

```
SOURCES_NAMES		:=		main \
                            file_1 \
                            folder/file_2 \
```

# Available rules

- make (all): to compile your program.
- make clean: to remove generated object files.
- make fclean: to remove generated object files and executable.
- make re: to remove generated object files, executable and recompile after that, from scratch.

# Available optional rules

These rules are optional and can be combined with the others.
- make noflag: this removes the -Werror compilation flag. It is usually better to keep it.
- make debug: this adds the -g3 compilation flag (useful with GNU Debugger (gdb) for example).
- make sanadd: this adds the fsanitize=address and -g3 compilation flags. Useful to perform run-check memory errors.
- make santhread: this adds the fsanitize=address and -g3 compilation flags. Useful to check for data-races and other thread related problems.
- make optimize: this optimizes the compilation with -O3 option.
