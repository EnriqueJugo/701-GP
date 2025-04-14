instruction_table = {
    # Normal instructions
    "ldr":     "000000",
    "str":     "000010",
    "jmp":     "011000",
    "present": "011100",
    "andr":    "001000",
    "orr":     "001100",
    "addr":    "111000",
    "subr":    "000100",
    "subvr":   "000011",

    # Inherent instructions
    "clfz":    "010000",
    "cer":     "111100",
    "ceot":    "111110",
    "seot":    "111111",
    "noop":    "110100",

    # Immediate instructions
    "sz":      "010100",

    # Direct addressing
    "ler":     "110110",

    # Special instructions
    "ssvop":   "111011",
    "ssop":    "111010",
    "lsip":    "110111",

    # Other instructions
    "datacall":   "101000",
    "datacall2":  "101001",
    "max":        "011110",
    "strpc":      "011101",
    "sres":       "101010",
}

addressing_modes = {
    "inherent":  "00",
    "immediate": "01",
    "direct":    "10",
    "register":  "11",
}