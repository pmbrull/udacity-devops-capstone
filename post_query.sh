#!/usr/bin/env bash

PORT=5000

# POST method query
curl -d "{  
   \"query\": \"${1}\"
}"\
     -H "Content-Type: application/json" \
     -X POST http://localhost:$PORT/query