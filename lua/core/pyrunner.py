#!/usr/bin/env python3
"""
Quick Python runner wrapper
Catches Ctrl+C so we don't get ugly tracebacks
"""

import sys
import os
import runpy

def main():
    if len(sys.argv) < 2:
        print("Usage: pyrunner.py <script.py>")
        sys.exit(1)
    
    script = sys.argv[1]
    
    # Make sure file actually exists
    if not os.path.exists(script):
        print(f"Error: File '{script}' not found")
        sys.exit(1)
    
    # Remove our wrapper from argv so script sees its real args
    sys.argv = sys.argv[1:]
    
    try:
        # Run the script
        runpy.run_path(script, run_name='__main__')
    except KeyboardInterrupt:
        # Clean exit on Ctrl+C
        print("\nInterrupted")
        sys.exit(0)
    except Exception as e:
        # Let real errors through so people can debug
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
