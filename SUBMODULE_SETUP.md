# Git Submodule Setup Guide

This guide explains how to use Git submodules to manage your content separately from your Quartz site repository.

## What Are Git Submodules?

Git submodules allow you to keep a Git repository as a subdirectory of another Git repository. This lets you:
- Keep your content in a separate, versioned repository
- Update content independently from the site code
- Automatically sync content in GitHub Actions builds

## Initial Setup

### Step 1: Create or Identify Your Content Repository

Your content needs to be in a Git repository. If you don't have one yet:

```bash
# Create a new directory for your content
mkdir ~/my-knowledge-content
cd ~/my-knowledge-content

# Initialize it as a Git repo
git init
git add .
git commit -m "Initial content"

# Create a GitHub repository and push
# (Create the repo on GitHub first, then:)
git remote add origin https://github.com/yourusername/your-content-repo.git
git branch -M main
git push -u origin main
```

### Step 2: Add Submodule to Quartz Repository

In your Quartz repository:

```bash
cd /Users/darius/Workspaces/quartz_knowledge_hub_site

# Remove existing content (if any)
rm -rf content/*
rm content/.gitkeep 2>/dev/null || true

# Add your content repo as a submodule
git submodule add https://github.com/yourusername/your-content-repo.git content

# Commit the submodule addition
git add .gitmodules content
git commit -m "Add content as submodule"
git push
```

### Step 3: Verify Setup

```bash
# Check submodule status
git submodule status

# You should see something like:
# abc1234 content (v1.0.0)
```

## Daily Workflow

### Updating Content

1. **Work on your content repository:**
   ```bash
   cd ~/my-knowledge-content
   # Make changes to your markdown files
   git add .
   git commit -m "Add new notes"
   git push
   ```

2. **Update the submodule reference in Quartz:**
   ```bash
   cd /Users/darius/Workspaces/quartz_knowledge_hub_site
   git submodule update --remote content
   git add content
   git commit -m "Update content submodule"
   git push
   ```

### Building Locally

```bash
# Make sure submodule is initialized and updated
git submodule update --init --recursive

# Build Quartz
npx quartz build
npx quartz build --serve  # Preview locally
```

## Cloning the Repository (New Machine)

When cloning the Quartz repository on a new machine:

```bash
# Clone with submodules
git clone --recurse-submodules https://github.com/dariustanrd/quartz_knowledge_hub.git

# Or if already cloned:
git submodule update --init --recursive
```

## Updating Submodule to Latest

To update to the latest commit from your content repository:

```bash
cd /Users/darius/Workspaces/quartz_knowledge_hub_site
git submodule update --remote content
git add content
git commit -m "Update content to latest"
git push
```

## Working Inside the Submodule

If you want to edit content directly from the Quartz repo:

```bash
cd content
# Make your edits
git add .
git commit -m "Update content"
git push

# Go back to Quartz repo
cd ..
git add content
git commit -m "Update submodule reference"
git push
```

## Removing the Submodule

If you need to remove the submodule:

```bash
# Remove the submodule
git submodule deinit -f content
git rm -f content
rm -rf .git/modules/content

# Commit the removal
git commit -m "Remove content submodule"
```

## Troubleshooting

### Submodule Shows as Modified

If `git status` shows the submodule as modified:

```bash
# Check what's different
cd content
git status

# If you want to update to latest:
cd ..
git submodule update --remote content
git add content
git commit -m "Update submodule"
```

### Submodule Points to Wrong Commit

```bash
# Reset to the commit referenced in parent repo
git submodule update --init --recursive

# Or update to latest from remote
git submodule update --remote content
```

### GitHub Actions Can't Access Private Submodule

If your content repository is private, you need to set up authentication:

1. Create a Personal Access Token (PAT) with `repo` scope
2. Add it as a secret in your Quartz repository: `Settings → Secrets → Actions`
3. Name it `PAT_TOKEN`
4. Update the workflow to use it (see below)

Update `.github/workflows/deploy.yml`:

```yaml
- uses: actions/checkout@v4
  with:
    fetch-depth: 0
    submodules: recursive
    token: ${{ secrets.PAT_TOKEN }}  # For private submodules
```

## Advantages of Submodules

✅ **Separation of concerns** - Content and site code are separate  
✅ **Independent versioning** - Version content separately  
✅ **Works in CI/CD** - GitHub Actions automatically checks out submodules  
✅ **No manual copying** - No need to copy files before committing  
✅ **Clean history** - Clear separation in Git history  

## Disadvantages

❌ **More complex** - Requires understanding Git submodules  
❌ **Two-step commits** - Need to commit in both repos  
❌ **Can be confusing** - Easy to forget to update submodule reference  

## Best Practices

1. **Always commit submodule updates** after updating content
2. **Use descriptive commit messages** for submodule updates
3. **Keep content repo public** if possible (or set up PAT for private repos)
4. **Document your workflow** so others (or future you) understand it
5. **Use `--recurse-submodules`** when cloning

## Quick Reference

```bash
# Add submodule
git submodule add <repo-url> content

# Initialize submodules (after clone)
git submodule update --init --recursive

# Update submodule to latest
git submodule update --remote content

# Update submodule to specific commit
cd content
git checkout <commit-hash>
cd ..
git add content
git commit -m "Pin submodule to specific commit"

# Remove submodule
git submodule deinit -f content
git rm -f content
```
