import os
import re
from instruction_table import instruction_table

class ReCOPParser:
    def __init__(self, filename):
        self.filename = filename
        self.instructions = []
        self.labels = {}
        self.current_address = 0

    def parse(self):
        with open(self.filename, 'r') as file:
            lines = file.readlines()

        self.current_address = 0

        for line in lines:
            instruction = {"instruction": "", "args": []}
            # Remove multiple white spaces
            line = re.sub(' +', ' ', line) 
            line = line.strip()

            # Remove empty lines
            if not line:
                continue
            if ";" in line:  # Ignore comments on same line
                line = line[0:line.find(";")]
                line = line.strip()

            if " " in line:
                tokens = line.split(" ")# Get first part of instruction

                # Check if it is an instruction
                if tokens[0] in instruction_table.keys():
                    instruction["instruction"] = tokens[0]

                    # Check arguments
                    for curr_arg in tokens[1:]:
                        # R(x) = Register #(x) = Immediate
                        instruction["args"].append(curr_arg)
                                     
                # Is a label
                else:
                    # Store address of label
                    self.labels[tokens[0]] = self.current_address

            #TODO: Check if ENDPROG and END
            
            self.current_address += 1

            self.parse_instruction(instruction)

        return self.instructions, self.labels

    def parse_instruction(self, instruction : dict):
        # instruction format
        # ---------------------------------------------
        # |AM(2)|OP(6)|Rz(4)|Rx(4)|ADDR/VAL/OTHERs(16)|
        # ---------------------------------------------

        opcode = instruction_table[instruction["instruction"]]
        for args in instruction["args"]:
            # Check if argument is a register
            if args.startswith("R"):
                reg_num = int(args[1:])
                opcode = (opcode << 4) | (reg_num & 0x0F)