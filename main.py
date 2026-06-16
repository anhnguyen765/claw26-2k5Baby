import os
import json
from datetime import datetime
from dotenv import load_dotenv
from flask import Flask, request, jsonify

from langchain_openai import ChatOpenAI

load_dotenv()

# Initialize Flask app (API only)
app = Flask(__name__)

# Initialize LLM first
api_key = os.getenv("LLM_API_KEY") or os.getenv("OPENAI_API_KEY")
if not api_key:
    print("WARNING: LLM_API_KEY not set, using dummy responses")
    llm = None
else:
    llm = ChatOpenAI(
        api_key=api_key,
        base_url=os.getenv("LLM_BASE_URL", "https://maas-llm-aiplatform-hcm.api.vngcloud.vn/v1"),
        model=os.getenv("LLM_MODEL", "gpt-5.0-nano"),
    )


def analyze_challenge(challenge: str, context: str = "") -> dict:
    """Analyze a product decision challenge."""
    if not llm:
        return {
            "emotion": {"primary_emotion": "uncertain", "intensity": 5},
            "questions": ["What evidence supports this?", "What alternatives exist?", "What's really happening?"]
        }

    try:
        emotion_prompt = f"Analyze: {challenge}\nRespond with JSON: {{\"primary_emotion\": \"string\", \"intensity\": 1-10}}"
        emotion_resp = llm.invoke(emotion_prompt)
        emotion_result = json.loads(emotion_resp.content)
    except:
        emotion_result = {"primary_emotion": "uncertain", "intensity": 5}

    try:
        question_prompt = f"Generate 5 questions for: {challenge}\nRespond with JSON: {{\"questions\": [\"q1\", \"q2\", \"q3\", \"q4\", \"q5\"]}}"
        question_resp = llm.invoke(question_prompt)
        question_result = json.loads(question_resp.content)
    except:
        question_result = {"questions": ["What evidence supports this?", "What alternatives exist?", "What's really happening?"]}

    return {
        "emotion": emotion_result,
        "questions": question_result.get("questions", [])
    }


# Create Flask app
app = Flask(__name__)


# Define routes
@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "healthy", "agent": "BabyWhy", "version": "1.0-phase1"}), 200


@app.route("/decide", methods=["POST"])
def handle_decision():
    try:
        data = request.get_json()
        if not data:
            return jsonify({"error": "No JSON data"}), 400

        challenge = data.get("challenge", "")
        context = data.get("context", "")

        if not challenge:
            return jsonify({"error": "Challenge required"}), 400

        analysis = analyze_challenge(challenge, context)

        return jsonify({
            "challenge": challenge,
            "analysis": analysis,
            "next_steps": ["Reflect", "Analyze stakeholders", "Reconnect to vision"]
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/journal", methods=["POST"])
def save_decision():
    return jsonify({
        "success": True,
        "decision_id": f"decision-{datetime.now().isoformat()}",
        "message": "Decision saved"
    }), 200


if __name__ == "__main__":
    print("Starting BabyWhy API on 0.0.0.0:8080")
    print("🔌 API endpoints: /health, /decide, /journal")
    app.run(host="0.0.0.0", port=8080, debug=False)
