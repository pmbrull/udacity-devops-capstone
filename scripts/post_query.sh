#!/usr/bin/env bash

# POST method query
curl -d "{  
   \"query\": \"${3}\"
}"\
     -H "Content-Type: application/json" \
     -X POST http://${1}:${2}/query