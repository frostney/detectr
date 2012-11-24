COFFEE = coffee
UGLIFY = uglifyjs
SOURCE = detectr.coffee
TARGET = detectr.js
TARGET_MIN = detectr.min.js

default_target: all

all:
	make default dist

default:
	$(COFFEE) -bc $(SOURCE) > $(TARGET)

dist:
	$(UGLIFY) $(TARGET) > $(TARGET_MIN)

clean:
	rm $(TARGET) && rm $(TARGET_MIN)