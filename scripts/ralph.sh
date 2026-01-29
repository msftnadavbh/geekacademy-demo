#!/bin/bash

# Ralph Wiggum Autonomous Development Loop (GitHub Copilot CLI)
# ============================================================
# Runs GitHub Copilot CLI in a continuous loop. Each iteration feeds PROMPT.md
# to Copilot in non-interactive mode, until a completion signal is detected or
# max iterations is reached.
#
# Usage: ./scripts/ralph.sh <max_iterations>
# Example: ./scripts/ralph.sh 5

set -Eeuo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check for required argument
if [ "${1:-}" = "" ]; then
  echo -e "${RED}Error: Missing required argument${NC}"
  echo ""
  echo "Usage: $0 <max_iterations>"
  echo "Example: $0 5"
  exit 1
fi

MAX_ITERATIONS="$1"

# Validate max iterations is a number
if ! [[ "$MAX_ITERATIONS" =~ ^[0-9]+$ ]]; then
  echo -e "${RED}Error: max_iterations must be a positive integer${NC}"
  echo "Got: $MAX_ITERATIONS"
  exit 1
fi

# Ensure Copilot CLI exists
if ! command -v copilot >/dev/null 2>&1; then
  echo -e "${RED}Error: 'copilot' CLI not found in PATH${NC}"
  echo "Install GitHub Copilot CLI: https://docs.github.com/en/copilot/using-github-copilot/using-github-copilot-in-the-command-line"
  exit 1
fi

# Verify required files exist
if [ ! -f "PROMPT.md" ]; then
  echo -e "${RED}Error: PROMPT.md not found${NC}"
  echo "Please create PROMPT.md with your spec/instructions."
  exit 1
fi

# Create activity log if it doesn't exist
if [ ! -f "activity.md" ]; then
  echo -e "${YELLOW}Warning: activity.md not found, creating it...${NC}"
  cat > activity.md << 'EOF'
# Ralph Wiggum - Activity Log

## Current Status
**Last Updated:** Not started
**Tasks Completed:** 0
**Current Task:** None

---

## Session Log

<!-- Agent will append dated entries here -->
EOF
fi

# Read prompt once per run
PROMPT_TEXT="$(cat PROMPT.md)"

echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}   Ralph Wiggum Autonomous Loop${NC}"
echo -e "${BLUE}   (GitHub Copilot CLI Edition)${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""
echo -e "Max iterations: ${GREEN}$MAX_ITERATIONS${NC}"
echo -e "Completion signal: ${GREEN}<promise>DONE</promise>${NC}"
echo ""
echo -e "${YELLOW}Starting in 3 seconds... Press Ctrl+C to abort${NC}"
sleep 3
echo ""

# Main loop
for ((i=1; i<=MAX_ITERATIONS; i++)); do
  echo -e "${BLUE}======================================${NC}"
  echo -e "${BLUE}   Iteration $i of $MAX_ITERATIONS${NC}"
  echo -e "${BLUE}======================================${NC}"
  echo ""

  # Run GitHub Copilot CLI in non-interactive mode:
  # -p / --prompt: execute prompt and exit
  # --allow-all-tools: enables all tool permissions
  # --allow-all-paths: allows file access anywhere
  result="$(copilot -p "$PROMPT_TEXT" --allow-all-tools --allow-all-paths 2>&1)" || true

  # Print output for visibility
  echo "$result"
  echo ""

  # Check for completion signal (accept both DONE and COMPLETE variants)
  if [[ "$result" == *"<promise>DONE</promise>"* ]] || [[ "$result" == *"<promise>COMPLETE</promise>"* ]]; then
    echo ""
    echo -e "${GREEN}======================================${NC}"
    echo -e "${GREEN}   SPEC COMPLETE!${NC}"
    echo -e "${GREEN}======================================${NC}"
    echo ""
    echo -e "Finished after ${GREEN}$i${NC} iteration(s)"
    echo ""
    echo "Next steps:"
    echo "  1. Review the fix in your code"
    echo "  2. Check activity.md for the build log"
    echo "  3. Run the processor to verify the fix works"
    echo ""
    exit 0
  fi

  echo -e "${YELLOW}--- End of iteration $i ---${NC}"
  echo ""

  # Small delay between iterations to prevent hammering
  sleep 2
done

echo ""
echo -e "${RED}======================================${NC}"
echo -e "${RED}   MAX ITERATIONS REACHED${NC}"
echo -e "${RED}======================================${NC}"
echo ""
echo -e "Reached max iterations (${RED}$MAX_ITERATIONS${NC}) without completion."
echo ""
echo "Options:"
echo "  1. Run again with more iterations: ./scripts/ralph.sh 10"
echo "  2. Check activity.md to see current progress"
echo "  3. Check the spec file for acceptance criteria"
echo "  4. Manually complete remaining tasks"
echo ""
exit 1
