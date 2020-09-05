def task_selection(archive_task_list, task_path, task_list, proj_path, proj_name):
    # import command line packages
    import os
    import sys
    # reload(sys) #to help with seemingly random'ascii' encoding error
    # sys.setdefaultencoding('utf8') # ^^ <--Pythong interpreter doesn't like it, but it works

    # import time package
    import time

    # import data presentation packages
    from tabulate import tabulate
    import pandas as pd
    
    # open main file
    proj_timing_file    = open('%s/log.txt' %(proj_path), 'r')
    proj_time           = proj_timing_file.read().splitlines()

    # get proj time
    proj_time_s = 0
    for line in proj_time:
        logtime      = line.split() #separate out the lines
        logtime_proj = logtime[3] #get the project name
        if logtime_proj == proj_name:
            proj_time_s = proj_time_s + int(logtime[-1]) #add the seconds

    # apply the project time
    proj_time_h     = proj_time_s / 3600 #calc hours
    proj_time_m     = (proj_time_s - (int(proj_time_h) * 3600)) / 60 #calc mins

    print('====================\n%s: %i Hours & %i Minutes\n====================\n' %(proj_name.upper(), proj_time_h, proj_time_m))


    # ================
    # Select the Task
    # ================
    archive_task_list.sort()
    task_check_loop = True
    while task_check_loop:
        # list tasks in the archive folder

        completed_tasks = []
        completed_task_time_h = []
        completed_task_time_m = []
        print('\nCompleted Tasks:')
        for task in archive_task_list:

            # open proj log file
            task_timing_file    = open('%s/%s/log.txt' %(proj_path, proj_name), 'r')
            task_time           = task_timing_file.read().splitlines()

            # get task time
            task_time_s = 0
            for line in task_time:
                logtime      = line.split() #separate out the lines
                logtime_task = logtime[-3] #get the task name
                if logtime_task == task:
                    task_time_s = task_time_s + int(logtime[-1]) #add the seconds

            # apply the task time
            task_time_h     = task_time_s / 3600 #calc hours
            task_time_m     = (task_time_s - (int(task_time_h) * 3600)) / 60 #calc mins

            # list it
            completed_tasks.append(task)
            completed_task_time_h.append(int(task_time_h))
            completed_task_time_m.append(int(task_time_m))

            # print('-x- %s\t\tH %i\tM %i' %(task, task_time_h, task_time_m))

        completed_task_df = pd.DataFrame({'Task': completed_tasks, 'Hours': completed_task_time_h, 'Minutes': completed_task_time_m})
        print(tabulate(completed_task_df, headers = 'keys', tablefmt = 'psql', showindex = False))

        time.sleep(.1)

        # list the active tasks
        task_list.sort()
        print('\nTasks:')
        prog_task_num = []
        prog_task = []
        prog_task_h = []
        prog_task_m = []
        for task in task_list:

            # open proj log file
            task_timing_file    = open('%s/%s/log.txt' %(proj_path, proj_name), 'r')
            task_time           = task_timing_file.read().splitlines()

            # get task time
            task_time_s = 0
            for line in task_time:
                logtime      = line.split() #separate out the lines
                logtime_task = logtime[-3] #get the task name
                if logtime_task == task:
                    task_time_s = task_time_s + int(logtime[-1]) #add the seconds

            # apply the task time
            task_time_h     = task_time_s / 3600 #calc hours
            task_time_m     = (task_time_s - (int(task_time_h) * 3600)) / 60 #calc mins 

            # list it
            # print('[%i] %s\t\tH %i\tM %i' %((task_list.index(task) + 1), task, task_time_h, task_time_m))

            prog_task_num.append(int(task_list.index(task) + 1))
            prog_task.append(task)
            prog_task_h.append(int(task_time_h))
            prog_task_m.append(int(task_time_m))

        # time.sleep(.1)

        prog_task_df = pd.DataFrame({'#': prog_task_num, 'Task': prog_task, 'Hours': prog_task_h, 'Minutes': prog_task_m})
        print(tabulate(prog_task_df, headers = 'keys', tablefmt = 'psql', showindex = False))

        task_input_loop = True
        while task_input_loop:
            try:
                task = int(input('\nTask?\nTo return to project selection, enter \'0\', otherwise, enter a number:  '))
            except ValueError:
                continue
            else:
                task_input_loop = False

        if task == 0:
            task_name = 'new_jobber'
            task_check_loop = False
            task_input_loop = False
            break

        elif task <= len(task_list):
            task_name = task_list[(task - 1)]
        
            # confirm the task
            task_confirm_loop = True
            while task_confirm_loop:
                task_confirm = input('\n%s? (y/n):  ' %task_name)

                if (task_confirm == '') or (task_confirm == 'y'):
                    # fulfill vars
                    due                 = ''
                    allday              = ''
                    event_name          = ''
                    task_check_loop     = False
                    task_confirm_loop   = False

                elif task_confirm == 'n': #input incorrect task
                    task_confirm_loop = False

                else: #wtf
                    print('\nThat don\'t make no sense. Try again.\n')

        else: #create new task
            # confirm new task
            task_confirm_loop = True
            while task_confirm_loop:
                task_confirm = input('\nNew task? (y/n):  ')

                if (task_confirm == '') or (task_confirm == 'y'):
                    task_check_loop     = False
                    task_confirm_loop   = False
                    no_new_task         = False

                elif task_confirm == 'n': #input incorrect task
                    task_confirm_loop   = False
                    no_new_task         = True

                else: #wtf
                    print('\nThat don\'t make no sense. Try again.\n')

            if no_new_task:
                continue

            new_task = True
            while new_task:
                task_name = input('\nNew Task (Name):  ')

                confirm_task = True
                while confirm_task:
                    # confirm the task name
                    task_loop_confirm = input('\n%s? (y/n)' %task_name)
                    
                    if (task_loop_confirm == '') or (task_loop_confirm == 'y'):
                        # check to see if actually a task that was previously archived
                        if os.path.isdir('%s/archive/%s' %(task_path, task_name)): #exists in archive folder
                            os.system('mv -v -f %s/archive/%s %s' %(task_path, task_name, task_path))

                            # abort loops
                            new_task        = False
                            confirm_task    = False
                            task_check_loop = False

                        else: #is a brand new task
                            os.system('mkdir %s/%s' %(task_path, task_name)) #create new task directory
                            open('%s/%s/log.txt' %(task_path, task_name), 'w+') #create task logfile
                            open('%s/%s/dets.txt' %(task_path, task_name), 'w+') #create dets file

                            try:
                                task_timing_file.close()
                            except UnboundLocalError:
                                print('\n\n')
                            except KeyboardInterrupt:
                                print('\n\n')
                            else:
                                print('') #get to work?

                            # set due date
                            due_date_loop = True
                            while due_date_loop:
                                due_date = input('Is there a date by when this task should be completed? (y/n):  ')
                                if (due_date == '') or (due_date == 'y'):
                                    due_date_subloop = True
                                    while due_date_subloop:
                                        due         = input('Input the date (e.g., August 24, 2020, 1:00:00 PM):  ')
                                        due_confirm = input(str('%s? (y/n):  ' %due))
                                        if (due_confirm == '') or (due_confirm == 'y'):
                                            # abort loops
                                            due_date_subloop    = False
                                    allday_subloop = True
                                    while allday_subloop:
                                        allday      = input('All day event? (y/n):  ')
                                        allday_confirm = input(str('%s? (y/n):  '))
                                        if ((allday == 'y') or (allday == '')) and ((allday_confirm == 'y') or (allday_confirm == '')):
                                            allday = str('true')
                                            allday_subloop = False
                                        elif (allday == 'n') and ((allday_confirm == 'y') or (allday_confirm == '')):
                                            allday = str('false')
                                            allday_subloop = False
                                        else: #wtf
                                            print('There is an issue with determining the allday nature of the event.')
                                    eventname_loop = True
                                    while eventname_loop:
                                        event_name   = input('Name the event:  ')
                                        eventname_confirm = input(str('%s? (y/n):  '))
                                        if (eventname_confirm == 'y') or (eventname_confirm == ''):
                                            eventname_loop = False
                                        elif eventname_confirm == 'n':
                                            eventname_loop = True
                                        else: #wtf
                                            print('There is something wrong with determining the event name.') 
                                    # add to-do to calendar
                                    os.system(str('osascript -e \'tell application \"iCal\" to tell calendar \"To-Dos\" to make event with properties {start date: date \"%s\", allday event: %s, summary: \"%s\"}\'' %(due, allday, event_name)))
                                    due_date_loop       = False
                                elif due_date == 'n':
                                    due             = ''
                                    due_date_loop   = False
                                    allday          = ''
                                    event_name      = ''
                                else: #wtf
                                    print('\nThat don\'t make no sense. Try again.\n')

                            # abort loops
                            new_task        = False
                            confirm_task    = False
                            task_check_loop = False

                    elif task_loop_confirm == 'n': #input wrong task name
                        confirm_task    = False

                    else: #wtf
                        print('\nThat don\'t make no sense. Try again.\n')

    # subtasks (todos)
    if task_name != 'new_jobber':
        todo_dir    = '%s/%s' %(task_path, task_name)
        todo_list   = next(os.walk(todo_dir))[2]
        todo_list.remove('log.txt')
        todo_list.remove('dets.txt')
        for i in range(0, int(len(todo_list))):
            todo_list[i] = os.path.splitext(todo_list[i])[0][:-6]
        todo_list.sort
            
    if task_name == 'new_jobber':
        due         = ''
        allday      = ''
        event_name  = ''
        todo_list   = ''

    return task_name, due, allday, event_name, todo_list