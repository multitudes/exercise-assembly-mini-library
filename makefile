NAME = libasm/libasm.a

SRCS = $(addprefix libasm/, strlen.s write.s read.s strcpy.s strdup.s strcmp.s)
SRCS_BONUS = $(addprefix libasm/, putnbr_base.s list_push_front.s list_size.s list_sort.s list_remove_if.s)

OBJS = $(SRCS:.s=.o)
OBJS_BONUS = $(SRCS_BONUS:.s=.o)
# CFLAGS = -fPIE
# DEBUG_NASM = -g -F dwarf

all: $(NAME) 

$(NAME): $(OBJS)
	ar rcs $@ $^

%.o: %.s
	nasm $(DEBUG_NASM) -f elf64 $< -o $@

bonus: $(OBJS) $(OBJS_BONUS) main_bonus.c
	ar rcs $(NAME) $(OBJS) $(OBJS_BONUS)
	gcc main_bonus.c -Llibasm -lasm -o bonus
	./bonus

clean:
	rm -f $(OBJS) $(OBJS_BONUS)

fclean: clean
	rm -f $(NAME)
	rm -f test_strlen bonus main

re: fclean all

test: all main.c
	gcc main.c -Llibasm -lasm -o test_strlen
	./test_strlen

.PHONY: all clean fclean re bonus