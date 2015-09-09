#!/usr/bin/expect -f

set secret_path "$GC_SECRET_PATH"
set service_account "$GC_SERVICE_ACCOUNT"
set project_id "$GC_PROJECT_ID"

set timeout 1800
set cmd [lindex $argv 0]
set licenses [lindex $argv 1]
spawn {*}$cmd

# those questions may change in the future due to the updates of gsutil.
expect {
	"What is the full path to your private key file?" {
		exp_send "$secret_path\r"
		exp_continue
	}
	"What is your service account email address?" {
		exp_send "$service_account\r"
		exp_continue
	}
	"What is the password for your service key file *" {
		exp_send "\r"
		exp_continue
	}
	"Would you like gsutil to change the file permissions for you?" {
		exp_send "\r"
		exp_continue
	}
	"What is your project-id?" {
		exp_send "$project_id\r"
		exp_continue
	}
	eof
}
