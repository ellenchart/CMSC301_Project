#ifndef __PROJECT1_CPP__
#define __PROJECT1_CPP__

#include "project1.h"
#include <vector>
#include <string>
#include <unordered_map>
#include <iostream>
#include <sstream>
#include <fstream>
#include <unordered_map>
#include <unordered_set>

/**
 * Parses the data directive to return elements needed to store in static memory.
 * 
 * The elements are of string type to preserve unknown labels.
 * 
 * FIXME escape character not supported in .asciiz string
*/
std::vector<std::string> parse_data_directive(const std::string &directive) {
    std::vector<std::string> tokens = split(directive, WHITESPACE + ",\"");
    if (tokens[0] == ".word") {
        return std::vector(tokens.begin()+1, tokens.end());
    } else if (tokens[0] == ".asciiz") {
        std::vector<std::string> result;
        // turns every character into ASCII code
        for (int c: tokens[1]) result.push_back(std::to_string(c));
        // appending trailing NULL byte
        result.push_back("0");
        return result;
    }
    return {};
}

// see pseudo.txt for how we translates them
const std::unordered_map<std::string, int> pseudo_sizes {
    {"la", 1}, {"mov", 1}, // {"li", 2},
    {"sge", 2}, {"sgt", 1}, {"sle", 2}, {"seq", 3}, {"sne", 3},
    {"bge", 2}, {"bgt", 2}, {"ble", 2}, {"blt", 2},
    {"abs", 4}
};

const std::unordered_set<std::string>
    R {"add", "sub", "and", "or", "nor", "xor", "slt", "mult", "div", "mflo", "mfhi", "sll", "srl", "jr"},
    I {"lw", "sw", "beq", "bne", "addi", "andi", "ori", "xori", "lui"},
    J {"j", "jal"},
    P {"la", "li", "sge", "sgt", "sle", "seq", "sne", "bge", "bgt", "ble", "blt", "mov", "abs"},
    special {"jalr", "syscall"}
;

// detailed instruction format
const std::unordered_set<std::string>
    R_rd_rs_rt {"add", "sub", "and", "or", "nor", "xor", "slt"},
    R_rs_rt {"mult", "div"},
    R_rd {"mflo", "mfhi"},
    R_rd_rt_shamt {"sll", "srl"},
    R_rs {"jr"},
    I_rt_imm_rs {"lw", "sw"},
    I_rs_rt_imm {"beq", "bne"},
    I_rt_rs_imm {"addi", "andi", "ori", "xori"},
    I_rt_imm {"lui"},
    J_addr {"j", "jal"},
    P_rd_imm {"la", "li"},
    P_rd_rs_rt {"sge", "sgt", "sle", "seq", "sne"},
    P_rs_rt_imm {"bge", "bgt", "ble", "blt"},
    P_rd_rs {"mov", "abs"}
;

// opcodes of all instructions except those with zero opcode
const std::unordered_map<std::string, int> opcodes {
    {"lw", 0x23},
    {"sw", 0x2B},
    {"beq", 0x04},
    {"bne", 0x05},
    {"j", 0x02},
    {"jal", 0x03},
    {"addi", 0x08},
    {"andi", 0x0C},
    {"ori", 0x0D},
    {"xori", 0x0E},
    {"lui", 0x0F}
};

// function codes of all R-format instructions
const std::unordered_map<std::string, int> functs {
    {"add", 0x20},
    {"sub", 0x22},
    {"and", 0x24},
    {"or", 0x25},
    {"nor", 0x27},
    {"xor", 0x26},
    {"slt", 0x2A},
    {"mult", 0x18},
    {"div", 0x1A},
    {"mflo", 0x12},
    {"mfhi", 0x10},
    {"sll", 0x00},
    {"srl", 0x02},
    {"jr", 0x08},
    {"jalr", 0x09}
};

/**
 * Returns the number of real instructions the given mnemonic will be translated into.
*/
int mnemonic_size(const std::string &mnemonic) {
    std::vector<std::string> terms = split(mnemonic, WHITESPACE+",()");
    if (I_rt_imm_rs.count(terms[0])) { // lw, sw
        int imm = std::stoi(terms[2]);
        return (INT16_MIN <= imm && imm <= INT16_MAX)? 1 : 3;
    }
    if (I_rt_rs_imm.count(terms[0])) { // addi, etc.
        int imm = std::stoi(terms[3]);
        return (INT16_MIN <= imm && imm <= INT16_MAX)? 1 : 3;
    }
    if (terms[0] == "li") {
        int imm = std::stoi(terms[2]);
        return (INT16_MIN <= imm && imm <= INT16_MAX)? 1 : 2;
    }
    if (pseudo_sizes.count(terms[0]))
        return pseudo_sizes.at(terms[0]);
    else
        return 1;
}

