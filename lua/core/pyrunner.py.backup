import sys
import runpy

# Wrapper to run python scripts cleanly without KeyboardInterrupt Traceback
if len(sys.argv) < 2:
    sys.exit(1)

target_file = sys.argv[1]

# Set up sys.argv to look like the target script was called directly
# (Remove the wrapper from the arg list)
sys.argv = sys.argv[1:]

try:
    # Run the user's script
    runpy.run_path(target_file, run_name='__main__')
except KeyboardInterrupt:
    # Catch Ctrl+C and exit silently
    sys.exit(0)
except Exception as e:
    # Let other errors show (so they can debug bugs)
    raise e
