"""
Example: Query streaming metrics using the insights agent
"""

import sys
import os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from insights_agent.server import ask_question, generate_query, compare_metrics, check_data_quality

def main():
    print("=" * 70)
    print("AI-Assisted Insights Agent - Query Examples")
    print("=" * 70)
    
    # Example 1: Ask a question
    print("\n1. Asking: 'What are total subscribers?'\n")
    result = ask_question("What are total subscribers?", "last 30 days")
    print(f"Answer: {result['answer']}")
    print(f"SQL: {result['sql']}")
    print(f"Confidence: {result['confidence']}")
    
    # Example 2: Generate a query
    print("\n" + "=" * 70)
    print("\n2. Generating query for 'monthly revenue'\n")
    query_result = generate_query("monthly revenue for the last quarter")
    print(f"SQL: {query_result['sql']}")
    print(f"Metric: {query_result['metric_name']}")
    
    # Example 3: Compare metrics
    print("\n" + "=" * 70)
    print("\n3. Comparing churn rate vs engagement rate\n")
    comparison = compare_metrics("churn_rate", "engagement_rate", "last 90 days")
    print(f"Relationship: {comparison['relationship']}")
    print(f"Correlation: {comparison['correlation']}")
    print(f"Insight: {comparison['insight']}")
    
    # Example 4: Check data quality
    print("\n" + "=" * 70)
    print("\n4. Checking data quality for subscribers metric\n")
    quality = check_data_quality("total_subscribers")
    print(f"Quality Score: {quality['quality_score']}/100")
    print(f"Freshness: {quality['freshness']}")
    print(f"Completeness: {quality['completeness']}")
    print(f"Issues: {quality['issues']}")
    
    print("\n" + "=" * 70)
    print("\nDone! All metrics queried successfully.")
    print("=" * 70)

if __name__ == "__main__":
    main()
