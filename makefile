# Detect architecture
ARCH := $(shell uname -m)

# Set architecture-specific variables
ifeq ($(ARCH),arm64)
    ASM_DIR = libasm-ARM64
    ASM = as
    ASM_FLAGS = 
    OBJ_FORMAT = 
    NAME = $(ASM_DIR)/libasm.a
else ifeq ($(ARCH),x86_64)
    ASM_DIR = libasm-x86-64
    ASM = nasm
    ASM_FLAGS = -f elf64
    OBJ_FORMAT = 
    NAME = $(ASM_DIR)/libasm.a
else
    $(error Unsupported architecture: $(ARCH))
endif

# Source files (same names in both directories)
SRCS = $(addprefix $(ASM_DIR)/, strlen.s write.s read.s my_strcpy.s strdup.s strcmp.s)
SRCS += $(addprefix $(ASM_DIR)/, putnbr_base.s list_push_front.s list_size.s list_sort.s list_remove_if.s)

OBJS = $(SRCS:.s=.o)

all: $(NAME) 

$(NAME): $(OBJS)
	ar rcs $@ $^

# Architecture-specific assembly rules
ifeq ($(ARCH),arm64)
%.o: %.s
	$(ASM) $(ASM_FLAGS) $< -o $@
else
%.o: %.s
	$(ASM) $(DEBUG_NASM) $(ASM_FLAGS) $< -o $@
endif

clean:
	rm -f $(OBJS) 

fclean: clean
	rm -f $(NAME)
	rm -f test

re: fclean all

test: all main.c
	gcc main.c -L$(ASM_DIR) -lasm -o test
	./test

.PHONY: all clean fclean re bonus