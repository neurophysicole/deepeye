def settings():
    # import command line packages
    import os
    import glob

    # import date/time packages
    import datetime
    from datetime import datetime, date

    # import timing package
    import time

    # set the directories
    home_dir = os.getcwd()
    main_dir = os.path.dirname(os.path.abspath('%s/..' %__file__)) #main directory

    print('%s' %main_dir)
    
    # open the settings file
    settings_file = '%s/settings.txt' %(main_dir)
    settings_file = open(settings_file, 'r')
    settings_list = settings_file.read().splitlines()
     
    # date
    date        = datetime.today().date()
    date_format = '%m.%d.%Y'

    # ======================
    # Get Branch Variables
    # ======================

    for line in range(1, len(settings_list)):
        # current branch
        # get the branch name
        if settings_list[line] == 'CURRENT BRANCH NAME':
            cur_branch_name    = settings_list[(line + 1)]

        # next branch
        # get the branch name
        elif settings_list[line] == 'NEXT BRANCH START':
            next_branch_start   = settings_list[(line + 1)]
            next_branch_start   = datetime.strptime(next_branch_start, date_format).date()

        # get the branch name
        elif settings_list[line] == 'NEXT BRANCH NAME':
            next_branch_name    = settings_list[(line + 1)]

    # close settings file
    settings_file.close()

    # ========================
    # Confirm Current Branch
    # ========================

    if not date <= next_branch_start: #date is not within the boundaries of the current branch
        # update current and next branch
        confirm_renew_loop = True
        while confirm_renew_loop:
            confirm_renew = input('\nRenewing the current branch.\n\nCONFIRM that this should be carried out (y/n): ')
            if (confirm_renew == '') or (confirm_renew == 'y'):
                # need to update the current branch
                old_branch_name    = cur_branch_name
                cur_branch_name    = next_branch_name

                # need to update the next branch
                next_branch_name   = input('\nCome up with a name for the next branch (e.g., \'20_Fall\'):\n')
                next_branch_start  = input('\nInput the date that the next branch should start (e.g., \'08.24.2020\'):\n')

                print('\nOkay, the current branch is set to %s.\nIf for some reason, this is inaccurate, you will need to update the settings (during job selection -- coming up), or just manually update the settings in the \'settings.txt\' file.\n' %cur_branch_name)

                confirm_renew_loop = False

                # ======================
                # Establish New Branch
                # ======================
                # make new branch dir and move everything over there..
                # make new branch directory
                print('\nSetting up %s directory.\n' %cur_branch_name)

                os.system('mkdir %s/%s' %(main_dir, cur_branch_name))

                # make new log file
                newlog = open('%s/%s/log.txt' %(main_dir, cur_branch_name), 'w+')
                newlog.close()

                # move everything over
                # list projects in old branch directory
                old_branch_list = next(os.walk('%s/%s' %(main_dir, old_branch_name)))[1]

                # list lists in old branch directory
                old_branch_list_lists = next(os.walk('%s/%s' %(main_dir, old_branch_name)))[2]
                for i in old_branch_list_lists:
                    if i == 'log.txt':
                        old_branch_list_lists.remove(i)

                # move all project dirs form old branch to new branch
                for seg_proj in old_branch_list:
                    os.system('mv -v -f %s/%s/%s %s/%s' %(main_dir, old_branch_name, seg_proj, main_dir, cur_branch_name))

                # move all lists from old branch to new branch
                for i in old_branch_list_lists:
                    os.system('mv -v -f %s/%s/%s %s/%s' %(main_dir, old_branch_name, i, main_dir, cur_branch_name))
                
                # =====================
                # Update Settings File
                # =====================
                # update the settings list
                for line in range(1, len(settings_list)):
                    # current branch
                    # get the branch name
                    if settings_list[line] == 'CURRENT BRANCH NAME':
                        settings_list[(line + 1)] = cur_branch_name

                    # next branch
                    # get the branch name
                    elif settings_list[line] == 'NEXT BRANCH START':
                        settings_list[(line + 1)] = next_branch_start

                    # get the branch name
                    elif settings_list[line] == 'NEXT BRANCH NAME':
                        settings_list[(line + 1)] = next_branch_name

                # open the settings file
                settings_file = '%s/settings.txt' %(main_dir)
                with open(settings_file, 'w') as settings_file:
                    for line in settings_list:
                        settings_file.write('%s\n' %line)


            elif confirm_renew == 'n': #renewal not accepted
                print('\n!Aborting renewal. Current branch: %s! If this isn\'t right, you might have to restart and update it correctly; or just go into the \'settings.txt\' file and update the branch information manually.' %cur_branch_name)

                confirm_renew_loop = False

            else: #wtf
                print('\nTry again.')

    # ====================
    # Set Terminal Windows
    # ====================
    term_wins_before = glob.glob('../../dev/ttys00*') # get list of terminal windows (before)
    os.system('osascript -e \"tell application \\"System Events\\" to keystroke \\"t\\" using {command down}\"')
    os.system('osascript -e \"tell application \\"System Events\\" to keystroke \\"t\\" using {command down}\"')
    os.system('osascript -e \"tell application \\"System Events\\" to keystroke \\"t\\" using {command down}\"')
    time.sleep(3) # needs time to make the window or else it won't work..
    term_wins_after = glob.glob('../../dev/ttys00*') # get list of terminal windows (after)

    # compare terminal window lists
    newterm_list = []
    for i in range(0, len(term_wins_after)):
        if term_wins_after[i] not in term_wins_before:
            newterm_list.append(term_wins_after[i][5:])
        
    todo_terminal   = newterm_list[0]
    notes_terminal  = newterm_list[1]
    dets_terminal   = newterm_list[2]

    # ID Terminal Windows
    os.system(str('echo \'Todos\' > %s' %todo_terminal))
    os.system(str('echo \'Dets\' > %s' %dets_terminal))
    os.system(str('echo \'Notes\' > %s' %notes_terminal))

    return main_dir, home_dir, cur_branch_name, todo_terminal, notes_terminal, dets_terminal