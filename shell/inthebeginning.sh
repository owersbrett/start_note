#!/bin/bash

# run from the root of the project, not the shell directory
# ./shell/inthebeginning.sh "I want to make a todo list from a table of contents."

sh table_of_contents.sh lib
CURRENT_TABLE_OF_CONTENTS=$(cat _tableofcontents.md)
# OpenAI API URL
API_URL="https://api.openai.com/v1/chat/completions"

# The prompt for GPT-4
SYSTEM_CONTENT=$(cat shell/_system_content.md | jq -sR @json)
EXAMPLE_PROMPT=$(cat shell/_example_prompt.md | jq -sR @json)
EXAMPLE_RESPONSE=$(cat shell/_example_response.md | awk '{printf "%s\\n", $0}' ORS='' | jq -sR @json)
PROMPT=$CURRENT_TABLE_OF_CONTENTS
# PROMPT=$1
echo $SYSTEM_CONTENT
echo $EXAMPLE_PROMPT
echo $EXAMPLE_RESPONSE
echo $PROMPT
# JSON payload
JSON_PAYLOAD=$(jq -n \
                  --arg system_content "$SYSTEM_CONTENT" \
                  --arg example_prompt "$EXAMPLE_PROMPT" \
                  --arg example_response "$EXAMPLE_RESPONSE" \
                  --arg prompt "$PROMPT" \
                  --arg temperature "0.5" \
                  --arg max_tokens "777" \
                '{
                    "model": "gpt-3.5-turbo",
                    "messages": [
                    {
                        "role": "system",
                        "content": ($system_content | @json)
                    },
                    {
                        "role": "user",
                        "content": ($example_prompt | @json)
                    },
                    {
                        "role": "assistant",
                        "content": ($example_response | @json)
                    },
                    {
                        "role": "user",
                        "content": ($prompt | @json)
                    }
                    ],
                    "temperature": ($temperature | tonumber),
                    "max_tokens": ($max_tokens | tonumber),
                }')

echo ""
echo ""
echo "----------------------------------------------------------------------------------"
echo ""
echo ""
echo $JSON_PAYLOAD
echo ""
echo ""
echo "----------------------------------------------------------------------------------"
echo ""
echo ""
# Send the request to OpenAI API
RESPONSE=$(curl -s -X POST "$API_URL" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -d "$JSON_PAYLOAD")

ECHO $RESPONSE

echo "$RESPONSE" > todos-response.json
valid_json=$(echo $RESPONSE | jq '.choices[0].message.content')

# Extract the text from the response
# TODO_LIST=$(echo $RESPONSE  | jq -r '.choices[0].message.content')

# Save the response to a file
valid_json="${valid_json#\\\"}"
valid_json="${valid_json%\\\"}"
echo "$valid_json" > todos.md


# Output the result
echo "To-dos have been saved to todos.json"

