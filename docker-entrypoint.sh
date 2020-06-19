#!/bin/ash -e

if [ ${#} -eq 0 ]; then
  echo "This image containes two tools: "
  echo "eslint: docker run --rm -w="/code/frontend" -v $(pwd):/code tivix/docker-jslinter:v1.1 eslint --max-warnings 0 --rule 'import/no-unresolved: "off"' "./src/**/*.{js,jsx,ts,tsx}""
  echo "prettier: docker run --rm -w="/code/frontend" -v $(pwd):/code tivix/docker-jslinter:v1.1 prettier -c './src/**/*.{json,md,yml}'"
else
  exec "${@}"
fi