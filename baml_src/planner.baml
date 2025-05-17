// Defining math tool classes
class MathTool {
  name string
  description string
}

class ToolCall {
  tool string
  args float[]
  description string
}

class Plan {
  calls ToolCall[]
  explanation string
}

// Define the Planner function that will generate a plan of tool calls
function GenerateMathPlan(instructions: string, tools: MathTool[]) -> Plan {
  client CustomGPT4oMini // Using the same client as in resume.baml

  prompt #"
    You are a planning assistant that takes natural language instructions and available tools,
    and generates a plan of tool calls to fulfill the instructions.
    
    {{ ctx.output_format }}
    
    {{_.role("user")}}
    Available tools:
    {{ tools }}
    
    Instructions:
    {{ instructions }}
    
    Generate a plan using these tools. The plan should be a list of tool calls with proper arguments.
    Each tool call should include which tool to use, what arguments to pass, and a brief description of what this step achieves.
    Also include an overall explanation of the plan.

    Format your response as a structured JSON object with this schema:
    {
      "calls": [
        {
          "tool": "tool_name",
          "args": [number1, number2, ...],
          "description": "Description of what this call achieves"
        }
      ],
      "explanation": "Overall explanation of the plan"
    }
  "#
}

// Test case for the planner with addition
test simple_math_plan {
  functions [GenerateMathPlan]
  args {
    instructions "add 42 and 58"
    tools [
      {
        name "Sum"
        description "Adds two numbers together"
      }
    ]
  }
}

// Test cases for the planner
test simple_addition_plan {
  functions [GenerateMathPlan]
  args {
    instructions "add 42 and 58"
    tools [
      {
        name "Sum"
        description "Adds two numbers together"
      }
    ]
  }
}

test multi_step_calculation {
  functions [GenerateMathPlan]
  args {
    instructions "multiply 10 and 5, then subtract 15"
    tools [
      {
        name "Multiply"
        description "Multiplies two numbers together"
      },
      {
        name "Subtract"
        description "Subtracts second number from first"
      }
    ]
  }
}
