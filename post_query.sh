#!/usr/bin/env bash

# POST method query
curl -d "{  
   \"query\": \"${1}\"
}"\
     -H "Content-Type: application/json" \
     -X POST http://localhost:$LOCAL_PORT/query