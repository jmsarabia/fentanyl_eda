# fentanyl_eda

## Instructions for Set-up 

All of these commands are run from the command line.

__Cloning__
1. Send me your github username, or email, to add you as a collaborator on this project
2. Decide whether to use HTTPS or SSH for pushing (see more info here: https://docs.github.com/en/get-started/getting-started-with-git/about-remote-repositories).  If using SSH, make sure you have an SSH key set up on your machine (https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) and have set up SSH access in _your_ account (https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).   The tradeoffs between the two: SSH is more secure, and once you set it up, you can run commands like `git push` without needing to enter credentials.  HTTPS may be a bit easier to set up, but you'll need to enter your credentials every time you interact with the remote repository.
3. Download this repository using `git clone git@github.com:robords/fentanyl_eda.git` if using SSH or `git clone https://github.com/robords/fentanyl_eda.git` if using HTTPS


__Setting up a Virtual Env and Installing Requirements__
Prequisites: 1) You must have Python 3 already installed on your machine and 2) you must have pip installed on your machine (ideally pip3)
Notes:
* You can use `make` as for shortcuts for these commands (this is what the makefile is for in the repo), but it's not necessary
* Run these commands from within the repository directory that you cloned
* These commands were run on macOS. 

1. Create your virtual environment by running the command `python3 -m venv ~/.venv/msdsCapstone_fentanyl_eda`.  You can run this 
2. Activate your virtual environment by running the command `source ~/.venv/msdsCapstone_fentanyl_eda/bin/activate`.  You should see the env name added in parenthesis on the command line, something like `(msdsCapstone_fentanyl_eda) robords@ABCD12345 fentanyl_eda %`
3. Install the libraries from `requirements.txt` by running the command `pip3 install -r requirements.txt`.  If you don't have pip3 installed on your machine, the command is just `pip install -r requirements.txt`.  You should see all the libraries being installed in your virtual environment.

__Jupyter__
1. To start your Jupyter notebook, once your in your virtual environment, run the command `jupyter notebook`.  Th
