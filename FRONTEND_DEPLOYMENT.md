# BabyWhy Frontend Deployment Guide

This guide explains how to deploy the BabyWhy frontend to GitHub Pages.

## 🚀 Automatic Deployment (GitHub Actions)

The frontend automatically deploys to GitHub Pages whenever you push changes to the `web/` folder.

### What happens:
1. Push changes to `main` branch in `web/` folder
2. GitHub Actions workflow triggers automatically
3. Frontend builds and deploys to GitHub Pages
4. Live at: `https://anhnguyen765.github.io/claw26-2k5Baby/`

### Workflow file:
- `.github/workflows/deploy.yml` - Handles automatic deployment

---

## 🔧 Configuration

### Update API Endpoint

The frontend needs to point to your deployed API endpoint.

Edit `web/app.js` line 2:

```javascript
const API_ENDPOINT = 'https://your-api-endpoint.com';
```

Replace with your actual AgentBase endpoint:
```javascript
const API_ENDPOINT = 'https://endpoint-a1dc6b2b-964b-4935-af74-89bb58d4d723.agentbase-runtime.aiplatform.vngcloud.vn';
```

Then commit and push:
```bash
git add web/app.js
git commit -m "Update API endpoint to production"
git push origin main
```

---

## 📱 Accessing the Frontend

Once deployed, access at:
```
https://anhnguyen765.github.io/claw26-2k5Baby/
```

### GitHub Pages Settings

To enable GitHub Pages:

1. Go to your repository settings
2. Scroll to "Pages" section
3. Set Source to: `GitHub Actions`
4. Wait for first deployment (1-2 minutes)
5. Frontend will be live!

---

## 🔗 Connecting to API

When you open the frontend, it will automatically call your API endpoint.

**Make sure:**
- API endpoint is correct in `web/app.js`
- API is running and accessible
- No CORS issues (same endpoint for both web + API)

### Testing

```bash
# Test API health
curl https://endpoint-a1dc6b2b-964b-4935-af74-89bb58d4d723.agentbase-runtime.aiplatform.vngcloud.vn/health

# Test from frontend (should work without errors)
# Open: https://anhnguyen765.github.io/claw26-2k5Baby/
# Try chatting - check browser console for any errors
```

---

## 📦 What Gets Deployed

Only files in the `web/` folder:
- `index.html` - Main HTML
- `styles.css` - Styling
- `app.js` - Application logic
- `history.js` - Chat history management

---

## 🔄 Update Process

To update the frontend:

1. Edit files in `web/` folder
2. Commit: `git add web/ && git commit -m "Update frontend"`
3. Push: `git push origin main`
4. GitHub Actions deploys automatically
5. Check https://anhnguyen765.github.io/claw26-2k5Baby/ (may take 1-2 min)

---

## ✅ Status

- **Repository**: https://github.com/anhnguyen765/claw26-2k5Baby
- **Frontend**: https://anhnguyen765.github.io/claw26-2k5Baby/
- **API**: https://endpoint-a1dc6b2b-964b-4935-af74-89bb58d4d723.agentbase-runtime.aiplatform.vngcloud.vn
- **Deployment**: Automatic via GitHub Actions

---

## 🆘 Troubleshooting

### Frontend won't load
- Check GitHub Actions workflow in repo settings → Actions tab
- Verify `.github/workflows/deploy.yml` exists
- Check repository "Pages" settings → Source should be "GitHub Actions"

### API calls failing
- Verify API endpoint in `web/app.js` is correct
- Check API is actually running and responsive
- Open browser console (F12) to see the error
- Ensure CORS is not blocking (should be OK if using same endpoint)

### Pages not updating after push
- Wait 1-2 minutes for GitHub Actions
- Hard refresh browser (Ctrl+Shift+R on Windows/Linux, Cmd+Shift+R on Mac)
- Check Actions tab to see if deployment succeeded

---

## 📚 Related Documentation

- Backend API: See `DEPLOYMENT_GUIDE.md`
- Full setup: See `BUNDLED_DEPLOYMENT.md`
- User guide: See `ONBOARDING.md`

