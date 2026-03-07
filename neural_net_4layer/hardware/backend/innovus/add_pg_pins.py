import sys
import re

def add_pg_pins(input_file, output_file):
    with open(input_file, 'r') as f:
        content = f.read()

    # Match module nn_top(...)
    # Use re.DOTALL to match across multiple lines
    module_pattern = r'(module\s+nn_top\s*\()([^)]*)(\);)'
    
    def repl_ports(match):
        prefix = match.group(1)
        ports = match.group(2)
        suffix = match.group(3)
        # Add VDD, VSS to the end of the port list
        if ports.strip():
            new_ports = ports.rstrip() + ",\n     VDD, VSS"
        else:
            new_ports = "VDD, VSS"
        return f"{prefix}{new_ports}{suffix}"

    new_content = re.sub(module_pattern, repl_ports, content, flags=re.MULTILINE)

    # Add inout VDD, VSS;
    # Usually after the ports, we have input/output declarations.
    # We can insert it right after the module declaration.
    inout_pattern = r'(module\s+nn_top\s*\(.*?\);)'
    new_content = re.sub(inout_pattern, r'\1\n  inout VDD, VSS;', new_content, flags=re.DOTALL)

    with open(output_file, 'w') as f:
        f.write(new_content)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python add_pg_pins.py <input_v> <output_v>")
        sys.exit(1)
    add_pg_pins(sys.argv[1], sys.argv[2])
