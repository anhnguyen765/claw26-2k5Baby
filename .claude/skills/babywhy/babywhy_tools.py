"""
BabyWhy Decision Clarity Coach - Claude Integration Tools

This module provides Claude tools to integrate with the BabyWhy API for
decision analysis, emotional signal detection, and decision journaling.
"""

import os
import json
import requests
from typing import Optional, Dict, Any

# Configuration
BABYWHY_API_ENDPOINT = os.getenv(
    "BABYWHY_API_ENDPOINT",
    "https://endpoint-3f1e948d-3509-4189-902d-5d5a173745fa.agentbase-runtime.aiplatform.vngcloud.vn"
)

TIMEOUT = 30  # API call timeout in seconds


def health_check() -> Dict[str, Any]:
    """
    Check if the BabyWhy API is healthy and accessible.

    Returns:
        dict: Health status with agent info and version
    """
    try:
        response = requests.get(
            f"{BABYWHY_API_ENDPOINT}/health",
            timeout=TIMEOUT
        )
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        return {
            "status": "error",
            "message": f"API health check failed: {str(e)}",
            "endpoint": BABYWHY_API_ENDPOINT
        }


def analyze_decision(
    challenge: str,
    context: str = ""
) -> Dict[str, Any]:
    """
    Analyze a product decision challenge using BabyWhy's AI engine.

    Performs:
    - Emotional signal detection
    - Socratic questioning
    - Assumption identification
    - Next steps recommendation

    Args:
        challenge (str): The decision challenge or situation to analyze
        context (str, optional): Additional context about the decision

    Returns:
        dict: Analysis including emotions, questions, and next steps

    Example:
        >>> result = analyze_decision(
        ...     "Should we prioritize technical debt or new features?",
        ...     "Engineering wants cleanup, sales wants features"
        ... )
        >>> print(result['analysis']['emotion'])
        {'primary_emotion': 'frustrated', 'intensity': 7}
    """
    try:
        payload = {"challenge": challenge}
        if context:
            payload["context"] = context

        response = requests.post(
            f"{BABYWHY_API_ENDPOINT}/decide",
            json=payload,
            timeout=TIMEOUT
        )
        response.raise_for_status()
        return response.json()

    except requests.exceptions.RequestException as e:
        return {
            "error": str(e),
            "challenge": challenge,
            "message": "Failed to analyze decision"
        }


def save_decision(
    decision_summary: str,
    analysis_data: Optional[Dict[str, Any]] = None,
    resolution: str = ""
) -> Dict[str, Any]:
    """
    Save a decision analysis to the BabyWhy decision journal.

    Persists decisions for future reference and pattern identification.

    Args:
        decision_summary (str): Brief summary of the decision made
        analysis_data (dict, optional): The analysis output from analyze_decision
        resolution (str, optional): How the decision was ultimately resolved

    Returns:
        dict: Confirmation with decision ID

    Example:
        >>> save_decision(
        ...     "Chose to prioritize technical debt for Q2",
        ...     analysis_data={"emotion": {...}, "questions": [...]},
        ...     resolution="Negotiated with sales for phased feature delivery"
        ... )
    """
    try:
        payload = {"decision_summary": decision_summary}
        if analysis_data:
            payload["analysis"] = analysis_data
        if resolution:
            payload["resolution"] = resolution

        response = requests.post(
            f"{BABYWHY_API_ENDPOINT}/journal",
            json=payload,
            timeout=TIMEOUT
        )
        response.raise_for_status()
        return response.json()

    except requests.exceptions.RequestException as e:
        return {
            "error": str(e),
            "decision_summary": decision_summary,
            "message": "Failed to save decision"
        }


def format_analysis_for_claude(analysis: Dict[str, Any]) -> str:
    """
    Format BabyWhy analysis output for readable Claude response.

    Args:
        analysis (dict): Raw analysis from analyze_decision

    Returns:
        str: Formatted markdown for Claude
    """
    if "error" in analysis:
        return f"❌ Error: {analysis.get('message', 'Unknown error')}"

    output = []

    # Challenge
    if "challenge" in analysis:
        output.append(f"**Challenge**: {analysis['challenge']}\n")

    # Emotional Signal
    if "analysis" in analysis and "emotion" in analysis["analysis"]:
        emotion = analysis["analysis"]["emotion"]
        output.append(f"**Emotional Signal**: {emotion.get('primary_emotion', 'unknown')} (intensity: {emotion.get('intensity', '?')}/10)\n")

    # Socratic Questions
    if "analysis" in analysis and "questions" in analysis["analysis"]:
        output.append("**Reflection Questions**:")
        for i, q in enumerate(analysis["analysis"]["questions"], 1):
            output.append(f"{i}. {q}")
        output.append("")

    # Next Steps
    if "next_steps" in analysis:
        output.append("**Suggested Next Steps**:")
        for i, step in enumerate(analysis["next_steps"], 1):
            output.append(f"{i}. {step}")
        output.append("")

    return "\n".join(output)


# Tool definitions for Claude integration
BABYWHY_TOOLS = {
    "analyze_decision": {
        "description": "Analyze a product decision challenge with BabyWhy's AI engine. Gets emotional insights and Socratic questions to help think through the decision.",
        "parameters": {
            "type": "object",
            "properties": {
                "challenge": {
                    "type": "string",
                    "description": "The decision challenge or situation you need to think through (e.g., 'Should we prioritize technical debt or new features?')"
                },
                "context": {
                    "type": "string",
                    "description": "Optional context about the decision (e.g., stakeholder positions, constraints, business impact)"
                }
            },
            "required": ["challenge"]
        },
        "function": analyze_decision
    },
    "save_decision": {
        "description": "Save a decision to the BabyWhy decision journal for future reference and pattern tracking.",
        "parameters": {
            "type": "object",
            "properties": {
                "decision_summary": {
                    "type": "string",
                    "description": "Brief summary of the decision made"
                },
                "resolution": {
                    "type": "string",
                    "description": "Optional: How the decision was ultimately resolved"
                }
            },
            "required": ["decision_summary"]
        },
        "function": save_decision
    },
    "health_check": {
        "description": "Check if the BabyWhy API is accessible and healthy.",
        "parameters": {
            "type": "object",
            "properties": {},
            "required": []
        },
        "function": health_check
    }
}


if __name__ == "__main__":
    # Quick test
    print("🏥 BabyWhy Health Check...")
    health = health_check()
    print(json.dumps(health, indent=2))

    if health.get("status") == "healthy":
        print("\n🚀 Testing analyze_decision...")
        result = analyze_decision(
            "Engineering wants to refactor our codebase but sales is pushing for new features",
            "We have 2 engineers and limited time"
        )
        print(format_analysis_for_claude(result))
