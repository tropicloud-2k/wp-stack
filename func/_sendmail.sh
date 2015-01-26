#!/usr/bin/env bash

# ------------------------
# WPS SENDMAIL
# ------------------------
# ex: wps_sendmail <welcome> -d $WP_URL -u $WP_USER -m $WP_MAIL -p $WP_PASS
# ------------------------

function wps_sendmail() {

	WP_USER="$( echo $@ | grep -o '\-u.*' | awk '{print $2}' )"
	WP_PASS="$( echo $@ | grep -o '\-p.*' | awk '{print $2}' )"
	WP_MAIL="$( echo $@ | grep -o '\-m.*' | awk '{print $2}' )"
	 WP_URL="$( echo $@ | grep -o '\-d.*' | awk '{print $2}' )"
	 
	ADM_MAIL='admin@tropicloud.net'
	MANDRILL='JVjDagu4lFHJhgjjY2yfKw'

	if [[  $2 == 'welcome'  ]]; then
	
		curl -s -A 'Mandrill-Curl/1.0' -d '{"key":"'$MANDRILL'","template_name":"wp-stack","template_content":[{"name":"title","content":"[WP-STACK] New WordPress Site"}],"message":{"subject":"[WP-STACK] New WordPress Site","from_email":"'$ADM_MAIL'","from_name":"Tropicloud","to":[{"email":"'$WP_MAIL'","name":"'$WP_USER'","type":"to"}],"headers":{"Reply-To":"'$ADM_MAIL'"},"important":true,"track_opens":true,"track_clicks":true,"auto_text":false,"auto_html":false,"inline_css":false,"url_strip_qs":false,"preserve_recipients":true,"view_content_link":false,"bcc_address":"'$ADM_MAIL'","tracking_domain":null,"signing_domain":null,"return_path_domain":null,"merge":true,"global_merge_vars":[{"name":"WP_URL","content":"'$WP_URL'"},{"name":"WP_USER","content":"'$WP_USER'"},{"name":"WP_PASS","content":"'$WP_PASS'"}]}}' 'https://mandrillapp.com/api/1.0/messages/send-template.json' | jq '.'

	fi
}
