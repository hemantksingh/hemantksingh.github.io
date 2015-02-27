---
layout: post
title: Git Basics
date: '2014-10-02T11:23:00.000-08:00'
author: Hemant Kumar
tags: git
categories: kodekitab
modified_time: '2015-02-26T11:23:46.244-08:00'
---

# Git overview #
* Distributed Version Control
* Data Consistency and Integrity
* Performance - Diffs are local therefore quicker, do not have to go over the network to perform diffs.
* Merging - Auto merging updates the changed file(s) if the changes are not on the same line of the changed file.
* Conflicts (changes on the same lines of the changed file) have to be merged manually.


### Git commands ###
Clone a repository locally from the remote server  
`$ git clone git@github.com:username/demo.git`

****************************************************************
**Create new repository**

Add a new repository on github online - 'demo'. Then create a local directory - 'demo' and navigate to it through the command line.  
{% highlight sh %}
$ touch README.md # Creates a README file  
$ git init  # Initializes a git repository  
$ git add README.md  # Adds the README.md file to staging area  
$ git commit -m "first commit"  # Creates a commit  
$ git remote add origin git@github.com:username/demo.git # Specifies the remote URL  
$ git push -u origin master # Transfers the repository to remote server and tracks the remote branch
{% endhighlight %}

****************************************************************
**Git settings**  
Git settings are defined in a .gitconfig file which is located in %USERPROFILE% on Windows and $HOME on Unix based machines.

List the config settings  
```
$ git config --list
```

Set the default username and email globally for the entire system  
{% highlight sh %}
$ git config --global user.name "Your Name Here"  
$ git config --global user.email "your_email@example.com"
{% endhighlight %}
In order to override this with a different name or e-mail address for specific projects, you can run the command without the --global option when you’re in that project.

If git prompts you for a username and password you could be using the HTTPS clone for your repository instead of your SSH key passphrase. The SSH based URL looks like - git@github.com:user/repo.git. Follow the steps below to switch it to SSH.

Verify the remote that a local repo is mapped to  
{% highlight sh %}
$ git remote show  
# or  
$ git remote
{% endhighlight %}

Verify the remote URL that a local repo is mapped to  
```
$ git remote -v
```

Change the remote URL that local repo is mapped to  
```
$ git remote set-url origin git://new.url.here
```

Push all local branches that have the same name on the remote. This means potentially many different branches will be pushed, including those that you might not even want to  
```
$ git config --global push.default matching
```

Push only the current working branch if it has the same name on remote  
```
$ git config --global push.default simple
```

****************************************************************
**Branches**

Get a list of all the branches  
$ git branch -a

Create a branch and switch to it at the same time  
$ git checkout -b <branchName>

Create a branch, switch to it and set the tracking/upstream branch  
$ git checkout -b <branchName> --track origin/<branchName>

Merge with a specified branch  
$ git merge <path to remote branch>

Delete a remote branch  
$ git push origin --delete <branchName>

Delete a local branch  
$ git branch -d <branchName>

Track a remote branch e.g. track remote master with local master  
$ git branch --set-upstream-to=<remote>/<branchName> <branchName>  
$ git branch --set-upstream-to=origin/master master

Compare a file in 2 branches  
$ git difftool <branch1> <branch2> -- myfile.cs

Compare the commits in 2 branches  
 git cherry -v <branch1> <branch2>

*****************************************************************
**Undoing changes**

$ git reset head --hard (Moves the head to the most recent commit and erase all the changes in your working tree)  
$ git reset --hard <sha1-commit-id> (Moves the head to the specified commit)

Find a commit that you undid, it is typically present in git reflog unless you have garbage collected your repository  
$ git reflog

Remove untracked (git ignored) files and directories  
$ git clean -xdf

-f option required for overriding permissions  
-d also remove the directories  
-X just remove ignored files (for example - files in build dir: bin/, user setting files etc.)  
-x remove ignored as well as non-ignored files

****************************************************************
**Amend a commit**

Ensure all changes are staged  
$ git commit -A  
$ git commit --amend -m "New commit message"

Amend a commit with no changes to the message  
$ git commit -A --amend --no-edit

****************************************************************
**Remove local commits**

Revert the commit without creating another commit  
$ git revert -n <sha1-commit-id>

Remove local commit and reset the head to the same as remote branch  
$ git reset HEAD^  
Or  
$ git reset origin/branchName --hard

Remove local commit but keep changes  
$ git reset <sha1-commit-id>  (Undoes the commit after sha1-commit-id and keeps the changes in working directory)

****************************************************************
**Rearrange commits** 

$ git rebase -i

Rebase your last 2 local commits  
$ git rebase -i HEAD~2

Abort a rebase  
$ git rebase --abort

Move to an old commit  
$ git reflog

Suppose the old commit that you want to go back to was HEAD@{5} in the ref log  
$ git reset --hard HEAD@{5}

Go back to the previous commit   
$ git reset --hard HEAD~1

****************************************************************
**Stash your work**

$ git stash

Stash work with comment  
$ git stash save <comment>

List the stashes  
$ git stash list 

Apply a stash  
$ git stash apply (Applies the stash at the top)  
$ git stash apply stash@{n} (Applies the stash at 'n' and keeps it in the stash stack)  
$ git stash pop stash@{n} (Applies the stash at 'n' and removes it in the stash stack)  

Drop a stash  
$ git stash drop (Drops the stash at the top)  
$ git stash drop stash@{n}  (Drops the stash at 'n')

Create a branch from a stash  
$ git stash (Stash your work)  
$ git stash branch <branchName> (Switch to a new branch that contains the stashed work)

This creates a new branch for you, checks out the commit you were on when you stashed your work, 
reapplies your work there, and then drops the stash if applied successfully.

****************************************************************
**Tags**

List all the tags  
$ git tag

Create a tag  
$ git tag <tagname>

By default, the git push command doesn't transfer tags to remote servers.  
Push tags to a shared server after you have created them  
$ git push origin <tagname>

Push all of your tags to the remote server that are not already there  
$ git push origin --tags

****************************************************************
**[Generating SSH Keys](https://help.github.com/articles/generating-ssh-keys/)**

Adding SSH key to the ssh-agent  
$ ssh-add ~/.ssh/id_rsa

On trying to add the SSH key to the ssh-agent you can get the following error: 'Could not open connection to your authentication agent'. You need to start ssh-agent before you can run the ssh-add command by running:  
$ eval `` `ssh-agent -s` ``

Once the key has been added git should not ask for the key pass phrase on every push/pull.

****************************************************************