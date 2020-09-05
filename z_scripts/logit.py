def logit(proj_path, proj_name, task_path, task_name, todo, task_start, task_end, task_details, task_notes, time_s, z_event, main_dir, logfile, project_status, status_file, proj_phases):
    # import date/time packages
    import datetime
    from datetime import datetime, date
    
    # import os packages
    import os
    import sys
    # reload(sys) #to help with seemingly random'ascii' encoding error
    # sys.setdefaultencoding('utf8') # ^^ <--Python interpreter doesn't like it, but it works
    
    # get the date (year first)
    date        = datetime.today().strftime('%Y-%m-%d')
    task_start  = task_start.strftime('%-H%M')
    task_end    = task_end.strftime('%-H%M')
    
    # log task notes
    task_header      = '%s: %s, %s-%s' %(todo, date, task_start, task_end)

    # if close task, need to save the current notes to the archive folder
    if z_event == 'Project Complete':
        task_note_dir   = '%s/archive/%s/archive/%s' %(main_dir, proj_name, task_name)
        task_log_dir    = '%s/archive/%s' %(main_dir, proj_name)
        print('Moving %s project to the archive.' %proj_name)
        os.system('mv -v -f %s/%s %s/archive' %(main_dir, proj_name, main_dir))
    elif z_event == 'Task Complete':
        task_note_dir   = '%s/archive/%s' %(task_path, task_name)
        task_log_dir    = '%s' %(task_path)
        print('Moving %s task to the %s archive folder.' %(task_name, proj_name))
        os.system('mv -v -f %s/%s %s/archive' %(task_path, task_name, task_path))
    else: # no archiving
        task_note_dir   = '%s/%s' %(task_path, task_name)
        task_log_dir    = '%s' %task_path

    # setup log
    log = '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' %(date, task_start, task_end, proj_name, task_name, todo, time_s)

    # log details in project file
    proj_dets_file = '%s/dets.txt' %(task_log_dir)
    proj_dets_file = open(proj_dets_file, 'a+')
    proj_dets_file.write('\n%s\n%s%s\n' %(task_header, log, task_details))
    proj_dets_file.close()

    # log details in task file
    task_dets_file = '%s/dets.txt' %(task_note_dir)
    task_dets_file = open(task_dets_file, 'a+')
    task_dets_file.write('\n%s\n%s%s\n' %(task_header, log, task_details))
    task_dets_file.close()

    # log notes in file
    task_note_file = '%s/%s_notes.txt' %(task_note_dir, todo)
    task_note_file = open(task_note_file, 'a+')
    task_note_file.write('\n%s\n%s%s' %(task_header, log, task_notes))
    task_note_file.close()

    # update task log
    task_log_fname  = '%s/%s' %(task_note_dir, logfile)
    task_log_file   = open(task_log_fname, 'a+')
    task_log_file.write(log)
    task_log_file.close()

    # update project log
    proj_log_fname  = '%s/%s' %(task_log_dir, logfile)
    proj_log_file   = open(proj_log_fname, 'a+')
    proj_log_file.write(log)
    proj_log_file.close()
    
    # update master log
    master_log_fname    = '%s/%s' %(proj_path, logfile)
    master_log_file     = open(master_log_fname, 'a+')
    master_log_file.write(log)
    proj_log_file.close()

    for i in range(0, len(project_status)):
        if project_status[i]:
            status = proj_phases[i]
            project_status_fname    = '%s/%s/%s' %(proj_path, proj_name, status_file)
            project_status_file     = open(project_status_fname, 'r')
            proj_status_phases      = project_status_file.readlines()
            proj_status_phases      = proj_status_phases[1]
            project_status_file.close()
            proj_status_update = str('%s\n%s' %(status, proj_status_phases))
            project_status_file     = open(project_status_fname, 'w')
            project_status_file.write(proj_status_update)
            project_status_file.close()
