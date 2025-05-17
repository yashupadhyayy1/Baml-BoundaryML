from baml_client.async_client import b
import asyncio
import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Define math tool functions in Python
def Sum(a, b):
    return a + b

def Subtract(a, b):
    return a - b

def Multiply(a, b):
    return a * b

def Divide(a, b):
    if b == 0:
        raise ValueError("Division by zero is not allowed")
    return a / b

# Map tool names to Python functions
tool_map = {
    "Sum": Sum,
    "Subtract": Subtract,
    "Multiply": Multiply,
    "Divide": Divide,
}

# This function executes the plan entirely in Python without using an LLM
def execute_plan(plan, tool_map):
    """
    Execute a mathematical plan step by step using pure Python functions.
    
    Args:
        plan: A Plan object with calls and explanation
        tool_map: Dictionary mapping tool names to Python functions
        
    Returns:
        The final result of executing all steps in the plan
    """
    final_result = None
    print("\nExecuting steps (pure Python, no LLM):")
    for call in plan.calls:
        tool_func = tool_map.get(call.tool)
        if tool_func:
            result = tool_func(*call.args)
            print(f"  {call.tool}({', '.join(map(str, call.args))}) = {result} | {call.description}")
            final_result = result
        else:
            print(f"  Tool {call.tool} not implemented in Python.")
    return final_result

async def run_test_case(test_case, tools):
    print(f"\n=== Running {test_case['name']} ===")
    
    # PART 1: Generate the plan using BAML and LLM
    print("\n--- PART 1: Plan Generation with LLM ---")
    plan = await b.GenerateMathPlan(instructions=test_case['instructions'], tools=tools)
    print("Plan explanation:", plan.explanation)
    
    # PART 2: Execute the plan using pure Python functions (no LLM)
    print("\n--- PART 2: Plan Execution with Pure Python ---")
    final_result = execute_plan(plan, tool_map)
            
    print("\nFinal result:", final_result)
    if final_result == test_case['expected_output']:
        print("✅ Test passed!")
    else:
        print(f"❌ Test failed! Expected {test_case['expected_output']}, got {final_result}")

async def main():
    tools = [
        {"name": "Multiply", "description": "Multiplies two numbers together"},
        {"name": "Divide", "description": "Divides first number by second number"},
        {"name": "Sum", "description": "Adds two numbers together"},
        {"name": "Subtract", "description": "Subtracts second number from first"},
    ]
    
    test_cases = [
        {
            "name": "Test input 1",
            "instructions": "divide by ten, the sum of 20 and 30",
            "expected_output": 5
        },
        {
            "name": "Test input 2",
            "instructions": "add 20 and 30, divide it by the sum of two and three",
            "expected_output": 10
        },
    ]
    
    for test_case in test_cases:
        await run_test_case(test_case, tools)

if __name__ == "__main__":
    # Run the async main function
    asyncio.run(main())

