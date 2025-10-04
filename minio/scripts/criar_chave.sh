#!/bin/bash
# Irá parar se 1 comando falhar
set -e

# 1. Verificar se o nome do bucket foi passado como argumento
USER_NAME=$1
BUCKET_NAME=$2
ACCESS_KEY=$3
SECRET_KEY=$4
if [ -z "$USER_NAME" ] || [ -z "$BUCKET_NAME" ] || [ -z "$ACCESS_KEY" ] || [ -z "$SECRET_KEY" ]; then
    echo -e "O nome do bucket é obrigatório. Uso: ./criar_chave.sh <usuário> <bucket> <access-key> <secret-key>"
    exit 1
fi

# 1. Criar policy que dá acesso ao bucket.
# https://docs.min.io/community/minio-object-store/administration/identity-access-management/policy-based-access-control.html#minio-policy
# https://stackoverflow.com/questions/2953081/how-can-i-write-a-heredoc-to-a-file-in-bash-script
POLICY_FILE="policy-${BUCKET_NAME}.json"
cat << EOF > "${POLICY_FILE}"
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "RW bucket ${BUCKET_NAME}",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:ListAllMyBuckets",
                "s3:GetBucketLocation",
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:DeleteObjectVersion",
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${BUCKET_NAME}",
                "arn:aws:s3:::${BUCKET_NAME}/*"
            ]
        }
    ]
}
EOF

mc admin policy create myminio "${BUCKET_NAME}-policy" "${POLICY_FILE}"

# 2. Criar usuário que terá acesso ao bucket e associar a policy criada
# https://docs.min.io/community/minio-object-store/administration/identity-access-management/minio-user-management.html
mc admin policy attach myminio "${BUCKET_NAME}-policy" --user "${USER_NAME}"

# 3. Criar conta de serviço (chave de acesso + secreta)
# https://docs.min.io/community/minio-object-store/reference/minio-mc-admin/mc-admin-accesskey-create.html#command-mc.admin.accesskey.create
mc admin accesskey create myminio/ "${USER_NAME}" --access-key "$ACCESS_KEY" --secret-key "$SECRET_KEY" --policy "${POLICY_FILE}" > /dev/null || echo "Service account Já existe!"

rm "${POLICY_FILE}"
