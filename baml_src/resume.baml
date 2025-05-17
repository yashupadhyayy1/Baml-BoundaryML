// Defining a data model.
class Resume {
  name string
  email string
  experience Experience[]
  skills string[]
}

class Experience {
  company string
  role string
  duration string
  location string
}

// Create a function to extract the resume from a string.
function ExtractResume(resume: string) -> Resume {
  // Specify a client as provider/model-name
  // you can use custom LLM params with a custom client name from clients.baml like "client CustomHaiku"
  client CustomGPT4oMini // Set OPENAI_API_KEY to use this client.
  prompt #"
    Extract from this content:
    {{ ctx.output_format }}

    {{_.role("user")}}
    {{ resume }}

  "#
}



// Test the function with a sample resume. Open the VSCode playground to run this.
test vaibhav_resume {
  functions [ExtractResume]
  args {
    resume #"
      Rohit Shende
      rohitshende020@gmail.com

      Experience:
      - Founder at BoundaryML
      - CV Engineer at Google
      - CV Engineer at Microsoft

      Skills:
      - Rust
      - C++
    "#
  }
}