/**
 * Writes the instruction to the stream and returns the number of real instructions.
*/
int write_instr(int pc, const std::vector<std::string> &terms, const std::unordered_map<std::string, int> &labels, std::ofstream &file) {
    auto regs = [&] (int i) { return registers[terms[i]]; };
    std::string inst_type = terms[0];

    if (R.count(inst_type)) {
        // R-format is simple: figure out all fields and just write it
        int rs = 0, rt = 0, rd = 0, shamt = 0, funct = functs.at(inst_type);
        if (R_rd_rs_rt.count(inst_type)) {
            rd = regs(1), rs = regs(2), rt = regs(3);
        } else if (R_rs_rt.count(inst_type)) {
            rs = regs(1), rt = regs(2);
        } else if (R_rd.count(inst_type)) {
            rd = regs(1);
        } else if (R_rd_rt_shamt.count(inst_type)) {
            rd = regs(1), rt = regs(2), shamt = std::stoi(terms[3]);
        } else if (R_rs.count(inst_type)) {
            rs = regs(1);
        }
        write_binary(encode_Rtype(0, rs, rt, rd, shamt, funct), file);
        return 1;
    }
    
    if (I.count(inst_type)) {
        // I-format is tricky for 32-bit immediate
        int opcode = opcodes.at(inst_type);
        if (I_rt_imm_rs.count(inst_type)) {
            int rt = regs(1), imm = std::stoi(terms[2]), rs = regs(3);
            // i32 imm is split into i16 upper and lower, where (upper << 16) + lower == imm
            // therefore, lower can be used as offset value in lw and sw
            int upper = (imm + 0x8000U) >> 16;
            int lower = imm - (upper << 16);
            if (upper) {
                // lui $at, upper
                write_instr(pc, {"lui", "$at", std::to_string(upper)}, labels, file);
                // add $at, rs, $at
                write_instr(pc+1, {"add", "$at", terms[3], "$at"}, labels, file);
                // lw $rt, lower($at)
                write_instr(pc+2, {inst_type, terms[1], std::to_string(lower), "$at"}, labels, file);
                return 3;
            } else {
                write_binary(encode_Itype(opcode, rs, rt, imm), file);
                return 1;
            }
        }
        if (I_rs_rt_imm.count(inst_type)) {
            // seldom should we worry about imm in branching
            int rs = regs(1), rt = regs(2), imm = labels.at(terms[3]) - pc - 1;
            write_binary(encode_Itype(opcode, rs, rt, imm), file);
            return 1;
        }
        if (I_rt_rs_imm.count(inst_type)) {
            int rt = regs(1), rs = regs(2), imm = std::stoi(terms[3]);
            if (INT16_MIN <= imm && imm <= INT16_MAX) {
                write_binary(encode_Itype(opcode, rs, rt, imm), file);
                return 1;
            }
            // i32 imm is split into u16 upper and lower, where ((upper << 16) | lower) == imm
            // therefore, they can be OR-ed together (notes that ori uses ZeroExtImm)
            unsigned upper = ((unsigned)imm) >> 16, lower = imm & 0xffff;
            // lui $at, upper
            write_instr(pc, {"lui", "$at", std::to_string(upper)}, labels, file);
            // ori $at, $at, lower
            write_instr(pc+1, {"ori", "$at", "$at", std::to_string(lower)}, labels, file);
            // HACK drop 'i' suffix
            std::string dropi = inst_type.substr(0, inst_type.length()-1);
            // add rt, rs, $at
            write_instr(pc+2, {dropi, terms[1], terms[2], "$at"}, labels, file);
            return 3;
        }
        if (I_rt_imm.count(inst_type)) {
            int rs = 0, rt = regs(1), imm = std::stoi(terms[2]);
            write_binary(encode_Itype(opcode, rs, rt, imm), file);
            return 1;
        }
    }

    if (J.count(inst_type)) {
        write_binary(encode_Jtype(opcodes.at(inst_type), labels.at(terms[1])), file);
        return 1;
    }

    if (P.count(inst_type)) {
        if (inst_type == "la") {
            int imm = labels.at(terms[2]) * 4;
            // addi rd, $0, imm
            return write_instr(pc, {"addi", terms[1], "$0", std::to_string(imm)}, labels, file);
        }
        if (inst_type == "li") {
            int imm = std::stoi(terms[2]);
            if (INT16_MIN <= imm && imm <= INT16_MAX) {
                // addi rd, $0, imm
                return write_instr(pc, {"addi", terms[1], "$0", terms[2]}, labels, file);
            } else {
                // lui rd, upper
                write_instr(pc, {"lui", terms[1], std::to_string(((unsigned)imm) >> 16)}, labels, file);
                // ori rd, rd, lower
                write_instr(pc+1, {"ori", terms[1], terms[1], std::to_string(imm & 0xffff)}, labels, file);
                return 2;
            }
        }
        // sge rd, rs, rt:
        //   slt rd, rs, rt
        //   xori rd, rd, 1
        if (inst_type == "sge") {
            write_instr(pc, {"slt", terms[1], terms[2], terms[3]}, labels, file);
            write_instr(pc+1, {"xori", terms[1], terms[1], "1"}, labels, file);
            return 2;
        }
        // sgt rd, rs, rt:
        //   slt rd, rt, rs
        if (inst_type == "sgt") {
            return write_instr(pc, {"slt", terms[1], terms[3], terms[2]}, labels, file);
        }
        // sle rd, rs, rt:
        //   slt rd, rt, rs
        //   xori rd, rd, 1
        if (inst_type == "sle") {
            write_instr(pc, {"slt", terms[1], terms[3], terms[2]}, labels, file);
            write_instr(pc+1, {"xori", terms[1], terms[1], "1"}, labels, file);
            return 2;
        }
        // seq rd, rs, rt:
        //   slt $at, rt, rs
        //   slt rd, rs, rt
        //   nor rd, rd, $at
        if (inst_type == "seq") {
            write_instr(pc, {"slt", "$at", terms[3], terms[2]}, labels, file);
            write_instr(pc+1, {"slt", terms[1], terms[2], terms[3]}, labels, file);
            write_instr(pc+2, {"nor", terms[1], terms[1], "$at"}, labels, file);
            return 3;
        }
        // sne rd, rs, rt:
        //   slt $at, rt, rs
        //   slt rd, rs, rt
        //   or rd, rd, $at
        if (inst_type == "sne") {
            write_instr(pc, {"slt", "$at", terms[3], terms[2]}, labels, file);
            write_instr(pc+1, {"slt", terms[1], terms[2], terms[3]}, labels, file);
            write_instr(pc+2, {"or", terms[1], terms[1], "$at"}, labels, file);
            return 3;
        }
        // bge rs, rt, label:
        //   slt $at, rs, rt # rs < rt
        //   beq $at, $0, label # rs >= rt
        if (inst_type == "bge") {
            write_instr(pc, {"slt", "$at", terms[1], terms[2]}, labels, file);
            write_instr(pc+1, {"beq", "$at", "$0", terms[3]}, labels, file);
            return 2;
        }
        // bgt rs, rt, label:
        //   slt $at, rt, rs # rs > rt
        //   bne $at, $0, label # rs > rt
        if (inst_type == "bgt") {
            write_instr(pc, {"slt", "$at", terms[2], terms[1]}, labels, file);
            write_instr(pc+1, {"bne", "$at", "$0", terms[3]}, labels, file);
            return 2;
        }
        // ble rs, rt, label:
        //   slt $at, rt, rs # rs > rt
        //   beq $at, $0, label # rs <= rt
        if (inst_type == "ble") {
            write_instr(pc, {"slt", "$at", terms[2], terms[1]}, labels, file);
            write_instr(pc+1, {"beq", "$at", "$0", terms[3]}, labels, file);
            return 2;
        }
        // blt rs, rt, label:
        //   slt $at, rs, rt # rs < rt
        //   bne $at, $0, label # rs < rt
        if (inst_type == "blt") {
            write_instr(pc, {"slt", "$at", terms[1], terms[2]}, labels, file);
            write_instr(pc+1, {"bne", "$at", "$0", terms[3]}, labels, file);
            return 2;
        }
        // mov rd, rs:
        //   add rd, $0, rs
        if (inst_type == "mov") {
            return write_instr(pc, {"add", terms[1], "$0", terms[2]}, labels, file);
        }
        // abs rd, rs:
        //   slt $at, rd, $0
        //   sub $at, $0, $at
        //   xor rd, $at, rs
        //   sub rd, rd, $at
        if (inst_type == "abs") {
            write_instr(pc, {"slt", "$at", terms[1], "$0"}, labels, file);
            write_instr(pc+1, {"sub", "$at", "$0", "$at"}, labels, file);
            write_instr(pc+2, {"xor", terms[1], "$at", terms[2]}, labels, file);
            write_instr(pc+3, {"sub", terms[1], terms[1], "$at"}, labels, file);
            return 4;
        }
    }

    if (special.count(inst_type)) {
        if (inst_type == "jalr") {
            // if no rd is provided, $ra is the default
            int rs = regs(1), rd = terms.size() > 2? regs(2) : registers["$ra"];
            write_binary(encode_Rtype(0, rs, 0, rd, 0, functs.at(inst_type)), file);
            return 1;
        }
        if (inst_type == "syscall") {
            write_binary(0x0000d00c, file);
            return 1;
        }
    }

    return 0;
}

