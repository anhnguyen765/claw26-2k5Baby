#!/bin/bash
# BabyWhy Deployment Script
# Run this in an environment with Docker installed and IAM credentials configured

set -e

# Configuration
GREENNODE_CLIENT_ID="d41cdbb4-9219-4337-bd28-575743d0a58b"
GREENNODE_CLIENT_SECRET="ebef63f2-50d5-4c3b-8f0c-0dbec643140c"
IMAGE_REGISTRY="vcr.vngcloud.vn"
IMAGE_REPO="111480-abp111770"
IMAGE_NAME="baby-why"
IMAGE_TAG="latest"
RUNTIME_NAME="baby-why"
FLAVOR="runtime-s2-general-2x4"
ENV_FILE=".env"

export GREENNODE_CLIENT_ID
export GREENNODE_CLIENT_SECRET

echo "🚀 BabyWhy Deployment Pipeline"
echo "================================"

# Step 1: Build Docker image
echo ""
echo "📦 Step 1: Building Docker image..."
docker build --platform linux/amd64 -t ${IMAGE_REGISTRY}/${IMAGE_REPO}/${IMAGE_NAME}:${IMAGE_TAG} .
if [ $? -eq 0 ]; then
    echo "✅ Build successful"
else
    echo "❌ Build failed"
    exit 1
fi

# Step 2: Login to Container Registry
echo ""
echo "🔑 Step 2: Logging in to Container Registry..."
bash .claude/skills/agentbase/scripts/cr.sh credentials docker-login
if [ $? -eq 0 ]; then
    echo "✅ Login successful"
else
    echo "❌ Login failed"
    exit 1
fi

# Step 3: Push image
echo ""
echo "📤 Step 3: Pushing image to registry..."
docker push ${IMAGE_REGISTRY}/${IMAGE_REPO}/${IMAGE_NAME}:${IMAGE_TAG}
if [ $? -eq 0 ]; then
    echo "✅ Push successful"
else
    echo "❌ Push failed"
    exit 1
fi

# Step 4: Create runtime
echo ""
echo "⚙️  Step 4: Creating runtime on AgentBase..."
RUNTIME_ID=$(bash .claude/skills/agentbase/scripts/runtime.sh create \
  --name "${RUNTIME_NAME}" \
  --image "${IMAGE_REGISTRY}/${IMAGE_REPO}/${IMAGE_NAME}:${IMAGE_TAG}" \
  --flavor "${FLAVOR}" \
  --env-file "${ENV_FILE}" \
  --from-cr \
  --description "BabyWhy - AI Decision Clarity Coach for Product Owners" \
  --min-replicas 1 \
  --max-replicas 1 \
  --cpu-scale 50 \
  --mem-scale 50 2>&1 | grep -o '"id":"[^"]*"' | cut -d'"' -f4)

if [ -z "$RUNTIME_ID" ]; then
    echo "❌ Runtime creation failed"
    exit 1
fi

echo "✅ Runtime created: $RUNTIME_ID"

# Step 5: Wait for ACTIVE status
echo ""
echo "⏳ Step 5: Waiting for runtime to become ACTIVE..."
MAX_RETRIES=60
RETRY_INTERVAL=5
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    STATUS=$(bash .claude/skills/agentbase/scripts/runtime.sh get $RUNTIME_ID 2>&1 | grep -o '"status":"[^"]*"' | cut -d'"' -f4)

    if [ "$STATUS" = "ACTIVE" ]; then
        echo "✅ Runtime is ACTIVE"
        break
    elif [ "$STATUS" = "ERROR" ] || [ "$STATUS" = "FAILED" ]; then
        echo "❌ Runtime status: $STATUS"
        bash .claude/skills/agentbase/scripts/runtime.sh get $RUNTIME_ID
        exit 1
    else
        echo "   Status: $STATUS (waiting...)"
        sleep $RETRY_INTERVAL
        RETRY_COUNT=$((RETRY_COUNT + 1))
    fi
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo "❌ Runtime did not become ACTIVE within timeout"
    exit 1
fi

# Step 6: Get endpoint URL
echo ""
echo "🌐 Step 6: Getting endpoint URL..."
ENDPOINT_URL=$(bash .claude/skills/agentbase/scripts/runtime.sh endpoints list $RUNTIME_ID 2>&1 | grep -o '"url":"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -z "$ENDPOINT_URL" ]; then
    echo "❌ Could not get endpoint URL"
    exit 1
fi

echo "✅ Endpoint URL: $ENDPOINT_URL"

# Step 7: Test health
echo ""
echo "🏥 Step 7: Testing health endpoint..."
HEALTH_CODE=$(curl -s -o /dev/null -w "%{http_code}" "${ENDPOINT_URL}/health")

if [ "$HEALTH_CODE" = "200" ]; then
    echo "✅ Health check passed"
else
    echo "⚠️  Health check returned: $HEALTH_CODE"
fi

# Final summary
echo ""
echo "================================"
echo "✅ Deployment Complete!"
echo "================================"
echo ""
echo "Summary:"
echo "  Runtime ID:   $RUNTIME_ID"
echo "  Runtime Name: ${RUNTIME_NAME}"
echo "  Endpoint:     ${ENDPOINT_URL}"
echo "  Health:       $HEALTH_CODE"
echo ""
echo "Next steps:"
echo "  1. Test your agent:"
echo "     curl -X POST ${ENDPOINT_URL}/decide \\"
echo "       -H 'Content-Type: application/json' \\"
echo "       -d '{\"challenge\": \"Engineering never listens to product priorities\"}'"
echo ""
echo "  2. Monitor logs:"
echo "     bash .claude/skills/agentbase/scripts/runtime.sh endpoints logs $RUNTIME_ID DEFAULT"
echo ""
echo "  3. View in console:"
echo "     https://aiplatform.console.vngcloud.vn/agent-runtime?tab=runtime"
echo ""
