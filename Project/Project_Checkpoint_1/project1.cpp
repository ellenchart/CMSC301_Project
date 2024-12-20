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
    int count = 0;
    std::map<std::string, int> map;
    for (int i = 1; i < argc - 2; i++)
    {
        std::ifstream infile(argv[i]); //  open the input file for reading
        if (!infile)
        { // if file can't be opened, need to let the user know
            std::cerr << "Error: could not open file: " << argv[i] << std::endl;
            exit(1);
        }

        std::string str;
        while (getline(infile, str))
        {                     // Read a line from the file
            str = clean(str); // remove comments, leading and trailing whitespace
            if (str == "")
            { // Ignore empty lines
                continue;
            }
            else if (str[0] == '.')
            {
                // ignore directives
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
                // Detect and count pseudoinstructions
                std::vector<std::string> terms = split(str, WHITESPACE + ",()");
                std::string inst_type = terms[0];

                // Default increment is 1, increase if pseudoinstruction
                int instructionCountIncrement = 1;
                if (inst_type == "bge" || inst_type == "bgt" || inst_type == "sge")
                {
                    instructionCountIncrement = 2; // These pseudoinstructions expand to 2 real instructions
                }

                count += instructionCountIncrement;
                instructions.push_back(str); // Add the cleaned instruction to a list for processing in Phase 3
            }

            // instructions.push_back(str); // TODO This will need to change for labels
            // if bge pushes back more than one instruction
        }

        // for (const auto &elem : map)
        // {
        //     std::cout << elem.first << " " << elem.second << "\n";
        // }
        infile.close();
    }

    /** Phase 2
     * Process all static memory, output to static memory file
     * TODO: All of this
     */

    // for (const auto &elem : map)
    // {
    //     std::cout << elem.first << " " << elem.second << "\n";
    // }

    // std::map<char, int> asciiMap;
    // for (int i = 97; i <= 122; i++)
    // {
    //     asciiMap.insert(std::pair<char, int>(char(i), i));
    // }
    // for (int i = 65; i <= 90; i++)
    // {
    //     asciiMap.insert(std::pair<char, int>(char(i), i));
    // }

    std::map<std::string, int> staticLabelMap;
    std::map<std::string, int> staticAddressMap;
    int addressCount = 0; // addressCount should be counted per assemble, not per file
    for (int i = 1; i < argc - 2; i++)
    {
        std::ifstream infile(argv[i]); //  open the input file for reading
        if (!infile)
        { // if file can't be opened, need to let the user know
            std::cerr << "Error: could not open file: " << argv[i] << std::endl;
            exit(1);
        }

        std::string str;

        int lastWhitespace = 0;

        while (getline(infile, str))
        { // Read a line from the file

            str = clean(str);

            int a = str.find('.');

            // std::cout << "aa" << str << "aa" << "\n";

            if (str == ".data")
            {
                continue;
            }
            else if (str == ".text")
            {
                // std::cout << "enters .text";
                break;
            }
            else if (str == ".align"){
                break;
            }
            else if (str.find(".word") != std::string::npos)
            {
                // if(str == ".text"){
                //     std::cout << "Something is Wrong";
                // }

                std::string tempString = str.substr(0, str.find(' ') - 1);

                // std::cout << "bb" << tempString << "bb" << "\n";

                // std::string runningString = str.substr(str.find(' '), str.size());

                lastWhitespace = str.find(' ') + 1;

                staticLabelMap.insert(std::pair<std::string, int>(tempString, addressCount));

                tempString = str.substr(lastWhitespace, str.find(' ', lastWhitespace) - lastWhitespace);
                lastWhitespace = str.find(' ', lastWhitespace) + 1;

                // while(runningString.find(' ') != std::string::npos)
                // do
                // bool failsafe = false;
                //std::cout << str << "\n";
                if (str.find(' ', lastWhitespace - 1) == std::string::npos)
                {
                  //  std::cout << "Inside";
                    //std::cout << tempString << "\n";
                }
                while (str.find(' ', lastWhitespace - 1) != std::string::npos)
                {
                    //std::cout << "While Loop: ";
                   // std::cout << tempString << "\n";
                    // std::cout <<  str.find(' ', lastWhitespace) << "\n";
                    // std::cout <<  lastWhitespace << "\n";

                    // runningString = runningString.substr(runningString.find(' ') + 1, runningString.size());

                    // std::cout << tempString << "here" << "\n";

                    if (tempString == ".word")
                    {
                        // std::cout << tempString << "\n";
                        // std::cout << "In .word if statement \n";

                        tempString = str.substr(lastWhitespace, str.find(' ', lastWhitespace) - lastWhitespace);
                        lastWhitespace = str.find(' ', lastWhitespace) + 1;

                        if (str.find(' ', lastWhitespace - 1) == std::string::npos)
                        {

                            // std::cout << "__" << tempString << "__" << "\n";

                            if (isdigit(tempString[0]))
                            {
                                // std::cout << "In Here Top 1-1";

                                write_binary(stoi(tempString), static_outfile);
                            }
                            else
                            {
                                // std::cout << "In Here Top1-1";
                                write_binary(map.at(tempString) * 4, static_outfile);
                            }
                            staticAddressMap.insert(std::pair<std::string, int>(tempString, addressCount));
                            addressCount += 4;
                        }
                    }
                    else
                    {
                        // std::cout << "__" << tempString << "__" << "\n";
                        if (isalpha(tempString[0]))
                        {
                            // should numbers be in this map?
                            // std::cout << tempString << "\n";
                            // std::cout << "In first if of else statement \n";

                            // tempString = str.substr(lastWhitespace, str.find(' ', lastWhitespace) - lastWhitespace);
                            // lastWhitespace = str.find(' ', lastWhitespace) + 1;

                            // std::cout << tempString<< " top";

                            // std::cout << "First\n";
                            // std::cout << tempString << "\n";
                            // if (tempString == ".word")
                            // {
                            //     std::cout << "Huh";
                            // }

                            int tempAddress = map.at(tempString);
                            tempAddress *= 4;
                            write_binary(tempAddress, static_outfile);
                            staticAddressMap.insert(std::pair<std::string, int>(tempString, addressCount));
                            addressCount += 4;

                            tempString = str.substr(lastWhitespace, str.find(' ', lastWhitespace) - lastWhitespace);
                            lastWhitespace = str.find(' ', lastWhitespace) + 1;

                            if (str.find(' ', lastWhitespace - 1) == std::string::npos)
                            {

                                // std::cout << "__" << tempString << "__" << "\n";

                                if (isdigit(tempString[0]))
                                {
                                    // std::cout << "In Here Top 1-1";

                                    write_binary(stoi(tempString), static_outfile);
                                }
                                else
                                {
                                    // std::cout << "In Here Top1-1";
                                    write_binary(map.at(tempString) * 4, static_outfile);
                                }
                                staticAddressMap.insert(std::pair<std::string, int>(tempString, addressCount));
                                addressCount += 4;
                            }
                        }
                        else
                        {
                            // std::cout << tempString << "\n";
                            // std::cout << "In else of else statement \n";

                            // std::cout << tempString << "first";

                            // std::cout << tempString << " bottom";

                            if (isdigit(tempString[0]))
                            {
                                // std::cout << "In Here Bottom 1";
                                write_binary(stoi(tempString), static_outfile);
                            }
                            else
                            {
                                // std::cout << "In Here Bottom 1-1";
                                write_binary(map.at(tempString) * 4, static_outfile);
                            }
                            staticAddressMap.insert(std::pair<std::string, int>(tempString, addressCount));
                            addressCount += 4;

                            tempString = str.substr(lastWhitespace, str.find(' ', lastWhitespace) - lastWhitespace);
                            lastWhitespace = str.find(' ', lastWhitespace) + 1;

                            if (str.find(' ', lastWhitespace - 1) == std::string::npos)
                            {

                                // std::cout << "__" << tempString << "__" << "\n";

                                if (isdigit(tempString[0]))
                                {
                                    // std::cout << "In Here Bottom 2-1";
                                    write_binary(stoi(tempString), static_outfile);
                                }
                                else
                                {
                                    // std::cout << "In Here Bottom 2-2";
                                    write_binary(map.at(tempString) * 4, static_outfile);
                                }
                                staticAddressMap.insert(std::pair<std::string, int>(tempString, addressCount));
                                addressCount += 4;
                            }

                            // std::cout << tempString << "second";
                        }
                    }

                    // if((str.find(' ', lastWhitespace) == std::string::npos) && (failsafe = false))
                    // {
                    //     failsafe = true;
                    // }
                    // else{
                    //     failsafe = false;
                    // }
                }
                // while(str.find(' ', lastWhitespace - 1) != std::string::npos);
            }
        }

        // for (const auto &elem : map)
        // {
        //     std::cout << elem.first << " " << elem.second << "\n";
        // }
        infile.close();

    }
    staticLabelMap.insert(std::pair<std::string, int>("_END_OF_STATIC_MEMORY_", addressCount));
    

    //  for (const auto &elem : map)
    //     {
    //         std::cout << elem.first << " " << elem.second << "\n";
    //     }

    /** Phase 3
     * Process all instructions, output to instruction memory file
     * TODO: Almost all of this, it only works for adds
     */

    count = 0;
    // std::cout << "Past Phase 2";
    for (std::string inst : instructions)
    {
        std::vector<std::string> terms = split(inst, WHITESPACE + ",()");
        std::string inst_type = terms[0];
        // std::cout << inst_type << "\n";
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

            int tempImm = std::stoi(terms[3]);

            // // std::cout << terms[3].at(0);

            // if (terms[3].at(0) == '-')
            // {
            //     tempImm = tempImm * -1;
            //     std::cout << tempImm;
            // }

            int result = encode_Itype(8, registers[terms[2]], registers[terms[1]], stoi(terms[3]));
            write_binary(encode_Itype(8, registers[terms[2]], registers[terms[1]], stoi(terms[3])), inst_outfile);
            // std::cout << registers[terms[2]];
            // std::cout << registers[terms[1]];
            // std::cout << stoi(terms[3]);

            // break;
        }
        else if (inst_type == "mult")
        {
            int result = encode_Rtype(0, registers[terms[1]], registers[terms[2]], 0, 0, 24);
            write_binary(encode_Rtype(0, registers[terms[1]], registers[terms[2]], 0, 0, 24), inst_outfile);
        }
        else if (inst_type == "div")
        {
            int result = encode_Rtype(0, registers[terms[1]], registers[terms[2]], 0, 0, 26);
            write_binary(encode_Rtype(0, registers[terms[1]], registers[terms[2]], 0, 0, 26), inst_outfile);
        }
        else if (inst_type == "sll")
        {
            // int tempImm = stoi(terms[3]);

            // if (terms[3].at(0) == '-')
            // {
            //     tempImm = tempImm * -1;
            // }

            int result = encode_Rtype(0, 0, registers[terms[2]], registers[terms[1]], stoi(terms[3]), 0);
            write_binary(encode_Rtype(0, 0, registers[terms[2]], registers[terms[1]], stoi(terms[3]), 0), inst_outfile);
        }
        else if (inst_type == "srl")
        {
            // int tempImm = stoi(terms[3]);

            // if (terms[3].at(0) == '-')
            // {
            //     tempImm = tempImm * -1;
            // }

            int result = encode_Rtype(0, 0, registers[terms[2]], registers[terms[1]], stoi(terms[3]), 2);
            write_binary(encode_Rtype(0, 0, registers[terms[2]], registers[terms[1]], stoi(terms[3]), 2), inst_outfile);
        }
        else if (inst_type == "lw")
        {
            // int tempImm = stoi(terms[2]);

            // if (terms[2].at(0) == '-')
            // {
            //     tempImm = tempImm * -1;
            // }

            // ask which register the offset is in
            int result = encode_Itype(35, registers[terms[3]], registers[terms[1]], stoi(terms[2]));
            write_binary(encode_Itype(35, registers[terms[3]], registers[terms[1]], stoi(terms[2])), inst_outfile);
        }
        else if (inst_type == "sw")
        {
            // int tempImm = stoi(terms[2]);

            // if (terms[2].at(0) == '-')
            // {
            //     tempImm = tempImm * -1;
            // }

            // ask which register the offset is in
            int result = encode_Itype(43, registers[terms[3]], registers[terms[1]], stoi(terms[2]));
            write_binary(encode_Itype(43, registers[terms[3]], registers[terms[1]], stoi(terms[2])), inst_outfile);
        }
        else if (inst_type == "slt")
        {
            int result = encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 42);
            write_binary(encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 42), inst_outfile);
        }
        else if (inst_type == "beq")
        {
            // int tempAddress = 0;
            //  if (map.at(terms[3]) < count)
            //  {
            //      tempAddress = map.at(terms[3]) - count - 1; // subtracting absolute address - where we are now
            //      // std::cout << "here";
            //  }
            //  else
            //  {
            //      tempAddress = map.at(terms[3]) - count - 1;
            //  }
            int tempAddress = map.at(terms[3]) - count - 1;

            // std::cout << tempAddress;

            // int tempAddress = map.at(terms[3]) - count; // subtracting absolute address - where we are now

            int result = encode_Itype(4, registers[terms[1]], registers[terms[2]], tempAddress);
            write_binary(encode_Itype(4, registers[terms[1]], registers[terms[2]], tempAddress), inst_outfile);
        }
        else if (inst_type == "bne")
        {
            // int tempAddress = 0;
            // if (map.at(terms[3]) < count)
            // {
            //     tempAddress = map.at(terms[3]) - count - 1; // subtracting absolute address - where we are now
            //     // std::cout << "here";
            // }
            // else
            // {
            //     tempAddress = map.at(terms[3]) - count - 1;
            // }
            // int tempAddress = map.at(terms[3]) - count; // subtracting absolute address - where we are now
            int tempAddress = map.at(terms[3]) - count - 1;

            int result = encode_Itype(5, registers[terms[1]], registers[terms[2]], tempAddress);
            write_binary(encode_Itype(5, registers[terms[1]], registers[terms[2]], tempAddress), inst_outfile);
        }
        else if (inst_type == "j")
        {
            int result = encode_Jtype(2, map.at(terms[1]));
            write_binary(encode_Jtype(2, map.at(terms[1])), inst_outfile);
        }
        else if (inst_type == "jal")
        {
            int result = encode_Jtype(3, map.at(terms[1]));
            write_binary(encode_Jtype(3, map.at(terms[1])), inst_outfile);
        }
        else if (inst_type == "jr")
        {
            int result = encode_Rtype(0, registers[terms[1]], 0, 0, 0, 8);
            write_binary(encode_Rtype(0, registers[terms[1]], 0, 0, 0, 8), inst_outfile);
        }
        else if (inst_type == "jalr")
        {
            // need an if statement for how many registers in the argument
            if (terms.size() == 3)
            {
                int result = encode_Rtype(0, registers[terms[1]], 0, registers[terms[2]], 0, 9);
                write_binary(encode_Rtype(0, registers[terms[1]], 0, registers[terms[2]], 0, 9), inst_outfile);
            }
            else
            {
                // we choose 31 because it's 11111 in binary
                int result = encode_Rtype(0, registers[terms[1]], 0, 31, 0, 9);
                write_binary(encode_Rtype(0, registers[terms[1]], 0, 31, 0, 9), inst_outfile);
            }
        }
        else if (inst_type == "syscall")
        {
            // this is syscall exit code
            int result = encode_Rtype(0, 0, 0, 26, 0, 12);
            write_binary(encode_Rtype(0, 0, 0, 26, 0, 12), inst_outfile);
        }
        else if (inst_type == "mflo")
        {
            int result = encode_Rtype(0, 0, 0, registers[terms[1]], 0, 18);
            write_binary(encode_Rtype(0, 0, 0, registers[terms[1]], 0, 18), inst_outfile);
        }
        else if (inst_type == "mfhi")
        {
            int result = encode_Rtype(0, 0, 0, registers[terms[1]], 0, 16);
            write_binary(encode_Rtype(0, 0, 0, registers[terms[1]], 0, 16), inst_outfile);
        }
        else if (inst_type == "bge")
        {
            // int tempAddress = 0;
            // if (map.at(terms[3]) < count)
            // {
            //     tempAddress = map.at(terms[3]) - count -1; // subtracting absolute address - where we are now
            //     // std::cout << "here";
            // }
            // else
            // {
            //     tempAddress = map.at(terms[3]) - count - 1;
            // }
            int tempAddress = map.at(terms[3]) - count - 1;

            // Using the register $at (assembler temporary) for storing the result of slt
            int slt_result = encode_Rtype(0, registers[terms[2]], registers[terms[1]], 1, 0, 42); // slt $at, $rt, $rs
            write_binary(slt_result, inst_outfile);

            // Branch if equal (if slt_result is zero)
            int beq_result = encode_Itype(4, 1, 0, tempAddress);
            // beq $at, $zero, target
            write_binary(beq_result, inst_outfile);
            count++;
        }
        else if (inst_type == "bgt")
        {
            // int tempAddress = 0;
            // if (map.at(terms[3]) < count)
            // {
            //     tempAddress = map.at(terms[3]) - count - 1; // subtracting absolute address - where we are now
            //     // std::cout << "here";
            // }
            // else
            // {
            //     tempAddress = map.at(terms[3]) - count - 1;
            // }
            int tempAddress = map.at(terms[3]) - count - 1;

            // Using the register $at (assembler temporary) for storing the result of slt
            int slt_result = encode_Rtype(0, registers[terms[2]], registers[terms[1]], 1, 0, 42); // slt $at, $rt, $rs
            write_binary(slt_result, inst_outfile);

            // If r1 > r2, branch to label
            int bne_result = encode_Itype(5, 1, 0, tempAddress);
            // bne $at, $zero, target
            write_binary(bne_result, inst_outfile);
            count++;
        }
        else if (inst_type == "ble")
        {
            // int tempAddress = 0;
            // if (map.at(terms[3]) < count)
            // {
            //     tempAddress = map.at(terms[3]) - count; // subtracting absolute address - where we are now
            //     // std::cout << "here";
            // }
            // else
            // {
            //     tempAddress = map.at(terms[3]) - count - 1;
            // }
            int tempAddress = map.at(terms[3]) - count - 1;

            // Using the register $at (assembler temporary) for storing the result of slt
            int slt_result = encode_Rtype(0, registers[terms[2]], registers[terms[1]], 1, 0, 42); // slt $at, $rt, $rs
            write_binary(slt_result, inst_outfile);

            // Branch if equal (if slt_result is zero)
            int beq_result = encode_Itype(4, 1, 0, tempAddress);
            // beq $at, $zero, target
            write_binary(beq_result, inst_outfile);
            count++;
        }
        else if (inst_type == "blt")
        {
            // int tempAddress = 0;
            // if (map.at(terms[3]) < count)
            // {
            //     tempAddress = map.at(terms[3]) - count; // subtracting absolute address - where we are now
            //     // std::cout << "here";
            // }
            // else
            // {
            //     tempAddress = map.at(terms[3]) - count - 1;
            // }
            int tempAddress = map.at(terms[3]) - count - 1;

            // Using the register $at (assembler temporary) for storing the result of slt
            int slt_result = encode_Rtype(0, registers[terms[2]], registers[terms[1]], 1, 0, 42); // slt $at, $rt, $rs
            write_binary(slt_result, inst_outfile);

            // If r1 > r2, branch to label
            int bne_result = encode_Itype(5, 1, 0, tempAddress);
            // bne $at, $zero, target
            write_binary(bne_result, inst_outfile);
            count++;
        }
        else if (inst_type == "la")
        {

            // implement la as an addi $r, address, 0
            // la $s0, address = addi $s0, address, 0

            int address = staticLabelMap.at(terms[2]);

            int result = encode_Itype(8, 0, registers[terms[1]], address);
            write_binary(encode_Itype(8, 0, registers[terms[1]], address), inst_outfile);

            // std::cout << registers[terms[2]];
        }
        else if (inst_type == "sge")
        {
            // slt $1, $9, $8  (check if rt < rs)
            int slt_result = encode_Rtype(0, registers[terms[3]], registers[terms[2]], registers[terms[1]], 0, 42); // slt $1, $9, $8
            write_binary(slt_result, inst_outfile);

            // $1, $1, 1 (invert the result of slt)
            int addi_result = encode_Itype(0, registers[terms[1]], registers[terms[1]], 1); // $1, $1, 1
            write_binary(addi_result, inst_outfile);
            count++;
        }
        else if (inst_type == "sle")
        {
            // slt $1, $9, $8  (check if rt < rs)
            int slt_result = encode_Rtype(0, registers[terms[3]], registers[terms[2]], registers[terms[1]], 0, 42); // slt $1, $9, $8
            write_binary(slt_result, inst_outfile);

            // $1, $1, 1 (invert the result of slt)
            int addi_result = encode_Itype(0, registers[terms[1]], registers[terms[1]], 1); // $1, $1, 1
            write_binary(addi_result, inst_outfile);
            count++;
        }
        else if (inst_type == "andi")
        {
            int tempImm = std::stoi(terms[3]);
            int result = encode_Itype(12, registers[terms[2]], registers[terms[1]], tempImm);
            write_binary(result, inst_outfile);
        }
        else if (inst_type == "or")
        {
            int result = encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 37);
            write_binary(encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 37), inst_outfile);
        }
        else if (inst_type == "nor")
        {
            int result = encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 39);
            write_binary(encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 39), inst_outfile);
        }
        else if (inst_type == "xor")
        {
            int result = encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 38);
            write_binary(encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 38), inst_outfile);
        }
        else if (inst_type == "and")
        {
            int result = encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 36);
            write_binary(encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 36), inst_outfile);
        }
        else if (inst_type == "ori")
        {
            int tempImm = std::stoi(terms[3]);
            int result = encode_Itype(13, registers[terms[2]], registers[terms[1]], tempImm);
            write_binary(result, inst_outfile);
        }
        else if (inst_type == "mv")
        {
            // the destination is 0
            int mv_result = encode_Rtype(0, registers[terms[2]], 0, registers[terms[1]], 0, 32);
            write_binary(mv_result, inst_outfile);
        }
        else if (inst_type == "ld")
        {
            // offset + base register
            int tempImm = std::stoi(terms[3]);
            int base_register = registers[terms[2]];
            int dest_register = registers[terms[1]];

            int ld_result = encode_Itype(55, base_register, dest_register, tempImm);
            write_binary(ld_result, inst_outfile);
        }

        // std::cout << registers[terms[2]];
        // std::cout << registers[terms[1]];
        // std::cout << stoi(terms[3]);
        count = count + 1;
    }
}
#endif
