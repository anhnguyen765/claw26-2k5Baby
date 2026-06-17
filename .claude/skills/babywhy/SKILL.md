# BabyWhy Decision Clarity Coach

A Claude skill that integrates with the BabyWhy AI Decision Clarity Coach API to help Product Owners, Managers, and Leaders think through complex product decisions with structured Socratic questioning.

## Overview

BabyWhy provides:
- **Emotional Signal Detection** — identifies emotional states in decisions
- **Socratic Reflection** — asks clarifying questions to challenge assumptions
- **Stakeholder Analysis** — maps stakeholder conflicts and incentives
- **Decision Journaling** — persists decisions for future reference
- **Product Vision Anchoring** — reconnects to strategic outcomes

## API Endpoints

- **Health**: `GET /health` — Check API status
- **Analyze Decision**: `POST /decide` — Get emotional analysis and Socratic questions
- **Save Decision**: `POST /journal` — Persist decision to history

## Configuration

Set the API endpoint via environment variable or configuration:

```bash
export BABYWHY_API_ENDPOINT="https://endpoint-3f1e948d-3509-4189-902d-5d5a173745fa.agentbase-runtime.aiplatform.vngcloud.vn"
```

If not set, defaults to the production endpoint.

## Available Tools

### analyze_decision
Analyze a product decision challenge using BabyWhy's AI engine.

**Usage**: Ask Claude to analyze a decision, stakeholder conflict, or product challenge.

**Input**:
- `challenge` (string): Your decision challenge or situation
- `context` (string, optional): Additional context about the decision

**Output**:
```json
{
  "challenge": "Your decision challenge",
  "analysis": {
    "emotion": {
      "primary_emotion": "string (e.g., frustrated, overwhelmed)",
      "intensity": "1-10 scale"
    },
    "questions": ["Question 1", "Question 2", "Question 3", ...]
  },
  "next_steps": ["Step 1", "Step 2", "Step 3"]
}
```

**Example**:
> I'm struggling with a decision between investing in technical debt cleanup vs. building new features. Engineering says we need the cleanup, but sales is pushing for new features. Our VP wants both.

Claude will call `analyze_decision` with:
- challenge: "Should we prioritize technical debt cleanup or new features?"
- context: "Engineering wants cleanup, sales wants features, VP wants both"

### save_decision
Save a decision analysis to the decision journal for future reference.

**Usage**: After analyzing a decision, ask Claude to save it.

**Input**:
- `decision_summary` (string): Brief summary of the decision
- `analysis_data` (object): The analysis from `analyze_decision`
- `resolution` (string, optional): How the decision was ultimately resolved

**Output**:
```json
{
  "success": true,
  "decision_id": "decision-2026-06-17T...",
  "message": "Decision saved"
}
```

## Example Interactions

### Example 1: Analyzing a Decision

**User**: I need help thinking through a product decision. We're a SaaS company and our biggest customer is asking for a custom feature that would take 3 months to build. It's valuable but would delay our public roadmap.

**Claude** (using BabyWhy):
1. Calls `analyze_decision` with your challenge
2. Reports back emotional signals (likely frustration, pressure)
3. Shares Socratic questions from BabyWhy:
   - "What evidence shows this customer is critical to our business?"
   - "What opportunities cost us by delaying the roadmap?"
   - "Is there a hybrid approach (smaller scope, phased delivery)?"
4. Suggests next steps: document stakeholder needs, analyze revenue impact, explore compromises

### Example 2: Stakeholder Conflict

**User**: Our compliance team and engineering team have completely opposite views on a security architecture decision. How do I navigate this?

**Claude** (using BabyWhy):
1. Analyzes the decision challenge
2. Reports emotional signals (frustration, anxiety about conflict)
3. Shares questions designed to reframe the conflict:
   - "What shared outcome do both teams care about?" (both want security, stability)
   - "What are the underlying fears/constraints for each team?"
   - "Where might you find a solution that addresses both?"

## Integration with Claude

This skill automatically registers tools with Claude. When you ask Claude about product decisions, stakeholder conflicts, or strategic product challenges, Claude will:

1. Recognize when to use BabyWhy's analysis
2. Call the appropriate endpoint
3. Interpret the response and discuss with you
4. Optionally save decisions to the journal

## Command Reference

### Skill Usage

```
/babywhy analyze "Your decision challenge here"
/babywhy save "Your decision summary"
/babywhy health
```

Or just ask Claude naturally:

> "Help me think through a decision about prioritizing technical debt."

Claude will use the BabyWhy tools automatically.

## Rate Limits & Status

- **Health Check**: `GET /health` returns `{"status": "healthy", "agent": "BabyWhy"}`
- **API Rate**: No enforced limits (depends on AgentBase runtime configuration)
- **Endpoint**: Production endpoint configured in environment

## Troubleshooting

### API Not Responding
```bash
curl -s https://endpoint-3f1e948d-3509-4189-902d-5d5a173745fa.agentbase-runtime.aiplatform.vngcloud.vn/health
```

Should return: `{"status": "healthy", "agent": "BabyWhy", "version": "1.0-phase1"}`

### API Key / Authentication
BabyWhy API is publicly accessible (no authentication required). If you need to restrict access, contact your AgentBase administrator.

### Decision Not Saved
Check the `/journal` endpoint is reachable and the decision summary is clear.

## Integration Examples

### With LangChain
```python
from langchain.tools import tool
import requests

@tool
def analyze_decision_tool(challenge: str, context: str = "") -> dict:
    """Analyze a product decision using BabyWhy"""
    response = requests.post(
        f"{BABYWHY_ENDPOINT}/decide",
        json={"challenge": challenge, "context": context}
    )
    return response.json()
```

### With LangGraph
```python
from langgraph.graph import StateGraph

def analyze_node(state):
    challenge = state.get("challenge")
    result = requests.post(
        f"{BABYWHY_ENDPOINT}/decide",
        json={"challenge": challenge}
    )
    state["analysis"] = result.json()
    return state
```

## Support

- **API Status**: https://aiplatform.console.vngcloud.vn/agent-runtime
- **GitHub Repo**: https://github.com/anhnguyen765/claw26-2k5Baby
- **Issues/Feedback**: Contact the product team

---

**Version**: 1.0-phase1  
**Last Updated**: 2026-06-17  
**API Endpoint**: https://endpoint-3f1e948d-3509-4189-902d-5d5a173745fa.agentbase-runtime.aiplatform.vngcloud.vn
