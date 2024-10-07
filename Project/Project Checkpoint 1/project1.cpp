#ifndef __PROJECT1_CPP__
#define __PROJECT1_CPP__

#include "project1.h"
#include <vector>
#include <string>
#include <unordered_map>
#include <iostream>
#include <sstream>
#include <fstream>
#include <map>

int main(int argc, char *argv[])
{
    if (argc < 4) // Checks that at least 3 arguments are given in command line
    {
        std::cerr << "Expected Usage:\n ./assemble infile1.asm infile2.asm ... infilek.asm staticmem_outfile.bin instructions_outfile.bin\n"
                  << std::endl;
        exit(1);
    }
    // Prepare output files
    std::ofstream inst_outfile, static_outfile;
    static_outfile.open(argv[argc - 2], std::ios::binary);
    inst_outfile.open(argv[argc - 1], std::ios::binary);
    std::vector<std::string> instructions;

    /**
     * Phase 1:
     * Read all instructions, clean them of comments and whitespace DONE
     * TODO: Determine the numbers for all static memory labels NEED TO DO
     * (measured in bytes starting at 0)
     * TODO: Determine the line numbers of all instruction line labels
     * (measured in instructions) starting at 0
     */

    // For each input file:
    for (int i = 1; i < argc - 2; i++)
    {
        std::ifstream infile(argv[i]); //  open the input file for reading
        if (!infile)
        { // if file can't be opened, need to let the user know
            std::cerr << "Error: could not open file: " << argv[i] << std::endl;
            exit(1);
        }

        std::string str;
        int count = 0;
        std::map<std::string, int> map;
        while (getline(infile, str))
        {                     // Read a line from the file
            str = clean(str); // remove comments, leading and trailing whitespace
            if (str == "")
            { // Ignore empty lines
                continue;
            }
            else if (str.find(':') != std::string::npos) // if it can't find ':' then output npos (no position)
            {
                std::string stringTemp = str.substr(0, str.find(':'));
                map.insert(std::pair<std::string, int>(stringTemp, count));
                continue;
            }
            else
            {
                count = count + 1;
            }

            instructions.push_back(str); // TODO This will need to change for labels
        }
        infile.close();
    }

    /** Phase 2
     * Process all static memory, output to static memory file
     * TODO: All of this
     */

    /** Phase 3
     * Process all instructions, output to instruction memory file
     * TODO: Almost all of this, it only works for adds
     */

    int count = 0;
    for (std::string inst : instructions)
    {
        std::vector<std::string> terms = split(inst, WHITESPACE + ",()");
        std::string inst_type = terms[0];
        if (inst_type == "add")
        {
            int result = encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 32);
            write_binary(encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 32), inst_outfile);
        }
        else if (inst_type == "sub")
        {
            int result = encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 34);
            write_binary(encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 34), inst_outfile);
        }
        else if (inst_type == "addi")
        {
            int result = encode_Itype(8, registers[terms[1]], registers[terms[2]], stoi(terms[3]));
            write_binary(encode_Itype(8, registers[terms[1]], registers[terms[2]], stoi(terms[3])), inst_outfile);
        }
        else if (inst_type == "mult")
        {
            int result = encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 34);
            write_binary(encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 34), inst_outfile);
        }
        else if (inst_type == "div")
        {
            int result = encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 34);
            write_binary(encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 34), inst_outfile);
        }
        else if (inst_type == "sll")
        {
            int result = encode_Itype(8, registers[terms[1]], registers[terms[2]], stoi(terms[3]));
            write_binary(encode_Itype(8, registers[terms[1]], registers[terms[2]], stoi(terms[3])), inst_outfile);
        }
        else if (inst_type == "srl")
        {
            int result = encode_Itype(8, registers[terms[1]], registers[terms[2]], registers[terms[3]]);
            write_binary(encode_Itype(8, registers[terms[1]], registers[terms[2]], stoi(terms[3])), inst_outfile);
        }
        else if (inst_type == "lw")
        {
            // unsure of how if where these terms are is correct
            int result = encode_Itype(35, registers[terms[3]], registers[terms[1]], stoi(terms[2]));
            write_binary(encode_Itype(35, registers[terms[3]], registers[terms[1]], stoi(terms[2])), inst_outfile);
        }
        else if (inst_type == "sw")
        {
            // unsure of how if where these terms are is correct
            int result = encode_Itype(43, registers[terms[3]], registers[terms[1]], stoi(terms[2]));
            write_binary(encode_Itype(43, registers[terms[3]], registers[terms[1]], stoi(terms[2])), inst_outfile);
        }
        else if (inst_type == "slt")
        {

            int result = encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 32);
            write_binary(encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 32), inst_outfile);
        }
        else if (inst_type == "slt")
        {

            int result = encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 32);
            write_binary(encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 32), inst_outfile);
        }
        else if (inst_type == "beq")
        {
            // issue with offset
            // are terms in correct order?
            int result = encode_Itype(4, registers[terms[1]], registers[terms[2]], stoi(terms[3]));                // get offset instead of just terms[3]
            write_binary(encode_Itype(4, registers[terms[1]], registers[terms[2]], stoi(terms[3])), inst_outfile); // get offset instead of just terms[3]
        }
        else if (inst_type == "bne")
        {
            // issue with offset
            int result = encode_Itype(5, stoi(terms[1]), stoi(terms[2]), stoi(terms[3]));                // get offset instead of just terms[3]
            write_binary(encode_Itype(5, stoi(terms[1]), stoi(terms[2]), stoi(terms[3])), inst_outfile); // get offset instead of just terms[3]
        }
        else if (inst_type == "j")
        {
            // Same as 'jal'
            int result = encode_Jtype(2, stoi(terms[1]));
            write_binary(encode_Jtype(2, stoi(terms[1])), inst_outfile);
        }
        else if (inst_type == "jal")
        {
            // Is terms[1] just the name of the label, or does it hold what we want here?
            int result = encode_Jtype(3, stoi(terms[1]));
            write_binary(encode_Jtype(3, stoi(terms[1])), inst_outfile);
        }
        else if (inst_type == "jr")
        {
            // 6, 5, 15, 6 form
            // we do not have an encode function for something like that yet
        }
        else if (inst_type == "jalr")
        {
            int result = encode_Rtype(0, registers[terms[1]], 0, registers[terms[2]], 0, 9);
            write_binary(encode_Rtype(0, registers[terms[1]], 0, registers[terms[2]], 0, 9), inst_outfile);
        }
        else if (inst_type == "syscall")
        {
            int result = encode_Rtype(0, 0, 0, 0, 0, 12);
            write_binary(encode_Rtype(0, 0, 0, 0, 0, 12), inst_outfile);
        }
    }
}
#endif
