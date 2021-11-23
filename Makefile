all: mush

clean:
	rm -rf mush main.c *.o *vert*.h *frag*.h

mush: mush.o rubbish.a
	clang $^ \
	-lpthread -lm -ldl -lX11 \
	-L. -l:cimgui.so \
	-rpath . \
	-o $@
mush.o: main.c vert.h frag.h
	clang -Werror -O0 -ggdb \
	-I. \
	-c $< -o $@
main.c: main.sl
	sl $< > $@
vert.h: vert_user.glsl
	xxd -i $< > $@
frag.h: frag_user.glsl
	xxd -i $< > $@
