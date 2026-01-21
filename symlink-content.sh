#!/bin/bash

# Script to symlink or copy content files into the Quartz content directory
# Usage: ./symlink-content.sh <source_directory> [--copy]

SOURCE_DIR="$1"
MODE="${2:-symlink}"  # Default to symlink, use --copy to copy instead

if [ -z "$SOURCE_DIR" ]; then
    echo "Usage: $0 <source_directory> [--copy]"
    echo ""
    echo "Examples:"
    echo "  $0 /path/to/your/notes"
    echo "  $0 /path/to/your/notes --copy"
    echo ""
    echo "Note: Use --copy for CI/CD environments where symlinks won't work"
    exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory '$SOURCE_DIR' does not exist"
    exit 1
fi

CONTENT_DIR="content"

# Create content directory if it doesn't exist
mkdir -p "$CONTENT_DIR"

# Remove existing symlinks/files in content directory (but keep .gitkeep)
find "$CONTENT_DIR" -mindepth 1 ! -name '.gitkeep' -delete

if [ "$MODE" = "--copy" ]; then
    echo "Copying files from $SOURCE_DIR to $CONTENT_DIR..."
    cp -r "$SOURCE_DIR"/* "$CONTENT_DIR"/ 2>/dev/null || {
        # Handle case where source might have hidden files
        rsync -av --exclude='.git' "$SOURCE_DIR"/ "$CONTENT_DIR"/
    }
    echo "Files copied successfully!"
else
    echo "Creating symlinks from $SOURCE_DIR to $CONTENT_DIR..."
    
    # Create symlinks for each item in source directory
    for item in "$SOURCE_DIR"/*; do
        if [ -e "$item" ]; then
            item_name=$(basename "$item")
            ln -sf "$item" "$CONTENT_DIR/$item_name"
            echo "  Linked: $item_name"
        fi
    done
    
    # Also handle hidden files (but exclude .git)
    for item in "$SOURCE_DIR"/.*; do
        if [ -e "$item" ] && [ "$(basename "$item")" != "." ] && [ "$(basename "$item")" != ".." ] && [ "$(basename "$item")" != ".git" ]; then
            item_name=$(basename "$item")
            ln -sf "$item" "$CONTENT_DIR/$item_name"
            echo "  Linked: $item_name"
        fi
    done
    
    echo "Symlinks created successfully!"
fi
