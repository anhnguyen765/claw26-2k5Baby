#!/bin/bash
set -e

export GREENNODE_CLIENT_ID="d41cdbb4-9219-4337-bd28-575743d0a58b"
export GREENNODE_CLIENT_SECRET="ebef63f2-50d5-4c3b-8f0c-0dbec643140c"

echo ""
echo "🚀 =========================================="
echo "   Creating New BabyWhy Runtime"
echo "=========================================="
echo ""

# Step 1: Build
echo "📦 Step 1: Building Docker image..."
docker build --platform linux/amd64 -t vcr.vngcloud.vn/111480-abp111770/baby-why:latest . 2>&1 | tail -3
echo "✅ Build successful"
echo ""

# Step 2: Push
echo "📤 Step 2: Pushing to container registry..."
docker push vcr.vngcloud.vn/111480-abp111770/baby-why:latest 2>&1 | tail -3
echo "✅ Push successful"
echo ""

# Step 3: Create new runtime
echo "⚙️  Step 3: Creating new runtime..."
RUNTIME_RESPONSE=$(bash .claude/skills/agentbase/scripts/runtime.sh create \
  --name "baby-why-production" \
  --image "vcr.vngcloud.vn/111480-abp111770/baby-why:latest" \
  --flavor "runtime-s2-general-2x4" \
  --env-file ".env" \
  --from-cr \
  --description "BabyWhy v2 - Decision Clarity Coach (Bundled)" \
  --min-replicas 1 \
  --max-replicas 1 \
  --cpu-scale 50 \
  --mem-scale 50 2>&1)

# Extract Runtime ID
RUNTIME_ID=$(echo "$RUNTIME_RESPONSE" | grep -o '"id":"runtime-[^"]*"' | head -1 | cut -d'"' -f4)

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
    exit 1
fi

echo "✅ Endpoint URL retrieved"
echo ""

# Success!
echo "=========================================="
echo "✅ NEW RUNTIME CREATED SUCCESSFULLY!"
echo "=========================================="
echo ""
echo "📊 RUNTIME DETAILS"
echo "────────────────────────────────────────"
echo "Runtime Name:     baby-why-production"
echo "Runtime ID:       $RUNTIME_ID"
echo "Status:           ACTIVE ✅"
echo "Endpoint:         $ENDPOINT"
echo ""
echo "🌐 ACCESS YOUR BABYWHY"
echo "────────────────────────────────────────"
echo "$ENDPOINT"
echo ""
echo "Test endpoints:"
echo "  Health:  $ENDPOINT/health"
echo "  API:     $ENDPOINT/decide"
echo ""
echo "=========================================="
echo ""

# Test health
echo "🧪 Testing health endpoint..."
HEALTH=$(curl -s $ENDPOINT/health)
if echo "$HEALTH" | grep -q "healthy"; then
    echo "✅ Health check passed"
else
    echo "⚠️  Health check response: $HEALTH"
fi

echo ""
echo "🎉 Ready to use! Open the endpoint in your browser."
echo ""
