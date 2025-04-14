def int_to_bin(value: int, bit_length: int) -> str:
        if value >= 2**bit_length or value < 0:
            raise ValueError(f"Value {value} cannot be represented in {bit_length} bits.")
        return format(value, f'0{bit_length}b')