int main(int argc, char* argv[]) {
    if (argc < 4) // Checks that at least 3 arguments are given in command line
    {
        std::cerr << "Expected Usage:\n ./assemble infile1.asm infile2.asm ... infilek.asm staticmem_outfile.bin instructions_outfile.bin\n" << std::endl;
        exit(1);
    }
    //Prepare output files
    std::ofstream inst_outfile, static_outfile;
    static_outfile.open(argv[argc - 2], std::ios::binary);
    inst_outfile.open(argv[argc - 1], std::ios::binary);
    std::vector<std::string> instructions, data;
    std::unordered_map<std::string, int> label_map;
    int instr_n = 0, data_n = 0;

    /**
     * Phase 1:
     * Read all instructions, clean them of comments and whitespace DONE
     * TODO: Determine the numbers for all static memory labels
     * (measured in bytes starting at 0)
     * TODO: Determine the line numbers of all instruction line labels
     * (measured in instructions) starting at 0
    */

    // whether in data segment
    bool in_data_segment = false;

    // For each input file:
    for (int i = 1; i < argc - 2; i++) {
        std::ifstream infile(argv[i]); //  open the input file for reading
        if (!infile) { // if file can't be opened, need to let the user know
            std::cerr << "Error: could not open file: " << argv[i] << std::endl;
            exit(1);
        }

        std::string str;
        while (getline(infile, str)){ //Read a line from the file
            str = clean(str); // remove comments, leading and trailing whitespace
            if (str == "") continue; // skip empty lines
            // switch to data segment
            if (str == ".data") {
                in_data_segment = true;
                continue;
            }
            // switch to text segment
            if (str == ".text") {
                in_data_segment = false;
                continue;
            }

            // extract the label
            std::string text;
            if (str.find(':') != std::string::npos) {
                std::vector<std::string> splits = split(str, ":");
                label_map[splits[0]] = in_data_segment? data_n : instr_n;
                if (splits.size() < 2) continue;
                text = clean(std::move(splits[1]));
            } else {
                text = str;
            }
            
            if (in_data_segment) {
                // extracts memory content
                std::vector<std::string> elements = parse_data_directive(text);
                // appends to static memory
                data.insert(data.end(), elements.begin(), elements.end());
                // updates data address
                data_n = data.size();
            } else {
                // skip directives
                if (text[0] == '.') continue;
                // push the instruction
                instructions.push_back(text);
                // updates instruction address
                instr_n += mnemonic_size(text);
            }
        }
        infile.close();
    }

    /** Phase 2
     * Process all static memory, output to static memory file
     */
    for (const std::string & s : data) {
        // TODO numerical label?
        if (label_map.count(s))
            // if it is a label, queries its address to output
            write_binary(label_map[s] * 4, static_outfile);
        else
            // otherwise presumes it is a number
            write_binary(std::stoi(s), static_outfile);
    }
    static_outfile.close();

    /** Phase 3
     * Process all instructions, output to instruction memory file
     * TODO: Almost all of this, it only works for adds
     */
    int pc = 0;
    for(std::string instr : instructions) {
        std::vector<std::string> terms = split(instr, WHITESPACE+",()");
        pc += write_instr(pc, terms, label_map, inst_outfile);
    }
    inst_outfile.close();
}

#endif
