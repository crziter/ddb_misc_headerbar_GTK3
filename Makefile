
# Headerbar UI plugin for the DeaDBeeF audio player
#
# Copyright (C) 2015 Nicolai Syvertsen <saivert@gmail.com>
#
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.


OUT_GTK3?=ddb_misc_headerbar_GTK3.so

GTK3_CFLAGS?=`pkg-config --cflags gtk+-3.0`

GTK3_LIBS?=`pkg-config --libs gtk+-3.0`

CC?=gcc
CFLAGS+=-Wall -O2 -fPIC -std=c99 -D_GNU_SOURCE
LDFLAGS+=-shared

GTK3_DIR?=gtk3

SOURCES?=$(wildcard *.c)
OBJ_GTK3?=$(patsubst %.c, $(GTK3_DIR)/%.o, $(SOURCES))

define compile
	echo $(CC) $(CFLAGS) $1 $2 $< -c -o $@
	$(CC) $(CFLAGS) $1 $2 $< -c -o $@
endef

define link
	echo $(CC) $(LDFLAGS) $1 $2 $3 -o $@
	$(CC) $(LDFLAGS) $1 $2 $3 -o $@
endef

# Builds GTK+3 versions of the plugin.
all: gtk3

# Builds GTK+3 version of the plugin.
gtk3: mkdir_gtk3 $(SOURCES) $(GTK3_DIR)/$(OUT_GTK3)

mkdir_gtk3:
	@echo "Creating build directory for GTK+3 version"
	@mkdir -p $(GTK3_DIR)

$(GTK3_DIR)/$(OUT_GTK3): $(OBJ_GTK3)
	@echo "Linking GTK+3 version"
	@$(call link, $(OBJ_GTK3), $(GTK3_LIBS), $(SQLITE_LIBS))
	@echo "Done!"

$(GTK3_DIR)/%.o: %.c
	@echo "Compiling $(subst $(GTK3_DIR)/,,$@)"
	@$(call compile, $(GTK3_CFLAGS))

clean:
	@echo "Cleaning files from previous build..."
	@rm -r -f $(GTK2_DIR) $(GTK3_DIR)
