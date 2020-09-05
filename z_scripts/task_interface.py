def task_interface(proj_name, task_name, proj_path, cur_branch_name, thymer, proj_status, todo_list):
    # import date/time packages
    import datetime
    from dateutil.relativedelta import relativedelta
    from datetime import datetime, date

    # import command line packages
    import os
    import sys
    # reload(sys) #to help with seemingly random'ascii' encoding error
    # sys.setdefaultencoding('utf8') # ^^ <--Python interpreter doesn't like it, but it works

    # import interface packages
    import PySimpleGUI as sg
    from PySimpleGUI import SetOptions

    # task timer - start
    task_start = datetime.now()
    
    # thymer scripts
    open_thymer  = 'open -a Thyme'
    start_thymer = 'osascript -e \'tell app "Thyme" to start\''
    stop_thymer  = 'osascript -e \'tell app "Thyme" to stop\''
    close_thymer = 'osascript -e \'quit app "Thyme"\''

    # startup Thyme (operates in the top bar)
    if thymer: #if Thyme isn't already running
        os.system(close_thymer)
        os.system(open_thymer)
        os.system(start_thymer)

    # date/time parameters
    date = datetime.today().strftime('%m-%d-%Y')
    time = datetime.today().strftime('%-H:%M')

    # get timing
    # ----------
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
    proj_time_total = 'Hours %i: Minutes %i' %(proj_time_h, proj_time_m) #put it together

    # open proj log file
    task_timing_file    = open('%s/%s/log.txt' %(proj_path, proj_name), 'r')
    task_time           = task_timing_file.read().splitlines()

    # get task time
    task_time_s = 0
    for line in task_time:
        logtime      = line.split() #separate out the lines
        logtime_task = logtime[-3] #get the task name
        if logtime_task == task_name:
            task_time_s = task_time_s + int(logtime[-1]) #add the seconds

    # apply the task time
    task_time_h     = task_time_s / 3600 #calc hours
    task_time_m     = (task_time_s - (int(task_time_h) * 3600)) / 60 #calc mins 
    task_time_total = 'Hours %i: Minutes %i' %(task_time_h, task_time_m) #put it together

    # ---------------
    # window sections
    SetOptions(background_color = 'black', element_background_color = 'black', text_color = 'white', text_element_background_color = 'black', element_text_color = 'white')

    # status
    status_fname = '%s/%s/status.txt' %(proj_path, proj_name)
    status_file = open(status_fname, 'r')
    proj_status_lines = status_file.readlines()
    proj_status = proj_status_lines[0][:-1]
    proj_phases = str(proj_status_lines[1])
    proj_phases = proj_phases.split()
    status_file.close()

    phase_list = []
    for i in range(0, len(proj_phases)):
        if proj_phases[i] == proj_status:
            phase_list.append(True)
        elif proj_phases[i] != proj_status:
            phase_list.append(False)
        else: #wtf
            print('wtf?')
    if len(proj_phases) < 6:
        for i in range(len(proj_phases), 6): #does this need to be +1??
            proj_phases.append('NA')
            phase_list.append(False)

    # ------
    # window
    z_window = sg.Window(str('%s: %s' %(date, time)), resizable = True, disable_close = True, finalize = True)
    z_layout = [
        [sg.Frame(layout = [[sg.Text(str('%s' %proj_name))], [sg.Text(str('%s' %proj_time_total))],[sg.CloseButton('Project Complete')]], title = 'Project', relief = sg.RELIEF_SUNKEN), sg.Frame(layout = [[sg.Text(str('%s' %task_name))], [sg.Text(str('%s' %task_time_total))], [sg.CloseButton('Task Complete')]], title = 'Task', relief = sg.RELIEF_SUNKEN)],
        [sg.Text('To-Do\'s')], [sg.InputText(key = 'subtask_txt', default_text = 'NA', size = (30, 1))], [sg.Listbox(values = todo_list, key = 'subtask_lst', size = (30, 3))],
        [sg.Frame(layout = [[sg.Radio(str('%s' %proj_phases[0]), "status", key = 'status_0_key', default = phase_list[0], size = (10, 1)), sg.Radio(str(proj_phases[1]), "status", key = 'status_1_key', default = phase_list[1], size = (10,1)), sg.Radio(str(proj_phases[2]), "status", key = 'status_2_key', default = phase_list[2], size = (10, 1)), sg.Radio(str(proj_phases[3]), "status", key = 'status_3_key', default = phase_list[3], size = (10, 1)), sg.Radio(str(proj_phases[4]), "status", key = 'status_4_key', default = phase_list[4], size = (10, 1)), sg.Radio(str(proj_phases[5]), "status", key = 'status_5_key', default = phase_list[5], size = (10, 1))]], title = 'Status', relief = sg.RELIEF_SUNKEN)], 
        [sg.Text('Details')], 
        [sg.Multiline(size = (100, 8), key = 'details', autoscroll = True)], 
        [sg.Text('Notes')], 
        [sg.Multiline(size = (100, 8), key = 'notes', autoscroll = True)], 
        [sg.CloseButton('Dunzo')]
    ]

    # ==========
    # Responses
    # ==========
    # setup responses
    z_event, z_values = z_window.Layout(z_layout).Read()

    # notes
    task_details    = z_values['details']
    task_notes      = z_values['notes']

    # to-dos
    if z_values['subtask_txt'] == 'NA':
        try:
            todo = str(z_values['subtask_lst'][0])  #this gets logged as a list, take index 0
        except IndexError:
            todo = 'NA'
            if not os.path.isfile('%s/%s/%s/%s_notes.txt' %(proj_path, proj_name, task_name, todo)):
                open('%s/%s/%s/%s_notes.txt' %(proj_path, proj_name, task_name, todo), 'w+') #create new todo file

        else:
            todo = str(z_values['subtask_lst'][0])  #this gets logged as a list, take index 0

    elif z_values['subtask_txt'] != 'NA':
        todo = z_values['subtask_txt']
        open('%s/%s/%s/%s_notes.txt' %(proj_path, proj_name, task_name, todo), 'w+') #create new todo file
    else: #wtf
        print('Error determining the subtask')

    # status
    status_0 = z_values['status_0_key']
    status_1 = z_values['status_1_key']
    status_2 = z_values['status_2_key']
    status_3 = z_values['status_3_key']
    status_4 = z_values['status_4_key']
    status_5 = z_values['status_5_key']

    project_status  = [ status_0, status_1, status_2, status_3, status_4, status_5 ]

    # timing calculations
    # -------------------
    # task timer - end
    task_end    = datetime.now()
    time_x      = relativedelta(task_end, task_start)

    # calculations
    # convert it all to seconds
    time_h = '{h}'.format(h = time_x.hours)
    time_m = '{m}'.format(m = time_x.minutes)
    time_s = '{s}'.format(s = time_x.seconds)

    time_h = int(time_h)*3600
    time_m = int(time_m)*60

    # add them all up
    time_s = int(time_s) + time_h + time_m

    # add them to the project and task timings
    # project timing
    proj_time = str(proj_time_s + time_s)
    proj_timing_file.close()

    # task timing
    task_time = str(task_time_s + time_s)
    task_timing_file.close()

    # shutdown Thymer
    if thymer:
        os.system(stop_thymer)
        os.system(close_thymer)

    return z_event, todo, task_start, task_end, task_details, task_notes, time_s, proj_time, project_status, proj_phases