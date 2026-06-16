# BabyWhy - AI Decision Clarity Coach

Welcome to **BabyWhy**, your AI-powered decision clarity coach designed specifically for Product Owners, Product Managers, and Product Leaders.

## 🎯 What is BabyWhy?

BabyWhy helps you think more clearly about difficult product decisions by:

- **Detecting emotional signals** in your challenges (frustration, overwhelm, uncertainty)
- **Asking Socratic questions** that challenge assumptions and explore alternatives
- **Providing structured reflection** to transform confusion into clarity
- **Supporting deliberate decision-making** through guided inquiry

Unlike typical AI assistants, BabyWhy doesn't give you quick answers. Instead, it helps **you** make better decisions through deeper thinking.

---

## 🚀 Getting Started

### Live Agent URL
```
https://endpoint-ac02c91a-691a-4f9d-b982-7b00bd9097d3.agentbase-runtime.aiplatform.vngcloud.vn
```

### Available Endpoints

#### 1. **Health Check** (GET)
Check if the agent is running:
```bash
curl https://endpoint-ac02c91a-691a-4f9d-b982-7b00bd9097d3.agentbase-runtime.aiplatform.vngcloud.vn/health
```

**Response:**
```json
{
  "agent": "BabyWhy",
  "status": "healthy",
  "version": "1.0-phase1"
}
```

---

#### 2. **Decision Analysis** (POST /decide)
Analyze a product decision challenge and get Socratic insights.

**Request:**
```bash
curl -X POST https://endpoint-ac02c91a-691a-4f9d-b982-7b00bd9097d3.agentbase-runtime.aiplatform.vngcloud.vn/decide \
  -H "Content-Type: application/json" \
  -d '{
    "challenge": "Engineering never listens to product priorities",
    "context": "Optional: additional context about the situation"
  }'
```

**Parameters:**
- `challenge` (required) - Your product decision challenge or concern
- `context` (optional) - Additional background information

**Response:**
```json
{
  "challenge": "Engineering never listens to product priorities",
  "analysis": {
    "emotion": {
      "primary_emotion": "frustrated",
      "intensity": 7
    },
    "questions": [
      "What evidence directly supports this interpretation?",
      "Can you recall situations where engineering did align with product?",
      "What alternative explanations exist for this pattern?",
      "What would need to change for your perspective to shift?",
      "If you removed emotion from this, what remains as fact?"
    ]
  },
  "next_steps": [
    "Reflect on the Socratic questions",
    "Consider stakeholder perspectives",
    "Reconnect to product vision",
    "Document your decision"
  ]
}
```

---

#### 3. **Decision Journal** (POST /journal)
Save your decision analysis for future reference.

**Request:**
```bash
curl -X POST https://endpoint-ac02c91a-691a-4f9d-b982-7b00bd9097d3.agentbase-runtime.aiplatform.vngcloud.vn/journal \
  -H "Content-Type: application/json" \
  -d '{
    "challenge": "Engineering never listens to product priorities",
    "context": "Q3 planning discussion",
    "decision": "Implement weekly sync between engineering and product",
    "reasoning": "Clear communication channel reduces misalignment",
    "expected_outcome": "Improved alignment and faster prioritization",
    "assumptions_made": ["Weekly syncs will be attended", "Issues can be resolved in meetings"]
  }'
```

**Response:**
```json
{
  "success": true,
  "decision_id": "decision-2026-06-16T16:50:00",
  "message": "Decision saved"
}
```

---

## 💡 Use Cases & Examples

### Example 1: Stakeholder Conflict
**Challenge:** "Sales wants features we haven't prioritized, but engineering says they'll delay critical infrastructure work"

**What BabyWhy does:**
- Detects the underlying conflict and urgency
- Asks questions like: "What would happen if we delayed infrastructure work?" and "What's the revenue impact of each option?"
- Helps you think through stakeholder incentives
- Guides you toward a decision that considers all perspectives

### Example 2: Decision Fatigue
**Challenge:** "I'm exhausted making the same prioritization decisions every day. Nothing feels right anymore"

**What BabyWhy does:**
- Recognizes burnout signals in your language
- Asks clarifying questions about the root cause
- Helps you distinguish between decision fatigue and legitimate concern
- Guides you toward understanding what's really happening

### Example 3: Uncertain Product Direction
**Challenge:** "We're not sure if we should pivot toward AI features or focus on our core product stability"

**What BabyWhy does:**
- Asks you to articulate evidence for each option
- Questions your assumptions about customer needs
- Helps you reconnect to your product vision
- Guides you through exploring alternatives

---

## 🎯 Best Practices

### 1. **Be Specific**
Good challenge:
> "Engineering says implementing this feature will take 3 weeks and require refactoring, but sales committed to a customer we can deliver in 1 week"

Less helpful:
> "Engineering doesn't listen"

