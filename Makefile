CC := clang
CFLAGS := -Wall -g -Wno-everything -pthread -lm

SRCS := main.c model.c avl_ville.c  avl_trajet.c util.c
HEADERS := model.h avl_ville.h avl_trajet.h util.h 
OBJS := $(SRCS:.c=.o)
EXEC := main

all: $(EXEC)

$(EXEC): $(OBJS)
#    $(CC) $(CFLAGS) $(OBJS) -o $(EXEC)
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@


all: main

# main: $(OBJS) $(HEADERS)
# 	$(CC) $(CFLAGS) -O3 $(SRCS) -o "$@"

main-debug: $(SRCS) $(HEADERS)
	$(CC) $(CFLAGS) -O0 $(SRCS) -o "$@"

clean:
	rm -f main main-debug






#CC = gcc
#CFLAGS = -Wall 

#SRCS = main.c traitement_t.c traitement_s.c
#OBJS = $(SRCS:.c=.o)
##

#all: $(EXEC)

#$(EXEC): $(OBJS)
 #   $(CC) $(CFLAGS) $(OBJS) -o $(EXEC)
#%.o: %.c    $(CC) $(CFLAGS) -c $< -o $@
#clean:
 #   rm -f $(OBJS) $(EXEC)






#all: main

#CC = clang
#override CFLAGS += -g -Wno-everything -pthread -lm

#SRCS = $(shell find . -name '.ccls-cache' -type d -prune -o -type f -name '*.c' -print)
#HEADERS = $(shell find . -name '.ccls-cache' -type d -prune -o -type f -name '*.h' -print)

#main: $(SRCS) $(HEADERS)
#	$(CC) $(CFLAGS) $(SRCS) -o "$@"

#main-debug: $(SRCS) $(HEADERS)
#	$(CC) $(CFLAGS) -O0 $(SRCS) -o "$@"

#clean:
#	rm -f main main-debug