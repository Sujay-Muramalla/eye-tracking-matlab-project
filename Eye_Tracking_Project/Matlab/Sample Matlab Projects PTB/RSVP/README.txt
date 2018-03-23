RSVP

On each trial this code shows an (optional) a text string, followed by a string of images, and then waits for a subject response.  The example is set up to run an RSVP task: on each trial you are first prompted to look for a particular target, and then you will see a rapid stream of images.  You must say whether you saw the target in the image stream by pressing y or n.



To modify the code for your experiment:

Put your images in the images folder.  Your images should be organized into subfolders, one folder per trial.

Your results will be saved in the results folder.

If you want to include text in your experiment, replace the text file with your own list of text items.  The code assumes that the text file and image folders are in the same order (line 1 of the text file will appear on the same trial as the first folder of images, line 2 with the second folder image, etc.).  To ensure that the text appears with the right image set, I strongly recommend that you name your image folders with numbers, like "001", "002", etc.

Modify the settings in the file settingsImageSequence.m to suit your experiment.