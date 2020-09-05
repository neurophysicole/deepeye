def repo_pull(home_dir, main_dir):

    # load packages
    import os
    import sys

    # pullit
    os.chdir(str('%s' %main_dir)) #need to pull from the repo directory
    os.system('git pull')

    os.chdir(str('%s' %home_dir)) #return back to the home directory

def repo_commit(home_dir, main_dir, proj_name, task_name, task_details):

    # load packages
    import os
    import sys

    # commit
    os.chdir(str('%s' %main_dir)) #need to pull from the repo directory
    os.system('git add .')
    os.system(str('git commit -am \"%s: %s: %s\"' %(proj_name, task_name, task_details))) #commit message consists of the task details

    os.chdir(str('%s' %home_dir)) #return back to the home directory

def repo_push(home_dir, main_dir):

    # load packages
    import os
    import sys

    # pushit
    os.chdir(str('%s' %main_dir)) #need to pull from the repo directory
    os.system('git push')

    os.chdir(str('%s' %home_dir)) #return back to the home directory
