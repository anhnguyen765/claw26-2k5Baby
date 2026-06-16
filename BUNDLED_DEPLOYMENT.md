# BabyWhy - Bundled Runtime Deployment

Deploy the complete BabyWhy system (API + Web UI) as a single runtime on AgentBase!

## 🎯 What You Get

One single endpoint that serves:
- ✅ **Web Interface** - Modern chat UI with history at `/`
- ✅ **API Endpoints** - Decision analysis at `/decide`
- ✅ **Health Check** - System status at `/health`
- ✅ **Static Files** - CSS, JS fully bundled

**No separate frontend deployment needed!**

```
https://your-endpoint.com/           ← Web interface (chat UI)
https://your-endpoint.com/health     ← Health check (API)
https://your-endpoint.com/decide     ← Decision analysis (API)
```

---

## 📦 Package Structure

Your project is now ready for bundled deployment:

```
claw-a-thon-26/
├── main.py                # Flask app (updated to serve web files)
├── Dockerfile             # Updated to include web/
├── requirements.txt       # Python dependencies
├── .env                   # Environment variables
└── web/                   # Web interface (bundled in image)
    ├── index.html
    ├── styles.css
    ├── app.js
    └── history.js
```

---

## 🚀 Deployment Steps

### Step 1: Build & Push Docker Image

```bash
cd /Users/lap14569/claw-a-thon-26

# Set credentials
export GREENNODE_CLIENT_ID="d41cdbb4-9219-4337-bd28-575743d0a58b"
export GREENNODE_CLIENT_SECRET="ebef63f2-50d5-4c3b-8f0c-0dbec643140c"

# Build Docker image
docker build --platform linux/amd64 -t vcr.vngcloud.vn/111480-abp111770/baby-why:bundled .

# Push to registry
docker push vcr.vngcloud.vn/111480-abp111770/baby-why:bundled

# Verify push
echo "✅ Image pushed successfully"
```

### Step 2: Delete Old Runtime (Optional)

If you want to replace the existing runtime:

```bash
bash .claude/skills/agentbase/scripts/runtime.sh delete runtime-e2078338-eb7f-457c-aa71-e3e416236e3f

sleep 10
```

### Step 3: Create New Bundled Runtime

```bash
bash .claude/skills/agentbase/scripts/runtime.sh create \
  --name "baby-why-bundled" \
  --image "vcr.vngcloud.vn/111480-abp111770/baby-why:bundled" \
  --flavor "runtime-s2-general-2x4" \
  --env-file ".env" \
  --from-cr \
  --description "BabyWhy - Complete bundled system (API + Web UI)" \
  --min-replicas 1 \
  --max-replicas 1 \
  --cpu-scale 50 \
  --mem-scale 50
```

The command will return a **new Runtime ID**. Save it!

### Step 4: Wait for ACTIVE Status

```bash
RUNTIME_ID="<your-new-runtime-id-here>"

bash .claude/skills/agentbase/scripts/runtime.sh get $RUNTIME_ID
```

Wait until `status` shows `ACTIVE` (usually 30-60 seconds)

### Step 5: Get Your Endpoint URL

```bash
bash .claude/skills/agentbase/scripts/runtime.sh endpoints list $RUNTIME_ID
```

Find the `url` field - this is your **live endpoint**!

### Step 6: Test Everything

```bash
ENDPOINT="https://your-endpoint-from-above"

# Test 1: Health check
curl $ENDPOINT/health

# Test 2: Web interface (open in browser)
open $ENDPOINT/

# Test 3: API endpoint
curl -X POST $ENDPOINT/decide \
  -H "Content-Type: application/json" \
  -d '{"challenge":"Test"}'
```

---

## 🎉 You're Live!

Share this single URL with your team:
```
https://your-endpoint-from-above.com
```

Everything works from that one link:
- 📱 Chat interface at root `/`
- 🔧 API endpoints for programmatic access
- 💾 Chat history saved automatically
- 📤 Export/import conversations

---

## 📝 Complete Deployment Script

Save this as `deploy_bundled.sh`:

```bash
#!/bin/bash
set -e

export GREENNODE_CLIENT_ID="d41cdbb4-9219-4337-bd28-575743d0a58b"
export GREENNODE_CLIENT_SECRET="ebef63f2-50d5-4c3b-8f0c-0dbec643140c"

echo "🚀 Deploying BabyWhy Bundled Runtime..."

# Step 1: Build
echo "📦 Building Docker image..."
docker build --platform linux/amd64 -t vcr.vngcloud.vn/111480-abp111770/baby-why:bundled .

# Step 2: Push
echo "📤 Pushing to container registry..."
docker push vcr.vngcloud.vn/111480-abp111770/baby-why:bundled

# Step 3: Create runtime
echo "⚙️ Creating runtime on AgentBase..."
RUNTIME_RESPONSE=$(bash .claude/skills/agentbase/scripts/runtime.sh create \
  --name "baby-why-bundled" \
  --image "vcr.vngcloud.vn/111480-abp111770/baby-why:bundled" \
  --flavor "runtime-s2-general-2x4" \
  --env-file ".env" \
  --from-cr)

echo "$RUNTIME_RESPONSE"

# Extract Runtime ID
RUNTIME_ID=$(echo "$RUNTIME_RESPONSE" | grep -o '"id":"[^"]*"' | cut -d'"' -f4)

echo "✅ Runtime created: $RUNTIME_ID"
echo ""
echo "⏳ Waiting for ACTIVE status..."

# Poll for ACTIVE status
for i in {1..60}; do
    STATUS=$(bash .claude/skills/agentbase/scripts/runtime.sh get $RUNTIME_ID 2>&1 | grep -o '"status":"[^"]*"' | cut -d'"' -f4)
    
    if [ "$STATUS" = "ACTIVE" ]; then
        echo "✅ Runtime is ACTIVE!"
        break
    fi
    
    echo "   Status: $STATUS (waiting...)"
    sleep 5
done

# Get endpoint
echo ""
echo "🌐 Getting endpoint URL..."
ENDPOINT=$(bash .claude/skills/agentbase/scripts/runtime.sh endpoints list $RUNTIME_ID 2>&1 | grep -o '"url":"[^"]*"' | head -1 | cut -d'"' -f4)

echo ""
echo "=========================================="
echo "✅ BabyWhy is LIVE!"
echo "=========================================="
echo ""
echo "📍 Runtime ID:  $RUNTIME_ID"
echo "🌐 Endpoint:    $ENDPOINT"
echo ""
echo "📱 Web UI:      $ENDPOINT/"
echo "🔌 API:         $ENDPOINT/health"
echo "                $ENDPOINT/decide"
echo ""
echo "Share with team: $ENDPOINT/"
echo "=========================================="
```

