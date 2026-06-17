# BabyWhy - Decision Clarity Coach

AI-powered decision clarity coach for Product Owners, designed to improve decision quality through structured Socratic questioning, emotional analysis, and stakeholder mapping.

## Quick Start

### Local Development

```bash
# Create virtual environment
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Configure environment
cp .env.example .env  # Then edit with your LLM credentials

# Run locally
python main.py
```

Agent will start at `http://localhost:8080`

### Health Check
```bash
curl http://localhost:8080/health
```

### Use the Agent
```bash
curl -X POST http://localhost:8080/decide \
  -H "Content-Type: application/json" \
  -d '{"challenge": "Engineering never listens to product priorities"}'
```

## Features

- **Emotional Reflection** - Detect emotional signals in challenges
- **Socratic Questioning** - Challenge assumptions with guided questions
- **Stakeholder Analysis** - Map stakeholders and their competing interests
- **Product Alignment** - Reconnect decisions to strategic outcomes
- **Decision Journal** - Track and reflect on past decisions

## Architecture

Multi-agent system with specialized agents:

1. **Emotional Reflection Agent** - Emotion detection, cognitive labeling
2. **Socratic Coach Agent** - Assumption testing, perspective exploration
3. **Stakeholder Strategy Agent** - Stakeholder mapping, conflict identification
4. **Product Alignment Agent** - User value validation, vision alignment
5. **Decision Historian Agent** - Session memory, decision tracking, trend analysis

## Deployment

### Docker Build
```bash
docker build -t baby-why:latest .
docker run -p 8080:8080 --env-file .env baby-why:latest
```

### Deploy to AgentBase
```bash
agentbase-wizard
# Or continue with: agentbase-deploy
```

## Configuration

See `.env` for required environment variables:
- `LLM_API_KEY` - API key for your LLM provider
- `LLM_BASE_URL` - Base URL for LLM API
- `LLM_MODEL` - Model name (default: gpt-4o)
- `MEMORY_ID` - Optional AgentBase memory ID

## API Endpoints

- `GET /health` - Health check
- `POST /decide` - Submit a decision challenge

## Development

For more details, see the AgentBase documentation and LangGraph guide.
