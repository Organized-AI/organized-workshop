#!/usr/bin/env bash
# apply-organized-codebase.sh
# Applies the Organized Codebase template to any project
# Version: 2.0 (Just integration)
# Bundled inside the organized-bootstrap-qa plugin.
# Source of truth: Organized-AI/organized-codebase @ feature/bootstrap-qa-loop

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$(dirname "$SCRIPT_DIR")/templates"

echo -e "${BLUE}"
echo "═══════════════════════════════════════════════════════════════"
echo "  Organized Codebase Applicator v2.0"
echo "  with Just scaffolding integration"
echo "═══════════════════════════════════════════════════════════════"
echo -e "${NC}"

usage() {
    echo "Usage: $0 [OPTIONS] [TARGET_DIR]"
    echo ""
    echo "Options:"
    echo "  -j, --just-only     Only copy justfile (skip direct scaffolding)"
    echo "  -f, --full          Full scaffolding (run justfile recipes)"
    echo "  -h, --help          Show this help message"
}

check_just() {
    if command -v just &> /dev/null; then
        echo -e "${GREEN}✅ Just is installed${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠️  Just is not installed${NC}"
        echo "  macOS:   brew install just"
        echo "  Linux:   cargo install just"
        echo "  Windows: winget install casey.just"
        return 1
    fi
}

copy_justfile() {
    local target_dir="$1"
    if [ -f "$TEMPLATE_DIR/justfile" ]; then
        if [ -f "$target_dir/justfile" ]; then
            echo -e "${YELLOW}⚠️  justfile already exists. Backing up to justfile.bak${NC}"
            cp "$target_dir/justfile" "$target_dir/justfile.bak"
        fi
        cp "$TEMPLATE_DIR/justfile" "$target_dir/justfile"
        echo -e "${GREEN}✅ Copied justfile template${NC}"
    else
        echo -e "${YELLOW}⚠️  No bundled justfile template found — falling back to direct scaffolding${NC}"
        return 1
    fi
}

direct_scaffold() {
    local target_dir="$1"
    echo -e "${BLUE}📁 Creating directory structure...${NC}"
    mkdir -p "$target_dir/.claude"/{agents,commands,hooks,skills}
    mkdir -p "$target_dir/PLANNING"/{implementation-phases,decisions,experiments}
    mkdir -p "$target_dir/ARCHITECTURE"
    mkdir -p "$target_dir/DOCUMENTATION"
    mkdir -p "$target_dir/SPECIFICATIONS"
    mkdir -p "$target_dir/AGENT-HANDOFF"
    mkdir -p "$target_dir/CONFIG"
    mkdir -p "$target_dir/scripts"
    mkdir -p "$target_dir/.archive"
    mkdir -p "$target_dir/.claude/workflows"
    echo -e "${GREEN}✅ Directory structure created${NC}"
}

main() {
    local target_dir="."
    local just_only=false
    local full_mode=false

    while [[ $# -gt 0 ]]; do
        case $1 in
            -j|--just-only) just_only=true; shift ;;
            -f|--full) full_mode=true; shift ;;
            -h|--help) usage; exit 0 ;;
            *) target_dir="$1"; shift ;;
        esac
    done

    target_dir="$(cd "$target_dir" 2>/dev/null && pwd)" || {
        echo -e "${RED}❌ Target directory does not exist: $target_dir${NC}"
        exit 1
    }

    echo -e "${BLUE}Target directory: $target_dir${NC}"
    echo ""

    if copy_justfile "$target_dir" && check_just; then
        if [ "$just_only" = true ]; then
            echo -e "${GREEN}Justfile copied. Run: just apply-organized${NC}"
        elif [ "$full_mode" = true ]; then
            (cd "$target_dir" && just apply-organized)
        else
            echo -e "${GREEN}Justfile copied! Run: just apply-organized${NC}"
        fi
    else
        echo -e "${YELLOW}Falling back to direct scaffolding...${NC}"
        direct_scaffold "$target_dir"
    fi

    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
}

main "$@"
