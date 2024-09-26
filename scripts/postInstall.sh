# set env vars
set -o allexport; source .env; set +o allexport;

echo "Waiting for software to be ready ..."
sleep 30s;

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

if ! command_exists jq; then
    echo "jq is not installed. Attempting to install..."
    if command_exists apt-get; then
        sudo apt-get update && sudo apt-get install -y jq
    elif command_exists yum; then
        sudo yum install -y jq
    elif command_exists brew; then
        brew install jq
    else
        echo "Error: Unable to install jq. Please install it manually and run this script again."
        exit 1
    fi
fi

target=$(docker-compose port llana-app 3000)

attempt_login() {
    curl -s -X POST "http://$target/auth/login" \
        -H "Content-Type: application/json" \
        -d '{
            "username": "test@test.com",
            "password": "test"
        }' | jq -r .access_token
}

# Set maximum number of retries
MAX_RETRIES=5
RETRY_INTERVAL=5

# Attempt login with retries
for ((i=1; i<=MAX_RETRIES; i++)); do
    echo "Login attempt $i of $MAX_RETRIES"
    ACCESS_TOKEN=$(attempt_login)

    if [ -n "$ACCESS_TOKEN" ] && [ "$ACCESS_TOKEN" != "null" ]; then
        echo "Access token obtained successfully."
        echo "$ACCESS_TOKEN"
        break
    else
        echo "No valid access token received."
        if [ $i -lt $MAX_RETRIES ]; then
            echo "Retrying in $RETRY_INTERVAL seconds..."
            sleep $RETRY_INTERVAL
        else
            echo "Maximum retries reached. Login failed."
            exit 1
        fi
    fi
done

# Check if we have a valid access token
if [ -z "$ACCESS_TOKEN" ] || [ "$ACCESS_TOKEN" == "null" ]; then
    echo "Failed to obtain a valid access token after $MAX_RETRIES attempts."
    exit 1
fi


echo "Access token obtained successfully."

echo "Creating new admin user..."
CREATE_USER_RESPONSE=$(curl -s -X POST "http://$target/User/" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $ACCESS_TOKEN" \
    -d '{
        "email": "'"$ADMIN_EMAIL"'",
        "password": "'"$ADMIN_PASSWORD"'",
        "role": "ADMIN",
        "firstName": "Super",
        "lastName": "Admin"
    }')

sleep 5s;
if echo "$CREATE_USER_RESPONSE" | jq -e . >/dev/null 2>&1; then
    echo "Admin user created successfully."
else
    echo "Error: Failed to create admin user."
    exit 1
fi
