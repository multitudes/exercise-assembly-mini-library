NAME = libasm/libasm.a

SRCS = $(addprefix libasm/, strlen.s write.s read.s strcpy.s strdup.s strcmp.s)
SRCS += $(addprefix libasm/, putnbr_base.s list_push_front.s list_size.s list_sort.s list_remove_if.s)

OBJS = $(SRCS:.s=.o)

all: $(NAME) 

$(NAME): $(OBJS)
	ar rcs $@ $^

%.o: %.s
	nasm $(DEBUG_NASM) -f elf64 $< -o $@

clean:
	rm -f $(OBJS) 

fclean: clean
	rm -f $(NAME)
	rm -f test

re: fclean all

test: all main.c
	gcc main.c -Llibasm -lasm -o test
	./test

.PHONY: all clean fclean re bonus