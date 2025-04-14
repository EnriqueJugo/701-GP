import os
import re
from instruction_table import instruction_table
import utils

class ReCOPParser:
    def __init__(self, filename):
        self.filename = filename
        self.instructions = []
        self.labels = {}
        self.current_address = 0

    def parse(self):
        with open(self.filename, 'r', encoding='utf-8') as file:
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


            tokens = [token.lower() for token in line.split(" ")]
            # Check if it is an instruction
            if tokens[0] in instruction_table.keys():
                instruction["instruction"] = tokens[0].lower()

                # Check arguments
                for curr_arg in tokens[1:]:
                    # R(x) = Register #(x) = Immediate
                    instruction["args"].append(curr_arg.lower())
                                     
            # Is a label
            else:
                # Store address of label
                self.labels[line] = self.current_address

            #TODO: Check if ENDPROG and END
            
            self.current_address += 1

            self.parse_instruction(instruction)

        return self.instructions, self.labels

    def parse_instruction(self, instruction : dict):
        # instruction format
        # ---------------------------------------------
        # |AM(2)|OP(6)|Rz(4)|Rx(4)|ADDR/VAL/OTHERs(16)|
        # ---------------------------------------------

        if instruction["instruction"] not in instruction_table:
            return
            
        inst = instruction_table[instruction["instruction"]]
        
        addr_type = 0  
        
        # Inherit
        if len(instruction["args"]) == 0:
            inst = inst + '0' * 24
            addr_type = '00'
        
        # Register, Immediate, Direct
        else:
            count = 2
            for args in instruction["args"]:
                # Register
                if args.startswith("r"):
                    reg_num = int(args[1:])
                    inst = inst + utils.int_to_bin(reg_num, 4)
                    addr_type = '11'
                
                # Immediate
                if args.startswith("#"):
                    operand = int(args[1:])
                    inst = inst + '0' * (4 * count)  + utils.int_to_bin(operand, 16)
                    addr_type = '01'
                
                # Direct
                if args.startswith("$"):
                    operand = int(args[1:])
                    inst = inst + '0' * (4 * count)  + utils.int_to_bin(operand, 16)
                    addr_type = '10'
                    
                count = count - 1
        
        if addr_type == 0b11:
            inst = inst << 16
        # Concat. address mode bits
        inst = addr_type + inst
                
        self.instructions.append(inst)