# Superfuel Assignment - Mathematical Planner

This project demonstrates a two-step approach to mathematical planning:
1. Using an LLM (via BAML) to generate a plan with steps
2. Executing the plan with pure Python functions

## Project Setup

### Prerequisites

- Python 3.10+
- [Poetry](https://python-poetry.org/docs/#installation) for dependency management
- OpenAI API key

### Installation

1. Clone this repository:
   ```
   git clone <repository-url>
   cd Superfuel-Assignment
   ```

2. Install dependencies:
   ```
   poetry install
   ```

3. Set up your environment variables:
   
   The project uses an `.env` file to store API keys. Make sure your `.env` file has:
   ```
   OPENAI_API_KEY=your_openai_api_key
   ```

4. Install BAML CLI (if not already installed):
   ```powershell
   poetry run baml-cli init
   ```

5. Generate BAML client code:
   ```powershell
   poetry run baml-cli generate
   ```
   
   This command will process the BAML files in the `baml_src` directory and generate or update the client code in the `baml_client` directory.

## Running the Application

Run the main application using Poetry:

```powershell
poetry run python -m app.main
```

This will:
- Load the test cases
- Generate a mathematical plan using BAML and LLM
- Execute the plan using pure Python functions
- Compare results against expected outputs

## Test Cases

The application includes the following test cases:

1. **Test input 1**: "divide by ten, the sum of 20 and 30" (Expected result: 5)
2. **Test input 2**: "add 20 and 30, divide it by the sum of two and three" (Expected result: 10)

### Example Output

When you run the application, you'll see output similar to:

```
=== Running Test input 1 ===

--- PART 1: Plan Generation with LLM ---
Plan explanation: The plan first calculates the sum of 20 and 30 using the Sum tool, resulting in 50. Then, it divides this sum by 10 using the Divide tool to achieve the final result.

--- PART 2: Plan Execution with Pure Python ---

Executing steps (pure Python, no LLM):
  Sum(20.0, 30.0) = 50.0 | Calculates the sum of 20 and 30, which equals 50.
  Divide(50.0, 10.0) = 5.0 | Divides the result of the sum (50) by 10.

Final result: 5.0
✅ Test passed!

=== Running Test input 2 ===

--- PART 1: Plan Generation with LLM ---
Plan explanation: The plan first calculates the sum of 20 and 30, which results in 50. Then, it calculates the sum of 2 and 3, which results in 5. Finally, it divides the first sum (50) by the second sum (5) to get the final result.

--- PART 2: Plan Execution with Pure Python ---

Executing steps (pure Python, no LLM):
  Sum(20.0, 30.0) = 50.0 | Adds 20 and 30 together to get the total sum.
  Sum(2.0, 3.0) = 5.0 | Adds 2 and 3 together to get the sum of these two numbers.
  Divide(50.0, 5.0) = 10.0 | Divides the sum of 20 and 30 by the sum of 2 and 3.

Final result: 10.0
✅ Test passed!
```

## Project Structure

- `app/main.py`: Main application code
- `baml_src/`: BAML definition files
  - `clients.baml`: Defines LLM clients
  - `planner.baml`: Defines the mathematical planner function
- `baml_client/`: Auto-generated BAML client code

## Execution Flow

When you run the code:

1. The program first loads environment variables from your `.env` file.
2. It defines basic math functions (Sum, Subtract, Multiply, Divide) and maps them to tool names.
3. For each test case:
   - It sends the natural language instructions to BAML/OpenAI to generate a structured plan
   - It executes the plan step by step using pure Python functions
   - It compares the result to the expected output

## Understanding the Code

### How It Works

This code demonstrates a two-part process for mathematical planning:

1. **Planning Phase (Using LLM)**: 
   - The natural language instruction is sent to an LLM via BAML
   - The LLM generates a structured plan with mathematical operations

2. **Execution Phase (Pure Python)**:
   - The plan is executed step-by-step using Python functions
   - Results from each step are calculated and printed
   - The final result is compared to the expected output

### BAML Integration

The project uses BAML (Boundary AI Markup Language) to:
- Define the structure of the mathematical plan
- Create typed interfaces between the LLM and the Python code
- Manage the communication with OpenAI's API

BAML files in this project:
- `clients.baml`: Defines LLM clients (CustomGPT4o, CustomGPT4oMini) and their configurations
- `planner.baml`: Defines the GenerateMathPlan function, its input/output types, and test cases
- `generators.baml`: Contains additional BAML function definitions
- `resume.baml`: Contains additional BAML function definitions

The BAML CLI processes these files to generate strongly-typed Python clients in the `baml_client` directory.

## Troubleshooting

If you encounter API errors, make sure:
1. Your OpenAI API key is valid and has sufficient credits
2. Your `.env` file is properly configured and being loaded
3. You have the necessary permissions to use the specified models

If you see the following error:
```
AttributeError: 'coroutine' object has no attribute 'explanation'
```
This indicates that you're not properly awaiting an asynchronous function call. The code in this repository is already set up correctly to use async/await syntax.

