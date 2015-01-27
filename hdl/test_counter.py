#!/usr/bin/env python

from __future__ import generators
import os, unittest

from myhdl import Simulation, StopSimulation, Signal
from myhdl import delay, intbv, negedge, posedge, now, Cosimulation

class mySim(object):
    def __init__(self, sources = [], outfile = ""):
        self.sources = [x.strip() for x in sources]
        open(outfile,"w").close()
        self.outfile = outfile
        
    def compile(self, **defines):
        """Compiles a simulation."""
        define_args = ["-D%s=%s" %(x, defines[x]) for x in defines.keys()]
        define_args = ' '.join(define_args)
        source_args = ' '.join(self.sources)
        cmd_string = "iverilog -o %s %s %s" %(self.outfile, define_args, source_args)
        print cmd_string
        os.system(cmd_string)
    
    def cosim(self, **signals):
        return Cosimulation("vvp -m ./myhdl.vpi %s" % self.outfile, **signals) 

class TestCounter(unittest.TestCase):
    def setUp(self):
        self.data_width = 8
        self.sources = ['sync_counter.v', 'counter_tb.v'] 
        self.outfile = 'counter_tb.o'
        
        self.signals = {
            'i_clk'      : Signal(intbv(0)),
            'i_rst'      : Signal(intbv(0)),
            'i_enable'   : Signal(intbv(1)),
            'o_data_out' : Signal(intbv(0)[self.data_width:])
        }
        
        counter_sim = mySim(self.sources, self.outfile)
        counter_sim.compile(DATA_WIDTH=self.data_width)  
        
        self.cosim = counter_sim.cosim(**self.signals)
    
    def tearDown(self):
        del(self.cosim)
        os.remove(self.outfile)
    
    def testBasic(self):
        def clockGen():
            i_clk = self.signals['i_clk']
            while 1:
                yield delay(10)
                i_clk.next = not i_clk
                
        def myBench():
            i_clk = self.signals['i_clk']
            o_data_out = self.signals['o_data_out']
            i_enable = self.signals['i_enable']
            i_rst = self.signals['i_rst']
            
            yield posedge(i_clk)
            i_enable.next = False
            i_rst.next = True
            yield posedge(i_clk)
            i_rst.next = False
            yield posedge(i_clk)
            yield posedge(i_clk)
            
            self.assertEqual(o_data_out, 0)
            i_enable.next = True
            yield posedge(i_clk)
            
            for x in range(2**(self.data_width + 1) + 8):
                self.assertEqual(x & 0xFF, o_data_out)
                yield posedge(i_clk)
            
            i_enable.next = False
            i_rst.next = True
            
            yield posedge(i_clk)
            i_rst.next = False
            yield posedge(i_clk)
            yield posedge(i_clk)
            
            self.assertEqual(o_data_out, 0)
            
            raise StopSimulation
        
        sim = Simulation(self.cosim, clockGen(), myBench())
        sim.run(quiet=1)


if __name__ == '__main__':
    unittest.main()


            
            

    

    
        


                

        

