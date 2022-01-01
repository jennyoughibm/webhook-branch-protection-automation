class WebhooksController < ApplicationController
  WEBHOOK_HEADERS = ["HTTP_USER_AGENT", "CONTENT_TYPE", "HTTP_X_GITHUB_EVENT", "HTTP_X_GITHUB_DELIVERY", "HTTP_X_HUB_SIGNATURE"]

 before_action :verify_signature!
 before_action :verify_event_type!

  def create
    create_branch_protection
    notification_subscription
#     create_issue_for_branch_protection

    puts "Webhook successfully received!!!"
    WEBHOOK_HEADERS.each do |header|
      puts "#{header}: #{request.headers[header]}"
    end
  end

  private

  def payload
    params["webhook"]
  end

  def error(msg)
    text = "Webhook invalid: #{msg}"
    puts text
    render(status: 422, json: text)
  end

 def verify_event_type!
   type = request.headers["HTTP_X_GITHUB_EVENT"]
   return if type == "create" or type == "ping" or type == "branch_protection_rule" or type == "issues"
   error("unallowed event type: #{type}")
 end

 def created?
   payload["action"] == "created"
 end

#  def merged_into_master?
#    merged = payload["pull_request"]["merged"] == true
#    in_to_master = payload["pull_request"]["base"]["ref"] == "master"

#    merged && in_to_master
#  end

 def octokit
   Octokit::Client.new(access_token: ENV["GITHUB_PERSONAL_ACCESS_TOKEN"])
 end

 def create_branch_protection
   octokit.protect_branch(repo, 'master', options = {"enforce_admins": true, "required_pull_request_reviews": {"dismiss_stale_reviews": true, "require_code_owner_reviews": true, "required_approving_review_count": 1}})
 end

 def notification_subscription
   octokit.update_subscription(repo, options = {subscribed: true})
 end

 def create_issue_for_branch_protection
   octokit.create_issue(repo, 'Branch protection created', body = 'Branch protection created #jennyoughibm', options = {})
 end

 def repo
   payload["repository"]["full_name"]
 end

 def verify_signature!
   secret = ENV["GITHUB_WEBHOOK_SECRET"]

   signature = 'sha1='
   signature += OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret, request.body.read)

   unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
     guid = request.headers["HTTP_X_GITHUB_DELIVERY"]
     error("unable to verify payload for #{guid}")
   end
 end
end
