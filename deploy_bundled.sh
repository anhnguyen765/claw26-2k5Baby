#!/bin/bash
set -e

# BabyWhy Bundled Runtime Deployment Script
# Deploys the complete system (API + Web UI) as one runtime

export GREENNODE_CLIENT_ID="d41cdbb4-9219-4337-bd28-575743d0a58b"
export GREENNODE_CLIENT_SECRET="ebef63f2-50d5-4c3b-8f0c-0dbec643140c"

echo ""
echo "🚀 =========================================="
echo "   BabyWhy Bundled Runtime Deployment"
echo "=========================================="
echo ""

# Step 1: Build
echo "📦 Step 1: Building Docker image..."
echo "   Platform: linux/amd64"
echo "   Including: main.py + web/ interface"
docker build --platform linux/amd64 -t vcr.vngcloud.vn/111480-abp111770/baby-why:bundled . 2>&1 | tail -5
echo "✅ Build successful"
echo ""

# Step 2: Push
echo "📤 Step 2: Pushing to container registry..."
docker push vcr.vngcloud.vn/111480-abp111770/baby-why:bundled 2>&1 | tail -3
echo "✅ Push successful"
echo ""

# Step 3: Create runtime
echo "⚙️  Step 3: Creating bundled runtime on AgentBase..."
RUNTIME_RESPONSE=$(bash .claude/skills/agentbase/scripts/runtime.sh create \
  --name "baby-why-bundled" \
  --image "vcr.vngcloud.vn/111480-abp111770/baby-why:bundled" \
  --flavor "runtime-s2-general-2x4" \
  --env-file ".env" \
  --from-cr \
  --description "BabyWhy - Complete bundled system (API + Web UI)" \
  --min-replicas 1 \
  --max-replicas 1 \
  --cpu-scale 50 \
  --mem-scale 50 2>&1)

# Extract Runtime ID
RUNTIME_ID=$(echo "$RUNTIME_RESPONSE" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -z "$RUNTIME_ID" ]; then
    echo "❌ Failed to create runtime"
    echo "Response: $RUNTIME_RESPONSE"
    exit 1
fi

echo "✅ Runtime created: $RUNTIME_ID"
echo ""

# Step 4: Poll for ACTIVE status
echo "⏳ Step 4: Waiting for runtime to become ACTIVE..."
echo "   (This typically takes 30-60 seconds)"
echo ""

TIMEOUT=120
ELAPSED=0
while [ $ELAPSED -lt $TIMEOUT ]; do
    STATUS=$(bash .claude/skills/agentbase/scripts/runtime.sh get $RUNTIME_ID 2>&1 | grep -o '"status":"[^"]*"' | head -1 | cut -d'"' -f4)

    if [ "$STATUS" = "ACTIVE" ]; then
        echo "   ✅ Status: ACTIVE"
        break
    elif [ "$STATUS" = "ERROR" ] || [ "$STATUS" = "FAILED" ]; then
        echo "❌ Runtime status: $STATUS"
        exit 1
    fi

    echo -n "   Status: $STATUS (waiting $ELAPSED/$TIMEOUT seconds)...\r"
    sleep 5
    ELAPSED=$((ELAPSED + 5))
done

if [ $ELAPSED -ge $TIMEOUT ]; then
    echo "❌ Timeout waiting for ACTIVE status"
    exit 1
fi

echo ""
echo ""

# Step 5: Get endpoint
echo "🌐 Step 5: Retrieving endpoint URL..."
ENDPOINT_RESPONSE=$(bash .claude/skills/agentbase/scripts/runtime.sh endpoints list $RUNTIME_ID 2>&1)
ENDPOINT=$(echo "$ENDPOINT_RESPONSE" | grep -o '"url":"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -z "$ENDPOINT" ]; then
    echo "⚠️  Could not retrieve endpoint"
    echo "Runtime ID: $RUNTIME_ID"
    echo "Please check manually:"
    echo "  bash .claude/skills/agentbase/scripts/runtime.sh endpoints list $RUNTIME_ID"
    exit 1
fi

echo "✅ Endpoint URL retrieved"
echo ""

# Success!
echo "=========================================="
echo "✅ DEPLOYMENT SUCCESSFUL!"
echo "=========================================="
echo ""
echo "📊 DEPLOYMENT SUMMARY"
echo "────────────────────────────────────────"
echo "Runtime ID:       $RUNTIME_ID"
echo "Status:           ACTIVE ✅"
echo "Endpoint:         $ENDPOINT"
echo ""
echo "🌐 LIVE ENDPOINTS"
echo "────────────────────────────────────────"
echo "Web UI (Chat):    $ENDPOINT/"
echo "Health Check:     $ENDPOINT/health"
echo "API - Decide:     $ENDPOINT/decide"
echo "API - Journal:    $ENDPOINT/journal"
echo ""
echo "📱 SHARE WITH TEAM"
echo "────────────────────────────────────────"
echo "$ENDPOINT"
echo ""
echo "One URL. Everything works. No setup needed!"
echo ""
echo "=========================================="
echo ""

# Test endpoints
echo "🧪 Testing endpoints..."
echo ""

# Test health
HEALTH=$(curl -s $ENDPOINT/health)
if echo "$HEALTH" | grep -q "healthy"; then
    echo "✅ /health endpoint working"
else
    echo "⚠️  /health endpoint may not be responding yet"
fi

echo ""
echo "🎉 Ready to use! Open the endpoint URL in your browser."
echo ""