### 2. **Include Context**
BabyWhy works better when you provide background:
```json
{
  "challenge": "Should we build a custom integration or use a third-party API?",
  "context": "We have limited engineering bandwidth this quarter. The custom solution would be more flexible but require 2 months of work."
}
```

### 3. **Follow the Socratic Questions**
Don't just read the questions — actually reflect on them:
- Write down your honest answers
- Challenge your own assumptions
- Look for evidence that contradicts your initial view

### 4. **Use the Decision Journal**
Save your decisions with reasoning. Later, you can:
- Review how well your assumptions held up
- Learn from past decisions
- Spot patterns in your decision-making
- Share reasoning with your team

---

## 🔄 The BabyWhy Process

```
1. YOU DESCRIBE → Your product challenge or decision
                  ↓
2. BABYWHY ANALYZES → Emotional signals, assumptions, patterns
                      ↓
3. BABYWHY QUESTIONS → Socratic questions to challenge thinking
                       ↓
4. YOU REFLECT → Answer the questions honestly
                ↓
5. YOU DECIDE → Make a more informed decision
               ↓
6. YOU DOCUMENT → Save your reasoning in the journal
```

---

## 📋 Core Principles

### Clarity Over Comfort
BabyWhy won't validate your emotions or tell you what you want to hear. It seeks truth.

### Questions Before Advice
Rather than prescribing solutions, BabyWhy helps **you** think more deeply.

### Product-Centric Thinking
Every decision connects back to user value and business outcomes.

### Human Agency
BabyWhy improves your ability to decide — it doesn't make decisions for you.

---

## 🛠️ Integration

### Using with cURL
```bash
curl -X POST https://endpoint-ac02c91a-691a-4f9d-b982-7b00bd9097d3.agentbase-runtime.aiplatform.vngcloud.vn/decide \
  -H "Content-Type: application/json" \
  -d '{"challenge": "Your decision challenge"}'
```

### Using with Python
```python
import requests
import json

endpoint = "https://endpoint-ac02c91a-691a-4f9d-b982-7b00bd9097d3.agentbase-runtime.aiplatform.vngcloud.vn"

# Get analysis
response = requests.post(
    f"{endpoint}/decide",
    json={"challenge": "Your product challenge here"}
)
analysis = response.json()
print(json.dumps(analysis, indent=2))

# Save to journal
journal_response = requests.post(
    f"{endpoint}/journal",
    json={
        "challenge": "Your challenge",
        "decision": "Your decision",
        "reasoning": "Why you decided this"
    }
)
```

### Using with JavaScript
```javascript
const endpoint = "https://endpoint-ac02c91a-691a-4f9d-b982-7b00bd9097d3.agentbase-runtime.aiplatform.vngcloud.vn";

// Get analysis
fetch(`${endpoint}/decide`, {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    challenge: "Your product challenge here"
  })
})
.then(res => res.json())
.then(data => console.log(data));
```

---

## ❓ FAQ

**Q: Will BabyWhy tell me what decision to make?**  
A: No. BabyWhy helps you think more clearly so *you* can make better decisions.

**Q: Can I use BabyWhy for non-product decisions?**  
A: Yes! The Socratic process works for any complex decision with competing priorities.

**Q: How do I share decisions with my team?**  
A: Save decisions in the journal and share the decision ID with your team. They can reference your reasoning.

**Q: Is my data private?**  
A: Your challenges and decisions are processed through the agent. Please don't share sensitive information.

**Q: How long does analysis take?**  
A: Typically 2-5 seconds depending on the complexity of your challenge.

---

## 🔗 Resources

- **Status & Monitoring**: https://aiplatform.console.vngcloud.vn/agent-runtime
- **Documentation**: See the project README for technical details
- **Feedback**: Report issues or suggest improvements

---

## 🎓 Learn More

### The Socratic Method
The Socratic method is an ancient form of inquiry that challenges assumptions through dialogue. BabyWhy uses this approach to help you:
- Examine your beliefs
- Identify hidden assumptions
- Explore alternative perspectives
- Reach deeper understanding

### Product Decision Frameworks
Consider pairing BabyWhy with frameworks like:
- **Jobs to Be Done** - Understand what customers actually need
- **Stakeholder Analysis** - Map competing interests
- **Value vs. Effort Matrix** - Prioritize effectively
- **Decision Journal** - Track and learn from decisions

---

## 🚀 Get Started Now

1. **Ask your first question:**
```bash
curl -X POST https://endpoint-ac02c91a-691a-4f9d-b982-7b00bd9097d3.agentbase-runtime.aiplatform.vngcloud.vn/decide \
  -H "Content-Type: application/json" \
  -d '{"challenge": "What should I decide today?"}'
```

2. **Reflect on the Socratic questions** — spend 5 minutes thinking deeply about each one

3. **Make your decision** — with more clarity and confidence

4. **Save your reasoning** — document why you decided, so you can learn later

---

**Version:** 1.0-phase1  
**Last Updated:** June 16, 2026  
**Agent Status:** Active ✅
