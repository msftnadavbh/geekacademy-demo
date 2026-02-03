#!/bin/bash

# Ralph Wiggum Autonomous Development Loop (GitHub Copilot CLI)
# ============================================================
# Runs GitHub Copilot CLI in a continuous loop. Each iteration feeds PROMPT.md
# to Copilot in non-interactive mode, until a completion signal is detected or
# max iterations is reached.
#
# Usage: ./scripts/ralph.sh [--plan] <max_iterations>
# Example: ./scripts/ralph.sh 5
# Example: ./scripts/ralph.sh --plan 5
#
# Options:
#   --plan    Run a planning step before the fix loop (asks Copilot to
#             analyze the spec and output an implementation plan first)

set -Eeuo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Parse options
PLAN_MODE=false
while [[ "${1:-}" == -* ]]; do
  case "$1" in
    --plan)
      PLAN_MODE=true
      shift
      ;;
    *)
      echo -e "${RED}Error: Unknown option: $1${NC}"
      echo ""
      echo "Usage: $0 [--plan] <max_iterations>"
      echo "Example: $0 5"
      echo "Example: $0 --plan 5"
      exit 1
      ;;
  esac
done

# Check for required argument
if [ "${1:-}" = "" ]; then
  echo -e "${RED}Error: Missing required argument${NC}"
  echo ""
  echo "Usage: $0 [--plan] <max_iterations>"
  echo "Example: $0 5"
  echo "Example: $0 --plan 5"
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

# Read prompt once per run
PROMPT_TEXT="$(cat PROMPT.md)"

echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}   Ralph Wiggum Autonomous Loop${NC}"
echo -e "${BLUE}   (GitHub Copilot CLI Edition)${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""
echo -e "Max iterations: ${GREEN}$MAX_ITERATIONS${NC}"
echo -e "Completion signal: ${GREEN}<promise>DONE</promise>${NC}"
if [ "$PLAN_MODE" = true ]; then
  echo -e "Plan mode: ${CYAN}enabled${NC}"
fi
echo ""

# Planning phase (optional)
if [ "$PLAN_MODE" = true ]; then
  echo -e "${CYAN}======================================${NC}"
  echo -e "${CYAN}   Planning Phase${NC}"
  echo -e "${CYAN}======================================${NC}"
  echo ""

  PLAN_PROMPT="Read the spec file at specs/001-fix-python-typeerror/spec.md and the relevant codebase.

Create a brief implementation plan with:
1. Root cause analysis (what is broken and why)
2. Files that need to be modified
3. Specific changes to make
4. How to verify the fix works

Output ONLY the plan, no code changes yet."

  echo -e "${YELLOW}Asking Copilot to create implementation plan...${NC}"
  echo ""

  plan_result="$(copilot -p "$PLAN_PROMPT" --allow-all-tools --allow-all-paths 2>&1)" || true
  echo "$plan_result"
  echo ""

  echo -e "${CYAN}--- Planning phase complete ---${NC}"
  echo ""
  echo -e "${YELLOW}Proceeding to implementation in 3 seconds...${NC}"
  sleep 3
  echo ""
fi

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
    echo "  2. Run the processor to verify the fix works"
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
echo "  2. Check the spec file for acceptance criteria"
echo "  3. Manually complete remaining tasks"
echo ""
exit 1
