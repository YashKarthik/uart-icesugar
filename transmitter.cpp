#include <stdlib.h>
#include <iostream>
#include <cstdlib>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vtransmitter.h"

#define MAX_SIM_TIME 300
int sim_time = 0;
int posedge_cnt = 0;

int main(int argc, char** argv, char** env) {
    srand (time(NULL));
    Verilated::commandArgs(argc, argv);
    Vtransmitter *circuit = new Vtransmitter;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    circuit->trace(m_trace, 5);
    m_trace->open("transmitter-trace.vcd");

    while (sim_time < MAX_SIM_TIME) {
        if (sim_time >= MAX_SIM_TIME/8 && sim_time < MAX_SIM_TIME/7) {
            circuit->i_tx_start = 1;
            circuit->i_data = 13;
        } else {
            circuit->i_tx_start = 0;
            circuit->i_data = 0;
        }

        circuit->i_clk ^= 1;
        circuit->eval();
        m_trace->dump(sim_time);
        sim_time++;
    }

    m_trace->close();
    delete circuit;
    exit(EXIT_SUCCESS);
}
