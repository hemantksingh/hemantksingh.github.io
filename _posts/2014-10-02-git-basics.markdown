---
layout: post
title: Git Basics
date: '2014-10-02T11:23:00.000-08:00'
author: Hemant Kumar
tags: git
categories: kodekitab
comments: true
modified_time: '2015-10-15T11:23:46.244-08:00'
redirect_from: "/kodekitab/2014/10/02/git-basics.html"
---

# Git overview #
* Distributed Version Control
* Data Consistency and Integrity
* Performance - Diffs are local therefore quicker, do not have to go over the network to perform diffs.
* Merging - Automatic merge if there are no conflicts (more than one change at the same position of the modified file).
* Conflicts have to be merged manually.


### Git commands ###
Clone a repository locally from the remote server
{% highlight sh %}  
$ git clone git@github.com:username/demo.git
{% endhighlight %}
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
{% highlight sh %}
$ git config --list
{% endhighlight %}

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
{% highlight sh %}
$ git remote -v
{% endhighlight %}

Change the remote URL that local repo is mapped to  
{% highlight sh %}
$ git remote set-url origin git://new.url.here
{% endhighlight %}

Push all local branches that have the same name on the remote. This means potentially many different branches will be pushed, including those that you might not even want to  
{% highlight sh %}
$ git config --global push.default matching
{% endhighlight %}

Push only the current working branch if it has the same name on remote  
{% highlight sh %}
$ git config --global push.default simple
{% endhighlight %}

****************************************************************
**Branches**

Get a list of all the branches  
{% highlight sh %}
$ git branch -a
{% endhighlight %}

Create a branch and switch to it at the same time  
{% highlight sh %}
$ git checkout -b <branchName>
{% endhighlight %}

Create a branch, switch to it and set the tracking/upstream branch  
$ git checkout -b <branchName> --track origin/<branchName>

Merge with a specified branch
{% highlight sh %}
$ git merge <path to remote branch>
{% endhighlight %}

Delete a remote branch  
{% highlight sh %}
$ git push origin --delete <branchName>
{% endhighlight %}

Delete a local branch  
{% highlight sh %}
$ git branch -d <branchName>
{% endhighlight %}

Track a remote branch e.g. track remote master with local master  
{% highlight sh %}
$ git branch --set-upstream-to=<remote>/<branchName> <branchName>  
$ git branch --set-upstream-to=origin/master master
{% endhighlight %}

Compare a file in 2 branches  
{% highlight sh %}
$ git difftool <branch1> <branch2> -- myfile.cs
{% endhighlight %}

Compare the commits in 2 branches  
{% highlight sh %}
git cherry -v <branch1> <branch2>
{% endhighlight %}

*****************************************************************
**Undoing changes**

$ git reset head --hard (Moves the head to the most recent commit and erase all the changes in your working tree)  
{% highlight sh %}
$ git reset --hard <sha1-commit-id> #Moves the head to the specified commit
{% endhighlight %}

Find a commit that you undid, it is typically present in git reflog unless you have garbage collected your repository  
{% highlight sh %}
$ git reflog
{% endhighlight %}

Remove untracked (git ignored) files and directories  
{% highlight sh %}
$ git clean -xdf
{% endhighlight %}

-f option required for overriding permissions  
-d also remove the directories  
-X just remove ignored files (for example - files in build dir: bin/, user setting files etc.)  
-x remove ignored as well as non-ignored files

****************************************************************
**Amend a commit**

Ensure all changes are staged  
{% highlight sh %}
$ git commit -A  
$ git commit --amend -m "New commit message"
{% endhighlight %}

Amend a commit with no changes to the message  
{% highlight sh %}
$ git commit -A --amend --no-edit
{% endhighlight %}

****************************************************************
**Remove local commits**

Revert the commit without creating another commit  
{% highlight sh %}
$ git revert -n <sha1-commit-id>
{% endhighlight %}

Remove local commit and reset the head to the same as remote branch  
{% highlight sh %}
$ git reset HEAD^  
Or  
$ git reset origin/branchName --hard
{% endhighlight %}

Remove local commit but keep changes  
{% highlight sh %}
$ git reset <sha1-commit-id>  #Undoes the commit after sha1-commit-id
#and keeps the changes in working directory
{% endhighlight %}
****************************************************************
**Rearrange commits**
{% highlight sh %}
$ git rebase -i
{% endhighlight %}

{% highlight sh %}
Rebase your last 2 local commits  
$ git rebase -i HEAD~2
{% endhighlight %}

Abort a rebase  
{% highlight sh %}
$ git rebase --abort
{% endhighlight %}

Move to an old commit  
{% highlight sh %}
$ git reflog
{% endhighlight %}

Suppose the old commit that you want to go back to was HEAD@{5} in the ref log  
{% highlight sh %}
$ git reset --hard HEAD@{5}
{% endhighlight %}

Go back to the previous commit   
{% highlight sh %}
$ git reset --hard HEAD~1
{% endhighlight %}

****************************************************************
**Finding commits**

Find a commit with text "text to find"
{% highlight sh %}
$ git log --grep="text to find" --pretty=oneline
{% endhighlight %}

****************************************************************
**Create patch**

Creating a patch
{% highlight sh %}
$ git diff > <name>.patch
{% endhighlight %}


****************************************************************
**Stash your work**

{% highlight sh %}
$ git stash
{% endhighlight %}

Stash work with comment  
{% highlight sh %}
$ git stash save <comment>
{% endhighlight %}

List the stashes
{% highlight sh %}  
$ git stash list
{% endhighlight %}

Apply a stash
{% highlight sh %}  
$ git stash apply #Applies the stash at the top
$ git stash apply stash@{n} #Applies the stash at 'n' and keeps it in the stash stack  
$ git stash pop stash@{n} #Applies the stash at 'n' and removes it in the stash stack
{% endhighlight %}

Drop a stash  
{% highlight sh %}
$ git stash drop #Drops the stash at the top
$ git stash drop stash@{n}  #Drops the stash at 'n'
{% endhighlight %}

Create a branch from a stash  
{% highlight sh %}
$ git stash (Stash your work)  
$ git stash branch <branchName> #Switch to a new branch that contains the stashed work
{% endhighlight %}

This creates a new branch for you, checks out the commit you were on when you stashed your work,
reapplies your work there, and then drops the stash if applied successfully.

****************************************************************
**Tags**

List all the tags  
{% highlight sh %}
$ git tag
{% endhighlight %}

Create a tag  
{% highlight sh %}
$ git tag <tagname>
{% endhighlight %}

By default, the git push command doesn't transfer tags to remote servers. Push tags to a shared server after you have created them  
{% highlight sh %}
$ git push origin <tagname>
{% endhighlight %}

Push all of your tags to the remote server that are not already there  
{% highlight sh %}
$ git push origin --tags
{% endhighlight %}

****************************************************************
**[Generating SSH Keys](https://help.github.com/articles/generating-ssh-keys/)**

Adding SSH key to the ssh-agent  
$ ssh-add ~/.ssh/id_rsa

On trying to add the SSH key to the ssh-agent you can get the following error: 'Could not open connection to your authentication agent'. You need to start ssh-agent before you can run the ssh-add command by running:  
$ eval `` `ssh-agent -s` ``

Once the key has been added git should not ask for the key pass phrase on every push/pull.

****************************************************************
