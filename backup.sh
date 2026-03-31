ENV_FILE="/home/ubuntu/wordpress-app/.env"
 
if [ ! -f "$ENV_FILE" ]; then
    echo "[ERROR] .env file not found"
    exit 1
fi
 
source "$ENV_FILE"
TIMESTAMP=$(date +"%Y-%m-%d-%H%M")
BACKUP_FILE="backup-${TIMESTAMP}.sql"

if ! docker inspect -f '{{.State.Running}}' \
    "wordpress-db" 2>/dev/null | grep -q "true"; then
    echo "[ERROR] Container is not running."
    exit 1
fi

docker exec wordpress-db \
    mysqldump \
    -u root \
    -p"${MYSQL_ROOT_PASSWORD}" \
    --single-transaction \
    "${MYSQL_DATABASE}" > "$BACKUP_PATH"

    S3_BUCKET="wordpress-backup-ifunanya-2026"
S3_PATH="s3://${S3_BUCKET}/backups/${BACKUP_FILE}"
 
aws s3 cp "$BACKUP_PATH" "$S3_PATH"
 
echo "Backup uploaded to: $S3_PATH"

