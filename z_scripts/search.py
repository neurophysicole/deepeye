def search(main_dir):
    # import command line packages
    import os

    # import time package
    import time
    
    # search through each note file
    # if there is a match, then copy the filename and the note
    search_loop = True
    while search_loop:
        # collect the search term or phrase
        find = input('\nEnter in the term or phrase you would like to search for:\n\n')

        print('\nSearching. . .')
        main_dir_list = next(os.walk('%s' %main_dir))[1]
        main_dir_list.remove('z_scripts')
        for top_level_dir in main_dir_list: #main dir
            if top_level_dir != 'settings':
                proj_dir_list = next(os.walk('%s/%s' %(main_dir, top_level_dir)))[1]
                for proj_level_dir in proj_dir_list: #project dir
                    task_dir_list = next(os.walk('%s/%s/%s' %(main_dir, top_level_dir, proj_level_dir)))[1]
                    for task_level_dir in task_dir_list: #task dir
                        note_dir_list = next(os.walk('%s/%s/%s/%s' %(main_dir, top_level_dir, proj_level_dir, task_level_dir)))[1]
                        for note_level_dir in note_dir_list: #note dir
                            low_level_list = next(os.walk('%s/%s/%s/%s/%s' %(main_dir, top_level_dir, proj_level_dir, task_level_dir, note_level_dir)))[2]
                            for low_level_dir in low_level_list:
                                # read in the file
                                taskfile = open('%s/%s/%s/%s/%s/%s' %(main_dir, top_level_dir, proj_level_dir, task_level_dir, note_level_dir, low_level_dir), 'r')
                                taskfile = taskfile.read()

                                # if the search terms match, copy it to the command line
                                if find in taskfile:
                                    print('\n--------------------\n%s\n--------------------\n%s\n\n' %(task_level_dir.upper, taskfile))
                                
                                    time.sleep(.1)
        
        #do another search?
        keep_searching_loop = True
        while keep_searching_loop:
            keep_searching = input('\n\nWould you like to do another search? (y/n): ')
            if (keep_searching == 'y') or (keep_searching == ''):
                keep_searching_loop = False
            elif keep_searching == 'n':
                search_loop = False
                keep_searching_loop = False
            else: #wtf
                print('\nWait, that don\'t make no sense! Try again.\n')