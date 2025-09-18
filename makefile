NAME = libasm/libasm.a

SRCS = $(addprefix libasm/, ft_strlen.s ft_write.s ft_read.s ft_strcpy.s ft_strdup.s ft_strcmp.s)
OBJS = $(SRCS:.s=.o)

all: $(NAME)

$(NAME): $(OBJS)
	ar rcs $@ $^

%.o: %.s
	nasm $< -o $@

clean:
	rm -f $(OBJS)

fclean: clean
	rm -f $(NAME)

re: fclean all

.PHONY: all clean fclean re