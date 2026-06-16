# BabyWhy - Complete Deployment Guide

This guide walks you through deploying the entire BabyWhy system: the AI agent backend and the web interface.

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────┐
│     BabyWhy Web Interface (Frontend)    │
│     - Chat UI with history              │
│     - React/Vanilla JS + CSS            │
│     - Deployed to: Netlify/GitHub Pages │
└─────────────────┬───────────────────────┘
                  │
                  │ API Calls
                  │
┌─────────────────▼───────────────────────┐
│     BabyWhy Agent (Backend)             │
│     - Flask + LangChain                 │
│     - Deployed to: AgentBase Runtime    │
│     - Endpoints: /health, /decide       │
└─────────────────────────────────────────┘
                  │
                  │ API Calls
                  │
┌─────────────────▼───────────────────────┐
│     GreenNode MaaS (LLM)                │
│     - gpt-5.0-nano model                │
└─────────────────────────────────────────┘
```

---

## Part 1: Backend (AI Agent)

### Status: ✅ Already Deployed

Your BabyWhy agent is live on AgentBase!

**Agent Details:**
- **Runtime ID**: `runtime-e2078338-eb7f-457c-aa71-e3e416236e3f`
- **Endpoint**: `https://endpoint-ac02c91a-691a-4f9d-b982-7b00bd9097d3.agentbase-runtime.aiplatform.vngcloud.vn`
- **Status**: ACTIVE ✅
- **Framework**: Flask + LangChain
- **Memory**: Configured with AgentBase Memory Service

### Verify Backend is Working

```bash
# Health check
curl https://endpoint-ac02c91a-691a-4f9d-b982-7b00bd9097d3.agentbase-runtime.aiplatform.vngcloud.vn/health

# Should return:
# {"agent":"BabyWhy","status":"healthy","version":"1.0-phase1"}

# Test analysis
curl -X POST https://endpoint-ac02c91a-691a-4f9d-b982-7b00bd9097d3.agentbase-runtime.aiplatform.vngcloud.vn/decide \
  -H "Content-Type: application/json" \
  -d '{"challenge":"Test"}'
```

### Update Backend

To deploy code changes:

```bash
cd /Users/lap14569/claw-a-thon-26

# 1. Update your code (edit main.py, etc.)
# 2. Build Docker image
docker build --platform linux/amd64 -t vcr.vngcloud.vn/111480-abp111770/baby-why:latest .

# 3. Push to container registry
docker push vcr.vngcloud.vn/111480-abp111770/baby-why:latest

# 4. Update runtime
export GREENNODE_CLIENT_ID="d41cdbb4-9219-4337-bd28-575743d0a58b"
export GREENNODE_CLIENT_SECRET="ebef63f2-50d5-4c3b-8f0c-0dbec643140c"

bash .claude/skills/agentbase/scripts/runtime.sh update runtime-e2078338-eb7f-457c-aa71-e3e416236e3f \
  --image "vcr.vngcloud.vn/111480-abp111770/baby-why:latest" \
  --flavor "runtime-s2-general-2x4" \
  --env-file ".env" \
  --from-cr
```

---

## Part 2: Frontend (Web Interface)

### Option A: Deploy to Netlify (Recommended)

**Why Netlify?** Free, fast, instant deployment, great for static sites.

#### Step 1: Install Netlify CLI

```bash
npm install -g netlify-cli
```

#### Step 2: Deploy

```bash
cd /Users/lap14569/claw-a-thon-26/web
netlify deploy --prod --dir .
```

#### Step 3: Get Your Live URL
```
✔ Deployed to https://babywhy-prod.netlify.app
```

Visit that URL in your browser! 🎉

---

### Option B: Deploy to GitHub Pages

**Why GitHub Pages?** Free, no build process, integrated with version control.

#### Step 1: Create GitHub Repository

```bash
cd /Users/lap14569/claw-a-thon-26/web
git init
git add .
git commit -m "Initial BabyWhy web app"
git branch -M main
git remote add origin https://github.com/yourusername/baby-why.git
git push -u origin main
```

#### Step 2: Enable GitHub Pages

1. Go to your repository settings
2. Scroll to "GitHub Pages"
3. Select `main` branch as source
4. Save

#### Step 3: Access Your Site

```
https://yourusername.github.io/baby-why
```

---

### Option C: Deploy to Vercel

**Why Vercel?** Extremely fast, automatic deployments, great performance.

#### Step 1: Install Vercel CLI

```bash
npm install -g vercel
```

#### Step 2: Deploy

```bash
cd /Users/lap14569/claw-a-thon-26/web
vercel --prod
```

#### Step 3: Get Your URL

```
✔ Production: https://baby-why.vercel.app
```

---

### Option D: Traditional Web Hosting

**For Hostinger, GoDaddy, BlueHost, etc.:**

1. **Upload files via FTP:**
```bash
# Upload these files to public_html/:
index.html
styles.css
app.js
history.js
```

2. **Access at your domain:**
```
https://yourdomain.com
```

---

### Option E: Self-Hosted (Docker)

**Run on your own server:**

#### Create Dockerfile

```dockerfile
FROM nginx:alpine
COPY web/ /usr/share/nginx/html/
EXPOSE 80
```

#### Deploy

