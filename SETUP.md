# Setup Guide: Symlinking Content and GitHub Pages Deployment

This guide explains how to symlink your content files from another location and deploy to GitHub Pages.

## Local Development with Symlinks

### Step 1: Symlink Your Content

Use the provided script to symlink your content files:

```bash
./symlink-content.sh /path/to/your/notes
```

This will create symlinks in the `content/` directory pointing to your source files.

### Step 2: Build Locally

```bash
npm install
npx quartz build
npx quartz build --serve  # To preview locally
```

## GitHub Pages Deployment

### Important Note About Symlinks

GitHub Actions cannot follow symlinks to files outside the repository. You have two options:

### Option 1: Copy Files Before Committing (Recommended for Simple Setup)

Before committing and pushing, copy your files instead of symlinking:

```bash
./symlink-content.sh /path/to/your/notes --copy
git add content/
git commit -m "Update content"
git push
```

The GitHub Actions workflow will automatically build and deploy your site.

### Option 2: Use GitHub Actions to Copy from Another Repo

If your content is in a separate GitHub repository, you can modify the workflow to checkout and copy from that repo. See the workflow file for comments on how to do this.

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
1. Trigger on pushes to `v4` or `main` branches
2. Build your Quartz site
3. Deploy to GitHub Pages

## Troubleshooting

- **Symlinks not working in GitHub Actions**: This is expected. Use `--copy` mode before committing.
- **Build fails**: Make sure all dependencies are installed (`npm ci`)
- **Pages not updating**: Check that GitHub Pages is set to use "GitHub Actions" as the source
