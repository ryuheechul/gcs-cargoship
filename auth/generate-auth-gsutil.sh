#!/bin/bash -e

source ../.env
cat_template=$(cat auth-gsutil-template.sh)
cat_template=${cat_template//\$GC_SECRET_PATH/$GC_SECRET_PATH}
cat_template=${cat_template//\$GC_SERVICE_ACCOUNT/$GC_SERVICE_ACCOUNT}
cat_template=${cat_template//\$GC_PROJECT_ID/$GC_PROJECT_ID}

cp auth-gsutil-template.sh auth-gsutil.sh
echo "$cat_template" > auth-gsutil.sh
