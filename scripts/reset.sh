#!/bin/bash

# Reset Demo to Clean State
# ==========================
# Restores the repository to its original buggy state for re-running the demo.
#
# Usage: ./scripts/reset.sh [--hard]
#
# Options:
#   --hard    Also remove generated logs and any untracked files

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo -e "${BLUE}🔄 Contoso Toyland - Demo Reset${NC}"
echo "=================================="
echo ""

HARD_RESET=false
if [ "${1:-}" == "--hard" ]; then
  HARD_RESET=true
fi

# 1. Reset Python processor to buggy state
echo -e "${YELLOW}Resetting code to original (buggy) state...${NC}"
git checkout -- python/processor.py 2>/dev/null && \
  echo -e "  ${GREEN}✓${NC} python/processor.py restored" || \
  echo -e "  ${YELLOW}⚠${NC} python/processor.py unchanged (already clean)"

# 2. Clear logs
if [ "$HARD_RESET" = true ]; then
  echo ""
  echo -e "${YELLOW}Cleaning generated files...${NC}"
  
  # Remove logs
  if [ -d "logs" ] && [ -n "$(ls -A logs 2>/dev/null)" ]; then
    rm -f logs/*.log 2>/dev/null
    echo -e "  ${GREEN}✓${NC} Cleared logs/"
  else
    echo -e "  ${YELLOW}⚠${NC} logs/ already empty"
  fi
  
  # Remove any activity.md if it exists
  if [ -f "activity.md" ]; then
    rm -f activity.md
    echo -e "  ${GREEN}✓${NC} Removed activity.md"
  fi
fi

# 3. Regenerate fresh logs
echo ""
echo -e "${YELLOW}Regenerating fresh logs...${NC}"
python3 python/processor.py >/dev/null 2>&1
if [ -f "logs/python.log" ]; then
  LINES=$(wc -l < logs/python.log)
  echo -e "  ${GREEN}✓${NC} Generated logs/python.log ($LINES lines)"
else
  echo -e "  ${RED}✗${NC} Failed to generate logs"
fi

# 4. Summary
echo ""
echo -e "${GREEN}=================================="
echo -e "   Demo Reset Complete!"
echo -e "==================================${NC}"
echo ""
echo "Current state:"
python3 python/processor.py 2>&1 | grep -E "Successful|Failed" | head -2 | sed 's/^/  /'
echo ""
echo "Ready to run demo. See Facilitator.md for walkthrough."
echo ""