```bash
docker build -t baby-why-web .
docker run -d -p 80:80 baby-why-web
```

Access at `http://localhost`

---

## Part 3: Configuration

### Update API Endpoint in Frontend

If your backend endpoint changes, update `web/app.js`:

```javascript
// Line 3 - Change this to your new endpoint
const API_ENDPOINT = 'https://your-new-endpoint.com';
```

Then redeploy the frontend.

---

## Part 4: Team Deployment Checklist

Use this checklist to deploy BabyWhy for your team:

### Before Deployment
- [ ] Backend agent is ACTIVE and responding
- [ ] `/health` endpoint returns 200
- [ ] `/decide` endpoint returns analysis
- [ ] Choose frontend deployment platform
- [ ] Get custom domain (if desired)

### Deployment
- [ ] Deploy frontend (Netlify/GitHub Pages/Vercel)
- [ ] Update API endpoint in `app.js`
- [ ] Test from web interface
- [ ] Share URL with team

### Post-Deployment
- [ ] Verify all endpoints work
- [ ] Test chat history functionality
- [ ] Verify export/import works
- [ ] Monitor agent performance
- [ ] Collect user feedback

### Documentation
- [ ] Share user guide (ONBOARDING.md)
- [ ] Add to team tools list
- [ ] Create Slack/Teams shortcut
- [ ] Document support process

---

## 📊 Monitoring & Maintenance

### Monitor Backend

```bash
# Check agent status
export GREENNODE_CLIENT_ID="d41cdbb4-9219-4337-bd28-575743d0a58b"
export GREENNODE_CLIENT_SECRET="ebef63f2-50d5-4c3b-8f0c-0dbec643140c"

bash .claude/skills/agentbase/scripts/runtime.sh get runtime-e2078338-eb7f-457c-aa71-e3e416236e3f

# View logs
bash .claude/skills/agentbase/scripts/runtime.sh endpoints logs runtime-e2078338-eb7f-457c-aa71-e3e416236e3f DEFAULT
```

### Monitor Frontend

- Check deployment platform dashboard
- Monitor API error rates
- Track user engagement
- Review analytics if available

---

## 🔄 Update Process

### Small Updates (UI/Copy Changes)

```bash
# 1. Edit web files
cd web
# Edit index.html, styles.css, etc.

# 2. Redeploy
netlify deploy --prod --dir .
# (or your chosen platform's deploy command)
```

### Major Updates (Backend Logic)

```bash
# 1. Update main.py
cd /Users/lap14569/claw-a-thon-26
# Edit main.py

# 2. Build and push
docker build --platform linux/amd64 -t vcr.vngcloud.vn/111480-abp111770/baby-why:latest .
docker push vcr.vngcloud.vn/111480-abp111770/baby-why:latest

# 3. Update runtime
bash .claude/skills/agentbase/scripts/runtime.sh update runtime-e2078338-eb7f-457c-aa71-e3e416236e3f \
  --image "vcr.vngcloud.vn/111480-abp111770/baby-why:latest" \
  --flavor "runtime-s2-general-2x4" \
  --from-cr
```

---

## 🐛 Troubleshooting

### "Failed to get analysis" Error

**Cause**: Frontend can't reach backend  
**Fix**:
1. Verify API endpoint in `app.js` is correct
2. Test endpoint manually with curl
3. Check CORS settings if needed

### Chat History Not Saving

**Cause**: localStorage disabled or full  
**Fix**:
1. Check browser storage settings
2. Clear old conversations
3. Try a different browser

### Slow Responses

**Cause**: Network latency  
**Fix**:
1. Check agent logs for processing time
2. Verify LLM model is responding
3. Check network connectivity

### Frontend Won't Load

**Cause**: Files not uploaded correctly  
**Fix**:
1. Verify all files uploaded (index.html, styles.css, app.js, history.js)
2. Check file permissions (should be readable)
3. Check web server logs

---

## 🎯 Quick Start Command

Deploy everything in 5 minutes:

```bash
# 1. Verify backend
curl https://endpoint-ac02c91a-691a-4f9d-b982-7b00bd9097d3.agentbase-runtime.aiplatform.vngcloud.vn/health

# 2. Deploy frontend
cd /Users/lap14569/claw-a-thon-26/web
npm install -g netlify-cli  # If not installed
netlify deploy --prod --dir .

# 3. Share URL with team! 🎉
```

---

## 📞 Support

**For backend issues:**
- Check `/agentbase-monitor` skill
- View runtime logs
- Verify environment variables

**For frontend issues:**
- Check browser console (F12)
- Verify API endpoint is correct
- Clear browser cache

**For deployment help:**
- Consult platform documentation
- Check your domain/SSL settings
- Verify API CORS if using different domain

---

## ✅ Final Checklist

Before calling it done:

- [ ] Backend running and healthy
- [ ] Frontend deployed and accessible
- [ ] API endpoint configured correctly
- [ ] Chat works end-to-end
- [ ] History saves locally
- [ ] Export/import works
- [ ] Team has access
- [ ] Documentation shared
- [ ] Support plan in place
- [ ] Monitoring set up

---

**Congratulations! BabyWhy is now live for your team!** 🚀

For questions or updates, refer to:
- ONBOARDING.md - User guide
- web/README.md - Technical details
- This guide - Deployment instructions
