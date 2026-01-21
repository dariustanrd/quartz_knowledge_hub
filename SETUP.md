# Setup Guide: Git Submodules and GitHub Pages Deployment

This guide explains how to use Git submodules to manage your content separately and deploy to GitHub Pages.

## Overview

This repository uses **Git submodules** to manage content. Your content lives in a separate Git repository and is included as a submodule in the `content/` directory.

## Initial Setup

### Step 1: Set Up Your Content Repository

Your content needs to be in a Git repository. If you don't have one:

```bash
# Create and initialize your content repository
mkdir ~/my-knowledge-content
cd ~/my-knowledge-content
git init
git add .
git commit -m "Initial content"

# Create a GitHub repository and push
# (Create the repo on GitHub first, then:)
git remote add origin https://github.com/yourusername/your-content-repo.git
git branch -M main
git push -u origin main
```

### Step 2: Add Content as Submodule

In this Quartz repository:

```bash
# Remove existing content (if any)
rm -rf content/*

# Add your content repo as a submodule
git submodule add https://github.com/yourusername/your-content-repo.git content

# Commit the submodule
git add .gitmodules content
git commit -m "Add content as submodule"
git push
```

For detailed submodule instructions, see [SUBMODULE_SETUP.md](./SUBMODULE_SETUP.md).

## Daily Workflow

### Updating Content

1. **Make changes in your content repository:**
   ```bash
   cd ~/my-knowledge-content
   # Edit your markdown files
   git add .
   git commit -m "Add new notes"
   git push
   ```

2. **Update the submodule reference in Quartz:**
   ```bash
   cd /Users/darius/Workspaces/quartz_knowledge_hub_site
   ./update-content.sh "Update content"
   git push
   ```

   Or manually:
   ```bash
   git submodule update --remote content
   git add content
   git commit -m "Update content"
   git push
   ```

### Building Locally

```bash
# Make sure submodule is initialized
git submodule update --init --recursive

# Install dependencies (first time only)
npm install

# Build Quartz
npx quartz build
npx quartz build --serve  # Preview locally at http://localhost:8080
```

## GitHub Pages Deployment

The GitHub Actions workflow automatically:
1. Checks out the repository **with submodules**
2. Builds your Quartz site
3. Deploys to GitHub Pages

No manual steps needed! Just push your changes (including submodule updates) and the site will deploy automatically.

## Configuration

### Update baseUrl

Before deploying, update the `baseUrl` in `quartz.config.ts` to match your GitHub Pages URL:

Your GitHub Pages URL is configured as: `dariustanrd.github.io/quartz_knowledge_hub`

If you need to change it, update line 19 in `quartz.config.ts`:
```typescript
baseUrl: "your-username.github.io/your-repo-name",
```

### Enable GitHub Pages

1. Go to your repository on GitHub
2. Navigate to Settings → Pages
3. Under "Source", select "GitHub Actions"
4. Save the settings

## Workflow

The deployment workflow (`.github/workflows/deploy.yml`) will:
1. Trigger on pushes to `v4` branch
2. Checkout repository with submodules
3. Build your Quartz site
4. Deploy to GitHub Pages

## Cloning on a New Machine

When cloning this repository, make sure to include submodules:

```bash
git clone --recurse-submodules https://github.com/dariustanrd/quartz_knowledge_hub.git
```

Or if already cloned:

```bash
git submodule update --init --recursive
```

## Troubleshooting

- **Submodule shows as modified**: Run `git submodule update --init --recursive` to sync
- **Build fails**: Make sure submodules are initialized (`git submodule update --init --recursive`)
- **Private content repo**: See [SUBMODULE_SETUP.md](./SUBMODULE_SETUP.md) for PAT token setup
- **Pages not updating**: Check that GitHub Pages is set to use "GitHub Actions" as the source

## Additional Resources

- [SUBMODULE_SETUP.md](./SUBMODULE_SETUP.md) - Detailed submodule guide
- [Quartz Documentation](https://quartz.jzhao.xyz/) - Full Quartz documentation
