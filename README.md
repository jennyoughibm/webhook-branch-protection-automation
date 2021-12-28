# Webhooks & REST API

This project demostrate how to use Webhook and GitHub rest API to automate branch protection.

# Getting started

## Fork and clone

clone the repo to your local machine

```
git clone git@github.com:<username>/webhooks-with-rest.git --config core.autocrlf=input
```

## Bootstrap

Now that you have the repo locally `cd` into that directory and run

For Unix:

```
script/bootstrap
```

For Windows (in Powershell):

```
.\exe\bootstrap.ps1
```

Be sure you have docker running before attempting that command.

## Credentials

Now that you have the docker image created, we need to setup some credentials.

### Personal acess token

Generate a personal access token, and copy it to the .env.example file,update the value of the environment variable `GITHUB_PERSONAL_ACCESS_TOKEN` to the one that you just copied.

### Webhook secret

Use a very random string as the secret token, update the value of the environment variable `GITHUB_WEBHOOK_SECRET` with it in the .env.example file.

# Configuring a webhook

Now that we have all of the credentials necessary, we can run

For Unix:

```
script/server
```

For Windows (in Powershell):

```
.\exe\server.ps1
```

This will start the app server as well as a proxy to tunnel requests to your local server. There should be an output that includes a URL.

```
$ script/server

+----------------------------------------------+
| Your public url is: http://044af013.ngrok.io |
+----------------------------------------------+

This is the output of your web app.
===================================

Puma starting in single mode...
* Version 4.3.3 (ruby 2.6.3-p62), codename: Mysterious Traveller
* Min threads: 5, max threads: 5
* Environment: development
* Listening on tcp://0.0.0.0:3000
Use Ctrl-C to stop
```

Copy the generated URL and navigate to the repo settings page

<img src="https://user-images.githubusercontent.com/3330181/79942668-599fcf00-8435-11ea-9381-d889bb06c784.png" width=1000>

Then find webhooks in the side menu

<img src="https://user-images.githubusercontent.com/3330181/79942740-86ec7d00-8435-11ea-8190-4fa10c76cc8a.png" width=250>

And then select `add webhook`

<img src=https://user-images.githubusercontent.com/3330181/79942860-b3a09480-8435-11ea-9acc-c2d3e7522949.png width=1000>

Which will bring you to the form for creating a new repository webhook.

You will need a webhook with the following configuration:

- URL: paste your ngrok generated URL into the URL field
- Content Type: select json
- Secret: use the secret that you added as part of your credentials
- Events: select only the `Branch or tag creation` events
- Active: make sure the hook is marked as active

Once you add the event, you should see a ping event in both the logs

And once you create a branch, you will see the branch protection is automatically created.