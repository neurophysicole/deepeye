
# TO DO's
- setup a daily email?

# z
This project has been my first real work in Python - well, my first real programming work entirely, really. So just a fair warning that things might get weird.

**HEADS UP**: The documentation is pretty out-of-date, so I added the quick guide below to get you through. There are some packages and an additional app to install (although I suppose you might be able to get away without installing the app), and some additional info below that might be helpful to checkout as well, but I think the Quick Guide covers most of what you need to know to get rolling.

## Quick Guide Until the Documentation can be more Thoroughly Updated.
- Create a GitHub repo, save the stuff from this repo in the new repo you just made.
  - After closing out of the interface a new commit is made, and when completing a session, all commits are pushed. (More on this later.)
- Make sure the settings are up to date (settings.txt file)
  - In the settings file, name the current branch, and the next branch (branches are folder names where your stuff will be stored - so the file system can update/archive every semester)
  - Also, come up with a date that you would like to shift to a new branch (on that date, the new branch will be created and named whatever you name it, then all of the active projects will be migrated to the new branch. The log sheet will remain in the old branch folder for reference)
- Run the main `z.py` file in the Terminal (I have setup an alias in my `.bash_profile` to streamline this..)
- Do not leave the Terminal window while the program is loading up (if you leave the Terminal, there will be an error). I guess the system needs to be in the Terminal to figure out the names of the terminal tabs.
  - When you run the main script, it opens more terminal tabs for the list of lists and to print the notes and log info.
