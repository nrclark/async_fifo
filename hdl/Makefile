myhdl.vpi: icarus_vpi/myhdl.c icarus_vpi/myhdl_table.c
	iverilog-vpi $^

test_counter: myhdl.vpi sync_counter.v counter_tb.v test_counter.py
	python test_counter.py

clean:
	find . -type f -regex "^.*[.]py[oc]$$" | xargs rm -f
	find . -type f -regex "^.*[.]o$$" | xargs rm -f  
	rm -f myhdl.vpi
