#!/usr/bin/env python3
"""
Test BabyWhy Agent - Tests Claude integration with BabyWhy API

This script demonstrates how Claude can use BabyWhy tools to analyze
product decisions through Socratic questioning and emotional signal detection.
"""

import json
import subprocess
import sys

def call_api(endpoint, method="GET", data=None):
    """Call BabyWhy API using curl"""
    api_url = "https://endpoint-3f1e948d-3509-4189-902d-5d5a173745fa.agentbase-runtime.aiplatform.vngcloud.vn"

    cmd = ["curl", "-s"]

    if method == "POST":
        cmd.extend(["-X", "POST"])
        cmd.append(f"{api_url}{endpoint}")
        cmd.extend(["-H", "Content-Type: application/json"])
        cmd.extend(["-d", json.dumps(data)])
    else:
        cmd.append(f"{api_url}{endpoint}")

    result = subprocess.run(cmd, capture_output=True, text=True)

    try:
        return json.loads(result.stdout)
    except json.JSONDecodeError:
        return {"error": result.stdout, "stderr": result.stderr}


def test_health():
    """Test health endpoint"""
    print("🏥 Testing Health Endpoint...")
    result = call_api("/health")

    if result.get("status") == "healthy":
        print(f"✅ API is healthy: {result}")
        return True
    else:
        print(f"❌ Health check failed: {result}")
        return False


def test_analyze_decision():
    """Test decision analysis"""
    print("\n🧠 Testing Decision Analysis...")

    test_cases = [
        {
            "challenge": "Should we prioritize technical debt or new features?",
            "context": "Engineering wants cleanup, sales wants features"
        },
        {
            "challenge": "How do I navigate conflicting stakeholder needs?",
            "context": "CEO wants growth, compliance wants caution"
        },
        {
            "challenge": "Should we hire more PMs or focus on tools?",
            "context": "Team is stretched thin"
        }
    ]

    for i, test_case in enumerate(test_cases, 1):
        print(f"\n  Test {i}: {test_case['challenge']}")
        result = call_api("/decide", method="POST", data=test_case)

        if "error" in result:
            print(f"    ❌ Error: {result['error']}")
            return False

        analysis = result.get("analysis", {})
        emotion = analysis.get("emotion", {})
        questions = analysis.get("questions", [])

        print(f"    Emotion: {emotion.get('primary_emotion')} (intensity: {emotion.get('intensity')}/10)")
        print(f"    Questions: {len(questions)} generated")
        for q in questions[:2]:
            print(f"      - {q}")
        if len(questions) > 2:
            print(f"      ... and {len(questions) - 2} more")

    return True


def test_save_decision():
    """Test decision saving"""
    print("\n💾 Testing Decision Save...")

    result = call_api("/journal", method="POST", data={
        "decision_summary": "Prioritized technical debt for Q3 2026"
    })

    if result.get("success"):
        print(f"✅ Decision saved: {result.get('decision_id')}")
        return True
    else:
        print(f"❌ Save failed: {result}")
        return False


def simulate_claude_agent():
    """Simulate how Claude would interact with BabyWhy"""
    print("\n🤖 Simulating Claude Agent Interaction...")
    print("\n--- Claude Agent Transcript ---\n")

    user_challenge = "Engineering team wants to refactor our codebase but sales is pushing for new customer features. I'm torn between both."

    print(f"👤 User: {user_challenge}\n")

    # Claude would call analyze_decision
    print("🧠 Claude: Let me analyze this decision for you.\n")

    result = call_api("/decide", method="POST", data={
        "challenge": user_challenge,
        "context": "Product owner with 5 engineers"
    })

    if "error" not in result:
        analysis = result.get("analysis", {})
        emotion = analysis.get("emotion", {})
        questions = analysis.get("questions", [])
        next_steps = result.get("next_steps", [])

        print(f"**Detected Emotion**: {emotion.get('primary_emotion').title()} (intensity: {emotion.get('intensity')}/10)")
        print("\nI see you're experiencing some uncertainty here, which is natural when balancing competing priorities.")
        print("\n**Key Questions to Consider**:")
        for i, q in enumerate(questions, 1):
            print(f"{i}. {q}")

        print("\n**Suggested Next Steps**:")
        for step in next_steps:
            print(f"- {step}")

        print("\n💡 Claude: Once you've reflected on these questions, I can help you save your decision analysis.")

        # Claude would call save_decision
        save_result = call_api("/journal", method="POST", data={
            "decision_summary": "Evaluating technical debt vs new features trade-off"
        })

        if save_result.get("success"):
            print(f"✅ Analysis saved to journal: {save_result.get('decision_id')}")

        return True
    else:
        print(f"❌ Error: {result}")
        return False


def main():
    """Run all tests"""
    print("=" * 60)
    print("BabyWhy Agent Test Suite")
    print("=" * 60)

    tests = [
        ("Health Check", test_health),
        ("Decision Analysis", test_analyze_decision),
        ("Decision Save", test_save_decision),
        ("Claude Agent Simulation", simulate_claude_agent)
    ]

    results = {}
    for test_name, test_func in tests:
        try:
            results[test_name] = test_func()
        except Exception as e:
            print(f"❌ {test_name} failed with error: {e}")
            results[test_name] = False

    # Summary
    print("\n" + "=" * 60)
    print("Test Summary")
    print("=" * 60)

    for test_name, passed in results.items():
        status = "✅ PASS" if passed else "❌ FAIL"
        print(f"{status}: {test_name}")

    all_passed = all(results.values())

    print("\n" + "=" * 60)
    if all_passed:
        print("✅ All tests passed! BabyWhy is ready for Claude integration.")
    else:
        print("❌ Some tests failed. Check the output above.")
    print("=" * 60)

    return 0 if all_passed else 1


if __name__ == "__main__":
    sys.exit(main())
