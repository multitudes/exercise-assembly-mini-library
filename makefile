NAME = libasm/libasm.a

SRCS = $(addprefix libasm/, ft_strlen.s ft_write.s ft_read.s ft_strcpy.s ft_strdup.s ft_strcmp.s)
SRCS_BONUS = $(addprefix libasm/, ft_putnbr_base.s ft_list_push_front.s ft_list_size.s ft_list_sort.s ft_list_remove_if.s)

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
	rm -f test_strlen bonus

re: fclean all

test: all main.c
	gcc main.c -Llibasm -lasm -o test_strlen
	./test_strlen

.PHONY: all clean fclean re bonus