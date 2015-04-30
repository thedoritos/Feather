curl -F "file=@build/Fezaar.ipa" -F "token=$DEPLOY_GATE_API_KEY" https://deploygate.com/api/users/$DEPLOYGATE_USER_NAME/apps
