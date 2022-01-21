# DfT Analyst R repository template

This is a template git repository for use by DfT analysts in R. It aims to standardise issue reporting and pull requests, as well as minimising the risk of accidentally pushing secure data.

## To use 

To use this template, click on the green button "use template" at the top of this repository. This will allow you to set up a repository as normal, using the structure and features of this repo.

## Features

### Raising issues

The repository contains two issue templates which are loaded automatically; one for bug reporting, and one for feature suggestions. These can be used to record issues and planned improvements within your code, and the standardised template ensures you capture all of the required information every time.

### Pull requests

The repository contains a pull request template which loads automatically. This standardised form to complete ensures you are appropriately reviewing pull requests and provides a QA record of code changes.

### Commit template

The repository contains a git commit template. This does not load automatically, and must be requested in your R terminal by running

`git config commit.template .gitmessage`

This provides a template for good git messages, and also reminds users not to commit to Github any secrets or data.

### Gitignore

The git ignore file is set to ignore common data formats such as xlsx, csv and ods tables. It also ignores the .renviron file to allow you to store secrets such as API keys securely in your local environment.

The repository also includes Data and Output folders. Putting data inputs and outputs into these folders ensures they will not be pushed to Git, regardless of format. This is ideal when you have a project with a large number of varied inputs or outputs (e.g. XML files, or HTML outputs).
