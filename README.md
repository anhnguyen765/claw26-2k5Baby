# BabyWhy - Decision Clarity Coach

## The Problem

You're facing a tough decision. Engineering wants to tackle technical debt. Sales wants new features. The board is pushing for growth. Your instinct says one thing; the data suggests another.

You're stuck because:
- You have conflicting input from stakeholders
- You can't tell if you're deciding from fear, hope, or clarity
- There's no structure—just internal back-and-forth that drains energy

What you need is someone to ask you the right questions, not tell you what to do.

## What BabyWhy Does

BabyWhy is an **AI decision coach** that uses Socratic questioning to help you think through complex product and leadership decisions. Instead of advice, it offers:

- **Clarity on what's really at stake** — emotional signals that reveal hidden assumptions
- **Better questions** — structured questioning that challenges your thinking  
- **Stakeholder mapping** — understanding who wants what and why
- **A decision journal** — track your thinking over time to spot patterns

It's built for Product Owners, Managers, and Leaders who make decisions that matter.

## How to Use It

### Option 1: Web API (Fastest)

Post your decision challenge to the live API:

```bash
curl -X POST https://endpoint-3f1e948d-3509-4189-902d-5d5a173745fa.agentbase-runtime.aiplatform.vngcloud.vn/decide \
  -H "Content-Type: application/json" \
  -d '{
    "challenge": "Should we prioritize technical debt or new features?",
    "context": "Engineering wants cleanup, sales wants new features"
  }'
```

You'll get back:
- Emotional signals (uncertainty, frustration, clarity)
- Probing questions to sharpen your thinking
- Next steps for reflection

### Option 2: Claude Code (Natural Language)

If you use Claude Code, just ask naturally:

```
/babywhy "Help me think through prioritizing technical debt vs new features. Engineering wants cleanup but sales is pushing for features."
```

Claude will call the API and give you the analysis, plus help you reflect on the questions.

### Option 3: Run Locally

For development or private deployment:

```bash
# Setup
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Create .env with your LLM API credentials
# (template in .env)

# Run
python main.py
# API runs at http://localhost:8080
```

## Core Principles

- **Clarity over Comfort** — BabyWhy challenges assumptions, not validates them
- **Questions before Advice** — Explores context before recommending
- **Product-Centric** — Reconnects decisions to user value and business outcomes
- **Human Agency** — Improves your decision-making; doesn't decide for you

## API Endpoints

**Health Check**
```bash
GET /health
```

**Analyze a Decision**
```bash
POST /decide
{
  "challenge": "Your decision challenge",
  "context": "Optional context (stakeholders, constraints, etc.)"
}
```

**Save to Your Decision Journal**
```bash
POST /journal
{
  "decision_summary": "What you decided and why"
}
```

See the [API responses](README.md#api-endpoints-expanded) for full schema.

## Production Endpoint

```
https://endpoint-3f1e948d-3509-4189-902d-5d5a173745fa.agentbase-runtime.aiplatform.vngcloud.vn
```

Test it:
```bash
curl https://endpoint-3f1e948d-3509-4189-902d-5d5a173745fa.agentbase-runtime.aiplatform.vngcloud.vn/health
```

## Features

- **Emotional Reflection** — Identifies emotional signals in your challenge
- **Socratic Questions** — Asks clarifying questions to test assumptions
- **Stakeholder Analysis** — Maps stakeholder incentives and conflicts
- **Product Vision Anchoring** — Reconnects to strategic outcomes
- **Decision Journal** — Persist decisions for pattern analysis over time

## Troubleshooting

### API not responding?
```bash
curl https://endpoint-3f1e948d-3509-4189-902d-5d5a173745fa.agentbase-runtime.aiplatform.vngcloud.vn/health
```

Should return `{"status": "healthy", ...}`

### Getting CORS errors?
The API allows all origins. Check:
1. Your endpoint URL is correct
2. Request is `POST` with `Content-Type: application/json`
3. API is actually running

### LLM connection issues?
Check `.env` has your valid LLM API credentials.

## Get Started Now

1. **Try it immediately**: Copy-paste the curl command above
2. **Integrate it**: Use the `/babywhy` Claude skill or HTTP endpoint
3. **Run locally**: Follow the local setup section

---

**Status**: Production Ready  
**Built with**: Python, Flask, Claude AI  
**Deployed on**: AgentBase Runtime  
**Last Updated**: June 2026
