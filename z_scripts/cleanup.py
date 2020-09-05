def cleanup(main_dir, cur_branch_name):

    # import command line package
    import os

    # import timing package
    import time

    # clean out any duplicate Box files
    print('\nCleaning up the file drawers.')
    time.sleep(.1)

    #problem_file
    problem = '.DS_Store'

    # get list of projects
    proj_dir    = '%s/%s' %(main_dir, cur_branch_name)
    proj_list   = next(os.walk(proj_dir))[1]

    # iterate through projects
    for project in proj_list:

        # get task list
        task_dir    = '%s/%s' %(proj_dir, project)
        task_list   = next(os.walk(task_dir))[1]

        # iterate through tasks
        for task in task_list:

            # get the note list
            note_dir    = '%s/%s' %(task_dir, task)
            note_list   = next(os.walk(note_dir))[2]

            # iterate through notes
            for note in range(0, len(note_list)):
                tasknote = '%s/%s' %(note_dir, note_list[note]) #get note
                if problem in tasknote:
                    os.system('rm -v -f %s' %tasknote)
                    print('\nCleaned up a blah.')

    # all done
    print('\n--All Clear!\n')
    time.sleep(.1)