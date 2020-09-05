# ================
# Import Packages
# ================
# date/time packages
import time
import datetime
from dateutil.relativedelta import relativedelta
from datetime import datetime, date, timedelta

# command line packages
import os
import sys
# reload(sys) #to help with seemingly random'ascii' encoding error
# sys.setdefaultencoding('utf8') # ^^ <--Python interpreter doesn't like it, but it works

# interface packages
import PySimpleGUI as sg
from PySimpleGUI import SetOptions

# other necessary packages
import filecmp

# import custom modules
import loadup
import cleanup
import settings
import jobber
from print_notes import print_proj_notes
from print_notes import print_task_notes
from print_notes import print_proj_details
from print_notes import print_task_dets
import task_selection
import task_interface
import logit
from cloud_update import repo_pull
from cloud_update import repo_commit
from cloud_update import repo_push

# ------
# Runit
date        = datetime.today().strftime('%y-%m-%d')
logfile     = 'log.txt'
status_file = 'status.txt'

# loadup
loadup.loadup()

# load settings
main_dir, home_dir, cur_branch_name, todo_terminal, notes_terminal, dets_terminal = settings.settings()

# -------
# Loopit
exe_loop = True
while exe_loop:

    # initial pull
    repo_pull(home_dir, main_dir)

    # run clean up
    # looking for .DS_Store nuggets
    cleanup.cleanup(main_dir, cur_branch_name)

    # ==================
    # Determine To-Do's
    # ==================
    # current branch
    print('\nBRANCH: %s\n' %cur_branch_name)
    time.sleep(.1)

    # get projects
    proj_path   = '%s/%s' %(main_dir, cur_branch_name)

    try:
        proj_list   = next(os.walk(proj_path))[1]
    except StopIteration:
        proj_list   = []
    else:
        proj_list   = next(os.walk(proj_path))[1]

    proj_list.sort()

    # list project status and update todos
    todo_header = str('To check the status of your projects, and update your todo list, type todoz.') #todoz is an alias
    os.system('echo \'%s\' > %s' %(todo_header, todo_terminal)) #best way I could figure out how to do this..

    # list projects
    job_loop = True
    while job_loop:
        print('\nProjects:')
        for projects in proj_list:
            # display project
            print('[%i] %s' %((proj_list.index(projects) + 1), projects))
            time.sleep(.1)
    

    # ===========
    # Select Job
    # ===========
        # run job selection module
        proj_name, proj_status = jobber.jobber(proj_list, proj_path, main_dir)
        
        if proj_name == 'SEARCH':
            #do something else?
            keep_working_loop = True
            while keep_working_loop:
                keep_working = input('\nOK, is there something else that you would like to work on? (y/n): ')
                
                if (keep_working == 'y') or (keep_working == ''):
                    keep_working_loop = False
                elif keep_working == 'n':
                    exit()
                else: #wtf
                    print('\nThat don\'t make no sense! Try again.\n')
            #if going to do something else, need to restart back at the beginning of the loop
            if (keep_working == 'y') or (keep_working == ''):
                continue
            
        # ==========
        # Task Loop
        # ==========
        task_loop = True
        while task_loop:
            # print all project notes
            task_path, task_list, archive_task_list = print_proj_notes(proj_path, proj_name, notes_terminal, dets_terminal)
            time.sleep(.1)
            print_proj_details(proj_path, proj_name, notes_terminal, dets_terminal)

            # run task selection module
            task_name, due, allday, event_name, todo_list = task_selection.task_selection(archive_task_list, task_path, task_list, proj_path, proj_name)

            # determine if we need to go back to switch projects (searching through)
            if task_name == 'new_jobber':
                task_loop = False
                continue
            else:
                job_loop = False

            # ===========
            # List Notes
            # ===========
            # run notes module
            print_task_notes(task_path, task_name, notes_terminal, dets_terminal)
            print_task_dets(task_path, task_name, notes_terminal, dets_terminal)

            # ===============
            # Task Interface
            # ===============
            # create Thymer file to check so won't reset
            thymer_fname = '%s/thymer.txt' %main_dir
            if not os.path.isfile(thymer_fname):
                thymer_file = open(thymer_fname, 'w') #create the file
                thymer_file.close()
                thymer = True #lock it
            else:
                thymer_loop = True
                while thymer_loop:
                    thymer_decision = input('\nRestart Thymer? (y/n): ')

                    # determine whether Thymer needs to be reset or not
                    if (thymer_decision == 'y') or (thymer_decision == ''):
                        thymer      = True #reset the timer
                        thymer_loop = False
                    elif thymer_decision == 'n':
                        thymer      = False #don't reset Thymer
                        thymer_loop = False
                    else: #wtf
                        print('\nwtf? Try again.\n')

            # run task interface module
            # do work!
            z_event, todo, task_start, task_end, task_details, task_notes, time_s, proj_time, project_status, proj_phases = task_interface.task_interface(proj_name, task_name, proj_path, cur_branch_name, thymer, proj_status, todo_list)

            # ==========
            # Follow-up
            # ==========
            # in some instances, do a follow-up to determine if should keep working or shut it down
            follow_up_loop = True
            while follow_up_loop:
                # move completed project/task to archive folder
                if z_event == 'Project Complete':
                    # move task into the project archive folder
                    os.system('mv -v -f %s/%s %s/archive' %(task_path, task_name, task_path))
                    # move project to archive folder
                    os.system('mv -v -f %s/%s %s/archive' %(proj_path, proj_name, main_dir))
                elif z_event == 'Task Complete':
                    # move task to archive folder
                    os.system('mv -v -f %s/%s %s/archive' %(task_path, task_name, task_path))

                # working on a new task?  
                follow_up = input('\nKeep working? (y/n):  ')
                if (follow_up == '') or (follow_up == 'y'): #want to keep working
                    follow_up_what_loop = True
                    while follow_up_what_loop:
                        if z_event == 'Project Complete': #switch project
                            task_loop           = False
                            follow_up_loop      = False
                            follow_up_what_loop = False
                        else: #what to do?
                            follow_up_what = input('Same project? (y/n):  ')
                            if (follow_up_what == '') or (follow_up_what == 'y'): #don't switch projects
                                follow_up_loop      = False
                                follow_up_what_loop = False

                            elif follow_up_what == 'n': #switch project
                                task_loop           = False
                                follow_up_loop      = False
                                follow_up_what_loop = False

                            else: #wtf
                                print('\nWait. That don\'t make no sense. Try again.\n')

                elif follow_up == 'n': #done with the sesh
                    exe_loop        = False
                    task_loop       = False
                    follow_up_loop  = False
                else: #wtf
                    print('\nWait. That don\'t make no sense. Try again.\n')


            # ==============
            # Log Responses
            # ==============
            # run logit module
            logit.logit(proj_path, proj_name, task_path, task_name, todo, task_start, task_end, task_details, task_notes, time_s, z_event, main_dir, logfile, project_status, status_file, proj_phases)

            # commit changes
            repo_commit(home_dir, main_dir, proj_name, task_name, task_details)

# ------------
# push changes
repo_push(home_dir, main_dir)

# if opened Thymer, shut it down
if thymer:
    print('\nUnlocking Thymer.\n')
    os.system('rm -f %s' %thymer_fname)

exit()