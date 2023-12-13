#!/usr/bin/env bash
eval $(cryosparcm env)
USER_ID=$(cryosparcm cli 'list_users()' |sed -e '1,2d' -e 's/\s//g' -e '/^\s*$/d' \
	|grep '^|.*|{{ .Values.master.service_account.username }}|True|' \
	|cut -d'|' -f5)
PROJECT_ID=$(cryosparcm cli 'create_empty_project(\
	owner_user_id="'${USER_ID}'", \
	project_container_dir="{{ .Values.project_container.dir }}", \
	title="Extensive Validation Testing", \
	desc="Validation testing for all CryoSPARC updates")')
WORKSPACE_ID=$(cryosparcm cli 'create_empty_workspace("'${PROJECT_ID}'", "'${USER_ID}'", title="Benchmark & Validation")')
cryosparcm cli 'create_new_job("extensive_validation", "'${PROJECT_ID}'", "'${WORKSPACE_ID}'", "'${USER_ID}'")'
