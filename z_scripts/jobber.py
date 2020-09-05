def jobber(proj_list, proj_path, main_dir):
    # import command line packages
    import os
    import sys
    # reload(sys) #to help with seemingly random'ascii' encoding error
    # sys.setdefaultencoding('utf8') # ^^ <--Pythong interpreter doesn't like it, but it works

    # import modified packages
    import search

    job_loop = True
    while job_loop:
        job_input_loop = True
        while job_input_loop:
            try:
                job = int(input('\nWhat do you want to work on? Indicate the project you would like to work on by typing in the number, or enter in one of the other options (below):\n0 = Search\n\nJOB:  '))
            except ValueError:
                continue
            else:
                job_input_loop = False

        # ================
        # Execute the Job
        # ================
        if job == 0: #search (presents stats as well)
            search.search(main_dir)
            
            print('Done.')
        
            job_loop = False
            proj_name = 'SEARCH'
            break
        
        elif job <= len(proj_list): #pick a project
            # get the project name
            proj_name = proj_list[(job - 1)]

            # confirm project
            proj_loop_check = True
            while proj_loop_check:
                proj_loop = input('\n%s? (y/n):  ' %proj_name)
                if (proj_loop == '') or (proj_loop == 'y'):
                    proj_loop_check = False
                    job_loop = False

                elif proj_loop == 'n': #accidentally selected the wrong project
                    proj_loop_check = False
                
                else: #wtf
                    print('\nThat don\'t make no sense. Try again.\n')

        elif job > len(proj_list): #create a new project
            # confirm new project
            proj_loop_check = True
            while proj_loop_check:
                proj_loop = input('\nNew project? (y/n):  ')
                if (proj_loop == '') or (proj_loop == 'y'):
                    proj_loop_check = False
                    job_loop        = False
                    no_new_proj     = False

                elif proj_loop == 'n': #accidentally selected the wrong project
                    proj_loop_check = False
                    no_new_proj     = True
                
                else: #wtf
                    print('\nThat don\'t make no sense. Try again.\n')

            if no_new_proj:
                continue

            # make a new project
            new_proj_loop = True
            while new_proj_loop:
                proj_name = input('\nNew Project (Name):  ')

                new_proj_confirm_loop = True
                while new_proj_confirm_loop:
                    new_proj_confirm = input('\n%s? (y/n):  ' %proj_name)
                    if (new_proj_confirm == '') or (new_proj_confirm == 'y'):
                        # if new project is actually an old archived project, move the project over to be active
                        if os.path.isdir('%s/archive/%s' %(main_dir, proj_name)):
                            os.system('mv -v -f %s/archive/%s %s' %(main_dir, proj_name, proj_path))

                        else: #project is brand new
                            # create new project directory
                            os.system('mkdir %s/%s' %(proj_path, proj_name))

                            # create new project files
                            open('%s/%s/log.txt' %(proj_path, proj_name), 'w+')
                            open('%s/%s/dets.txt' %(proj_path, proj_name), 'w+')
                            open('%s/%s/status.txt' %(proj_path, proj_name), 'w+')

                            # udpate status
                            status_fname = '%s/%s/status.txt' %(proj_path, proj_name)
                            status_file = open(status_fname, 'w+')
                            status_phases = input('What are the phases of this project? (e.g., \'Design Dev Data Analysis Writing Pub\')\n:  ')
                            status_input = input('Task Status (pick from one of the following phases)\nPhases: %s  :  ' %status_phases)
                            status_file.write(str('%s\n%s' %(status_input, status_phases)))
                            status_file.close()
                            


                            # create new project archive directory
                            os.system('mkdir %s/%s/archive' %(proj_path, proj_name))

                            # abort loops
                            new_proj_confirm_loop   = False
                            new_proj_loop           = False
                            job_loop                = False
                    
                    elif new_proj_confirm == 'n': #input the wrong project name -- want to change the project name
                        new_proj_confirm_loop = False

                    else: #wtf
                        print('\nThat don\'t make no sense. Try again.\n')

        else: #wtf
            print('\nERROR: Impossible job selection..\n')

    status_fname = '%s/%s/status.txt' %(proj_path, proj_name)
    status_file = open(status_fname, 'r')
    proj_status = status_file.readlines()[0]
    status_file.close()

    return proj_name, proj_status