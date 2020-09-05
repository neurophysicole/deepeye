def print_proj_notes(proj_path, proj_name, notes_terminal, dets_terminal):
    # printing all of the project notes before selecting the task could help inform of what needs to be worked on..
    
    # import command line packages
    import os

    # import time package
    import time

    # get the task
    task_path = '%s/%s' %(proj_path, proj_name)
    task_list = next(os.walk(task_path))[1]
    task_list.remove('archive') #remove archive selection from task list
    # archive task list
    archive_task_path = '%s/archive' %task_path
    archive_task_list = next(os.walk(archive_task_path))[1]

    # list all proj notes
    # archive notes
    proj_header = str('\n\n===================\n===================\n\n%s NOTES - ARCHIVE\n\n===================\n===================\n\n' %proj_name.upper())
    os.system(str('echo \'%s\' > %s' %(proj_header, notes_terminal)))

    for archive_task in archive_task_list:
        # get the notes
        archive_note_dir    = '%s/archive/%s' %(task_path, archive_task)
        archive_note_list   = next(os.walk(archive_note_dir))[2]
        archive_note_list.remove('log.txt')
        archive_note_list.remove('dets.txt')
        archive_note_list   = sorted(archive_note_list)
        if '.DS_Store' in archive_note_list:
            os.system('rm -rf %s/.DS_Store' %archive_note_dir)
            archive_note_list.remove('.DS_Store')

        # task header
        task_header = str( '\n\n-------------------\n%s Task Notes - Archive\n-------------------\n\n' %archive_task )
        os.system(str('echo \'%s\' > %s' %(task_header, notes_terminal)))

        for archive_todo in archive_note_list:
            archive_note            = open('%s/%s' %(archive_note_dir, archive_todo), 'r')
            archive_note_contents   = archive_note.read()

            note = archive_note_contents.replace("'", "").replace('"', "")

            # print note
            note = str( '\n\n%s To Do\n-------------------\n%s\n' %(os.path.splitext(archive_todo)[0][:-10], note) )
            os.system(str('echo \'%s\' > %s' %(note, notes_terminal)))

            archive_note.close()

            time.sleep(.1)

    time.sleep(.1)

    # active project notes
    proj_header = str('\n\n===================\n===================\n\n%s NOTES - ACTIVE\n\n===================\n===================\n\n' %proj_name.upper())
    os.system(str('echo \'%s\' > %s' %(proj_header, notes_terminal)))

    for task in task_list: #list of tasks in the project
        note_dir    = '%s/%s' %(task_path, task)
        note_list   = next(os.walk(note_dir))[2]
        note_list.remove('log.txt')
        note_list.remove('dets.txt')
        note_list   = sorted(note_list)

        # task header
        task_header = str( '\n\n-------------------\n%s\n-------------------\n\n' %task )
        os.system(str('echo \'%s\' > %s' %(task_header, notes_terminal)))

        for task_todo in note_list:
            task_note           = open('%s/%s' %(note_dir, task_todo), 'r')
            task_note_contents  = task_note.read()

            note = task_note_contents.replace("'", "").replace('"', "")

            # print note
            note = str( '\n\n%s To Do\n-------------------\n%s\n' %(os.path.splitext(task_todo)[0][:-6], note) )
            os.system(str('echo \'%s\' > %s' %(note, notes_terminal)))

            task_note.close()

            time.sleep(.1)

    time.sleep(.1)

    return task_path, task_list, archive_task_list


def print_task_notes(task_path, task_name, notes_terminal, dets_terminal):
    # import command line packages
    import os

    # import time package
    import time

    # current task notes
    task_header = str('\n\n===================\n===================\n\n%s TASK NOTES\n\n===================\n===================\n\n' %task_name.upper())
    os.system(str('echo \'%s\' > %s' %(task_header, notes_terminal)))

    note_dir    = '%s/%s' %(task_path, task_name)
    note_list   = next(os.walk(note_dir))[2]
    note_list.remove('log.txt')
    note_list.remove('dets.txt')
    note_list   = sorted(note_list)

    for task_todo in note_list:
        task_note           = open('%s/%s' %(note_dir, task_todo), 'r')
        task_note_contents  = task_note.read()

        note = task_note_contents.replace("'", "").replace('"', "")

        # print note
        note = str( '\n\n%s To Do\n-------------------\n%s\n' %(os.path.splitext(task_todo)[0][:-10], note) )
        os.system(str('echo \'%s\' > %s' %(note, notes_terminal)))

        task_note.close()

        time.sleep(.1)

    time.sleep(.1)


def print_proj_details(proj_path, proj_name, notes_terminal, dets_terminal):
    # import command line packages
    import os

    # import time package
    import time

    # get the task
    task_path = '%s/%s' %(proj_path, proj_name)

    # active project notes
    det_header = str('\n\n===================\n===================\n\n%s DETS\n\n===================\n===================\n\n' %proj_name.upper())

    os.system(str('echo \'%s\' > %s' %(det_header, dets_terminal)))

    dets_file       = open('%s/dets.txt' %task_path, 'r')
    dets_contents   = dets_file.read()

    dets = dets_contents.replace("'", "").replace('"', "")

    # print note
    os.system(str('echo \'%s\' > %s' %(dets, dets_terminal)))

    dets_file.close()

    return task_path

def print_task_dets(task_path, task_name, notes_terminal, dets_terminal):
    # import command line packages
    import os

    # import time package
    import time

    # current task notes
    task_header = str('\n\n===================\n===================\n\n%s TASK DETS\n\n===================\n===================\n\n' %task_name.upper())
    os.system(str('echo \'%s\' > %s' %(task_header, dets_terminal)))

    dets_file       = open('%s/%s/dets.txt' %(task_path, task_name), 'r')
    dets_contents   = dets_file.read()

    dets = dets_contents.replace("'", "").replace('"', "")

    # print note
    os.system(str('echo \'%s\' > %s' %(dets, dets_terminal)))

    dets_file.close()

    time.sleep(.1)