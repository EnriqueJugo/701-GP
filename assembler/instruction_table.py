instruction_table = {
    # Normal instructions
    "ldr":    0b000000,
    "str":    0b000010,
    "jmp":    0b011000,
    "present": 0b011100,
    "andr":   0b001000,
    "orr":    0b001100,
    "addr":   0b111000,
    "subr":   0b000100,
    "subvr":  0b000011,

    # Inherent instructions
    "clfz":   0b010000,
    "cer":    0b111100,
    "ceot":   0b111110,
    "seot":   0b111111,
    "noop":   0b110100,

    # Immediate instructions
    "sz":     0b010100,

    # Direct addressing
    "ler":    0b110110,

    # Special instructions
    "ssvop":  0b111011,
    "ssop":   0b111010,
    "lsip":   0b110111,

    # Other instructions
    "datacall":   0b101000,
    "datacall2":  0b101001,
    "max":        0b011110,
    "strpc":      0b011101,
    "sres":       0b101010,
}

addressing_modes = {
    "inherent": 0b00,
    "immediate":    0b01,
    "direct":  0b10,
    "register":  0b11,
}