- create a new project -- for reference, the task structure goes Project > Task > ToDos. Projects and tasks are folders containing log sheets, and ToDos are .txt files contained within the Task folder. There is also a dets file (essentially a logfile for logging procedural-type details that aren't necessarily notes).
- create a new task 
  - I have recently added the question about having the task done by a particular date - but I might have messed up the input format on my example (or maybe it is correct, I can't remember now), either way, that is supposed to add an event to your iCalendar -- I don't think I have finished setting up this functionality yet, so I could see this leading to a few errors -- for instance, I think it will search for a calendar named `To-Dos`, not sure if I setup contingencies for errors that occur there yet..
- After you create the task, an interface will pop up. The interface will have the time-on-project and time-on-task logged at the top, followed by a list of To Dos, the project status, then a text bos for details (basically a session log), then a box for task notes.
- There are buttons at the top to mark the task or project completed. If one of these buttons are pressed, the task or project folder will be moved into an archive folder.
  - Archived tasks are still shown in the task selection area, and their notes are still printed (although you may have to search for them). If you make a new task or project with the same name as an archived task or project, that project folder will be moved from the archive and into the appropriate folder so that it will again be seen as active.
- If you want to add a new To Do to the list, type in the name of the To Do where the NA is (in the small text box). If you want to work on an already started TO Do, click on one of the To Dos in the list. If you want to work on a To Do in the list, the small textbox must say `NA`. If the small text box has anything except `NA` in the box (that is the default), it will log the current session whatever is in the small text box.
- When you are done, click the button at the bottom.
- After leaving the interface, a commit will be made. Once you log out of the session completely, the commits will be pushed to the repo.

- **NOTES:** I don't think the search works anymore (I can't recall for sure, but I don't think I have updated it since I updated the file structure)
- I think I want to get the details and notes to print side-by-side in a pandas dataframe, but I am not totally sure on that yet..
- Make sure that none of the names that you use for projects, tasks, or to-dos have spaces in them! (I can't remember for sure now, but dashes might be a no-go as well.). Planning to fix this, but just haven't gotten around to it yet..
- As far as I can tell, running multiple sessions simultaneously works perfectly fine.
- I originally made this in Python 2.7, but have since upgraded to 3.

- **Todoz**
- One of the tabs that gets opened will be designated for a separate "list of lists" that I refer to as todoz
- I haven't gotten this to work totally on its own yet - the Todos run off of a separate script, so it is a little different..
  - So here, you just have to run the todos script (I have setup another alias in my `.bash_profile` for this..).
- This script will be up a list of lists.. (well, it'll probably be empty the first time you do it..)
  - Create a new list (e.g., `todos`, `goals`, `study_ideas`, `follow_up_ideas`, etc..)
- Within that list, feel free to add and delete items as you go. (Note, deleting something means it is lost forever.)
  - Also worth noting that there may be some missing confirmation loops throughout.. haven't had time/energy to fully check.
- _NOTE_: You don't have to run the `z.py` script to run todoz.. You can just run the todoz script in the terminal on its own whenever you like and it will work.

### Installation
This program was designed to run on a Mac. Although I am sure it can run on a window's computer (maybe with some minor tweaks), I have not tried, and I do not plan to. Installing the program is simple, just download the package. The real work is in the setup.

#### Packages
You will need to have Python 2.7 (that is what I have programmed this in, although it may work with Py3 or other.. this is untested), and you will have to make sure that the packages that are used in this program are installed on your computer. The packages you will need are as follows:
- time
- datetime
- dateutil
- os
- sys
- PySimpleGUI
- filecmp

(Generally, packages can be installed on the command line using pip, or some other tool. Google it.)

##### Thyme
I also use an app called Thyme. It will run a timer in the top bar while I am working on my task (an easy way for me to see how long I have been working). This is initialized automatically by the program when you are entering the task interface. If you have another program that you would like to use (and you want this program to start and stop it automatically), you can update this in the `task_interface.py` script. If you do not use this, I believe you shouldn't have to make any changes (although I would recommend using it).

#### Setup
The program needs an initial working directory and date boundary parameters to determine when a new working directory should be created and used. In the `settings.txt` file, update the parameters by updating the line below the parameter name.

##### Parameter Updating
- CURRENT BRANCH NAME: The name of the main directory that you want to work in. I personally am breaking things up by semester. It is a natural separation for what I do. If you wanted, you could do every week or month or year, whatever (if you never want to change main directories, that is fine, just set the date to be a really long time from now).
- NEXT BRANCH START: This is the day you would like to start using a new main directory. When this date is reached, when you load up the program it will update the CURRENT BRANCH NAME with the NEXT BRANCH NAME; then, the program will ask you for your next branch name and start date that you would like to use. ***NOTE***: Date needs to be in the MM.DD.YYYY format.
- NEXT BRANCH NAME: You will need to specify this initially, but as you use the program, it will be updated incrementally.
- BACKUP DIRECTORY: If you are planning to backup your work to some sort of cloud service, it must be a file system mounted on your computer. For the backup directory, you will first need to make the main branch folder that you would like to backup to initially, then you will need to input the path to that folder (do not include the branch folder name in the BACKUP DIRECTORY path) in the `settings.txt` file.
- DUPLICATE ID: I use Box Drive, and I work on multiple computers. Occasionally Box Drive trips out and there are "conflicting changes" that generally just means the file is being saved multiple times. Because every session creates a new note, there is no need to worry about overwrite.. As such, when Box Drive trips out it copies the file and truncates my email to the filename. As such, I have created this DUPLICATE ID parameter to search the backup files for my email and delete those files. So, if your setup would benefit from this, figure out how the filenames are truncated and include it here. Otherwise, specify something that would never show up in one of your filenames, such as: "donotdeletemyfiles!".

##### Setting up the Command Line Shortcut
If you want to be able to open the program using a command line shortcut, you will need to update your `.bash_profile`. I personally like to open up the terminal and type in `z`, and it starts the program. To do this, you will need to open the Terminal to the Home directory (it will generally automatically open up in the Home directory). Then input `sudo nano .bash_profile`. This will open up a hidden file that will execute commands. Here is what I have in mine: `alias z="python ~/Documents/file_drawer/dev/z/z_scripts/z.py"` (your alias will have to include the path to the z.py file on your computer!). Once you have this setup, hit `ctrl + o` (this saves it), then hit `ctrl + x` (this closes out of the file). Now, you will have to close out of the terminal and open it back up for your changes to take effect. Once you are all setup here, you should just be able to open the terminal and type `z` and the program will start.

### Functionality
So, as far as functionality, this program serves a few main functions:
1) Keeps track of the time you have worked on a project.
2) Keeps track of the time you have worked on particular tasks.
3) Allows you to log notes for each task.
4) Logs your progress

