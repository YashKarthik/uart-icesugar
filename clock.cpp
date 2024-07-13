#include <stdlib.h>
#include <iostream>
#include <cstdlib>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vclock.h"

#define MAX_SIM_TIME 20000
int sim_time = 0;
int posedge_cnt = 0;

int main(int argc, char** argv, char** env) {
    srand (time(NULL));
    Verilated::commandArgs(argc, argv);
    Vclock *circuit = new Vclock;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    circuit->trace(m_trace, 5);
    m_trace->open("clock-trace.vcd");

    CData prev = circuit->o_clk;
    int count = 0;

    while (sim_time < MAX_SIM_TIME) {
        circuit->i_clk ^= 1;
        count++;

        circuit->eval();
        m_trace->dump(sim_time);
        sim_time++;

        if (circuit->o_clk != prev) {
            printf("count: %i\n", count);
            count = 0;
        }

        prev = circuit->o_clk;
    }

    m_trace->close();
    delete circuit;
    exit(EXIT_SUCCESS);
}
