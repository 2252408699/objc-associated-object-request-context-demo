CC := clang
CFLAGS := -fobjc-arc -Wall -Wextra -Werror
FRAMEWORKS := -framework Foundation
TARGET := build/associated_context_demo
SOURCE := Sources/main.m

.PHONY: all run clean
all: $(TARGET)
$(TARGET): $(SOURCE)
	mkdir -p build
	$(CC) $(CFLAGS) $(SOURCE) $(FRAMEWORKS) -o $(TARGET)
run: $(TARGET)
	./$(TARGET)
clean:
	rm -rf build
