# set env vars
set -o allexport; source .env; set +o allexport;

echo "Waiting for software to be ready ..."
sleep 15s;
