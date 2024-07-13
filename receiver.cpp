#include <stdlib.h>
#include <iostream>
#include <cstdlib>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vreceiver.h"

#define MAX_SIM_TIME 300
int sim_time = 0;
int posedge_cnt = 0;

int main(int argc, char** argv, char** env) {
    srand (time(NULL));
    Verilated::commandArgs(argc, argv);
    Vreceiver *circuit = new Vreceiver;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    circuit->trace(m_trace, 5);
    m_trace->open("receiver-trace.vcd");

    std::vector<int> data = {1, 0, 0, 0, 0, 1, 1, 0, 1, 0};
    int count = 0;

    while (sim_time < MAX_SIM_TIME) {
        circuit->i_rx = 1;
        if ((sim_time >= MAX_SIM_TIME/8 ) && (data.size() != 0)) {
            circuit->i_rx = data.back();
            count++;
            if (count == 2) {
                data.pop_back();
                count = 0;
            }
        };

        circuit->i_clk ^= 1;
        circuit->eval();
        m_trace->dump(sim_time);
        sim_time++;
    }

    m_trace->close();
    delete circuit;
    exit(EXIT_SUCCESS);
}
