#!/bin/sh

if [[ $CI_COMMIT_BRANCH == "staging" ]] ; then
  export CUSTOM_CONTAINER_NAME=$CUSTOM_CONTAINER_NAME_STAGING
  cat $ENV_STAGING >> .env | true
elif [[ $CI_COMMIT_BRANCH == "main" ]] ; then
  export CUSTOM_CONTAINER_NAME=$CUSTOM_CONTAINER_NAME_PRODUCTION
  cat $ENV_PRODUCTION >> .env | true
else
  touch .env
  echo "ENV: None of the condition met"
fi

echo "
  export NODE_ENV=production
  export SENTRY_DSN=$SENTRY_DSN
  export DOMAIN=$DOMAIN
  export CUSTOM_CONTAINER_NAME=$CUSTOM_CONTAINER_NAME
  export SUBDOMAIN=${CUSTOM_CONTAINER_NAME}.
  export COMPOSE_PROJECT_NAME=${CUSTOM_CONTAINER_NAME}-${DOMAIN//./-}
" >> .env
