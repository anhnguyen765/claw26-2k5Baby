# BabyWhy - Decision Clarity Coach

An AI-powered decision clarity coach for Product Owners, Managers, and Leaders. BabyWhy helps you think through complex product decisions using **structured Socratic questioning**, **emotional signal detection**, and **stakeholder analysis**.

Built as a REST API on **AgentBase Runtime** with **Claude agent integration** via the `.claude/skills/babywhy/` skill.

## 🎯 Core Philosophy

- **Clarity over Comfort** — challenges assumptions over validation
- **Questions before Advice** — explores context before recommending
- **Product-Centric** — reconnects to user value and business outcomes
- **Human Agency** — improves your decision-making, doesn't decide for you

## ⚡ Quick Start

### Test the API

```bash
# Health check
curl https://endpoint-3f1e948d-3509-4189-902d-5d5a173745fa.agentbase-runtime.aiplatform.vngcloud.vn/health

# Analyze a decision
curl -X POST https://endpoint-3f1e948d-3509-4189-902d-5d5a173745fa.agentbase-runtime.aiplatform.vngcloud.vn/decide \
  -H "Content-Type: application/json" \
  -d '{
    "challenge": "Should we prioritize technical debt or new features?",
    "context": "Engineering wants cleanup, sales wants features"
  }'
```

### Run Test Suite

```bash
python3 test_babywhy_agent.py
```

Tests health check, decision analysis, decision saving, and Claude agent simulation.

### Local Development

```bash
# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Create .env file
cp .env.example .env  # Edit with your LLM API credentials

# Run locally
python main.py
# API runs at http://localhost:8080
```

## 🚀 Deployment

Already deployed on **AgentBase Runtime**:
```
https://endpoint-3f1e948d-3509-4189-902d-5d5a173745fa.agentbase-runtime.aiplatform.vngcloud.vn
```

To redeploy with changes:
```bash
bash create_new_runtime.sh
```

## 📡 API Endpoints

### Health Check
```bash
GET /health
```
Returns: `{"status": "healthy", "agent": "BabyWhy", "version": "1.0-phase1"}`

### Analyze Decision
```bash
POST /decide
Content-Type: application/json

{
  "challenge": "Your decision challenge here",
  "context": "Optional context about stakeholders, constraints, etc."
}
```

**Response:**
```json
{
  "challenge": "...",
  "analysis": {
    "emotion": {
      "primary_emotion": "uncertain|frustrated|overwhelmed|...",
      "intensity": 1-10
    },
    "questions": [
      "What evidence supports this?",
      "What alternatives exist?",
      "What's really happening?"
    ]
  },
  "next_steps": [
    "Reflect on the questions",
    "Analyze stakeholders",
    "Reconnect to vision"
  ]
}
```

### Save Decision
```bash
POST /journal
Content-Type: application/json

{
  "decision_summary": "Your decision summary"
}
```

**Response:**
```json
{
  "success": true,
  "decision_id": "decision-2026-06-17T...",
  "message": "Decision saved"
}
```

## 🤖 Claude Agent Integration

BabyWhy is available as a Claude skill at `.claude/skills/babywhy/`

### Using with Claude Code

```bash
/babywhy analyze "Your decision challenge"
/babywhy save "Your decision summary"
/babywhy health
```

Or ask Claude naturally:
> "Help me think through a decision about prioritizing technical debt versus new features. Engineering wants cleanup but sales is pushing for features."

Claude will:
1. Call the BabyWhy API to analyze your decision
2. Report emotional signals and Socratic questions
3. Suggest next reflection steps
4. Optionally save the analysis to the journal

## 🧪 Features

- **Emotional Reflection** — Detects emotional states in challenges
- **Socratic Questioning** — Asks clarifying questions to challenge assumptions
- **Stakeholder Analysis** — Maps stakeholder conflicts and incentives
- **Product Vision Anchoring** — Reconnects decisions to strategic outcomes
- **Decision Journal** — Persists decisions for future pattern analysis

## 📁 Project Structure

```
├── main.py                 # Flask API server
├── requirements.txt        # Python dependencies
├── Dockerfile             # Docker container definition
├── .env.example           # Environment variables template
├── ONBOARDING.md          # User guide
├── DEPLOYMENT_GUIDE.md    # Deployment strategies
├── test_babywhy_agent.py  # Test suite
├── .claude/
│   └── skills/
│       └── babywhy/       # Claude skill integration
│           ├── SKILL.md   # Skill documentation
│           └── babywhy_tools.py  # Tool implementations
└── .claude/skills/agentbase/  # AgentBase platform tools
```

## 🔧 Configuration

See `.env` for environment variables:
- `LLM_API_KEY` — API key for your LLM provider (required)
- `LLM_BASE_URL` — LLM API endpoint (default: GreenNode MaaS)
- `LLM_MODEL` — Model name (default: gpt-5.0-nano)

## 🚨 CORS Support

The API includes CORS headers to allow calls from:
- Claude Code
- Web applications
- Other HTTP clients

All origins are allowed: `Access-Control-Allow-Origin: *`

## 📚 Documentation

- **ONBOARDING.md** — End-user guide for decision analysis
- **DEPLOYMENT_GUIDE.md** — Multiple deployment options
- **SKILL.md** — Claude skill documentation and examples
- **test_babywhy_agent.py** — Test suite and Claude agent examples

## 🐛 Troubleshooting

### API not responding
```bash
curl https://endpoint-3f1e948d-3509-4189-902d-5d5a173745fa.agentbase-runtime.aiplatform.vngcloud.vn/health
```

Should return `{"status": "healthy", ...}`

### CORS errors
The API supports CORS for all origins. If you get CORS errors, ensure:
1. API endpoint is correct in your client
2. Request uses `Content-Type: application/json`
3. API is actually running and responding

### LLM errors
Check your LLM API credentials in `.env`:
```bash
# Test LLM connectivity
curl -X POST $LLM_BASE_URL/chat/completions \
  -H "Authorization: Bearer $LLM_API_KEY" \
  -d '{"model":"$LLM_MODEL","messages":[{"role":"user","content":"test"}]}'
```

## 📊 Status

- ✅ API fully functional with CORS support
- ✅ Tested with Claude agent integration
- ✅ Deployed on AgentBase Runtime
- ✅ Decision journaling working
- ✅ Emotional analysis and Socratic questions enabled

## 🔗 Links

- **Production API**: https://endpoint-3f1e948d-3509-4189-902d-5d5a173745fa.agentbase-runtime.aiplatform.vngcloud.vn
- **GitHub Repo**: https://github.com/anhnguyen765/claw26-2k5Baby
- **AgentBase Console**: https://aiplatform.console.vngcloud.vn/agent-runtime

---

**Version**: 1.0-phase1  
**Status**: Production  
**Last Updated**: 2026-06-17
