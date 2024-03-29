compiler=x86_64-w64-mingw32-gcc
#compiler=gcc

clean:
	rm *.o
	rm -r Chemistry/constants/get_uma/*.o
	rm -r Chemistry/constants/get_oxistates/*.o
	rm -r Chemistry/constants/get_atomicnum/*.o
	rm -r Chemistry/constants/get_elem_symbol/*.o
	rm -r Chemistry/types/elem/*.o
	rm -r Chemistry/types/substance/*.o
	rm -r Chemistry/types/reaction/*.o
	rm -r Math/commons/commons.o Math/matrix/matrix.o Math/row/row.o
	rm GUI/*.o

#Math-----------------------------------------------------------------------------------------------------------
Math/%.o: Math/%.c Math/%.h
	$(compiler) -c $(@:.o=.c) -o $@

Math_objf:=Math/commons/commons.o Math/matrix/matrix.o Math/row/row.o

#Math-----------------------------------------------------------------------------------------------------------


#Chemistry------------------------------------------------------------------------------------------------------

#constants--------------------------------------------------

Chemistry/constants/%.o: Chemistry/constants/%.c Chemistry/constants/%.h Chemistry/constants/%.py
#	python $(@:.o=.py)
	$(compiler) -c $(@:.o=.c) -o $@

constants_objf:=$(Math_objf) Chemistry/constants/get_elem_symbol/get_elem_symbol.o Chemistry/constants/get_atomicnum/get_atomicnum.o Chemistry/constants/get_oxistates/get_oxistates.o Chemistry/constants/get_uma/get_uma.o

#constants--------------------------------------------------

#types------------------------------------------------------
Chemistry/types/elem/elem.o: Chemistry/types/elem/elem.h Chemistry/types/elem/elem.c $(constants_objf)
	$(compiler) -c Chemistry/types/elem/elem.c -o $@

Chemistry/types/substance/substance.o: Chemistry/types/substance/substance.c Chemistry/types/substance/substance.h Chemistry/types/elem/elem.o
	$(compiler) -c Chemistry/types/substance/substance.c -o $@

Chemistry/types/reaction/%.o: Chemistry/types/reaction/%.c Chemistry/types/reaction/reaction.h Chemistry/types/substance/substance.o
	$(compiler) -c $(@:.o=.c) -o $@

Chemistry_types_objf:=Chemistry/types/reaction/reaction.o Chemistry/types/reaction/balancer.o Chemistry/types/substance/substance.o Chemistry/types/elem/elem.o

#types------------------------------------------------------

#Chemistry------------------------------------------------------------------------------------------------------


#GUI--------------------------------------------------------
GUI/%.o: GUI/%.c GUI/GUI.h
	$(compiler) -c $(@:.o=.c) -o $@
#GUI--------------------------------------------------------


#Tests---------------------------------------------------------------------------------------------------------

test_elem: test_elem.c Chemistry/types/elem/elem.o $(constants_objf)
	$(compiler) $? -o $@

test_substance: test_substance.c Chemistry/types/substance/substance.o Chemistry/types/elem/elem.o $(constants_objf)
	$(compiler) $? -o $@

test_reaction: test_reaction.c $(Chemistry_types_objf) $(constants_objf)
	$(compiler) $? -o $@

test_matrix: test_matrix.c $(Math_objf)
	$(compiler) $? -o $@

#Tests---------------------------------------------------------------------------------------------------------


#Final product:

main.o: main.c
	$(compiler) -c $? -o $@

wmain.exe: main.o $(Chemistry_types_objf) $(constants_objf) GUI/WIN.o GUI/input.o GUI/output.o
	$(compiler) -mwindows -pthread --static $? -o $@
