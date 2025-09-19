NAME = libasm/libasm.a

SRCS = $(addprefix libasm/, ft_strlen.s ft_write.s ft_read.s ft_strcpy.s ft_strdup.s ft_strcmp.s)
SRCS += $(addprefix libasm/, ft_putnbr_base.s) # bonus
OBJS = $(SRCS:.s=.o)
# CFLAGS = -fPIE
# DEBUG_NASM = -g -F dwarf

all: $(NAME)

$(NAME): $(OBJS)
	ar rcs $@ $^

%.o: %.s
	nasm $(DEBUG_NASM) -f elf64 $< -o $@

bonus: all

clean:
	rm -f $(OBJS)

fclean: clean
	rm -f $(NAME)

re: fclean all

test: all
	gcc main.c -Llibasm -lasm -o test_strlen
	./test_strlen

.PHONY: all clean fclean re