Additionally, there are some functions to help you keep track of your time on task (_Thyme_), present your notes to you, and keep your work backed up:
- Each session starts by asking what project you would like to work on. If you already have a list of projects, type the number of the project you would like to work on and hit `Return`. If the project you want to work on is not listed (does not yet exist), or you are just getting started, type in a number that is larger than the number of projects that are listed (e.g. `99`), and you will be prompted to enter the name of the project that you would like to work on.
    - NOTE: For all of the prompts asking for 'yes' or 'no' confirmation, you can just hit `Return` without typing in `y`, just to save a bit of hassle.
  - If you would like to re-activate a project that you had previously thought was completed, just act as if you were going to add a new project, and type in the name of the project you would like to re-activate (type it in exactly the same).
  - Also, if you would like to enter the 'Search' module, type `0`. (I think this module is self-explanatory).
- After a project is selected, all of the notes affiliated with that project will be presented (organized by task, and then by date).
- You will next be prompted to enter the task. (This is the same process as selecting the project.)
  - If you would like to return to the project selection, type `0`. This can be handy if you just wanted to look through your notes.
- Once you select a task, the task interface will pop up and you can begin working.
- The rest should be pretty self-explanatory.

### Under the Hood
So, what is this program doing? Well, it creates a file structure that stores projects as folder within the main directory, with tasks as folders within the project folders, and then notes as .txt files within the tasks. The notes are all named with the date, and the start/end time. Each project contains an 'archive' folder for tasks that are marked as completed. Also, when a project is marked as completed, it is moved over to the archive folder that is outside of the main directory (this is so it can be found and re-activated if you are in a new time segment).

Within each project is a 'log.txt' file. This will show all of the work that you have done on that project. Within the main directory, there is another 'log.txt' file that logs all of the work that you do. When you update to a new time segment (create a new main directory at the end of the semester, or whatever time segment you decided on), the active projects are moved over to the new main directory (with the tasks and everything), but the log file is restarted for the new main directory. This will help you most easily parse what you worked on, and when.

The file structure should be pretty intuitive, so it can be search manually, but it would be much easier to just go through program and list the notes, maybe while using the `ctrl + f` function. If you flub something up and start a task under the wrong project or something, you can just close out that task, or you can manually go in an move the task folder under the proper project. NOTE: You will also need to update this on your cloud, if you are backing things up on cloud - and you will also need to update the log files if you want your time on task to be tracked accurately (delete the entries on the original log file, and copy them to the log file of the project you would like to work on).

At this point, there is no way to list the log file information, but these files are easy enough to pull up and look at. If you really want to look at all of your progress logged in one file, it is pretty easy to concatenate the log files in the terminal. Future iterations of this project may have more functionality in this realm, but at this point, this seems fairly inconsequential, at least for my purposes.

#### Backing Up
The cloud is checked at the beginning and end of each session, to make sure that everything is as up to date a possible. The backup system is a bit elaborate. This is because, like in my case, there is potential to be working on more than one computer. If this is the case, some work may be done that is not updated in the local system on another computer (i.e., the cloud may be more up to date than the local file system). But also, there is the potential that the computer was not able to connect to the cloud while working for some reason, so there may be some information that is more up to date locally. Finally, there could be both situations where some information is more up to date in the cloud, and some is more up to date on the local computer (or, one of the local computers). Either way, I have tried to account for all of these potential situations, but it was a little tricky, so keep an eye open for any potential bugs.

#### Thyme
This program has the capability to work on multiple sessions at the same time, on the same computer (although this would probably be a little disingenuous with regard to your time on task). As such, this would involve restarting _Thyme_. Because this could get confusing. _Thyme_ activation will be locked by the first session that was opened, and will be made available again when that session is complete. This is done by creating a file in the main dir named `thymer.txt`. This file is empty, but holds the _Thyme_ app locked so subsequently opened sessions will not restart the timer. This file is deleted by the session that created it, thus opening up the timer to be started by subsequent sessions. In the event that the session which started _Thyme_ crashes, the timer will keep going in the top bar, and subsequent sessions will likely not be able to open up the app. To fix this, simply go into the main directory and delete the file named `thymer.txt`. If this file does not exist, you have a different problem.
