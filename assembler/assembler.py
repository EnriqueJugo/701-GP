from recop_parser import ReCOPParser

import sys
from recop_parser import ReCOPParser

def main():
    # Check if the user provided a filename
    if len(sys.argv) != 2:
        print("Usage: python main.py <filename.asm>")
        return

    filename = sys.argv[1]

    try:
        parser = ReCOPParser(filename)
        instructions, labels = parser.parse()

        print("\n--- Machine Instructions ---")
        for i, inst in enumerate(instructions):
            print(f"{i:04}: {inst}")

        print("\n--- Labels ---")
        for label, address in labels.items():
            print(f"{label}: {address:04}")

    except FileNotFoundError:
        print(f"File not found: {filename}")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    main()