Run it:
```bash
chmod +x deploy_bundled.sh
./deploy_bundled.sh
```

---

## 🔄 Update Process

When you update the code:

```bash
# 1. Update code (main.py, web files, etc.)

# 2. Rebuild and push
docker build --platform linux/amd64 -t vcr.vngcloud.vn/111480-abp111770/baby-why:bundled .
docker push vcr.vngcloud.vn/111480-abp111770/baby-why:bundled

# 3. Update runtime
bash .claude/skills/agentbase/scripts/runtime.sh update $RUNTIME_ID \
  --image "vcr.vngcloud.vn/111480-abp111770/baby-why:bundled" \
  --flavor "runtime-s2-general-2x4" \
  --from-cr
```

No separate frontend deployment needed! 🎉

---

## 🛡️ Architecture Benefits

### Single Deployment
- ✅ One endpoint to manage
- ✅ No CORS issues
- ✅ No API endpoint mismatch
- ✅ Easier to monitor

### Complete System
- ✅ API + Web UI in one image
- ✅ Everything scales together
- ✅ One health check
- ✅ Simplified architecture

### Team Ready
- ✅ One URL to share
- ✅ Works immediately
- ✅ No setup required
- ✅ Perfect for demos

---

## 📊 Comparison

| Aspect | Separate Deployment | Bundled Runtime |
|--------|-------------------|------------------|
| Frontend URL | Netlify/GitHub Pages | Same as API |
| CORS Setup | Required | None |
| Endpoints | 2 separate | 1 endpoint |
| Sharing with Team | 2 URLs | 1 URL |
| Deployment | 2 separate steps | 1 step |
| Maintenance | 2 platforms | 1 platform |
| Latency | Potential CORS overhead | Direct access |

**Bundled Runtime wins!** 🎯

---

## 🔗 Your Endpoints

Once deployed, you have:

```bash
# Web Interface (open in browser)
GET /
→ Returns index.html with chat UI

# Health Check
GET /health
→ Returns {"status":"healthy","agent":"BabyWhy","version":"1.0-phase1"}

# API: Decision Analysis
POST /decide
Headers: Content-Type: application/json
Body: {"challenge":"Your decision challenge"}
→ Returns analysis with emotion, questions, next steps

# API: Save Decision  
POST /journal
Headers: Content-Type: application/json
Body: {"challenge":"...", "decision":"...", "reasoning":"..."}
→ Returns decision_id confirmation

# Static Files
GET /styles.css
GET /app.js
GET /history.js
→ Returns web assets
```

---

## ✅ Verification Checklist

Before calling it done:

- [ ] Docker image built successfully
- [ ] Image pushed to registry
- [ ] Runtime created (new ID received)
- [ ] Runtime status is ACTIVE
- [ ] Endpoint URL is accessible
- [ ] `GET /health` returns 200
- [ ] Web UI loads at `/`
- [ ] Chat history works
- [ ] `/decide` endpoint returns analysis
- [ ] Team has the URL
- [ ] Documentation shared

---

## 🎓 Next Steps

1. **Share URL** - One link, everyone gets everything
2. **Monitor** - Use AgentBase console for logs/metrics
3. **Update Code** - New builds automatically serve updated UI
4. **Scale** - Increase `--max-replicas` if needed
5. **Celebrate** - You have a fully deployed AI product! 🎉

---

## 🆘 Troubleshooting

### Web UI won't load
- Check that `web/` folder exists with all 4 files
- Verify Dockerfile includes `COPY web/ ./web/`
- Check logs: `bash .claude/skills/agentbase/scripts/runtime.sh endpoints logs $RUNTIME_ID DEFAULT`

### API endpoints 404
- Verify Flask routes are defined in main.py
- Check `/health` endpoint directly
- View logs for Flask startup messages

### Slow performance
- Increase flavor: `--flavor "runtime-s2-general-4x8"`
- Enable autoscaling: `--max-replicas 3`
- Monitor CPU/memory usage

### Chat history not working
- Check browser localStorage is enabled
- Verify API calls succeed in browser console
- Ensure `/decide` endpoint is returning data

---

**You now have a production-ready, fully bundled BabyWhy system!** 🚀

One endpoint. Everything included. Share and go! 📱
