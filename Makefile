#* *************************************************************************** *#
#* *                            GENERAL INFO                                 * *#
#* *************************************************************************** *#

NAME				:=		hello-world

#* *************************************************************************** *#
#* *                          COMPILATION_UTILS                              * *#
#* *************************************************************************** *#

CC					:=		gcc
CC_FLAGS			=
LIBRARY_FLAGS		=

#* *************************************************************************** *#
#* *                                 FILES                                   * *#
#* *************************************************************************** *#

#* SOURCES *#

SOURCES_PATH		:=		./srcs
SOURCES_EXTENSION	:=		.c

SOURCES_NAMES		:=		main \

SORTED_SOURCES_NAMES:=		$(sort $(SOURCES_NAMES))
SOURCES				:=		$(addsuffix $(SOURCES_EXTENSION), $(SORTED_SOURCES_NAMES))

#* HEADERS *#

HEADERS_PATH		:=		./includes
INCLUDE_FLAGS		:=		$(addprefix -I , $(HEADERS_PATH))

#* OBJECTS *#

OBJECTS_PATH		:=		./objs
OBJECTS				:=		$(addprefix $(OBJECTS_PATH)/, $(SOURCES:$(SOURCES_EXTENSION)=.o))

#* DEPENDENCIES *#

DEPENDENCIES		:=		$(OBJECTS:.o=.d)

#* *************************************************************************** *#
#* *                             RULE FILTERS                                * *#
#* *************************************************************************** *#

ifeq (noflag, $(filter noflag,$(MAKECMDGOALS)))
	CC_FLAGS		+=		-Wall -Wextra
else
	CC_FLAGS		+=		-Wall -Wextra -Werror
endif

ifeq (debug, $(filter debug,$(MAKECMDGOALS)))
	CC_FLAGS		+=		-g3
endif

ifeq (sanadd, $(filter sanadd,$(MAKECMDGOALS)))
	CC_FLAGS		+=		-fsanitize=address -g3
endif

ifeq (santhread, $(filter santhread,$(MAKECMDGOALS)))
	CC_FLAGS		+=		-fsanitize=thread -g3
endif

ifeq (optimize, $(filter optimize,$(MAKECMDGOALS)))
	CC_FLAGS		+=		-O3
endif	

#* *************************************************************************** *#
#* *                              CONSTANTS                                  * *#
#* *************************************************************************** *#

# Text formatting
BOLD				:=		\033[1m
ITALIC				:=		\033[3m
UNDERLINE			:=		\033[4m
STRIKETHROUGH		:=		\033[9m

# Color codes
RED					:=		\033[0;31m
GREEN				:=		\033[0;32m
YELLOW				:=		\033[0;33m
BLUE				:=		\033[0;34m
PURPLE				:=		\033[0;35m
CYAN				:=		\033[0;36m
WHITE				:=		\033[0;37m
RESET				:=		\033[0m

#* *************************************************************************** *#
#* *                               MESSAGES                                  * *#
#* *************************************************************************** *#

define success_message
	echo "✨ $(BOLD)$(GREEN)COMPILATION SUCCESSFUL$(RESET) ✨"
endef

define linking_message
	echo "🔧 $(YELLOW)Linking $(BOLD)$(CYAN)$@ $(RESET)$(YELLOW)...$(RESET) 🔧"
endef

define deletion_of_objects_message
	echo "❌ $(RED)Deleting $(BOLD)$(OBJECTS_PATH)$(RESET)"
endef

define deletion_of_executable
	echo "❌ $(RED)Deleting $(BOLD)$(NAME)$(RESET) $(RED)executable$(RESET)"
endef

LAST_DIRECTORY :=

define compile_message
	@if [ "$(dir $<)" != "$(LAST_DIRECTORY)" ]; then \
		echo "$(CYAN)$(ITALIC)Compiling files in directory $(BOLD)$(dir $<)$(RESET)"; \
		LAST_DIRECTORY="$(dir $<)"; \
	fi
	@echo "    $(YELLOW)•$(RESET) $(CYAN)$(notdir $<)$(RESET)";
	$(eval LAST_DIRECTORY := $(dir $<))
endef

#* *************************************************************************** *#
#* *                                 RULES                                   * *#
#* *************************************************************************** *#

#* Main *#

all:	$(NAME)

#* Compilation *#

-include $(DEPENDENCIES)
$(NAME):	$(OBJECTS)
	@echo -n "\n"
	@$(call linking_message)
	@$(CC) $(CC_FLAGS) $(INCLUDE_FLAGS) -o $@ $(OBJECTS) $(LIBRARY_FLAGS)
	@$(call success_message)

$(OBJECTS_PATH)/%.o: $(SOURCES_PATH)/%$(SOURCES_EXTENSION)
	@mkdir -p $(dir $@)
	@$(call compile_message)
	@$(CC) $(CC_FLAGS) -MMD -MF $(@:.o=.d) $(INCLUDE_FLAGS) -c $< -o $@

#* Clean up *#

clean:
	@if [ -d $(OBJECTS_PATH) ]; then \
		$(call deletion_of_objects_message); \
		rm -rf $(OBJECTS_PATH); \
	fi

fclean:	clean
	@if [ -f $(NAME) ]; then \
		$(call deletion_of_executable); \
		rm -f $(NAME); \
	fi

#* Rebuild *#

re:	fclean all

#* Options *#

noflag: 				all

debug:					all

sanadd:					all

santhread:				all

optimize:				all

#* Conflicts protection *#

.PHONY: clean fclean re noflag debug sanadd santhread optimize
